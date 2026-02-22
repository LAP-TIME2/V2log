# CLAUDE.md - V2log 헬스 앱 개발 가이드

## 프로젝트 개요

**V2log**는 전문가 루틴 + 빠른 기록 UX를 결합한 헬스 앱.

> "전문가 루틴으로 시작하고, 기록은 10초 만에"

### 기술 스택
- **Framework**: Flutter 3.24+ (Dart 3.5+)
- **State Management**: Riverpod 2.5+ (`@riverpod` 어노테이션)
- **Backend**: Supabase (Auth, Database, Storage)
- **Local Storage**: Hive, SharedPreferences
- **Charts**: fl_chart
- **Animations**: Rive, Lottie
- **Router**: GoRouter
- **Code Gen**: Freezed, json_serializable, riverpod_generator
- **CV/ML**: MediaPipe BlazePose, YOLO26-N → **상세는 `CLAUDE-CV.md` 참조**

### Git / GitHub
- **Remote**: `https://github.com/LAP-TIME2/V2log.git` (LAP-TIME**2** 계정)
- **커밋 형식**: `feat: 한국어 설명` / `fix: 한국어 설명` / `refactor: 한국어 설명`

---

## 프로젝트 구조 (Feature-First, Phase 5 마이그레이션 완료)

```
lib/
├── main.dart                              # 앱 진입점
├── app.dart                               # MaterialApp + ProviderScope
│
├── core/                                  # 앱 전역 설정 (변경 없음)
│   ├── constants/                         # app_colors, app_typography, app_spacing, app_assets
│   ├── theme/                             # app_theme, theme_provider
│   ├── router/app_router.dart             # GoRouter 설정 + ShellRoute
│   ├── utils/                             # validators, formatters, fitness_calculator, haptic_feedback, animation_config, session_notes_formatter, workout_share_utils, exercise_angles
│   ├── errors/app_exception.dart          # 통합 에러 타입
│   └── extensions/                        # context_extension, string_extension
│
├── features/                              # 기능별 모듈 (data/domain/presentation)
│   ├── auth/
│   │   ├── data/auth_repository.dart
│   │   ├── domain/auth_provider.dart
│   │   └── presentation/                  # login, register, splash, onboarding
│   ├── workout/
│   │   ├── data/                          # workout_repository, CV 서비스 (pose_detection, rep_counter, weight_detection, depth_estimation)
│   │   ├── domain/                        # workout_provider, workout_input_provider, timer_provider, cv_provider
│   │   └── presentation/                  # workout_screen, workout_summary, workout_dialogs, workout_components, camera_overlay, pose_overlay
│   ├── history/
│   │   └── presentation/history_screen.dart
│   ├── stats/
│   │   └── presentation/                  # stats_screen, widgets/ (volume_chart, one_rm_trend_chart, muscle_distribution_chart, weekly_summary_card)
│   ├── profile/
│   │   ├── data/user_repository.dart
│   │   ├── domain/                        # user_provider, notification_provider
│   │   └── presentation/                  # profile_screen, edit_profile_screen, notification_settings_screen
│   ├── routine/
│   │   ├── data/                          # routine_repository, preset_routine_repository
│   │   ├── domain/                        # routine_provider, preset_routine_provider
│   │   └── presentation/                  # routine_library_screen, preset_routine_detail_sheet
│   ├── exercise/
│   │   ├── data/exercise_repository.dart
│   │   ├── domain/exercise_provider.dart
│   │   └── presentation/exercise_detail_screen.dart
│   └── home/
│       └── presentation/home_screen.dart
│
├── shared/                                # 기능 간 공유 리소스
│   ├── models/                            # 모두 Freezed + JsonSerializable (user, exercise, routine, preset_routine, workout_session, workout_set, body_record, notification_settings, sync_queue)
│   ├── services/                          # supabase_service, local_storage_service, notification_service, sync_service, sync_provider
│   ├── widgets/
│   │   ├── atoms/                         # v2_button, v2_text_field, v2_card, v2_switch, number_stepper, animated_wrappers
│   │   └── molecules/                     # set_row, rest_timer, quick_input_control, preset_routine_card, exercise_animation_widget, mini_muscle_map, workout_share_card, share_preview_dialog
│   ├── dummy/                             # dummy_exercises, dummy_preset_routines, dummy_routines
│   └── sql/                               # seed_exercises.sql, update_exercise_animations.sql
```

---

## 라우트 맵 (GoRouter)

> 전체 라우트 → `lib/core/router/app_router.dart` 참조

**ShellRoute 탭**: `/home`, `/history`, `/stats`, `/profile`
**Shell 외부**: `/workout/ai|free|session/:id`, `/workout/summary`, `/routine/library|create|:id`, `/exercise/:id`
**인증**: `/` (splash), `/onboarding`, `/auth/login|register`

---

## 테마 시스템

- 다크/라이트 판별: `context.isDarkMode` (통일 완료, `Theme.of(context).brightness` 직접 사용 금지)
- **금지**: `MediaQuery.of(context).platformBrightness` (시스템 설정 → 사용 금지)
- 테마 반응형 색상: `context.bgColor`, `context.cardColor`, `context.borderColor`, `context.textColor` 등 → `lib/core/extensions/context_extension.dart` 참조
- Atom 위젯: factory constructor에서 null 전달 → `build()`에서 테마 기반 기본값 결정
- 라우팅: GoRouter의 `context.go()` / `context.push()` 만 사용 (자체 push/pop 금지)

---

## 데이터베이스 스키마 (Supabase)

> **전체 DDL, FK, CHECK 제약조건** → `docs/db-schema.md` 참조
> DB INSERT/UPDATE 작업 시 반드시 해당 파일을 읽고 제약조건 확인 후 진행.

**테이블 (10개)**: users, exercises, preset_routines, preset_routine_exercises, routines, routine_exercises, workout_sessions, workout_sets, exercise_records, body_records

**핵심 관계**:
```
auth.users ← users ← routines ← routine_exercises → exercises
users ← workout_sessions ← workout_sets → exercises
preset_routines ← preset_routine_exercises → exercises
```

---

## 필수 개발 규칙

### DB 작업 규칙
1. INSERT/UPDATE 전 **반드시** `docs/db-schema.md` 읽고 CHECK 제약조건, NOT NULL, FK 확인
2. `user_id` = `Supabase.instance.client.auth.currentUser?.id`
3. 회원가입 시 Auth + users 테이블 **동시** INSERT
4. Exercise ID는 반드시 **UUID** 형식 (ex-001 스타일 금지)

### CV 작업 시
- **반드시 `CLAUDE-CV.md` 참조** (CV 기술 스택, 코딩 규칙, 통합 포인트, 성능 최적화)

### 코드 품질 게이트 (2026-02-22 리팩토링 후 신설, 위반 시 커밋 금지)

| # | 규칙 | 위반 기준 | 검증 방법 |
|---|------|----------|----------|
| Q1 | **화면(Screen) 500줄 이하** | Screen 파일이 500줄 초과 | `wc -l` |
| Q2 | **print() / debugPrint() 금지** | lib/ 내 print/debugPrint 1건 이상 (cv/ 제외) | `Grep print\(` |
| Q3 | **isDark → context.isDarkMode** | `Theme.of(context).brightness` 직접 사용 1건 이상 | `Grep Theme.of.*brightness` |
| Q4 | **에러 처리 AppException만** | Repository에서 `return null` (에러 경로) 또는 커스텀 Exception | Grep |
| Q5 | **Provider가 Supabase 직접 호출 금지** | Provider에서 `supabase.from(` 직접 호출 | `Grep supabase.from` in providers |
| Q6 | **새 기능은 features/ 폴더에** | lib/ 루트나 기존 Layer-First 경로에 새 파일 생성 | 파일 경로 확인 |
| Q7 | **dart analyze error 0개** | error 1건 이상 | `dart analyze lib/` |

**커밋 전 자동 체크:** 위 7개 중 하나라도 위반되면 커밋하지 않고 먼저 수정.
**500줄 초과 시:** 위젯/다이얼로그/로직을 별도 파일로 추출한 후 커밋.

### 코드 작성 규칙
- Provider: `@riverpod` 어노테이션 사용
- 에러 처리: `AppException` 계열로 throw (`lib/core/errors/app_exception.dart`)
- Repository만 Supabase/Hive 호출. Provider → Repository → DB (단일 경로)
- 다크모드 판별: `context.isDarkMode` (context_extension.dart)
- 성능: ListView.builder, const 위젯 활용
- 코드 생성 후: `dart run build_runner build --delete-conflicting-outputs`

### 수정 작업 실패 방지
**A. 수정 전 3가지 먼저 확정:**
- **요구사항(What)**: 무엇을 바꿔야 하는가
- **수용기준(AC)**: "완료" 판정 기준 (수치/조건 명시)
- **금지사항(Don't)**: 건드리면 안 되는 것

**B. 2-스텝 수렴:**
1. 1차: 원인 가설 + 최소 변경으로 문제 해결
2. 2차: 리팩토링/코드 정리

**C. 변경 범위 통제:**
- 한 번에 파일 최대 3개만 수정
- "UI만 수정" / "API/모델은 건드리지 않음" 등 범위 고정

**D. 2회 실패 시 중단 → 원인분해:**
1. 왜 실패했는지 분해
2. 정석 패턴 확인 (공식 문서/예제)
3. 대안 2~3개 비교 후 가장 안전한 안으로 재시도

**E. 교차검증 3중 체크:**
1. 기능 검증: AC 통과?
2. 회귀 검증: 기존 기능 깨짐?
3. 엣지 케이스: 데이터 0개/최대값/작은 화면

---

## 알려진 함정 (Known Pitfalls)

### 1. Dialog Context Race Condition
```dart
// BAD - dialog pop 후 context가 stale 됨
showDialog(builder: (context) {
  Navigator.pop(context);
  context.go('/home'); // 실패!
});

// GOOD - dialog 열기 전에 캡처
final router = GoRouter.of(context);
final notifier = ref.read(provider.notifier);
showDialog(builder: (dialogContext) {
  Navigator.pop(dialogContext);
  router.go('/home'); // 안전
});
```
- `Navigator.pop` 후 dialog의 context/ref는 **죽은 상태**
- 반드시 dialog **바깥에서** router, notifier 캡처

### 2. 네비게이션 순서
```dart
// BAD - state 초기화 후 네비게이션 → 리빌드 → 로딩 스피너 깜빡임
state = null;
router.go('/home');

// GOOD - 네비게이션 먼저, state 초기화 나중
router.go('/home');
state = null;
```

### 3. GoRouter 충돌
- `context_extension.dart`에 자체 `push()`/`pop()` 만들지 말 것
- GoRouter의 `context.go()` / `context.push()` 만 사용

---

## 개발 명령어

```bash
# 코드 생성 (Freezed, Riverpod, JsonSerializable)
dart run build_runner build --delete-conflicting-outputs

# 개발 실행
flutter run                          # 연결된 기기
flutter run -d chrome                # Chrome
flutter run -d R3CN90HVMKL           # 테스트 안드로이드 기기

# 빌드
flutter build apk --release
```

---

## 개발 진행 상황

### Phase 1: MVP 기본 기능 — **완료** (인증, DB, 홈, 운동, 히스토리, 통계, 프로필, 테마)
### Phase 2: 확장 기능 — **완료** (애니메이션, 차트, 메모, 세트타입, 근육맵, 강도분석, 슈퍼세트, 공유, 알림)

### Phase 3: CV 기능 — **진행 중** (상세: `CLAUDE-CV.md`, 수정노트: `docs/CV_수정노트.md`)

#### CV Phase 1: 카메라 기반 횟수 카운팅 - **완료**
- [x] 패키지 설치 (camera, google_mlkit_pose_detection)
- [x] 플랫폼 권한 (Android CAMERA, iOS NSCameraUsageDescription)
- [x] `exercise_angles.dart` — 운동 14개 각도 규칙 (어깨 피벗 4개 추가) + 2단계 키워드 매칭
- [x] `pose_detection_service.dart` — MediaPipe BlazePose 래퍼 (프레임 스킵, 각도 계산)
- [x] `rep_counter_service.dart` v5.2 — One Euro Filter + Velocity Gate + 확인 시스템
- [x] `pose_overlay.dart` — 33개 관절 CustomPainter
- [x] `camera_overlay.dart` — 카메라+포즈+카운팅 위젯 (촬영 방향 표시)
- [x] `workout_screen.dart` 통합 — CV 토글 + 콜백
- [x] 실기기 테스트 + 정확도 검증 (정지 오카운팅 방지, 세트 간 정확도 유지, 준비 동작 필터링)
- [x] **운동 종목 확장** (41→90개, 8개 카테고리) + Supabase SQL 시드 스크립트
- [x] **어깨 피벗 CV 규칙 4개 추가** (Lateral Raise, Front Raise, Fly, Straight Arm Pull — H→S←E 축)
- [x] **키워드 매칭 버그 수정** (fly→Fly, raise 모호성 제거) + 2단계 매칭 시스템 (긴 키워드 우선)

#### CV Phase 2A: YOLO26 모델 학습 - **완료**
- [x] 사진 촬영 완료 (20kg/15kg/10kg/5kg/2.5kg)
- [x] Roboflow 프로젝트 생성 + 926장 업로드 + 537장 라벨링
- [x] Dataset v2 생성 (YOLOv8 포맷, 5클래스)
- [x] YOLO26-N 학습 완료 — mAP50: 96.2%, mAP50-95: 85.3% (목표 80% 초과 달성)
- [x] .tflite 변환 → V2log 앱으로 전달 (9.8MB, assets/models/)

#### CV Phase 2B: 앱 통합 - **버그 수정 완료, 헬스장 실기기 테스트 필요**
- [x] tflite_flutter + image 패키지 설치
- [x] WeightDetectionService 구현 (YOLO26-N 추론, 프레임 스킵, 안정성 체크)
- [x] **클래스 매핑 버그 수정** (Roboflow 알파벳순 5클래스로 교정, 9→5개)
- [x] **Two-Stage 파이프라인 구현** (Stage1: YOLO무게감지 → Stage2: Pose횟수카운팅, 순차 처리)
- [x] **"바벨 보여주기" UX** (전면카메라에 바벨 가져다대기 → 3회 안정화 → 자동 전환)
- [x] CameraOverlay 완전 재작성 (CameraStage enum, Stage별 UI/처리 분리)
- [x] WorkoutScreen AI 무게 감지 뱃지 + 자동 입력
- [x] **v2B-006: 3대 버그 수정** — 카메라 비율(FittedBox cover) + 무게 이중계산(좌우 그룹핑) + 배경 사람(selectPrimaryPose)
- [x] **v2B-007: 무게 감지 정확도 개선** — 카메라 720p + frameSkip 1 + Stage 1 프리뷰 280px
- [x] **v2B-008: TFLite 크래시 수정** — 싱글톤 서비스 위젯 lifecycle dispose 제거 (Use-After-Free 방지)
- [x] **v2B-009: 얼굴 오인식 수정** — confidence 0.7 + bbox 면적 필터 (False Positive 제거)
- [x] **v2B-010: 실기기 테스트 버그 4건** — 30초 모니터링 모드 + 하단 compact UI + 높이 280 통일 + ROI 3단계 배경 필터
- [x] **다중 원판 감지 A/B/C 테스트 구현** — 겹친 원판 과소추정 문제 해결 실험
  - Mode A: Bbox Aspect Ratio (ChatGPT 접근법) — 대각선 각도에서 두께 비율로 장수 추정
  - Mode B: MiDaS v2.1 Depth Estimation (Gemini 접근법) — 단안 깊이 추정으로 스택 두께 계산
  - Mode C: Sobel Edge Projection (Genspark 접근법) — 에지 히스토그램 피크 카운팅
  - `depth_estimation_service.dart` 신규 생성 (MiDaS TFLite 래퍼)
  - `--dart-define=BUILD_VARIANT` 분기로 APK 2개 빌드 (V2log-AC / V2log-B)
  - 실기기 설치 완료 (R3CN90HVMKL), 헬스장 테스트 대기
- [ ] 헬스장 실기기 테스트 (무게 감지 정확도 + Two-Stage 전환 + A/B/C 다중 원판 테스트) — **보류** (IoT 개발 우선)
- [ ] 버튼 0개 자동 UX (자동 감지 → 자동 시작 → 자동 종료) — **보류**
- [ ] 플레이트 등록 기능 (B2C 선택 / B2B 관리자용) — **보류**
- [ ] OCR 무게 읽기 (Google ML Kit Text v2) — **보류**

### Phase 4: Fica IoT 하드웨어 — **진행 중** (워크플로우: `docs/Phase4_IoT_워크플로우.md`)
- [x] 종합 개발 가이드 문서 작성
- [ ] 용어집 + 하드웨어 BOM 정리
- [x] 센서 모델 최종 선택: ICM-45686 (프로토타입용, 양산 시 LSM6DSV 재검토)
- [ ] 펌웨어 개발 (nRF52840 + Zephyr)
- [x] BLE GATT 프로토콜 스펙 v1.0 완성 (1,825줄, 13개 섹션) + 비전공자 해설집
- [x] 하드웨어 5개 미결정 사항 최종 확정 (센서 ICM-45686, 세트입력=앱, 동기화=실시간+배치, 7-seg=TM1637, LED=74HC595×3)
- [ ] 앱 BLE 연동 (Flutter)
- [ ] 프로토타입 PCB 설계

### Phase 5: 앱 전체 리팩토링 — **완료** (02-22)
- [x] **isDark 하드코딩 제거** (47건, 18파일) → `context.isDarkMode` 통일
- [x] **atom 위젯 const 추가** + **GoRouter 인증 가드** 추가
- [x] **sealed AppException 에러 처리 통일** (6개 repository)
- [x] **WorkoutScreen 분해**: 1,754줄 → 719줄 (workout_dialogs, workout_components, workout_input_provider 추출)
- [x] **StatsScreen 분해**: 1,934줄 → 213줄 (4개 차트 위젯 추출)
- [x] **Provider↔Repository 일관성**: workout_provider의 Supabase 직접 호출 13건 → Repository 경유
- [x] **finishWorkout 이중 실행 방지**: boolean flag → Completer 패턴
- [x] **세션 번호 레이스 컨디션 수정**: COUNT → MAX 방식
- [x] **print() 제거**: 268건 (29파일) → 0건 + 미사용 변수 정리
- [x] **Feature-First 폴더 마이그레이션**: `data/`+`domain/`+`presentation/` → `features/`+`shared/`
  - 8개 feature 모듈: auth, workout, history, stats, profile, routine, exercise, home
  - 60+ 파일 이동 + 323개 import 업데이트 + build_runner 재생성
  - `dart analyze` 에러 0건
