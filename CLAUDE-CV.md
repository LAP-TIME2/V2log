# CLAUDE-CV.md — CV 기능 개발 가이드

> V2log 앱에 Computer Vision 기능을 추가할 때 참고하는 코딩 가이드.
> 일반 앱 개발 가이드는 `CLAUDE.md` 참조.

---

## 1. CV 기술 스택

| 용도 | 기술 | 상태 |
|------|------|------|
| 횟수 카운팅 | **MediaPipe BlazePose** (33개 3D 관절) | 구글 완성 모델, 바로 사용 |
| 무게 감지 | **YOLO26-N** (커스텀 학습) | 직접 학습 필요 (CPU 43% 빨라짐, NMS-free) |
| Flutter 카메라 | `camera` ^0.11.3+1 | 추가 필요 |
| 포즈 감지 | `google_mlkit_pose_detection` ^0.14.1 | 추가 필요 |
| 커스텀 모델 | `tflite_flutter` ^0.10.4 | Phase 2에서 추가 |
| 이미지 처리 | `image` ^4.1.0 | Phase 2에서 추가 |
| 권한 관리 | `permission_handler` ^11.4.0 | 추가 필요 |
| 라벨링 도구 | Roboflow (웹, 무료 10,000장) | 외부 도구 |
| 학습 환경 | Google Colab (무료 T4 GPU) | 외부 도구 |

---

## 2. Phase 로드맵

```
Phase 1 (횟수 카운팅) — 지금 바로 가능
├── 기술: MediaPipe BlazePose + 관절 각도 Peak/Valley
├── 정확도: 88~95% (헬스장 환경)
├── 비용: 0원 (구글 완성 모델, 학습 불필요)
└── 앱 작업만: 패키지 설치 + 서비스/위젯 추가

Phase 2A (기본 모델 학습) — 앱 바깥, Python/Colab
├── 사진 3,000~5,000장 촬영 (여러 헬스장)
├── Roboflow 라벨링 → YOLO26-N 학습 (코드 3줄)
├── 변환: .pt → .tflite (코드 1줄)
├── 비용: 0원
└── 결과물: model.tflite 파일 1개

Phase 2B (앱 통합) — 기존 V2log 앱에 추가
├── Two-Stage 파이프라인: 무게 감지 모드 → Pose-only 모드
├── tflite_flutter로 model.tflite 실행
├── 무게 자동 적용 (확인 팝업 없음, 틀리면 수동 수정)
├── 자동 시작/종료 (첫 동작 감지 = 세트 시작, 무동작 = 세트 종료)
├── 플레이트 등록 (B2C 선택사항 / B2B 관리자용)
├── OCR 숫자 읽기 (보조 수단)
└── 80%만 맞춰도 수동 입력보다 빠름 = 충분한 가치

Phase 3 (미래, 12개월+)
├── LLM 기반 범용 카운팅 (CountLLM)
├── SAM 2 바벨 정밀 추적
├── 1,900+ 운동 지원 (LiFT 모델)
└── B2B 헬스장 설치형 카메라 시스템

※ IWF 컬러 인식 (HSV): 보너스 경로 (일반 헬스장 80-90%가 검정 플레이트)
※ Phase 1.5 (별도 스마트 무게): Phase 2A 직행 시 불필요
```

---

## 3. CV 아키텍처 (V2log 통합 구조)

### 앱 재구축 불필요 (분석 완료)
- 아키텍처 호환성: A+ (Clean Architecture, 레이어 분리 명확)
- 운동 화면 통합: A (setState 기반, CV 콜백 바로 연결)
- 데이터 모델: A+ (기존 WorkoutSetModel 필드 활용, 변경 불필요)
- 빌드 호환성: A (Flutter 3.38.7, minSdk 21, ML Kit/TFLite 지원)

### 신규 파일 (Phase 1)

```
lib/data/services/
├── pose_detection_service.dart    # MediaPipe 래퍼 (초기화, 프레임 분석, 해제)
└── rep_counter_service.dart        # 횟수 카운팅 (운동별 관절 각도 Peak/Valley)

lib/domain/providers/
└── cv_provider.dart                # CV 상태 관리 (@riverpod)

lib/presentation/widgets/molecules/
├── camera_overlay.dart             # 카메라 프리뷰 + 토글 UI
└── pose_overlay.dart               # 관절 점/선 오버레이

lib/core/utils/
└── exercise_angles.dart            # 운동별 관절 각도 규칙 데이터
```

### 기존 파일 수정 (최소)

| 파일 | 수정 내용 |
|------|----------|
| `workout_screen.dart` | 카메라 모드 토글 + `_onCvDetected()` 콜백 추가 |
| `app_router.dart` | (필요시) CV 관련 라우트 추가 |
| `AndroidManifest.xml` | `<uses-permission android:name="android.permission.CAMERA"/>` |
| `Info.plist` | `NSCameraUsageDescription` 추가 |

### 데이터 흐름 — Two-Stage 파이프라인

```
[1단계: 무게 감지 모드]           [2단계: 운동 모드 (Pose-only)]
카메라 스트림 (30fps)             카메라 스트림 (30fps)
    ↓ YOLO26-N + OCR 전력 투입       ↓ 프레임 스킵 (3번째만)
플레이트 감지 + 숫자 읽기         MediaPipe BlazePose 추론
    ↓                                 ↓ 150ms 디바운싱
_currentWeight 자동 적용          _currentReps 갱신 (카운팅)
(화면에 조용히 표시)              (1... 2... 3...)
    ↓ 첫 동작 감지 시                 ↓ 무동작 감지 시
   → 2단계로 전환                    → 세트 종료 + 휴식 타이머
                                      → 무게 변경 시 1단계로 복귀
```

### 부분 촬영 원칙 (전신 촬영 아님!)
- 대부분 운동은 **움직이는 관절 + 무게**만 화면에 잡히면 됨
- 벤치프레스: 바벨 + 어깨~손목 → 1~1.5m
- 레그프레스: 플레이트 + 대퇴~발목 → 1~1.5m
- 스쿼트: 거의 전신 → 가장 넓은 범위 필요
- **1~1.5m 거리면 플레이트 숫자 OCR 가능 + YOLO 감지 정확도 UP**

---

## 4. CV 코딩 규칙

1. **카메라 스트림 격리**: `CameraOverlay`는 반드시 별도 위젯으로 분리. WorkoutScreen 전체를 StreamBuilder로 감싸면 30fps 리빌드 → 버벅임.
2. **ML 추론 Isolate 분리**: `compute()` 또는 `Isolate`로 ML 추론을 메인 스레드에서 분리. 안 하면 UI 프레임 드롭.
3. **선택적 활성화**: 사용자가 "CV 모드" 토글로 필요할 때만 카메라 ON. 항상 켜두면 배터리 낭비.
4. **프레임 스킵**: 매 프레임이 아닌 2~3번째만 처리 (15 FPS면 횟수 카운팅에 충분).
5. **해상도 제한**: 카메라 640×480 고정 (성능 최적화).
6. **디바운싱**: CV 결과 → UI 갱신은 200ms 디바운싱 (초당 5번만 setState).

---

## 5. 운동 화면 통합 포인트

### 핵심: 기존 변수에 값만 넣으면 됨

```dart
// workout_screen.dart 기존 코드
double _currentWeight = 60.0;  // 수동 입력 값
int _currentReps = 10;          // 수동 입력 값

// CV 감지 결과도 같은 변수에 넣기
void _onCvDetected(double weight, int reps) {
  setState(() {
    _currentWeight = weight;
    _currentReps = reps;
  });
}
```

### 입력 모드

```dart
enum InputMode { manual, cv, hybrid }

// manual:  기존 휠피커 수동 입력
// cv:      카메라 자동 감지만
// hybrid:  자동 감지 + 수동 수정 가능 (권장)
```

### 데이터 모델 (변경 불필요)

```dart
// WorkoutSetModel 기존 필드 활용
weight: cvDetectedWeight,         // CV 감지 무게
reps: cvDetectedReps,             // CV 감지 횟수
rpe: cvConfidence,                // CV 신뢰도 (0.0~1.0)
notes: "CV감지: 신뢰도 ${(confidence * 100).toInt()}%",
```

---

## 6. 모델 학습 가이드 (Phase 2)

### 데이터 수집

| 방법 | 사진 수 | 비고 |
|------|---------|------|
| 직접 촬영 (핵심) | 2,000~3,000장 | 헬스장 3~5곳, 다양한 각도/조명 |
| Roboflow 기존 | 957장 (Weight Plates) | 무게 라벨 확인 필요 |
| 데이터 증강 | ×5~10배 | Roboflow 자동 (밝기/회전/노이즈) |
| **최종** | **8,000~10,000장** | 증강 포함 |

### 촬영 클래스: 25kg, 20kg, 15kg, 10kg, 5kg, 2.5kg, 1.25kg, barbell, empty_barbell

### 라벨링
- 도구: Roboflow (웹브라우저, 무료 10,000장)
- AI 보조: 500장 수동 → 임시 모델 → 나머지 자동+수정

### 학습 (코드 3줄)
```python
from ultralytics import YOLO
model = YOLO('yolo26n.pt')
model.train(data='data.yaml', epochs=100, imgsz=640, batch=16)
```

### 변환 (코드 1줄)
```python
model.export(format='tflite')
```

### 환경: Google Colab 무료 (5,000장 기준 2~4시간)

### B2B Fine-tuning 전략
- 헬스장 관리자가 앱에서 플레이트 촬영 (각 무게 앞면 1장씩, 2분)
- 또는 플레이트 등록 기능으로 시각적 프로필 저장
- 서버에서 기본 모델 + 관리자 데이터 → 맞춤 모델 자동 생성
- 해당 헬스장에서 90~95% 정확도

### 비용: 전 과정 무료 (시간만 투자)

---

## 7. 알려진 함정 (CV 전용)

### 1. 카메라 스트림 리빌드
```dart
// ❌ BAD: 30fps 전체 리빌드
StreamBuilder<CvFrame>(
  stream: cameraService.stream,
  builder: (context, snapshot) => WorkoutScreen(...),
);

// ✅ GOOD: 별도 위젯 + 콜백
CameraOverlay(onDetected: _onCvDetected)  // 이 위젯만 리빌드
```

### 2. 카메라 메모리 누수
- `dispose()`에서 카메라 컨트롤러 반드시 해제
- 화면 전환 시 스트림 정리 필수
- 안 하면 메모리 계속 증가 → OOM 크래시

### 3. 신뢰도 폴백
- 신뢰도 < 0.7 → 자동 입력 안 함 → 수동 입력 모드로 전환
- "정확하지 않을 수 있어요" 안내 표시

### 4. 헬스장 환경 정확도 하락
- 실험실 99% → 헬스장 88% (약 11% 하락)
- 원인: 조명, 다른 사람 가림, 카메라 각도
- 대응: 충분한 데이터 다양성 + 사용자 안내

### 5. 배터리 소모
- 카메라 + ML 연속: 시간당 15~25% 배터리
- 대응: 쉬는 시간 AI 중지, 필요시만 카메라 ON

---

## 8. 성능 최적화 체크리스트

### 플랫폼 설정
- [x] Android CAMERA 권한 추가
- [x] iOS NSCameraUsageDescription 추가
- [x] Android minSdk 21+ 확인

### 카메라 최적화
- [x] 해상도 640×480 제한
- [x] 프레임 스킵 (3번째만 처리 → 10 FPS)
- [x] CameraOverlay 별도 위젯 분리
- [x] dispose()에서 카메라 해제 + AppLifecycle 감지

### ML 최적화
- [x] ML Kit 네이티브 처리 (GPU/NNAPI 자동 가속, Isolate 불필요)
- [x] 150ms 디바운싱 + 800ms 최소 반복 간격

### UX 최적화
- [x] CV 모드 토글 (기본 OFF)
- [x] 세트 완료 시 카운터 자동 리셋
- [x] 신뢰도 < 0.7 → 자동 입력 안 함
- [x] 촬영 방향 안내 (정면/측면 실시간 표시)
- [ ] 쉬는 시간 AI 자동 중지
- [ ] "자동 감지: 50kg × 8회" 토스트 표시

---

## 9. CV 작업 진행 상황

### Phase 1: 횟수 카운팅 — **완료** (v5.2)
- [x] 카메라 권한 설정 (Android `CAMERA` / iOS `NSCameraUsageDescription`)
- [x] camera `^0.11.3+1` + google_mlkit_pose_detection `^0.14.1` + permission_handler `^12.0.1`
- [x] `pose_detection_service.dart` (162줄) — MediaPipe BlazePose 래퍼, 프레임 스킵, 각도 계산
- [x] `rep_counter_service.dart` (655줄) — One Euro Filter + Velocity Gate + 운동 시작 확인 시스템
- [x] `cv_provider.dart` (108줄) — CvState + CvInputModeState (@riverpod)
- [x] `camera_overlay.dart` (318줄) + `pose_overlay.dart` (133줄) — 촬영 방향 표시, 33개 관절 오버레이
- [x] `exercise_angles.dart` (374줄) — 10개 운동 각도 데이터 + 3단계 매칭
- [x] `workout_screen.dart`에 CV 모드 토글 + `onRepsDetected` 콜백 통합
- [x] 실기기 테스트 완료 — 정지 오카운팅 방지, 세트 간 정확도 유지, 준비 동작 필터링 검증

#### Phase 1 구현 상세
| 항목 | 수치 |
|------|------|
| 총 CV 코드 | 1,750줄 (코드 생성 제외) |
| 지원 운동 | 10개 (팔2 + 가슴어깨3 + 하체3 + 등2) |
| 정확도 | 88~95% (헬스장 환경) |
| 알고리즘 | One Euro Filter → Velocity Gate (15°/sec) → Amplitude Check |
| 촬영 방향 | 자동 감지 (hysteresis + 7프레임 투표) |
| 핵심 수치 | 디바운싱 150ms, 최소 반복 800ms, 정지 판정 <5°/sec |

### ~~Phase 1.5: 스마트 무게 입력~~ — **Phase 2A 직행으로 불필요**
- ~~IWF 컬러 인식~~: 보너스 경로 (일반 헬스장 80-90% 검정 플레이트)
- ~~PaddleOCR~~: Google ML Kit v2로 대체 검토 중

### Phase 2A: 모델 학습 — **완료**
- [x] 헬스장 사진 촬영 완료 (20kg/15kg/10kg/5kg/2.5kg)
- [x] Roboflow 프로젝트 생성 + 926장 업로드 + 537장 라벨링
- [x] Dataset v2 생성 (YOLOv8 포맷, 5클래스)
- [x] YOLO26-N 학습 완료 — mAP50: 96.2%, mAP50-95: 85.3% (목표 80% 초과 달성)
- [x] .tflite 변환 → V2log 앱으로 전달 (9.8MB, assets/models/weight_plate.tflite)

### Phase 2B: 앱 통합 — **Two-Stage 구현 완료, 실기기 테스트 필요**
- [x] tflite_flutter + image 패키지 설치
- [x] `weight_detection_service.dart` (387줄) — YOLO26-N 추론, 프레임 스킵 5, 3회 안정성 체크
- [x] **클래스 매핑 버그 수정** (Roboflow 알파벳순 5클래스: plate_10kg/15kg/2.5kg/20kg/5kg)
- [x] **Two-Stage 파이프라인 구현** — CameraStage enum (weightDetecting → repCounting)
  - Stage 1: YOLO만 실행 (Pose 스킵), "바벨을 카메라에 보여주세요" 안내
  - Stage 2: Pose만 실행 (YOLO 스킵), 기존 횟수 카운팅 + 확정 무게 표시
  - 자동 전환: isStable → 2초 딜레이 → Stage 2
- [x] **"바벨 보여주기" UX** — 전면카메라에 바벨 가져다대기 (삼각대/거치대 기준)
- [x] `camera_overlay.dart` 완전 재작성 (~630줄) — Stage별 UI/처리 분리
- [x] WorkoutScreen AI 무게 감지 뱃지 + onWeightDetected 콜백
- [ ] 실기기 테스트 검증
- [ ] 무게 자동 적용 UX (확인 팝업 없음) — 현재 구조 준비됨
- [ ] 자동 세트 시작 (첫 동작 감지) / 자동 종료 (무동작 감지)
- [ ] 플레이트 등록 기능 (B2C 선택 / B2B 관리자)
- [ ] OCR 숫자 읽기 (보조)
- [ ] B2B Fine-tuning 파이프라인

---

## 10. 헬스장 환경 체크리스트 (CV 기능 개발 시 필수 확인)

CV 코드 작성/수정 전에 아래 항목 검토:

- [ ] **다중 사용자**: 화면에 여러 명이 보일 때 누구를 추적하는가?
- [ ] **카메라 각도**: 정면/측면/대각선 모두 고려했는가?
- [ ] **카메라 비율**: AspectRatio 처리 되어있는가? (찌그러짐 방지)
- [ ] **거리 변화**: 1m, 2m, 3m에서 모두 작동하는가?
- [ ] **바벨 대칭**: 양쪽 원판이 다 보일 때와 한쪽만 보일 때 모두 정확한가?
- [ ] **조명/배경**: 밝은/어두운 환경, 복잡한 배경에서도 작동하는가?

### 플랜모드 서브에이전트 프롬프트 가이드

서브에이전트에게 CV 작업 지시 시 반드시 포함할 5가지:

1. **시나리오 테이블 작성 강제**: "코드 수정 전에 [상황/입력/현재동작/올바른동작] 표를 먼저 만들어라"
2. **가정(Assumption) 목록화**: "이 코드가 암묵적으로 가정하는 것을 나열하고, 헬스장 환경에서 성립하는지 검증해라"
3. **실제 배포 환경 명시**: "상업 헬스장, 10-30명 동시 운동, 전면 카메라, 삼각대, 1-3m 거리"
4. **크로스체크 질문**: "다른 각도에서도? 여러 명이 있어도? 기존 기능 안 깨지나?"
5. **반박(Devil's Advocate)**: "이 접근이 실패하는 상황 3가지를 찾고 대응책 제시"

---

## 11. 참고 문서

### 기술 조사
- `docs/reference/CV_무게측정_횟수카운팅_최신기술_보고서_2026.md` — 모델 비교, 정확도, 오픈소스 목록
- `docs/reference/02-13_CV_무게자동감지_실현가능성_종합분석_2026.md` — 3명 전문가 에이전트 현장 검증 (경쟁사, 광학, UX, B2B)

### 사업 전략
- `docs/reference/CV_피벗_사업계획서_Fica_2026.md` — 시장 분석, 경쟁사, 비즈니스 모델

### 앱 분석 보고서
- `docs/02-12_CV분석_1_아키텍처_전체구조.md` — 아키텍처 호환성 상세
- `docs/02-12_CV분석_2_운동화면_심층분석.md` — 운동 화면 통합 상세
- `docs/02-12_CV분석_3_성능_빌드_호환성.md` — 성능/빌드 상세

### Q&A 기록
- `docs/02-12-10-46_CV_무게횟수_자동감지_진행상황.md` — 기술 논의 전체 정리
