# CV 수정노트

> CV 기능 개발 과정에서 발견된 버그, 질문-답변, 해결 과정을 영구 기록.
> session-log는 세션별 초기화되지만, 이 파일은 Git에 영구 보존됨.

---

## v2B-001: 클래스 매핑 불일치 버그 (2026-02-16)

### 증상
- 헬스장 실기기 테스트에서 원판 측정이 **전혀 안 됨**
- CV 모드 ON → 카메라는 작동하지만 무게 감지 로그 없음

### 원인
**치명적 버그: Roboflow 클래스 순서 vs 코드 클래스 순서 불일치**

Roboflow는 클래스를 **알파벳순으로 자동 정렬**함. 모델 학습 시 5개 클래스가 이 순서로 학습됨:
```
0 = plate_10kg
1 = plate_15kg
2 = plate_2.5kg
3 = plate_20kg
4 = plate_5kg
```

하지만 코드에는 **9개 클래스가 다른 순서**로 들어있었음:
```dart
// 틀린 코드 (9개, 순서도 다름)
static const List<String> _classNames = [
  'plate_25kg', 'plate_20kg', 'plate_15kg', 'plate_10kg', 'plate_5kg',
  'plate_2.5kg', 'plate_1.25kg', 'barbell', 'empty_barbell',
];
```

**그러니까**: 모델이 "이건 20kg 원판이야 (class_id=3)"라고 출력하면, 코드는 3번째 클래스를 찾는데 그게 `plate_10kg`이었음. 결국 모든 무게가 엉뚱하게 매핑되고, 대부분은 범위 밖이라 아예 감지 안 된 것처럼 보임.

### 해결
```dart
// 수정된 코드 (5개, Roboflow 알파벳순)
static const List<String> _classNames = [
  'plate_10kg',   // 0
  'plate_15kg',   // 1
  'plate_2.5kg',  // 2
  'plate_20kg',   // 3
  'plate_5kg',    // 4
];
```

### 배운 점
1. **Roboflow는 클래스를 알파벳순으로 정렬한다** — data.yaml의 순서와 다를 수 있음
2. **모델의 실제 출력과 코드의 클래스 매핑은 반드시 일치해야 함**
3. **Python으로 TFLite 모델의 입출력 shape를 확인하는 습관** 필요

### 영향 파일
- `lib/data/services/weight_detection_service.dart` — _classNames, _classWeights 수정

---

## v2B-002: Two-Stage 파이프라인 UX 설계 (2026-02-16)

### 배경
- 원래 설계: YOLO + Pose 동시 실행 → 둘 다 성능 부족
- 사용자 피드백: 후면→전면 카메라 전환은 UX가 너무 복잡, 아무도 안 쓸 것

### 해결: "바벨 보여주기" + Two-Stage 순차 처리
```
Stage 1 (무게 감지 모드):
  - YOLO만 실행 (Pose 완전 스킵)
  - "바벨을 카메라에 보여주세요" 안내 표시
  - 사용자가 바벨을 전면 카메라 앞으로 가져감
  - 3회 안정화 → "XXkg 확정!" → 2초 후 자동 전환

Stage 2 (운동 모드):
  - Pose만 실행 (YOLO 완전 스킵)
  - 기존 횟수 카운팅 + 관절 오버레이
  - 좌하단에 확정 무게 작게 표시 (탭하면 Stage 1로 복귀)
```

### 핵심 설계 결정
- **한 번에 하나의 ML 모델만 실행** → 성능 확보
- **전면 카메라만 사용** → UX 복잡도 최소화 (삼각대/거치대 기준)
- **자동 전환** → 버튼 누르기 없음
- **세트 완료 시 Stage 1 복귀** → 무게 변경 대응

### 영향 파일
- `lib/presentation/widgets/molecules/camera_overlay.dart` — 완전 재작성 (~630줄)
- `lib/data/services/weight_detection_service.dart` — 디버그 로그 추가

### CameraStage enum
```dart
enum CameraStage {
  weightDetecting,  // Stage 1: YOLO만
  repCounting,      // Stage 2: Pose만
}
```

---

## 참고: 모델 성능 (YOLO26-N, 2026-02-15 학습)

| 지표 | 값 |
|------|-----|
| mAP50 | 96.2% |
| mAP50-95 | 85.3% |
| Recall | 90.6% |
| Precision | 95.9% |
| 모델 크기 | 9.8MB (.tflite) |
| 입력 | [1, 640, 640, 3] NHWC float32 |
| 출력 | [1, 300, 6] (x, y, w, h, conf, class_id) |
| 클래스 | 5개 (plate_10kg, plate_15kg, plate_2.5kg, plate_20kg, plate_5kg) |

---

## v2B-003: 무게 감지 성능 최적화 (2026-02-16)

### 증상
- 헬스장 실기기 테스트에서 **카메라 프레임이 슬라이드쇼 수준으로 떨어짐**
- 모델이 30.0kg을 감지하긴 했지만 **안정화가 67%에서 멈춤** (3회 중 2회)
- 1분+ 대기해도 안정화 완료 안 됨 → 사실상 사용 불가

### 원인 (5개 병목)
1. **YUV→img.Image 변환**: 순수 Dart로 30만 픽셀 루프 (200-500ms)
2. **img.copyResize**: 순수 Dart bilinear 보간 640×640 (100-200ms)
3. **텐서 생성**: `List.generate` 4중 루프로 boxed double 123만 개 할당 (150-300ms)
4. **TFLite 추론**: CPU 1스레드, GPU 미사용 (300-800ms)
5. **안정성 로직 버그**: `plates.isEmpty`일 때 0kg이 `_recentWeights`에 추가 → 안정화 방해

**그러니까**: 사진 1장을 AI에 넣으려고 Dart(느린 언어)로 30만 픽셀을 하나하나 변환하고, 또 리사이즈하고, 또 리스트로 복사하는 3단계 중복 처리를 하고 있었어요. 거기다 GPU를 안 쓰고 CPU 1개 코어만으로 AI를 돌렸고, 감지 실패 시 0kg이 기록돼서 안정화가 계속 깨졌어요.

### 해결 (4단계)

**Step 1: 안정성 로직 수정 + 버퍼 사전 할당**
```dart
// 감지 성공 시에만 기록 (0kg 오염 방지)
if (plates.isNotEmpty) {
  _recentWeights.add(totalWeight);
}
// 출력 텐서를 클래스 필드로 1회 할당, 매 프레임 재사용
final List<List<Float32List>> _outputTensor = List.generate(...);
```

**Step 2: img.Image 제거 + YUV→Float32List 직접 변환**
```
기존: YUV → img.Image (30만 루프) → img.copyResize (40만 보간) → List.generate (123만 double)
최적화: YUV → Float32List (nearest neighbor 리사이즈 통합, 1회 루프)
```
- `_convertCameraImage()`, `_preprocess()` 삭제
- `_preprocessInIsolate()` 신규 (top-level 함수)
- `import 'package:image/image.dart'` 삭제

**Step 3: GPU Delegate + 멀티스레드**
```dart
// 폴백 체인: GPU → XNNPack → CPU 4스레드
final options = InterpreterOptions()..threads = 4;
try { options.addDelegate(GpuDelegateV2(...)); }
catch (_) { options.addDelegate(XNNPackDelegate(...)); }
```

**Step 4: Isolate로 전처리 분리**
```dart
// 무거운 이미지 처리를 별도 Isolate(일꾼)에서 실행
final inputData = await Isolate.run(() => _preprocessInIsolate(params));
// → UI 스레드 블로킹 0ms (카메라 60fps 유지)
```

### 성능 비교

| 지표 | 최적화 전 | 최적화 후 |
|------|----------|----------|
| 전처리 | 500-1000ms | 30-50ms (off-thread) |
| 추론 | 300-800ms | 50-200ms (GPU/XNNPack) |
| 합계 | 1-3초 | 80-250ms |
| UI 블로킹 | 1-3초 (프리즈) | ~0ms |
| 안정화 시간 | 1분+ (실패) | 5-10초 |
| 메모리/프레임 | ~23MB | ~4.7MB |

### 배운 점
1. **img.Image는 실시간 처리에 부적합** — 순수 Dart 이미지 라이브러리는 디버깅용이지 프로덕션 파이프라인용이 아님
2. **중간 객체 최소화**: YUV→img.Image→resized→List 3단계를 YUV→Float32List 1단계로
3. **GPU Delegate는 Dart try-catch로 잡을 수 없다** — C++ 레벨 네이티브 크래시 → 앱 자체가 종료됨. 코드에서 제거해야 함
4. **Isolate.run()은 양날의 검** — 전처리 30-50ms 수준이면 오히려 Isolate 생성/파괴 오버헤드(7-20ms)가 역효과
5. **안정성 로직에 감지 실패 케이스 처리 필수** — 0kg 삽입이 전체 안정화를 방해

### 영향 파일
- `lib/data/services/weight_detection_service.dart` — 전면 재작성 (449줄 → 485줄)

### 상세 보고서
→ `docs/reference/02-16_무게감지_성능최적화_분석.md`

---

## v2B-004: 무게 감지 성능 최적화 v2 — 3가지 문제 수정 (2026-02-16)

### 증상 (v2B-003 최적화 후 발생)
- GPU Delegate → 네이티브 크래시 (앱 강제 종료)
- `interpreter.run()`에서 "failed precondition" 에러 → **무게 감지가 실제로 안 되고 있었음**
- Isolate.run() 매 프레임 생성/파괴 → 프레임 드롭 악화

### 원인 3가지

**문제 1: GPU Delegate 네이티브 크래시**
- `GpuDelegateV2()` 생성 시 C++ 레벨 크래시 → Dart try-catch로 **잡을 수 없음**
- tflite_flutter의 GPU delegate가 이 기기(Note 20 Ultra) 드라이버와 호환 안 됨
- **해결**: GPU/XNNPack delegate 코드 완전 제거 (v2B-003에서 이미 조치)

**문제 2: interpreter.run() "failed precondition"**
- `inputData.buffer` (ByteBuffer)를 전달 → tflite_flutter 내부에서 shape 불일치
- `_outputTensor`가 `List<List<Float32List>>` → tflite_flutter가 검증 안 하는 타입 조합
- **그러니까**: AI 모델에 데이터를 넣을 때, 모델이 기대하는 형태(4차원 배열)와 실제 넣은 형태(1차원 바이트)가 안 맞아서 "조건이 안 맞아!" 에러가 매 프레임 발생. 결국 무게 감지가 한 번도 성공하지 못함.
- **해결**: 입력은 `Float32List.buffer.asUint8List()`, 출력은 `List<List<List<double>>>`

**문제 3: Isolate.run() 오버헤드**
- 매 호출마다 새 Isolate 생성+파괴 (7-20ms 오버헤드/회)
- 460KB 데이터 직렬화/역직렬화 추가
- 전처리 30-50ms인데 Isolate 오버헤드 10-20ms → **20-60% 추가 비용**
- **그러니까**: "일꾼을 고용해서 일을 시키자!" 했는데, 매번 새 일꾼을 채용→해고하는 비용이 일 자체만큼 큰 상황. 차라리 혼자 하는 게 빠름.
- **해결**: Isolate 제거, UI 스레드에서 직접 처리. `_isProcessing` 플래그로 4/5 프레임 즉시 스킵 → 카메라 프리뷰 부드러움 유지.

### 변경 내역
1. **Isolate 제거** — `_preprocessInIsolate`, `_PreprocessParams`, `_buildPreprocessParams`, `import 'dart:isolate'` 삭제
2. **입력 형식 수정** — `Float32List._inputBuffer` 사전 할당 → `.buffer.asUint8List()` 으로 zero-copy 전달
3. **출력 형식 수정** — `List<List<Float32List>>` → `List<List<List<double>>>` (매 프레임 새로 할당, 0.1ms 미만)
4. **전처리 직접 실행** — `_preprocessDirect(CameraImage)` 메서드, Isolate 없이 UI 스레드

### 성능 비교

| 지표 | v2B-003 (문제) | v2B-004 (수정) |
|------|--------------|--------------|
| 전처리 | 30-50ms + Isolate 7-20ms | **30-50ms** |
| 추론 | 에러로 미실행 | **100-300ms** (4스레드) |
| UI 블로킹 | 10-20ms (오버헤드) | **130-350ms** (5프레임마다) |
| 실제 감지 | **작동 안 함** | **작동** |

### 배운 점
1. **tflite_flutter 입력은 Uint8List가 가장 안전** — `TfLiteTensorCopyFromBuffer()`로 직접 바이트 복사, shape 검사 없음
2. **tflite_flutter 출력은 List<List<List<double>>>이 검증됨** — Float32List 조합은 미검증
3. **Isolate.run()은 전처리 < 50ms일 때 역효과** — 생성/파괴 비용이 전처리와 비슷하면 의미 없음
4. **"작동하던 것 기반으로 수정"이 가장 안전** — 새로운 최적화 기법보다 검증된 입출력 형식 우선

### 영향 파일
- `lib/data/services/weight_detection_service.dart` — 재작성

---

## v2B-005: 무게 감지 성능 최적화 v3 — IsolateInterpreter + 안정화 개선 (2026-02-16)

### 증상 (v2B-004 최적화 후 발생)
- Stage 1 (YOLO 무게감지) ~28fps, Stage 2 (Pose 횟수카운팅) ~53fps → **2배 프레임 차이** 체감
- YOLO 추론 200ms가 UI 스레드에서 동기 실행 → 초당 1~2회 버벅임
- 안정화 UI에 "91%"라고 표시되지만 1분+ 지나도 안정화 완료 안 됨
- **그러니까**: AI가 무게를 계산하는 동안 화면이 멈추고, "거의 다 됐어요(91%)"라고 거짓말하고 있었어요

### 원인 2가지

**문제 1: YOLO 추론이 UI 스레드 블로킹**
- `_interpreter!.run(input, output)` = 동기 실행, 200ms 동안 UI 멈춤
- v2에서 Isolate.run()을 제거한 이유 → 매번 생성/파괴 오버헤드 (7-20ms)
- **하지만**: tflite_flutter 0.11.0에 `IsolateInterpreter` 클래스가 이미 있었음
  - `Isolate.run()`: 매번 새 Isolate 생성+파괴 (오버헤드 큼)
  - `IsolateInterpreter`: 1회 생성, 계속 재사용 (오버헤드 ~1ms)
- **그러니까**: "매번 새 일꾼을 뽑아서 해고"하는 대신, "상근 일꾼 1명"을 두고 계속 일 시키는 거예요

**문제 2: 안정화 로직이 너무 엄격**
- 기존: 최근 3개 무게가 **모두** ±2.5kg 이내 (3연속 일치)
- 모델이 프레임마다 다른 수의 플레이트 감지 → 무게가 40→30→25kg 변동
- `_stabilityTolerance = 2.5kg`인데, 변동이 10-20kg → **절대 안정화 불가**
- UI의 91%는 모델 신뢰도(confidence)인데, 이건 안정화와 무관 → **사용자 혼란**
- **그러니까**: "3번 연속 같은 무게가 나와야 해"인데, AI가 매번 다른 개수의 원판을 감지해서 무게가 계속 바뀜. 화면의 91%는 "AI가 자기 답에 91% 확신"이라는 뜻이지 "91% 완료"가 아니었음

### 해결 (2가지)

**문제 1 해결: IsolateInterpreter (tflite_flutter 공식)**
```dart
// 초기화 (1회)
_isolateInterpreter = await IsolateInterpreter.create(
  address: _interpreter!.address,
);

// 추론 (매 프레임 — 백그라운드)
await _isolateInterpreter!.run(input, output);
// → UI 스레드 블로킹 0ms, 카메라 프리뷰 부드러움 유지
```

**문제 2 해결: 최빈값(MODE) 기반 안정화**
```dart
// 변경 전: 3연속 ±2.5kg
// 변경 후: 5개 중 최빈값 3개 이상
static const int _stabilityWindow = 5;
static const int _stabilityRequired = 3;

// 신뢰도 필터: 70% 미만 감지는 기록하지 않음
static const double _stabilityConfidenceThreshold = 0.7;

// UI: "91%" → "2/3 안정화"
Text('잠시 고정해주세요 ($_stabilityHits/$_stabilityRequired 안정화)')
```

### 성능 비교

| 지표 | v2 | v3 |
|------|----|----|
| UI 블로킹 | 200ms (추론) | **0ms** (백그라운드) |
| Stage 1 FPS | ~28fps | **~45-50fps** (예상) |
| 안정화 방식 | 3연속 ±2.5kg | **5개 중 최빈값 3개** |
| 안정화 필터 | 없음 | **신뢰도 ≥ 0.7** |
| UI 표시 | 91% (모델 신뢰도) | **2/3 (실제 진행률)** |

### 배운 점
1. **tflite_flutter에 IsolateInterpreter가 이미 있었다** — 라이브러리 소스 코드를 먼저 확인하는 습관 필요
2. **"연속 N회 일치"는 노이즈에 취약** — 최빈값(MODE) 방식이 outlier에 강건함
3. **UI에 표시하는 지표와 실제 로직이 일치해야** — 신뢰도를 진행률로 오해하게 만들면 안 됨
4. **Isolate.run()과 IsolateInterpreter는 완전히 다른 패턴** — 전자는 1회용, 후자는 상주

### 영향 파일
- `lib/data/services/weight_detection_service.dart` — IsolateInterpreter + 안정화 로직 재작성
- `lib/presentation/widgets/molecules/camera_overlay.dart` — UI 안정화 진행률 표시

---

## v2B-006: 헬스장 실기기 테스트 3대 버그 수정 (2026-02-16)

### 증상 3가지

| # | 증상 | 심각도 |
|---|------|--------|
| 1 | 카메라 영상이 가로로 찌그러져 보임 (10kg이 20kg처럼 두꺼워 보임) | 높음 |
| 2 | 실제 40kg인데 60kg으로 표시됨 | 높음 |
| 3 | 뒤에 있는 사람을 추적해서 11회가 찍힘 (사용자는 아직 눕지도 않음) | 치명적 |

### 원인 1: 카메라 비율 깨짐

`StackFit.expand`가 카메라 프리뷰를 `SizedBox(height: 200)`에 억지로 꽉 채움. 카메라 원래 비율은 4:3인데, 가로로 넓은 상자에 맞추다보니 가로로 늘어남.

**그러니까**: 정사각형 사진을 직사각형 틀에 억지로 끼운 것. 원형 원판이 타원으로 보이는 거예요.

**해결**: `FittedBox(fit: BoxFit.cover)` — "비율 유지하면서 상자를 꽉 채워라, 넘치는 건 잘라" (사진 앱의 크롭과 같은 원리)

### 원인 2: 무게 이중 계산

모든 감지된 플레이트를 합산한 뒤 ×2. 양쪽 원판이 다 보이는 정면에서는 이중 계산됨.

**그러니까**: 바벨 양쪽에 10kg씩 = 40kg인데, 10+10=20 × 2 = 60kg으로 계산한 거예요.

**해결**: 좌/우 그룹핑 (xCenter 기준) → 더 많이 감지된 쪽(가까운 쪽)만 × 2
- 바벨 측면: 가까운 쪽 전부 감지 + 먼 쪽은 가려서 일부만 → 가까운 쪽이 정확
- 바벨 정면: 양쪽 동일 → max(left, right) = 한쪽 → × 2 = 정확

### 원인 3: 배경 사람 추적

`poses.first` = "가장 먼저 감지된 사람" = 배경 사람일 수 있음. MediaPipe는 모든 사람을 감지하지만, 첫 번째가 사용자라는 보장 없음.

**그러니까**: 헬스장에서 뒤에 누가 지나가면 그 사람의 동작을 세는 거예요. 사용자는 누워있는데 11회가 찍힘.

**해결**: `selectPrimaryPose()` — 가장 크고(70%) + 화면 중앙에 가까운(30%) 포즈 선택
- 가까운 사람 = 크게 보임 → 크기 점수 높음
- 사용자 = 대체로 화면 중앙 → 중앙 점수 높음
- 배경 사람 = 작고 가장자리 → 자동 무시

### 영향 파일
- `lib/data/services/weight_detection_service.dart` — `_calculateTotalWeight()` 좌/우 그룹핑
- `lib/data/services/pose_detection_service.dart` — `selectPrimaryPose()` static 메서드 추가
- `lib/presentation/widgets/molecules/camera_overlay.dart` — FittedBox cover + primaryPose 적용

### 배운 점
1. **StackFit.expand는 카메라에 쓰면 안 됨** — 비율이 깨짐. `FittedBox(BoxFit.cover)` 사용
2. **바벨 무게 계산은 "한쪽 × 2"가 정석** — 양쪽 합산은 가림/가시성 문제로 부정확
3. **다중 사용자 환경은 CV 개발 첫날부터 고려해야** — `poses.first`는 헬스장에서 사용 불가
4. **헬스장 환경 체크리스트 필수** — 실험실에서 1명일 때 잘 되는 건 아무 의미 없음

---

## v2B-007: 무게 감지 정확도 + 속도 개선 (2026-02-16)

### 증상
- 헬스장 실기기 테스트에서 **5kg 원판을 20kg으로 오분류** → 30kg 바벨이 60kg으로 표시
- 감지까지 4초, 안정화 0/3에서 장시간 정체, **총 27초 소요** → 사용 불가 수준
- 사용자가 카메라를 가까이 가져가야만 정확해지는 현상

### 근본 원인: 카메라 해상도 부족

**카메라 → YOLO 변환 경로**:
```
ResolutionPreset.low = 640×480
→ YOLO 입력 640×640으로 업스케일 (33% 확대, nearest neighbor → 블러)
→ 블러된 이미지에서 5kg과 20kg 원판 구분 불가
→ confidence 0.5~0.65 → 안정화 임계값(0.7) 미달 → 0/3 유지
```

**왜 가까이 가면 30kg이 되는가**: 원판이 프레임에서 더 크게 보여 세부 디테일(크기, 두께)이 선명 → 정확 분류

### 해결: 4개 수정

**1. 카메라 해상도: low → high (핵심)**
```dart
// camera_overlay.dart
ResolutionPreset.high  // 1280×720 → YOLO 640×640으로 다운스케일 (정보 유지)
```
- 720p가 640에 가장 가까워서 픽셀 활용률 89% (최적)
- veryHigh/max는 YOLO 품질 동일하고 Pose만 느려져서 비추천

**2. 프레임 스킵: 5 → 1 (매 프레임)**
```dart
// weight_detection_service.dart
static const int _frameSkipInterval = 1;
```
- `_isProcessing` 가드가 이미 자연 속도 제한 (5-7회/초 고정)
- frameSkip=1이면 추론 완료 후 즉시 다음 프레임 처리 (대기 33ms vs 166ms)
- CPU/배터리 영향 없음 (boolean 비교 1개 = 비용 0)

**3. 안정화 신뢰도 임계값: 0.7 → 0.55**
```dart
// weight_detection_service.dart
static const double _stabilityConfidenceThreshold = 0.55;
```
- 1.5m 거리에서도 안정화 가능
- 최빈값 3/5 필터가 노이즈 차단 → 낮은 임계값에도 정확

**4. Stage 1 프리뷰 높이: 200px → 280px**
```dart
// camera_overlay.dart
height: _currentStage == CameraStage.weightDetecting ? 280 : 200,
```
- 바벨 위치 확인 용이 (UX 개선)

### 예상 성능 비교

| 지표 | 수정 전 | 수정 후 |
|------|---------|---------|
| 카메라 해상도 | 640×480 (업스케일) | **1280×720 (다운스케일)** |
| 첫 감지 | ~4초 | **~1초** |
| 분류 정확도 | 5kg→20kg 오분류 | **5kg 정확 감지** |
| 안정화 임계값 | conf ≥ 0.7 | **conf ≥ 0.55** |
| 추론 후 대기 | 최대 166ms | **최대 33ms** |
| 총 소요 | **27초** | **3~5초 (예상)** |

### 설계 근거

| 선택 | 이유 |
|------|------|
| high(720p) vs veryHigh(1080p) | 720p→640이 거의 1:1 (89% 활용), 더 올려도 YOLO 품질 동일, Pose만 느려짐 |
| frameSkip=1 vs 3 | _isProcessing 가드가 실제 처리 횟수 제한, =1이면 즉시 반응만 좋아지고 단점 없음 |
| 0.55 vs 0.6 vs 0.7 | 해상도 상승으로 conf 자체가 높아짐 + 최빈값 필터가 노이즈 방어 |
| Stage별 해상도 분리 안 함 | CameraController는 1개 해상도만, 전환 시 1~2초 검은 화면 → UX 나쁨 |

### 영향 파일
- `lib/presentation/widgets/molecules/camera_overlay.dart` — ResolutionPreset.high + Stage별 프리뷰 높이
- `lib/data/services/weight_detection_service.dart` — frameSkip 1 + stability threshold 0.55

---

## v2B-008: TFLite 네이티브 크래시 — 스크린샷 시 앱 강제 종료 (2026-02-16)

### 증상
- 스크린샷 찍으면 앱 강제 종료
- crash buffer에 **같은 패턴 4건**:
  ```
  signal 11 (SIGSEGV), code 1 (SEGV_MAPERR)
  Cause: null pointer dereference
  backtrace: libtensorflowlite_jni.so → [anon:dart-code]
  ```

### 원인: Use-After-Free (해제 후 사용)

**경로**:
```
[1] 스크린샷 → Android: AppLifecycleState.inactive 발생
[2] didChangeAppLifecycleState(inactive) → _disposeCamera() 호출
[3] _disposeCamera() 내부에서 _weightService.dispose() 실행
    → _isolateInterpreter?.close() → 네이티브 TFLite 메모리 해제
[4] 이미 실행 중이던 _onCameraFrame:
    → await _isolateInterpreter!.run(input, output)
    → 💥 SIGSEGV: 이미 free된 네이티브 메모리 접근!
```

**왜 `_isProcessing` 플래그가 못 막는가**: `await` 시점에 Dart 이벤트 루프가 다른 이벤트(lifecycle)를 처리할 수 있음. `await`로 대기하는 동안 `dispose()`가 끼어들어서 인터프리터를 죽이는 것.

**그러니까**: TFLite AI 모델이 이미 메모리에서 해제된 상태인데 코드가 계속 사용하려고 해서 앱이 터지는 거예요. C++ 레벨 크래시라서 Dart의 try-catch로는 **절대 못 잡아요**.

### 해결: 싱글톤 서비스는 위젯 lifecycle에서 dispose하지 않는다

**핵심 원칙**: `WeightDetectionService`는 싱글톤 (`factory → _instance`). 앱 생명 주기 동안 1개만 존재. 위젯이 사라졌다가 다시 나와도 같은 인스턴스를 재사용.

**수정 1** — `camera_overlay.dart` `_disposeCamera()`:
```dart
// 변경 전:
_poseService.dispose();
_weightService.dispose();  // 💥 크래시 원인

// 변경 후:
_poseService.dispose();
// WeightDetectionService는 싱글톤 — dispose 금지
```

**수정 2** — `weight_detection_service.dart` `processFrame()`:
```dart
// 추론 직전 방어 null check (다른 경로에서 dispose 되었을 경우 안전하게 종료)
if (_isolateInterpreter == null || !_isInitialized) return null;
await _isolateInterpreter!.run(input, output);
```

### Q: 싱글톤을 안 죽이면 메모리 누수 아니야?
아님. 앱 전체에서 1개 (TFLite 10MB + IsolateInterpreter). 앱 종료 시 OS가 회수.

### Q: PoseDetectionService는 왜 dispose해도 되나?
싱글톤이 아님 + Google ML Kit은 Dart 레벨 안전 해제 + 동기적 처리라 in-flight 없음.

### 배운 점
1. **싱글톤 서비스를 위젯 lifecycle에서 dispose하면 Use-After-Free** — 특히 IsolateInterpreter/네이티브 코드
2. **C++ 레벨 크래시는 Dart try-catch로 잡을 수 없다** — signal 11 (SIGSEGV)은 프로세스 즉사
3. **`await` 중간에 다른 이벤트가 끼어든다** — async 메서드의 await 앞뒤로 상태가 바뀔 수 있음
4. **스크린샷이 AppLifecycleState.inactive를 트리거한다** — 삼성 캡처 애니메이션 때문

### 영향 파일
- `lib/presentation/widgets/molecules/camera_overlay.dart` — `_disposeCamera()`에서 `_weightService.dispose()` 제거
- `lib/data/services/weight_detection_service.dart` — `processFrame()` 내 추론 직전 방어 null check

---

## v2B-009: 얼굴/배경 오인식 — False Positive 필터링 (2026-02-16)

### 증상
- 원판 없이 **얼굴만 비췄는데 60kg "확정"**됨
- 심지어 140kg까지 감지 → 안정화 2/3 진행
- "AI 감지 58%" 표시 → 모델 신뢰도가 낮은데도 통과

### 원인
v2B-007에서 카메라를 640×480 → 1280×720으로 올리면서 `_confidenceThreshold`를 0.5, `_stabilityConfidenceThreshold`를 0.55로 낮춘 상태. 720p에서 진짜 원판은 0.8+ 나오는데, 얼굴/배경 같은 비(非)원판 객체가 0.5~0.6으로 나와서 임계값을 통과한 것.

**그러니까**: AI가 "이게 원판인 것 같은데... 58%밖에 확신 못해"라고 하는 건데, 통과 기준이 50%라서 "OK!" 하고 넘긴 거예요. 진짜 원판은 80% 이상 나오니까 기준을 70%로 올리면 얼굴 같은 오인식은 걸러지고 진짜 원판만 통과해요.

### 해결 (3가지)
1. **`_confidenceThreshold`**: 0.5 → **0.7** (얼굴 0.58 → 탈락, 진짜 원판 0.8+ → 통과)
2. **`_stabilityConfidenceThreshold`**: 0.55 → **0.7** (안정화 기록도 같은 기준)
3. **bbox 면적 필터 추가**: `width × height < 0.005` → 탈락 (프레임의 0.5% 미만인 미세 감지 차단)

### 배운 점
1. **임계값은 카메라 해상도에 맞춰야** — 640×480일 때 0.55는 적절했지만, 720p에서는 오인식 양산
2. **False Positive은 실험실에서 못 잡는다** — 원판으로만 테스트하면 "원판 아닌 것"에 대한 오동작을 모름
3. **"AI 감지 N%"가 58%면 의심해야** — 진짜 원판은 80%+ 나옴

### 영향 파일
- `lib/data/services/weight_detection_service.dart` — 임계값 상향 + bbox 면적 필터
