# CLAUDE-CV.md — CV 기능 개발 가이드

> V2log 앱에 Computer Vision 기능을 추가할 때 참고하는 코딩 가이드.
> 일반 앱 개발 가이드는 `CLAUDE.md` 참조.

---

## 1. CV 기술 스택

| 용도 | 기술 | 상태 |
|------|------|------|
| 횟수 카운팅 | **MediaPipe BlazePose** (33개 3D 관절) | 구글 완성 모델, 바로 사용 |
| 무게 감지 | **YOLO11 nano** (커스텀 학습) | 직접 학습 필요 |
| Flutter 카메라 | `camera` ^0.10.6 | 추가 필요 |
| 포즈 감지 | `google_mlkit_pose_detection` ^0.11.0 | 추가 필요 |
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

Phase 1.5 (스마트 무게 입력) — 3~6개월 후
├── 방식: 바벨 사진 촬영 → AI 추측 → "60kg 맞나요?" → 원탭 확인
├── 기술: IWF 컬러 인식 (HSV) + OCR (PaddleOCR) + YOLO 플레이트 개수
├── 정확도: 70~85%
└── 80%만 맞춰도 수동 입력보다 빠름 = 충분한 가치

Phase 2 작업 A (기본 모델 학습) — 앱 바깥, Python/Colab
├── 사진 3,000~5,000장 촬영 (여러 헬스장)
├── Roboflow 라벨링 → YOLO11 nano 학습 (코드 3줄)
├── 변환: .pt → .tflite (코드 1줄)
├── 비용: 0원
└── 결과물: model.tflite 파일 1개

Phase 2 작업 B (앱 통합) — 기존 V2log 앱에 추가
├── tflite_flutter로 model.tflite 실행
├── 플레이트 등록 UI (관리자용)
├── 무게 계산 로직 (플레이트 종류 × 개수)
└── B2B: 헬스장별 Fine-tuning (관리자 200~300장 촬영)

Phase 3 (미래, 12개월+)
├── LLM 기반 범용 카운팅 (CountLLM)
├── SAM 2 바벨 정밀 추적
└── 1,900+ 운동 지원 (LiFT 모델)
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

### 데이터 흐름

```
카메라 스트림 (30fps)
    ↓ 프레임 스킵 (2~3번째만)
프레임 전처리 (640×480 리사이즈)
    ↓ Isolate로 분리
ML 추론 (MediaPipe 또는 YOLO)
    ↓ 200ms 디바운싱
결과 → _onCvDetected(weight, reps)
    ↓ setState
_currentWeight / _currentReps 갱신
    ↓
기존 addSet() 로직 그대로 사용
```

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
model = YOLO('yolo11n.pt')
model.train(data='data.yaml', epochs=100, imgsz=640, batch=16)
```

### 변환 (코드 1줄)
```python
model.export(format='tflite')
```

### 환경: Google Colab 무료 (5,000장 기준 2~4시간)

### B2B Fine-tuning 전략
- 헬스장 관리자가 앱에서 플레이트 촬영 200~300장
- 사진마다 터치로 무게 선택 (라벨링)
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
- [ ] Android CAMERA 권한 추가
- [ ] iOS NSCameraUsageDescription 추가
- [ ] Android minSdk 21+ 확인

### 카메라 최적화
- [ ] 해상도 640×480 제한
- [ ] 프레임 스킵 (2~3번째만 처리)
- [ ] CameraOverlay 별도 위젯 분리
- [ ] dispose()에서 카메라 해제

### ML 최적화
- [ ] Isolate/compute()로 추론 분리
- [ ] 200ms 디바운싱
- [ ] GPU 위임(delegate) 사용

### UX 최적화
- [ ] CV 모드 토글 (기본 OFF)
- [ ] 쉬는 시간 AI 자동 중지
- [ ] 신뢰도 < 0.7 → 수동 폴백
- [ ] "자동 감지: 50kg × 8회" 토스트 표시

---

## 9. CV 작업 진행 상황

### Phase 1: 횟수 카운팅 — **미시작**
- [ ] 카메라 권한 설정 (Android/iOS)
- [ ] camera + google_mlkit_pose_detection 패키지 추가
- [ ] pose_detection_service.dart (MediaPipe 래퍼)
- [ ] rep_counter_service.dart (운동별 각도 규칙)
- [ ] cv_provider.dart (상태 관리)
- [ ] camera_overlay.dart + pose_overlay.dart (UI)
- [ ] exercise_angles.dart (운동 10~15개 각도 데이터)
- [ ] workout_screen.dart에 CV 모드 토글 추가
- [ ] 실기기 테스트 (바이셉 컬, 스쿼트, 벤치프레스)

### Phase 2: 무게 감지 — **미시작**
- [ ] 헬스장 사진 수집 (3,000~5,000장)
- [ ] Roboflow 라벨링
- [ ] YOLO11 nano 학습 (Colab)
- [ ] model.tflite 변환 + 앱 내장
- [ ] 플레이트 등록 UI
- [ ] 무게 계산 로직
- [ ] B2B Fine-tuning 파이프라인

---

## 10. 참고 문서

### 기술 조사
- `docs/reference/CV_무게측정_횟수카운팅_최신기술_보고서_2026.md` — 모델 비교, 정확도, 오픈소스 목록

### 사업 전략
- `docs/reference/CV_피벗_사업계획서_Fica_2026.md` — 시장 분석, 경쟁사, 비즈니스 모델

### 앱 분석 보고서
- `docs/02-12_CV분석_1_아키텍처_전체구조.md` — 아키텍처 호환성 상세
- `docs/02-12_CV분석_2_운동화면_심층분석.md` — 운동 화면 통합 상세
- `docs/02-12_CV분석_3_성능_빌드_호환성.md` — 성능/빌드 상세

### Q&A 기록
- `docs/02-12-10-46_CV_무게횟수_자동감지_진행상황.md` — 기술 논의 전체 정리
