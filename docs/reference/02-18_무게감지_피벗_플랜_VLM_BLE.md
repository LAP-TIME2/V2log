# 피벗: 무게 감지 2가지 접근법 (VLM + 소형 하드웨어)

작성일: 2026-02-18
작성: Claude (V2log 메인 개발 AI)
목적: CV 무게 감지 실패 → 대안 2가지 접근법 플랜

---

## Context

### 왜 피벗하는가
1. **CV 무게 감지 실패**: Aspect Ratio(A), Depth(B), Edge(C) 3가지 모두 헬스장 실기기 테스트에서 실패
   - 근본 원인: 원판 두께/지름 비율 7-13% → 단일 2D 카메라로 겹친 장수 구분 물리적 한계
   - Tempo(유일 상용 경쟁사)도 전용 ToF 카메라로도 동일 원판 겹침 불가 공식 인정
2. **폰 CV 공간 제약**: 저녁 피크 시간 상업 헬스장에서 핸드폰 설치 어려움

### 무조작 원칙 (절대 규칙)
> 운동 작동 중에는 "운동 선택/완료" 같은 불가피한 조작 외에, 사용자에게 추가 조작을 절대 요구하지 않는다.

### 현재 유지하는 것
- **횟수 카운팅**: 기존 Pose(BlazePose) CV 그대로 유지
- **Two-Stage 파이프라인 구조**: Stage 1(무게) → Stage 2(횟수) 그대로 유지
- **Stage 1만 교체**: YOLO 온디바이스 → VLM API 또는 하드웨어 입력으로 대체

### 사용자 환경
- **인터넷**: 헬스장 WiFi 있음 → VLM API 가능
- **스마트워치**: Galaxy Watch 보유
- **하드웨어**: 관심 있지만 경험 없음

---

## 접근법 1: VLM 스냅샷 — "사진 1장 → AI가 무게 알려줌"

### 핵심 아이디어
운동 시작 전, 바벨 사진 1장 → Gemini Flash API → "총 무게: 60kg" → 자동 입력

### 왜 YOLO보다 가능성이 높은가
| 비교 항목 | YOLO (현재) | VLM (새 접근) |
|----------|------------|--------------|
| 판단 기준 | bbox aspect ratio 1개 지표 | 이미지 전체 종합 이해 |
| 겹친 원판 | 두께 비율 계산 (물리적 한계) | "2장 겹쳐있다"를 시각적으로 이해 |
| 실시간성 | 프레임마다 30fps | 1회성, 1-3초 허용 |
| 각도 민감도 | 극도로 민감 (0° vs 60° = 사용 불가↔겨우 가능) | 다양한 각도 학습됨 (낮음) |
| 혼합 원판 | 클래스 분류만 (조합 추론 불가) | "20kg 1장 + 10kg 1장" 맥락 이해 |

### 비용 분석
```
Gemini 2.0 Flash (개발/테스트):
  - 무료 티어: 15 RPM, 1,500건/일 → 개발 중 완전 무료

Gemini 3 Flash (프로덕션):
  - 이미지 1장 ≈ $0.005 (약 7원)
  - 하루 10종목 = 70원/일
  - 월 2,100원 (구독료 9,900원의 21%)
  - 1,000명 기준 월 서버비: 약 210만원
```

### UX 플로우 (무조작 원칙 준수)
```
1. 운동 선택 → Stage 1 카메라 자동 활성화
2. 바벨이 화면에 잡힘 → YOLO로 "원판 존재" 감지 (기존 모델 재활용)
3. 원판 감지됨 → 자동 캡처 → Gemini API 전송
4. "분석 중..." 표시 (1-3초)
5. 응답: "60kg" → 자동 입력
6. Stage 2 전환 (Pose 횟수 카운팅)

※ 실패 시: 자동 입력 안 함 → 수동 입력 유지 (무조작)
※ 사용자가 누르는 버튼: 0개
```

### 구현 계획

#### Step 1: API 검증 (코드 변경 없이 테스트) — 1일

기존 헬스장 사진으로 Gemini API 정확도만 먼저 확인.

**할 일:**
1. Google AI Studio에서 API Key 발급 (무료)
2. Dart 스크립트로 테스트 (`tools/test_vlm_accuracy.dart` — 임시 파일)
3. 사진 10-20장 × 프롬프트 3-5개 조합 테스트
4. 정확도/응답시간/비용 측정표 작성

**테스트 사진 소스:**
- `C:\Dev\V2log-CV-Training\data\images\` — 기존 촬영분 (537장 라벨링됨)
- 헬스장 영상에서 프레임 추출 (다양한 각도/조합)

**프롬프트 후보:**
```
P1 (영어, 간단): "How many weight plates are on this barbell and what is the total weight in kg? Answer format: {total_kg: N, plates: [{weight_kg: N, count: N}]}"

P2 (영어, 상세): "You are a gym equipment analyzer. This image shows a barbell with Olympic weight plates. Count the number of plates on ONE SIDE, identify each plate's weight (standard colors: red=25kg, blue=20kg, yellow=15kg, green=10kg, white=5kg, or check markings). Return JSON: {side_kg: N, total_kg: N, plates: [{weight: N, count: N}]}"

P3 (한국어): "이 바벨 사진에서 한쪽에 끼워진 원판 장수와 각 무게를 알려주세요. JSON 형식: {한쪽_kg: N, 총_무게_kg: N, 원판: [{무게: N, 장수: N}]}"
```

**검증 기준 (통과/탈락):**
| 항목 | 통과 | 탈락 |
|------|------|------|
| Top-1 정확도 | ≥ 80% | < 60% |
| 응답 시간 | ≤ 3초 | > 5초 |
| 비용/요청 | ≤ $0.01 | > $0.05 |
| 각도 민감도 | 3개 이상 각도에서 일관 | 정면만 정확 |

**테스트 케이스:**
| # | 바벨 구성 | 한쪽 | 양쪽 합계 | 난이도 |
|---|----------|------|----------|--------|
| 1 | 빈 바벨 | 0kg | 20kg (바 자체) | 쉬움 |
| 2 | 20kg × 1장 | 20kg | 60kg | 쉬움 |
| 3 | 20kg × 2장 | 40kg | 100kg | **핵심** |
| 4 | 20kg × 3장 | 60kg | 140kg | 어려움 |
| 5 | 20kg + 10kg | 30kg | 80kg | 혼합 |
| 6 | 10kg × 2장 | 20kg | 60kg | 소형 다중 |
| 7 | 5kg × 2장 | 10kg | 40kg | 소형 |
| 8 | 각도별 동일 구성 (정면/30°/60°) | 동일 | 동일 | 민감도 |

#### Step 2: 앱 통합 (검증 통과 시) — 1-2일

**수정/신규 파일:**

| # | 파일 | 변경 | 신규/수정 |
|---|------|------|----------|
| 1 | `pubspec.yaml` | `google_generative_ai` 패키지 추가 | 수정 |
| 2 | `lib/data/services/vlm_weight_service.dart` | Gemini API 래퍼 서비스 | **신규** |
| 3 | `lib/core/constants/api_keys.dart` | API Key 관리 (또는 .env) | **신규** |
| 4 | `lib/presentation/widgets/molecules/camera_overlay.dart` | Stage 1에서 VLM 호출 연동 | 수정 |
| 5 | `lib/presentation/screens/workout/workout_screen.dart` | VLM 결과 수신 + 무게 자동 입력 | 수정 |

**VLM 서비스 핵심 설계:**
```dart
class VlmWeightService {
  // 싱글톤 (기존 WeightDetectionService처럼)
  static final instance = VlmWeightService._();

  /// 이미지 바이트 → Gemini API → 무게 결과
  Future<VlmWeightResult> detectWeight(Uint8List imageBytes) async {
    // 1. Gemini API 호출
    // 2. JSON 파싱
    // 3. 결과 반환 (totalKg, plates, confidence)
  }
}

class VlmWeightResult {
  final double totalKg;           // 양쪽 합계
  final double sideKg;            // 한쪽
  final List<PlateInfo> plates;   // 원판별 무게+장수
  final double confidence;        // 0.0~1.0
  final String rawResponse;       // 디버그용 원문
}
```

**camera_overlay.dart 변경:**
```
기존 Stage 1 플로우:
  카메라 프레임 → YOLO 추론 → 원판 감지 → 무게 계산 → 안정화 → 자동 확정

새 Stage 1 플로우:
  카메라 프레임 → YOLO 추론 → "원판 있음" 감지 → 캡처 → VLM API → 자동 확정

  핵심 차이:
  - YOLO는 "원판이 있다"만 판단 (기존 모델 재활용, 무게 계산 안 함)
  - 무게 계산은 VLM이 담당
  - 연속 프레임 대신 1회 캡처
```

### 리스크 & 대응

| 리스크 | 확률 | 대응 |
|--------|------|------|
| 정확도 < 80% | 중 | 프롬프트 최적화, few-shot 예제 추가 |
| WiFi 끊김 | 저 | 오프라인 fallback → 수동 입력 |
| 레이턴시 > 3초 | 중 | 이미지 압축, 해상도 조정 |
| API 비용 급증 | 저 | 일일 호출 제한 + 캐싱 (같은 운동 세트 간 재활용) |
| Gemini API 서비스 변경 | 저 | 추상화 레이어 → 다른 VLM으로 교체 가능 |

---

## 접근법 2: 소형 BLE 기기 — "버튼으로 무게 입력 + 폰 Pose로 횟수"

### 핵심 아이디어
작은 BLE 기기(ESP32 + 버튼 + 디스플레이)로 무게만 입력 → BLE로 폰에 전송 → 폰은 Pose 횟수 카운팅만

### 왜 이 조합인가
| 문제 | 해결 |
|------|------|
| 무게 감지 실패 (CV 한계) | 버튼으로 수동 입력 (100% 정확) |
| 폰 설치 공간 제약 | 기기는 손에 쥐거나 벤치에 놓으면 됨 |
| 운동 중 폰 터치 불편 | 물리 버튼은 장갑 끼고도 가능 |
| 무조작 원칙 | 세트 시작 전(휴식 중) 무게 입력 → 원칙 범위 밖 |

### 하드웨어 구성

```
[ESP32-C3 SuperMini]  — 초소형 BLE 모듈 (22×18mm, ~3,000원)
   + [0.96" OLED]     — 현재 무게 표시 (128×64px)
   + [로터리 인코더]   — 돌려서 무게 조정 (±2.5kg씩)
   + [버튼 1개]       — 확정
   + [리튬폴리머 배터리] — 300mAh (1주일+ 사용)
   + [3D 프린팅 케이스] — 손바닥 크기 (5×3×2cm)
```

**부품 비용 (BOM):**
| 부품 | 가격 | 구매처 |
|------|------|--------|
| ESP32-C3 SuperMini | ~3,000원 | 알리/네이버 |
| 0.96" I2C OLED | ~2,500원 | 알리/네이버 |
| 로터리 인코더 (KY-040) | ~1,000원 | 알리 |
| 택트 버튼 | ~200원 | 어디든 |
| 3.7V 300mAh 배터리 | ~3,000원 | 알리 |
| TP4056 충전 모듈 | ~500원 | 알리 |
| 3D 프린팅 케이스 | ~3,000원 | 직접 or 외주 |
| **합계** | **~13,000원** | |

### UX 플로우

```
[세트 사이 휴식 중] — 무조작 원칙 범위 밖
1. 이전 세트 무게가 OLED에 표시됨 (예: "60.0 kg")
2. 무게 변경 필요 시: 로터리 인코더 돌림 → ±2.5kg씩 (예: 62.5kg)
3. 확정 버튼 누름 → BLE로 폰에 전송
4. 폰 앱에 무게 자동 입력

[운동 중] — 무조작 원칙 적용
5. 폰 카메라로 Pose 횟수 카운팅 (기존 시스템 그대로)
6. 세트 완료 → 자동 기록 (무게 + 횟수)
```

**무게 변경 안 할 때 (같은 무게 반복):**
- 아무것도 안 해도 됨 → 이전 무게 자동 유지
- 점진적 과부하로 무게 올릴 때만 다이얼 돌림

### 구현 계획

#### Step 1: 하드웨어 프로토타입 — 1주

**ESP32 펌웨어 (Arduino/PlatformIO):**
```
기능:
1. OLED에 현재 무게 표시
2. 로터리 인코더 입력 → 무게 ±2.5kg 조정
3. 버튼 → 무게 확정 → BLE Notify 전송
4. BLE GATT 서비스:
   - Weight Service (UUID: 커스텀)
   - Weight Characteristic (float32, notify)
   - Control Characteristic (write: 초기값 설정)
5. Deep Sleep → 30초 무입력 시 절전 → 인코더/버튼 인터럽트로 깨움
```

**필요 개발 환경:**
- Arduino IDE 또는 PlatformIO (VS Code 확장)
- ESP32-C3 보드 매니저 설치
- 라이브러리: Adafruit_SSD1306, BLE 내장

**납땜 최소화 방안:**
- 브레드보드로 프로토타입 (납땜 0)
- 점퍼 와이어로 연결
- 동작 확인 후 → 만능기판 또는 PCB 주문

#### Step 2: Flutter BLE 연동 — 3일

**수정/신규 파일:**

| # | 파일 | 변경 | 신규/수정 |
|---|------|------|----------|
| 1 | `pubspec.yaml` | `flutter_blue_plus` 패키지 추가 | 수정 |
| 2 | `lib/data/services/ble_weight_service.dart` | BLE 스캔/연결/데이터 수신 | **신규** |
| 3 | `lib/presentation/widgets/molecules/camera_overlay.dart` | Stage 1에서 BLE 무게 수신 연동 | 수정 |
| 4 | `lib/presentation/screens/workout/workout_screen.dart` | BLE 결과 수신 + 무게 자동 입력 | 수정 |
| 5 | `lib/presentation/screens/profile/` | BLE 기기 페어링 설정 화면 | **신규** |

**BLE 서비스 핵심 설계:**
```dart
class BleWeightService {
  static final instance = BleWeightService._();

  // BLE 연결 상태 스트림
  Stream<BleConnectionState> get connectionState => ...;

  // 무게 데이터 스트림 (기기에서 확정 버튼 누를 때마다)
  Stream<double> get weightStream => ...;

  // 기기에 초기 무게 전송 (이전 세트 무게)
  Future<void> setInitialWeight(double kg) => ...;

  // 스캔 + 연결
  Future<void> scanAndConnect() => ...;
}
```

**camera_overlay.dart 변경:**
```
기존 Stage 1: 카메라 → YOLO → 무게 계산
새 Stage 1 (BLE 모드): BLE 기기에서 무게 수신 대기 → 수신 시 자동 확정 → Stage 2 전환

전환 조건:
- BLE 기기 연결됨 → BLE 모드 자동 활성화
- BLE 기기 미연결 → 기존 모드 (수동 입력 or VLM)
```

#### Step 3: 케이스 + 완성 — 1주

- Fusion 360 / TinkerCAD로 케이스 설계
- 3D 프린팅 (외주 또는 메이커 스페이스)
- 배터리 + 충전 모듈 통합
- 헬스장 실사용 테스트

### 리스크 & 대응

| 리스크 | 확률 | 대응 |
|--------|------|------|
| 하드웨어 개발 경험 부족 | 고 | 키트 형태 구매 + 튜토리얼 따라하기 |
| BLE 연결 불안정 | 중 | 재연결 로직 + 연결 끊기면 수동 입력 fallback |
| 배터리 수명 | 저 | Deep Sleep 모드 (대기 1주+) |
| 사용자가 기기 가져오기 귀찮음 | 중 | 헬스가방에 넣어두기 (열쇠 크기) |

---

## 두 접근법 비교

| 항목 | 접근법 1: VLM | 접근법 2: BLE 기기 |
|------|-------------|-------------------|
| **무게 입력 방식** | 자동 (사진 → AI) | 수동 (다이얼 + 버튼) |
| **무조작 원칙** | 완벽 준수 (0개 버튼) | 준수 (세트 사이 = 원칙 밖) |
| **정확도** | 미검증 (80%+ 목표) | 100% (사용자 직접 입력) |
| **인터넷 필요** | ✅ 필수 | ❌ 불필요 |
| **추가 비용** | API 비용 (월 ~2,100원/유저) | 하드웨어 (1회 ~13,000원) |
| **개발 난이도** | 낮음 (API 호출) | 중간 (하드웨어 + 펌웨어 + BLE) |
| **개발 기간** | 1-3일 | 2-3주 |
| **공간 제약 해결** | ❌ (폰 카메라 여전히 필요) | ❌ (폰 Pose용 카메라 필요) |
| **B2C 확장성** | 높음 (앱 업데이트만) | 낮음 (기기 판매/배송 필요) |

### 핵심 차이점
- **접근법 1**: "무게 입력을 완전 자동화" — 사용자가 아무것도 안 해도 됨. 단, AI 정확도에 의존.
- **접근법 2**: "무게 입력을 더 편하게" — 폰 터치 대신 물리 다이얼/버튼. 정확도 100%, 단 하드웨어 필요.

---

## 실행 순서 (추천)

### 1단계: 접근법 1 (VLM) 검증 — 즉시 (1일)
- **이유**: 코드 변경 없이 API 테스트만으로 검증 가능. 실패해도 시간 낭비 최소.
- Gemini API Key 발급 → 사진 10-20장 테스트 → 정확도 표 작성

### 2단계: 결과에 따라 분기

| VLM 결과 | 다음 행동 |
|----------|----------|
| ✅ 80%+ 정확도, ≤3초 | **VLM 앱 통합** (1-2일) → 접근법 2는 보류 |
| ⚠️ 60-80% | **프롬프트 최적화** + few-shot → 재테스트 → 그래도 안 되면 접근법 2 |
| ❌ < 60% | **접근법 2 (BLE 기기)** 진입 → 부품 주문 + 프로토타입 |

### 3단계 (VLM 통과 시): 앱 통합 — 1-2일
- `vlm_weight_service.dart` 신규 생성
- `camera_overlay.dart` Stage 1 수정
- 헬스장 실기기 테스트

### 3단계 (VLM 실패 시): BLE 기기 프로토타입 — 2주
- 부품 주문 (알리 1-2주)
- 대기 중: Flutter BLE 연동 코드 먼저 작성 (에뮬레이터 테스트)
- 부품 도착 → 브레드보드 조립 → 펌웨어 → 통합 테스트

---

## 수정 파일 (1단계: VLM 검증만)

| # | 파일 | 변경 | 신규/수정 |
|---|------|------|----------|
| 1 | `tools/test_vlm_accuracy.dart` | 정확도 테스트 스크립트 (임시) | **신규** |
| 2 | `pubspec.yaml` | `google_generative_ai` 패키지 추가 | 수정 |

**기존 YOLO/Pose 코드는 절대 건드리지 않음** — 1단계는 순수 검증만.

---

## 검증 방법

### VLM 정확도 테스트
1. 기존 촬영 사진 10-20장 준비 (다양한 조합/각도)
2. 각 사진 × 프롬프트 3-5개 = 30-100회 API 호출
3. 정답 무게와 비교 → 정확도 표 작성
4. 최적 프롬프트 선정 → 앱 통합 여부 결정

### BLE 기기 테스트 (접근법 2 진입 시)
1. 브레드보드 프로토타입으로 BLE 통신 확인
2. Flutter 앱에서 무게 데이터 수신 확인
3. 헬스장 실사용: 5세트 × 3종목 → 편의성/안정성 체크

---

## 참고 자료
- [Gemini API Pricing 2026](https://costgoat.com/pricing/gemini-api)
- [Gemini 3 Flash Vision](https://www.infoq.com/news/2026/02/google-gemini-agentic-vision/)
- [ESP32 + BLE Weight Scale DIY](https://medium.com/@sdranju/building-a-smart-weight-scale-with-esp32-and-bluetooth-ble-a-diy-guide-19a649bf9880)
- [Piko: ESP32 Fitness Buddy (Hackaday)](https://hackaday.com/2025/06/05/piko-your-esp32-powered-fitness-buddy/)
- `docs/reference/02-18_다중원판감지_최적카메라포지셔닝_조사보고서.md` — 내부 조사 (SNR, 물리적 한계)
