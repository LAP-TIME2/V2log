# Plan: Phase 2B — YOLO26-N 무게 자동 감지 앱 통합

## Context

Phase 2A에서 YOLO26-N 모델 학습 완료 (mAP50: 96.2%).
이제 학습된 모델을 V2log 앱에 넣어서 **카메라로 바벨을 비추면 무게를 자동 인식**하게 만든다.

**핵심 가치**: 수동 무게 입력(5초) → AI 자동 감지(0초) = UX 혁신

---

## 패키지 선택: `tflite_flutter`

| 후보 | 장점 | 단점 | 결정 |
|------|------|------|------|
| **`tflite_flutter`** | 가장 성숙, 직접 제어, 기존 camera 스트림 활용 | 수동 텐서 파싱 필요, GPU 가속 불가 | ✅ **선택** |
| `ultralytics_yolo` | 공식, YOLO 파싱 내장 | 자체 카메라뷰 충돌 위험, YOLO26 지원 불확실 | ❌ |
| `onnxruntime_v2` | NNAPI GPU 지원 | 더 무거움, Flutter 생태계 미성숙 | 📋 예비 |

**왜 `tflite_flutter`인가:**
- 기존 `camera` 패키지 스트림에서 프레임을 가져와 직접 추론 → 충돌 없음
- YOLO26 TFLite GPU 비호환 문제 있지만, 무게 감지는 2~3fps면 충분 → **CPU 전용으로 50~80ms/프레임이면 OK**
- 플레이트는 안 움직이니까 실시간 30fps 불필요
- `.tflite` 파일 이미 준비됨 (9.85MB)

---

## 모델 출력 형식 (YOLO26 NMS-free)

**입력**: `[1, 640, 640, 3]` (RGB, float32, /255.0 정규화)
**출력**: `[1, 300, 6]` (NMS-free, 최대 300개 감지)

각 감지: `[x_center, y_center, width, height, confidence, class_id]`
- confidence ≥ 0.5 → 유효 감지
- class_id → data.yaml 순서 (0: plate_25kg ~ 8: empty_barbell)

YOLO26은 NMS가 내장되어 있어서 **별도 NMS 후처리 불필요** (구 YOLO 대비 큰 장점)

---

## 클래스 → 무게 매핑

```dart
const classWeights = {
  0: ('plate_25kg', 25.0),
  1: ('plate_20kg', 20.0),
  2: ('plate_15kg', 15.0),
  3: ('plate_10kg', 10.0),
  4: ('plate_5kg', 5.0),
  5: ('plate_2.5kg', 2.5),
  6: ('plate_1.25kg', 1.25),
  7: ('barbell', 20.0),       // 플레이트 달린 바벨
  8: ('empty_barbell', 20.0), // 빈 바벨
};

// 총 무게 = 바벨(20kg) + 감지된 플레이트 합계
// 카메라는 한쪽만 보이므로 기본적으로 ×2 적용
// 예: plate_20kg 1개 + plate_10kg 1개 감지 → (20+10)×2 + 20 = 80kg
```

---

## Two-Stage 파이프라인 상태 머신

```
[IDLE] ──(CV 토글 ON)──> [WEIGHT_DETECTING]
  ^                           |
  |                           | 3회 연속 같은 무게 (±2.5kg) 감지
  |                           v
  |                      [WEIGHT_CONFIRMED]
  |                           |
  |                           | 첫 운동 동작 감지 (RepCounterService)
  |                           v
  |                      [REP_COUNTING]
  |                           |
  |                           | 무동작 5초 → 카운트다운 3초
  |                           v
  |                      [SET_COMPLETE] → addSet() + 휴식타이머
  |                           |
  |                           | 자동으로 다시
  |                           v
  |                      [WEIGHT_DETECTING] (무게 변경 체크)
  |
  └──(CV 토글 OFF)────────────┘
```

**프레임 라우팅:**
- WEIGHT_DETECTING: 매 5번째 프레임 → YOLO, 매 3번째 → Pose (동작 감시용)
- WEIGHT_CONFIRMED: 매 3번째 → Pose만 (첫 동작 감지 대기)
- REP_COUNTING: 매 3번째 → Pose + RepCounter (기존 Phase 1 그대로)
- SET_COMPLETE: 처리 중단

---

## 구현 Wave 구조

### Wave 1: 핵심 (무게 감지 + 자동 표시) — 먼저 구현

**새 파일 1개:**
- `lib/data/services/weight_detection_service.dart` (~200줄)
  - 싱글톤 패턴 (PoseDetectionService와 동일)
  - `initialize()`: tflite_flutter로 .tflite 모델 로드
  - `processFrame(CameraImage)`: 프레임 → 텐서 변환 → 추론 → 결과 파싱
  - `calculateTotalWeight()`: 플레이트 합산 로직
  - `dispose()`: 모델 해제
  - 매 5번째 프레임만 처리 (frame skip)

**수정 파일 4개:**

1. **`pubspec.yaml`** (+3줄)
   ```yaml
   tflite_flutter: ^0.11.0    # YOLO26 추론
   image: ^4.3.0              # CameraImage → RGB 변환
   ```
   ```yaml
   assets:
     - .env
     - assets/models/          # 모델 파일 등록
   ```

2. **`camera_overlay.dart`** (~60줄 추가/수정)
   - `WeightDetectionService` 인스턴스 추가
   - `onWeightDetected` 콜백 파라미터 추가
   - `enableWeightDetection` bool 파라미터 추가
   - `_onCameraFrame`에 분기: Stage 1이면 YOLO 실행, Stage 2면 Pose만
   - 카메라 위 무게 표시 UI (좌상단: "감지: 60kg")

3. **`workout_screen.dart`** (~25줄 추가)
   - `_weightAutoDetected` + `_detectedWeightConfidence` 상태 변수
   - `onWeightDetected` 콜백 연결 → `_currentWeight` 자동 설정
   - QuickInputControl 근처 "AI 감지" 뱃지 표시
   - 사용자 수동 조작 시 AI 뱃지 해제

4. **`cv_provider.dart`** (~15줄 추가)
   - `CvDetectionResult`에 `detectedWeight`, `weightConfidence` 필드 추가
   - `CvPipelineStage` enum 추가

### Wave 2, 3: 추후 구현 (이번 범위 아님)
- 자동 세트 시작/종료, 바운딩 박스 시각화, 전환 애니메이션 → Wave 1 테스트 후 결정

---

## 핵심 통합 포인트 (실제 코드 기반)

### camera_overlay.dart:16-18 (콜백 확장)
```dart
// 현재
final void Function(int reps, double confidence)? onRepsDetected;

// Phase 2B 추가
final void Function(double weight, double confidence)? onWeightDetected;
final bool enableWeightDetection;  // default: false
```

### camera_overlay.dart:123-141 (_onCameraFrame 분기)
```dart
// 현재: Pose만 처리
void _onCameraFrame(CameraImage image) async {
  final poses = await _poseService.processFrame(image, camera);
  // ... rep counting ...
}

// Phase 2B: Stage에 따라 분기
void _onCameraFrame(CameraImage image) async {
  // Stage 1: 무게 감지
  if (_pipelineStage == PipelineStage.weightDetecting) {
    final weightResult = await _weightService.processFrame(image, camera);
    if (weightResult != null) {
      widget.onWeightDetected?.call(weightResult.totalWeight, weightResult.confidence);
    }
  }

  // Pose는 항상 실행 (Stage 1에서도 동작 감지용)
  final poses = await _poseService.processFrame(image, camera);
  // ... 기존 rep counting 로직 그대로 ...
}
```

### workout_screen.dart:162-175 (콜백 연결)
```dart
// 현재
CameraOverlay(
  onRepsDetected: (reps, confidence) { ... },
)

// Phase 2B
CameraOverlay(
  onRepsDetected: (reps, confidence) { ... },  // 기존 유지
  enableWeightDetection: true,                   // 추가
  onWeightDetected: (weight, confidence) {       // 추가
    setState(() {
      _currentWeight = weight;
      _weightAutoDetected = true;
    });
  },
)
```

### workout_screen.dart:58 (상태 변수)
```dart
// 기존
bool _cvModeEnabled = false;

// 추가
bool _weightAutoDetected = false;
double _detectedWeightConfidence = 0.0;
```

---

## 무게 계산 로직 상세

```
1. YOLO 출력에서 confidence ≥ 0.5인 감지만 사용
2. barbell 또는 empty_barbell 감지 → barbellWeight = 20kg
3. 감지 안 됨 → barbellWeight = 20kg (기본 가정)
4. 플레이트 무게 합산 (감지된 것만)
5. 한쪽 촬영 가정: plateSum × 2
6. totalWeight = barbellWeight + (plateSum × 2)
7. 2.5kg 단위로 반올림
8. 3회 연속 같은 값(±2.5kg) → "확정" (weight_confirmed)
```

**에지 케이스:**
- 플레이트만 감지, 바벨 없음 → 바벨 20kg 기본 추가
- 빈 바벨만 감지 → 20kg
- 아무것도 감지 안 됨 5초 이상 → "플레이트가 감지되지 않습니다" 안내
- 사용자 수동 수정 시 → AI 뱃지 해제, 수동값 유지

---

## 파일 목록 요약

| 파일 | 작업 | 줄수 (예상) |
|------|------|------------|
| `lib/data/services/weight_detection_service.dart` | **신규** | ~200 |
| `pubspec.yaml` | 수정 (패키지 + assets) | +3 |
| `camera_overlay.dart` | 수정 (콜백 + 프레임 분기) | +60 |
| `workout_screen.dart` | 수정 (상태 + 콜백 + 뱃지) | +25 |
| `cv_provider.dart` | 수정 (weight 필드 + Stage enum) | +15 |

**총 새 코드**: ~300줄 (Wave 1)

---

## 구현 순서

### Step 1: 패키지 설치 + 에셋 등록
- pubspec.yaml에 `tflite_flutter`, `image` 추가
- `assets/models/` 등록
- `flutter pub get` + 빌드 확인

### Step 2: WeightDetectionService 기본 — 모델 로드만
- 싱글톤 클래스 생성
- initialize()에서 .tflite 모델 로드
- dispose()로 해제
- 빌드 + 모델 로드 성공 확인

### Step 3: WeightDetectionService — 프레임 처리 + 추론
- CameraImage → RGB Uint8List 변환 (image 패키지)
- 640×640 리사이즈 + /255.0 정규화
- tflite_flutter로 추론 실행
- YOLO26 출력 [1, 300, 6] 파싱
- 콘솔 로그로 감지 결과 확인

### Step 4: 무게 계산 로직
- 클래스별 무게 매핑
- 플레이트 합산 + ×2 + 바벨
- 2.5kg 반올림
- 3회 연속 안정성 체크

### Step 5: CameraOverlay 통합
- onWeightDetected 콜백 추가
- _onCameraFrame에 Stage 분기
- 카메라 UI에 감지 무게 표시

### Step 6: workout_screen 통합
- 상태 변수 + 콜백 연결
- _currentWeight 자동 설정
- AI 뱃지 표시
- 수동 오버라이드 처리

### Step 7: cv_provider 확장
- CvDetectionResult에 weight 필드
- PipelineStage enum

### Step 8: 실기기 테스트
- 실제 플레이트로 감지 테스트
- 각도/조명/거리별 정확도 확인
- 배터리 영향 체크
- 엣지 케이스 (감지 실패, 가림, 한쪽만 보임)

---

## 검증 방법

1. **빌드 테스트**: `flutter build apk --debug` 성공
2. **모델 로드**: WeightDetectionService.initialize() 호출 시 에러 없음
3. **추론 테스트**: 플레이트 사진을 카메라로 비추면 콘솔에 감지 로그 출력
4. **무게 계산**: 20kg 플레이트 2개 감지 시 → (20+20)×2 + 20 = 100kg... 아닌데, 감지된 게 2개면 이미 양쪽인지 한쪽인지 판단 필요
5. **실기기 테스트**: `flutter run -d R3CN90HVMKL`로 안드로이드 기기 테스트
6. **UX 테스트**: QuickInputControl 값이 AI 감지값으로 자동 변경되는지 확인

---

## 리스크 및 대응

| 리스크 | 가능성 | 대응 |
|--------|--------|------|
| tflite_flutter 빌드 실패 | 중 | onnxruntime_v2로 전환 |
| CameraImage→RGB 변환 느림 | 중 | frame skip 강화 (매 10번째), 또는 platform channel |
| YOLO26 출력 형식 예상과 다름 | 중 | 모델 output shape 확인 후 파서 조정 |
| CPU 추론 80ms+ 느림 | 저 | 2~3fps면 충분, 320×320으로 축소 가능 |
| 한쪽/양쪽 플레이트 구분 불가 | 높 | 기본 ×2 + 사용자 수정 허용 (hybrid) |
| 모델 10MB로 앱 사이즈 증가 | 확실 | 프리미엄 기능이므로 허용 |
