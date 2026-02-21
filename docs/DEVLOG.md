# V2log 개발 일지

> "전문가 루틴 + 빠른 기록 UX + IoT 자동 카운팅" 헬스 앱의 개발 과정을 시간순으로 기록합니다.

## 프로젝트 개요

- **기간**: 2026-01-28 ~ 현재
- **기술**: Flutter 3.24 + Supabase + MediaPipe BlazePose + YOLO26-N + **nRF52840 + IMU 센서 (IoT)**
- **팀**: 대표(이관주, 16년 피트니스 경력), CTO(AI), Claude Code(AI 페어 프로그래밍)
- **비즈니스**: SaaS 월 9,900원, B2C→B2B, BEP 1,515명
- **저장소**: https://github.com/LAP-TIME2/V2log.git

---

# Part 1: 경영진 요약

## Phase 요약

| Phase | 기간 | 상태 | 성과 |
|-------|------|------|------|
| 1. MVP 기본 기능 | 01-28 ~ 02-05 | ✅ 완료 | 회원가입 → 운동 기록 → 통계 전체 루프 완성 |
| 2. 확장 기능 | 02-06 ~ 02-11 | ✅ 완료 | 운동 시범, 근육맵, 슈퍼세트, 공유카드, 알림 |
| 3. CV (AI 기능) | 02-12 ~ 02-19 | ⏸️ 보류 | AI 횟수 카운팅 완성, 무게 자동 감지 한계 확인 → IoT 피벗 |
| 4. Fica IoT 하드웨어 | 02-20 ~ 현재 | 🔄 진행중 | IMU 센서 + BLE 컨트롤러 + NFC, 종합 개발 가이드 완성 |

## 주요 마일스톤

- **01-28**: 프로젝트 생성 (Flutter + Supabase 초기 설정)
- **02-01**: Supabase 연동 완료 (인증, DB, 운동 기록)
- **02-05**: MVP 완성 — 통계 차트, 메모, 빠른 입력 UX
- **02-06**: 세트 타입 구분 (웜업/본세트/드롭) + 알림 기능
- **02-10**: 라이트/다크 테마 시스템 구축
- **02-11**: Phase 2 완성 — 슈퍼세트, 근육맵, 공유카드, 강도분석
- **02-11**: IoT → CV 피벗 결정 (사업계획서 작성)
- **02-12**: CV Phase 1 완성 — MediaPipe 횟수 자동 카운팅 (14개 운동)
- **02-15**: YOLO26-N 학습 완료 (mAP50: 96.2%, 목표 80% 초과 달성)
- **02-15**: Phase 2B 앱 통합 시작 (tflite_flutter + Two-Stage 파이프라인)
- **02-16**: 첫 헬스장 실기기 테스트 → 버그 10건 발견 + 수정
- **02-18**: 다중 원판 감지 A/B/C 3가지 알고리즘 구현 + APK 2개 빌드
- **02-19**: VLM 테스트 FAIL 확정 (71%, 목표 80%) → CV 무게 감지 4가지 접근법 전부 실패
- **02-20**: **CV → IoT 피벗** — IMU 센서 4종 비교, 사업계획서 2종 (ICM-45686/LSM6DSV), 3D 데모
- **02-21**: 종합 개발 가이드 완성 (1,666줄, 8챕터) — 동작 스펙 STEP 0~6 확정

## 핵심 숫자

- **총 커밋**: 49개 (24일간)
- **운동 종목**: 90개 (41개 기본 + 49개 추가)
- **AI 모델 정확도**: mAP50 96.2% (YOLO26-N)
- **버그 수정**: v2B-001 ~ v2B-010 (실기기 테스트 기반)
- **문서**: 보고서 12편+, CV 수정노트 606줄, 사업계획서 2종, 종합 개발 가이드 1,666줄

---

# Part 2: 개발 타임라인

## 2026-02-21 (금) — 종합 개발 가이드 완성

**Phase**: Phase 4 (Fica IoT 하드웨어)

피트니스 카운터의 동작 스펙을 사용자가 직접 설명하고, 이를 8챕터 1,666줄의 종합 개발 가이드로 문서화한 날. 5개 에이전트 팀이 병렬로 각 영역(펌웨어/하드웨어/BLE/앱/백엔드)을 리서치+작성하고, 조립 에이전트가 최종 합본.

#### 커밋
- `docs: Fica IoT 피벗 — 종합 개발 가이드 + 사업계획서 2종 + 참고 문서` — f3951e3

#### 핵심 성과
- **종합 개발 가이드**: `docs/reference/02-21_피카_피트니스카운터_종합개발가이드.md` (1,666줄)
  - Ch.1: 용어 사전 45개 ("그러니까" 스타일)
  - Ch.2: ICM-45686 vs LSM6DSV 센서 비교 (95% 동일)
  - Ch.3: 시스템 동작 스펙 STEP 0~6 (사용자 확정)
  - Ch.4: 5개 영역 개발 워크플로우 + Phase A~D (12주)
  - Ch.5: 임베디드/하드웨어/BLE/앱/백엔드 상세 가이드 + 코드
  - Ch.6: 구매 목록 (프로토타입 446,000원 + 양산 37,000원/대)
  - Ch.7: 센서 미선택 개발 전략 (추상화 인터페이스)
  - Ch.8: 미결정 5건 + 리스크 6건 + 마일스톤 7개
- **CLAUDE.md Phase 4 추가**, MEMORY.md IoT 피벗 반영

#### 핵심 결정
- **피트니스 카운터 동작 스펙 확정** — NFC 탭 → 이전 기록 표시 → 세트 수 설정 → 자동 카운팅 → 휴식 타이머 → 기록 저장
- **안전바 해제 동작 필터링** — Confirmation System: 첫 2회 왕복은 패턴 확인, 3회째부터 정식 카운팅
- **센서 미선택 상태 착수 가능** — 95% 코드가 센서 무관

#### 배운 점
- 에이전트 팀 병렬 문서 작성: 5팀 분업 → 조립 에이전트 합본 → 검증 6건 통과

#### Context 최적화 (세션 2)
- **CLAUDE.md 슬림화**: 586→328줄 (-44%) — DB 스키마 추출, Phase 압축, 라우트/테마 압축
- **DB 스키마 분리**: `docs/db-schema.md` 신규 생성 (221줄, DDL+FK+CHECK 전체)
- **CLAUDE.local.md 정리**: 128→76줄 (-41%) — 순수 중복 삭제, 고유 콘텐츠 유지
- **MEMORY.md 이관**: "한국어 응답" 규칙 + "그러니까" 예시 이관 (147→149줄)
- **자동화 안전 검증**: PreCompact Hook(Notion), DEVLOG 자동 업데이트 모두 영향 없음 확인
- **예상 토큰 절감**: 16.1k→~10.2k (37%)
- 1,666줄 기술 문서를 단일 에이전트로 쓰면 컨텍스트 한계, 분할이 필수

---

## 2026-02-20 (목) — CV→IoT 피벗 + 사업계획서 2종 + 3D 데모

**Phase**: Phase 3 → Phase 4 전환

CV 무게 자동 감지의 4가지 접근법(YOLO/Depth/Edge/VLM) 전부 실패 확인 후, IMU 센서 + BLE 컨트롤러 기반 IoT 하드웨어로 피벗. 하루에 사업계획서 2종, IMU 4종 비교, 하드웨어 실현가능성 조사, 3D 인터랙티브 데모 2종을 완성.

#### 핵심 성과
- **하드웨어 센서 실현가능성 조사**: 3팀 에이전트 독립 조사 → 종합 보고서
- **IMU 4종 비교**: ICM-45686(1순위, 전력 최저), LSM6DSV(2순위, 가격 최저)
- **사업계획서 2종**: ICM-45686 버전 + LSM6DSV 버전 — Phase 1 IMU 센서 중심, CV는 "기술력 증거"로 리프레이밍
- **사업계획서 전략 강화**: 문제인식 4개 통일 + 기구 사용시간 컨트롤(NFC) + AI 맞춤 가이드 + 마일리지 시스템
- **45도 레그프레스 IMU 분석**: 4명 전문가 관점 (생체역학/하드웨어/신호처리/UX)
- **3D 인터랙티브 데모 2종**: Three.js 핀 로드 + 45도 플레이트 로드

#### 핵심 결정
- **CV → IoT 피벗 확정** — IMU 센서가 횟수 카운팅에 더 정확(93~96% vs CV 88~95%)하고, B2B 기구 사용시간 컨트롤 가능
- **사업계획서 Phase 재편** — Phase 1: IMU 하드웨어(핵심 제품), Phase 2: CV R&D(기술 고도화)
- **CV 폼체크 → "기술력 증거"로 전환** — 기능이 아닌 실행력 입증 자료

#### 배운 점
- 사업계획서에서 "기능"으로 나열하면 "할 일", "증거"로 나열하면 "한 일"이 됨
- Phase 순서는 기술 난이도가 아닌 수익 창출 시점 순으로 배치
- BOM 마진(71%)과 실질 마진(50~60%)은 20%p 차이 (조립/인증/A/S 비용)

→ 사업계획서: [02-20_2026_사업계획서_ICM45686.md](reference/02-20_2026_사업계획서_ICM45686.md), [02-20_2026_사업계획서_LSM6DSV.md](reference/02-20_2026_사업계획서_LSM6DSV.md)
→ IMU 비교: [02-20_IMU센서_4종_비교분석_보고서.md](reference/02-20_IMU센서_4종_비교분석_보고서.md)
→ 레그프레스 분석: [02-20_45도_플레이트로드_레그프레스_IMU_분석.md](reference/02-20_45도_플레이트로드_레그프레스_IMU_분석.md)

---

## 2026-02-19 (수) — VLM 테스트 FAIL + 피벗 준비

**Phase**: CV Phase 2B (마지막 시도)

CV 무게 자동 감지의 마지막 희망이었던 VLM(Vision Language Model) 테스트를 완료하고, 최종 FAIL을 확정한 날. 동시에 Claude Code 업데이트 정리, site-guide 스킬 구현.

#### 핵심 성과
- **VLM 3모델 테스트 완료**: gemini-2.5-flash(52.9%), gemini-2.0-flash(28.6%), gemini-3-flash-preview(71%) — 전부 목표 80% 미달
- **CV 무게 감지 4가지 접근법 전부 실패 확정**: YOLO(겹침), Depth(MiDaS), Edge(Sobel), VLM(71%)
- **Claude Code 업데이트 종합 정리**: v2.1.34~v2.1.47 changelog + 신규 기능 7가지
- **/site-guide 스킬 구현**: 외부 사이트 단계별 가이드 자동 생성 (Playwright MCP 연동)

#### 핵심 결정
- **VLM FAIL 확정** — 겹친 같은 원판(예: 20kg×3)은 AI가 원리적으로 구분 불가
- **CV 무게 감지 포기** → 대안 방향 논의 필요 (IoT/수동 UX/포기)

→ VLM 보고서: [V2log-VLM/results/2026-02-19_vlm_test_report.md]
→ Claude Code 정리: [02-19_Claude_Code_업데이트_종합정리_2026.md](reference/02-19_Claude_Code_업데이트_종합정리_2026.md)

---

### 2026-02-18 (수)

#### 커밋 (auto)
- `feat: 다중 원판 감지 A/B/C 테스트 구현 (3가지 알고리즘 비교)` — 0c6d03e — 다중 원판 감지 A/B/C 테스트 구현

**Phase**: CV Phase 2B (다중 원판 감지 실험)

YOLO가 겹친 원판을 1장만 감지하는 문제(20kg×2 → 60kg으로 과소추정)를 해결하기 위해, 3개 외부 AI(ChatGPT/Gemini/Genspark)의 접근법을 각각 구현하여 APK 2개에 담았다.

#### 주요 작업
- **Mode A (ChatGPT)**: Bbox aspect ratio 기반 — 대각선 각도에서 두께 비율로 원판 장수 추정
- **Mode B (Gemini)**: MiDaS v2.1 monocular depth estimation — 원판 영역 depth variance로 장수 추정
- **Mode C (Genspark)**: Sobel Y 에지 필터 + 수평 projection + 피크 카운팅
- **APK 분리**: `--dart-define=BUILD_VARIANT` + applicationId suffix로 원본 앱과 공존
  - V2log-AC (com.example.v2log.testac, 263MB) — Mode A + C
  - V2log-B (com.example.v2log.testb, 326MB) — Mode B (MiDaS 64MB 포함)
- **통합 레퍼런스 문서** 생성: `docs/reference/02-18_다중원판감지_ABC테스트_통합레퍼런스.md`

#### 신규 파일
- `lib/data/services/depth_estimation_service.dart` — MiDaS v2.1 TFLite 래퍼 (IsolateInterpreter, 동적 입력 크기)
- `assets/models/midas_v2.tflite` — MiDaS v2.1 depth estimation 모델 (64MB)

#### 수정 파일
- `lib/data/services/weight_detection_service.dart` — 모드 전환 + Mode A/B/C 알고리즘 3개 + DetectedPlate 확장(estimatedPlateCount + copyWith) + _PlateGeometry
- `lib/presentation/widgets/molecules/camera_overlay.dart` — 모드 선택 UI (BUILD_VARIANT 기반) + MiDaS 초기화

#### 핵심 결정
- **APK 2개 분리** — 사용자 요청: Mode B의 MiDaS 모델(64MB)이 크래시 리스크 있어서 A+C / B로 분리
- **예상 정확도**: 정면(0°)은 3가지 모두 물리적 한계, 대각선(30°+)에서만 의미
- **테스트 목적**: "어떤 각도/조건에서 어떤 방식이 실제로 작동하는지" 데이터 수집

#### 배운 점
- MiDaS v2.1 standard 모델은 25MB가 아닌 64MB (문서와 실제 차이)
- `--dart-define`으로 compile-time 상수 주입 → 같은 코드베이스에서 APK 변형 생성 가능
- applicationId를 임시 변경하면 같은 기기에 여러 빌드 공존 가능

→ 테스트 계획: [02-18_다중원판감지_ABC테스트_통합레퍼런스.md](reference/02-18_다중원판감지_ABC테스트_통합레퍼런스.md)

---

## 2026-02-18 (수) — 헬스장 A/B/C 테스트 결과 + Mode A 안정화

**Phase**: CV Phase 2B (다중 원판 감지 안정화)

헬스장 실기기 테스트에서 Mode A만 20kg 다중 원판 감지에 성공(3/4). Mode B/C는 실전 불가 확인. Mode A에 EMA/Hold/Cold Start 안정화를 적용하고, 독립 테스트 APK "V2log A(클로드)"를 product flavor로 생성.

#### 주요 작업
- **헬스장 A/B/C 테스트 결과 분석** — Mode A: 20kg×2 100kg 정확(3/4), 첫 측정만 140kg. Mode B/C: 실전 불가
- **Cold Start Skip** — 첫 3프레임 스킵으로 모델 warmup 대기 (140kg 버그 해결)
- **EMA Temporal Smoothing** — aspect ratio에 α=0.3 EMA 적용 (프레임간 진동 방지)
- **Hold Counter** — count 변경 시 3프레임 연속 확인 후 확정 (경계값 진동 방지)
- **clamp(1,4) → clamp(1,8)** — 레그프레스 20kg×5~6장 대응 + _maxAspectRatio 1.8→2.0
- **IoU NMS** — 클래스별 중복 제거 → IoU 기반 NMS로 교체 (다른 클래스 겹침도 처리)
- **Mode B/C 비활성화** — BUILD_VARIANT 분기 제거, 모드 선택기 OFF/A만
- **독립 테스트 APK** — product flavor (production/claude), applicationIdSuffix ".claude"

#### 핵심 결정
- **Mode A 유지 + 안정화**: 실전 테스트에서 유일하게 작동한 방식
- **OCR Phase 3에서 제외**: 겹친 원판 숫자 안 보임, 바깥 원판은 YOLO로 충분
- **5kg singleAspectMax 상향 철회**: 5kg×2 겹침은 흔한 상황, 감지 포기 불가

#### 배운 점
- **Cold Start는 실전에서만 보인다** — 실험실에서는 초기화 후 충분히 기다리고 테스트하기 때문
- **EMA + Hold 조합**이 실시간 CV에서 표준 패턴 — 1단계(smoothing) + 2단계(confirmation)
- **Product Flavor**로 같은 코드베이스에서 테스트/프로덕션 APK 분리 가능

→ 상세: [CV_수정노트.md](CV_수정노트.md) v2B-011, v2B-012

---

### 2026-02-17 (화)

#### 커밋 (auto)
- `docs: 개발 프로세스 가이드 문서 추가 (DEVGUIDE.md)` — faefdb8
- `feat: DEVLOG 개발 일지 시스템 구축 (3중 안전망)` — 0c430ae
- `fix: Phase 2B 실기기 테스트 버그 v2B-010 수정 + 참고문서 추가` — d602a17

---

## 2026-02-16 (일) — CV Phase 2B: 첫 헬스장 실기기 테스트 + 버그 10건 수정

**Phase**: CV Phase 2B (앱 통합)

이날 헬스장에서 실제 바벨로 테스트를 진행했고, **실험실에서는 발견할 수 없었던 버그 10건**을 발견하고 모두 수정했다. "헬스장 환경은 실험실과 완전히 다르다"는 교훈을 얻은 날.

#### 커밋
- `fix: Phase 2B 무게 감지 버그 4건 수정 (v2B-006~009)` — 3a907b6

#### 발견된 버그 + 해결 (v2B-001 ~ v2B-010)

| 버그 ID | 문제 | 해결 |
|---------|------|------|
| v2B-001 | 클래스 매핑 불일치 (Roboflow 알파벳순 vs 코드 순서) | 5클래스 알파벳순 교정 |
| v2B-002 | Two-Stage UX 설계 필요 | YOLO→Pose 순차 파이프라인 구현 |
| v2B-003 | 카메라 슬라이드쇼 (1-3초/프레임) | YUV→Float32 직접변환, GPU delegate |
| v2B-004 | interpreter.run() 에러 + Isolate 오버헤드 | 입출력 형식 수정, Isolate 제거 |
| v2B-005 | UI 블로킹 200ms + 안정화 미완료 | IsolateInterpreter + 최빈값 안정화 |
| v2B-006 | 카메라 비율 깨짐 + 무게 이중계산 + 배경 사람 추적 | FittedBox cover + 좌우 그룹핑 + primaryPose |
| v2B-007 | 5kg→20kg 오분류 (해상도 부족) | 720p + frameSkip 1 + 임계값 조정 |
| v2B-008 | 스크린샷 시 TFLite 크래시 (SIGSEGV) | 싱글톤 dispose 제거 (Use-After-Free 방지) |
| v2B-009 | 얼굴을 60kg 원판으로 오인식 | confidence 0.7 + bbox 면적 필터 |
| v2B-010 | 매 세트 재감지 + 배경 랙 오감지 | 30초 모니터링 모드 + ROI 3단계 필터 |

#### 핵심 결정
- **ROI 3단계 방어** (confidence → 공간 ROI → bbox 면적) 도입
- **30초 모니터링 모드** — 세트 간 원판 변경을 자동 감시
- **싱글톤 서비스는 위젯 lifecycle에서 dispose 금지** 원칙 확립

#### 배운 점
- 헬스장 환경은 실험실과 완전히 다름 (다중 사용자, 배경 랙, 거리 변화)
- 카메라 해상도를 바꾸면 confidence threshold도 같이 조정해야 함
- `await` 중간에 lifecycle 이벤트가 끼어들 수 있음

→ 상세: [CV_수정노트.md](CV_수정노트.md) (v2B-001 ~ v2B-010)
→ 분석: [02-16_무게감지_성능최적화_분석.md](reference/02-16_무게감지_성능최적화_분석.md)

---

## 2026-02-15 (토) — YOLO26-N 학습 완료 + Phase 2B 앱 통합 시작

**Phase**: CV Phase 2A → 2B 전환

YOLO26-N 모델이 mAP50 96.2%로 목표(80%)를 크게 초과 달성한 날. 바로 앱 통합(Phase 2B)에 착수했다.

#### 커밋
- `docs: CV 문서 docs/reference/ 이동 + 보고서 추가 + 가이드 최신화` — ffaaf20
- `chore: 데스크탑 테스트 환경 자동 셋업 스크립트 추가` — 8e17ba7
- `fix: 데스크탑 setup 스크립트 UTF-8 한글 깨짐 수정` — e5399c9
- `feat: 결정 반영 검증 시스템 구축 + 문서 불일치 수정` — 10b0fe8
- `fix: decision-check 검증 실패 3건 수정` — 482f8a6
- `feat: 운동 종목 49개 추가 + CV 어깨 피벗 규칙 4개 + 키워드 매칭 버그 수정` — 59f2611
- `feat: Phase 2B 무게 자동 감지 기본 구현 (YOLO26-N + tflite_flutter)` — 8c255d8
- `fix: Rear Delt Fly 잘못된 Fly 규칙 매칭 방지 + 카메라 dispose Race Condition 수정` — 25cb4b3

#### 핵심 성과
- **YOLO26-N 모델**: Google Colab에서 학습 → .tflite 변환 (9.8MB) → 앱 assets에 배치
- **운동 90개 달성**: 기존 41개 + 49개 추가 (어깨 피벗 4개 포함)
- **결정 반영 검증 시스템**: `/decision-check` 스킬 — 결정사항이 코드에 반영되었는지 자동 검증
- **WeightDetectionService**: YOLO26-N .tflite 추론 + CameraOverlay 통합
- **Two-Stage 파이프라인**: Stage 1(YOLO 무게) → Stage 2(Pose 횟수) 순차 처리

#### 핵심 결정
- **YOLO11 → YOLO26-N 확정** (2026-02-13 결정, 이날 검증 완료)
- **Two-Stage 파이프라인** — 두 ML 모델을 동시에 돌리지 않고 순차 실행
- **결정 기록 규칙 강화** — MEMORY.md에 📌/✅ 추적 + 검증 명령 필수

→ 참고: [02-15_Phase2B_무게자동감지_앱통합_플랜.md](reference/02-15_Phase2B_무게자동감지_앱통합_플랜.md)

---

## 2026-02-13 ~ 02-14 — CV 전략 수립 + 데이터 수집/라벨링

**Phase**: CV Phase 2A (데이터 수집/학습)

커밋은 없지만 핵심 전략 결정 + 데이터 작업이 이루어진 기간.

#### 주요 활동
- **3명 전문가 에이전트 조사**: 경쟁사, 광학, 파이프라인, UX, B2B 분석
- **사진 촬영**: 20kg/15kg/10kg/5kg/2.5kg 폴더별 정리
- **Roboflow**: 프로젝트 생성 (`laptimev2log/v2log-weight-plates`) → 926장 업로드 → 537장 라벨링
- **Dataset v2 생성**: YOLOv8 포맷, 5클래스 (plate_10kg, plate_15kg, plate_2.5kg, plate_20kg, plate_5kg)

#### 핵심 결정
- **YOLO11 → YOLO26-N 변경** — 최신 모델, 더 나은 성능
- **부분 촬영 원칙** — 바벨 전체가 아닌 원판만 찍기
- **버튼 0개 UX** — 감지 → 시작 → 종료 모두 자동
- **IWF 컬러 인식 → 보너스** — 필수 아닌 추후 기능
- **라벨링은 9개 클래스로 시작** — 나중에 3개로 합치기는 가능, 반대는 불가

→ 조사: [02-13_CV_무게자동감지_실현가능성_종합분석_2026.md](reference/02-13_CV_무게자동감지_실현가능성_종합분석_2026.md)

---

## 2026-02-12 (수) — IoT→CV 피벗 + CV Phase 1 완성

**Phase**: CV Phase 1 (횟수 카운팅)

가장 큰 기술 방향 전환이 있었던 날. IoT 센서 기반에서 **Computer Vision (스마트폰 카메라 + AI)** 기반으로 피벗했다. 동시에 CV Phase 1(횟수 자동 카운팅)을 하루 만에 완성했다.

#### 커밋
- `docs: CV 개발 문서 체계 정리 + CLAUDE-CV.md 생성` — c92063e
- `feat: CV Phase 1 횟수 자동 카운팅 구현 (v5.2)` — 78fd8ff
- `docs: CV 문서 최신화 + cv-status 스킬 업그레이드` — 0dab9ef

#### 핵심 성과
- **CLAUDE-CV.md 생성** — CV 전용 개발 가이드 (기술 스택, 코딩 규칙, 통합 포인트)
- **CV Phase 1 완성**:
  - `exercise_angles.dart` — 14개 운동 각도 규칙
  - `pose_detection_service.dart` — MediaPipe BlazePose 래퍼
  - `rep_counter_service.dart` v5.2 — One Euro Filter + Velocity Gate
  - `pose_overlay.dart` — 33개 관절 CustomPainter
  - `camera_overlay.dart` — 카메라+포즈+카운팅 위젯
- **cv-status 스킬** — CV 전체 진행 상황 대시보드

#### 핵심 결정
- **IoT → CV 피벗** — 센서 비용/설치 문제 해결, 스마트폰만으로 완결
- **포지셔닝**: "저비용 + 높은 범용성 + 폼체크" = 블루오션

→ 사업계획서: [CV_피벗_사업계획서_Fica_2026.md](reference/CV_피벗_사업계획서_Fica_2026.md)
→ 기술 보고서: [CV_무게측정_횟수카운팅_최신기술_보고서_2026.md](reference/CV_무게측정_횟수카운팅_최신기술_보고서_2026.md)

---

## 2026-02-11 (화) — Phase 2 완성 + CV 피벗 준비

**Phase**: Phase 2 (확장 기능) 마무리

하루에 6개 커밋으로 Phase 2의 모든 기능을 완성한 날. 동시에 CV 피벗을 위한 사업계획서와 기술 보고서도 작성했다.

#### 커밋
- `feat: 운동 시범 이미지 통합, UI 애니메이션 시스템, PreCompact 훅 인코딩 수정` — 95d0123
- `fix: PreCompact 훅 cmd /c 래핑 제거 및 권한 설정 정리` — a4ef460
- `feat: 슈퍼세트 지원 + 강도 분석 UI + 네비게이션 구조 개선` — 7ae53ff
- `feat: 이미지 저장/공유 기능 완성 + 공유 카드 날짜에 요일 추가` — b72072a
- `feat: 운동 헤더에 SVG 근육 맵 시각화 추가` — 0ca6913
- `refactor: CLAUDE.md 실제 코드 상태 동기화 + platformBrightness getter 제거` — b25b7c8
- `docs: CV 피벗 사업계획서 참고자료 추가` — 30ee506
- `feat: 통계 화면에 강도 존 분석 추가` — 2fa6717
- `docs: CV 무게측정/횟수카운팅 최신 기술 종합 보고서 추가` — 79debce

#### 핵심 성과
- **슈퍼세트**: 세트 타입 선택 + 파트너 운동 선택 + A↔B 자동 전환
- **근육 맵**: muscle_selector 패키지 + MiniMuscleMap 위젯, 운동 헤더 적용
- **공유 카드**: RepaintBoundary 캡처 + gal 갤러리 저장 + share_plus 공유
- **강도 분석**: 통계 화면 강도 존 카드 + 운동 실시간 강도 표시바
- **운동 시범 이미지**: 각 운동별 시범 이미지 통합
- **PreCompact 훅 안정화**: cmd /c 래핑 제거, UTF-8 인코딩 수정

---

## 2026-02-10 (월) — 라이트/다크 테마 시스템 + UI/UX 개선

**Phase**: Phase 2 (확장 기능)

#### 커밋
- `feat(theme): 라이트/다크 모드 전체 지원 및 테마 시스템 구축` — a54f29c
- `fix: UI/UX 개선 및 운동 데이터 중복 제거` — 2d64a67
- `fix: 운동 필터 카테고리 매핑, 트라이셉 중복 제거, 공유 다이얼로그 개선` — 15cf4c1

#### 핵심 성과
- **테마 시스템 구축**: `app_theme.dart` (ThemeData), `theme_provider.dart` (상태 관리)
- **context_extension.dart**: `context.bgColor`, `context.isDarkMode` 등 테마 반응형 색상
- **핵심 원칙**: `Theme.of(context).brightness` (앱 설정) 사용, `MediaQuery.platformBrightness` (시스템 설정) 사용 금지

---

## 2026-02-08 (토) — 운동 완료 버그 수정 (SSOT 통합)

**Phase**: Phase 1 → 2 사이 안정화

#### 커밋
- `fix(workout): 운동 완료 중복 실행 방지 SSOT 통합` — 587e5bc
- `fix(workout): 운동 완료 후 요약 화면 정상 표시 및 state 라이프사이클 개선` — 55f8b0a

#### 핵심 성과
- 운동 완료 버튼 중복 클릭 방지
- state 라이프사이클 개선 — 네비게이션 먼저, state 초기화 나중 (Dialog Context Race Condition 방지)
- **SSOT(Single Source of Truth)** 패턴 적용

---

## 2026-02-06 (목) — 세트 타입 + PR 표시 + 알림 기능

**Phase**: Phase 2 (확장 기능) 시작

#### 커밋
- `chore: add build directories to gitignore` — 60bd9f9
- `feat(workout): 세트 타입 기능 추가 및 운동 ID 시스템 수정` — 842e605
- `fix(workout): 세션 내 운동별 최고 무게 세트에만 PR 표시` — 08d2dc1
- `feat(notification): 알림 기능 완성 및 요일별 시간 설정` — 3eabf7e

#### 핵심 성과
- **세트 타입**: WARMUP, WORKING, DROP, FAILURE, SUPERSET 구분
- **PR 표시**: 세션 내 운동별 최고 무게 세트에만 표시
- **알림**: flutter_local_notifications + 요일별 시간 설정 + 테스트 알림

---

## 2026-02-05 (수) — 통계 차트 완성 + 메모 기능 + UI 개선

**Phase**: Phase 1 (MVP 완성)

하루에 7개 커밋, Phase 1의 핵심 기능들을 완성한 날.

#### 커밋
- `Phase 2 8주차: 통계 차트 완성 (부위별 색상, 볼륨 라벨, 더미 데이터)` — 2134e8e
- `Phase 2 8주차: 통계 차트 완성 + 1RM 추이 6개월 + 더미 데이터` — 8f61579
- `Phase 2 8주차 완료: 운동 빈도 통계 추가 + 부위별 색상 통일` — 627132e
- `Phase 2: UI 개선 - 휠 피커 무게/횟수 조절, 하체 카테고리 추가` — 4e1be5a
- `Phase 2 9주차: 운동 메모 기능 + 세트 스와이프 삭제` — b2c0847
- `Phase 2: 메모 기능 추가, 세트 삭제 길게누르기 방식 변경` — 13a4c62
- `Phase 2 9주차: 메모 표시 버그 수정` — 4342de2
- `feat: 운동 메모 기능 완성 및 ID 노출 버그 수정` — 1c3d9f8

#### 핵심 성과
- **통계 대시보드**: 주간/월간 볼륨 차트, 부위별 색상, 1RM 추이 6개월
- **운동 메모**: 각 운동별 메모 기능 + exercise_id 대신 운동명 표시
- **빠른 입력 UX**: 휠 피커 무게/횟수 조절, 횟수 100회 확대

---

## 2026-02-04 (화) — 운동 가이드 표시

**Phase**: Phase 1 (MVP)

#### 커밋
- `Phase 2-7: 운동 가이드 표시 진행중` — f352d0b
- `운동 진행 화면: 운동 방법/팁 항상 표시, 접기/펼치기 버튼 제거` — 3f67733

#### 핵심 성과
- 운동 중 방법/팁을 항상 표시 (접기/펼치기 UX 복잡성 제거)

---

## 2026-02-03 (월) — 회원가입 버그 수정 + 기록 상세/프로필

**Phase**: Phase 1 (MVP)

#### 커밋
- `디버그 로그 제거` — bfc2758
- `회원가입 users INSERT 수정 + CLAUDE.md 업데이트` — 470139d
- `Phase 7: 기록 상세, 프로필 화면 완료` — 761ee7e

#### 핵심 성과
- 회원가입 시 Auth + users 테이블 동시 INSERT 수정
- 기록 상세 화면 (히스토리 → 세션 상세)
- 프로필 화면 완성
- CLAUDE.md에 개발 규칙 추가 (CHECK 제약조건, FK 구조 등)

---

## 2026-02-01 (토) — Supabase 연동 + 운동 기록

**Phase**: Phase 1 (MVP)

#### 커밋
- `Phase 3-4 완료: Supabase 연동, 운동 기록 기능` — 0cefe6e
- `Supabase 연동 완료 + 개발 규칙 추가` — ca5a841

#### 핵심 성과
- **Supabase 연동**: Auth (이메일 로그인/회원가입), Database (전체 테이블)
- **Repository 패턴**: auth, user, exercise, routine, preset_routine, workout
- **Provider 패턴**: `@riverpod` 어노테이션 기반 상태 관리
- **더미 데이터**: exercises (802줄), preset_routines (501줄), routines (320줄)
- **화면 완성**: 운동 진행, 요약, 프리셋 루틴 상세, 통계 기초

---

## 2026-01-28 (수) — 프로젝트 시작

**Phase**: Phase 1 (MVP) 시작

#### 커밋
- `Initial commit: Flutter project setup` — b68c243
- `Phase 1 완료: 프로젝트 구조, UI 화면, 기본 위젯` — 1a938fe

#### 핵심 성과
- **Flutter 프로젝트 생성**: 전체 플랫폼 (Android, iOS, Web, Windows, macOS, Linux)
- **디자인 시스템 구축**:
  - `app_colors.dart` — dark + light 컬러 팔레트
  - `app_typography.dart` — Pretendard 타이포그래피
  - `app_spacing.dart` — 간격 시스템
- **핵심 위젯**: v2_button, v2_text_field, v2_card, number_stepper, set_row, rest_timer
- **라우팅**: GoRouter + ShellRoute (하단 네비게이션)
- **데이터 모델** (Freezed): user, exercise, routine, workout_session, workout_set
- **화면**: splash, onboarding, login, home, workout 기초

---

# 부록

## 관련 문서 인덱스

| 날짜 | 파일 | 내용 |
|------|------|------|
| 02-21 | [02-21_피카_피트니스카운터_종합개발가이드.md](reference/02-21_피카_피트니스카운터_종합개발가이드.md) | Fica IoT 종합 개발 가이드 (8챕터, 1,666줄) |
| 02-20 | [02-20_2026_사업계획서_ICM45686.md](reference/02-20_2026_사업계획서_ICM45686.md) | 2026 사업계획서 ICM-45686 버전 |
| 02-20 | [02-20_2026_사업계획서_LSM6DSV.md](reference/02-20_2026_사업계획서_LSM6DSV.md) | 2026 사업계획서 LSM6DSV 버전 |
| 02-20 | [02-20_IMU센서_4종_비교분석_보고서.md](reference/02-20_IMU센서_4종_비교분석_보고서.md) | IMU 4종 비교 (ICM-45686 1순위) |
| 02-20 | [02-20_45도_플레이트로드_레그프레스_IMU_분석.md](reference/02-20_45도_플레이트로드_레그프레스_IMU_분석.md) | 45도 레그프레스 IMU 전문가 분석 |
| 02-20 | [02-20_하드웨어센서_횟수카운팅_실현가능성_조사보고서.md](reference/02-20_하드웨어센서_횟수카운팅_실현가능성_조사보고서.md) | 하드웨어 센서 실현가능성 (3팀) |
| 02-19 | [02-19_Claude_Code_업데이트_종합정리_2026.md](reference/02-19_Claude_Code_업데이트_종합정리_2026.md) | Claude Code v2.1 업데이트 정리 |
| 02-16 | [CV_수정노트.md](CV_수정노트.md) | CV 버그 해결 상세 (v2B-001~010, 606줄) |
| 02-16 | [02-16_무게감지_성능최적화_분석.md](reference/02-16_무게감지_성능최적화_분석.md) | 성능 병목 분석 + 최적화 |
| 02-15 | [02-15_Phase2B_무게자동감지_앱통합_플랜.md](reference/02-15_Phase2B_무게자동감지_앱통합_플랜.md) | Phase 2B 구현 계획 |
| 02-13 | [02-13_CV_무게자동감지_실현가능성_종합분석_2026.md](reference/02-13_CV_무게자동감지_실현가능성_종합분석_2026.md) | 3명 전문가 에이전트 조사 |
| 02-12 | [CV_무게측정_횟수카운팅_최신기술_보고서_2026.md](reference/CV_무게측정_횟수카운팅_최신기술_보고서_2026.md) | YOLO 모델 비교, 오픈소스 |
| — | [CV_피벗_사업계획서_Fica_2026.md](reference/CV_피벗_사업계획서_Fica_2026.md) | Fica 사업계획서 (2025 베이스) |

## 자동 업데이트 방식

이 문서는 3중 안전망으로 자동 업데이트됩니다:

1. **Layer 1 (Claude 커밋 시)**: Claude가 커밋할 때 직접 타임라인 + 배운 점/결정 추가
2. **Layer 2 (PreCompact 훅)**: `auto-compact` 또는 `/compact` 시 훅이 기본 커밋 항목 자동 추가
3. **Layer 3 (/devlog 스킬)**: 수동으로 빠진 커밋 catch-up + `(auto)` 항목 보강
