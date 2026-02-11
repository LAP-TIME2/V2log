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

### Git / GitHub
- **Remote**: `https://github.com/LAP-TIME2/V2log.git` (LAP-TIME**2** 계정)
- **커밋 형식**: `feat: 한국어 설명` / `fix: 한국어 설명` / `refactor: 한국어 설명`

---

## 프로젝트 구조 (실제 파일 기준)

```
lib/
├── main.dart                          # 앱 진입점
├── app.dart                           # MaterialApp + ProviderScope
│
├── core/
│   ├── constants/
│   │   ├── app_colors.dart            # 컬러 팔레트 (dark + light)
│   │   ├── app_typography.dart        # Pretendard 타이포그래피
│   │   ├── app_spacing.dart           # 간격 시스템
│   │   └── app_assets.dart            # 에셋 경로
│   ├── theme/
│   │   ├── app_theme.dart             # 라이트/다크 ThemeData
│   │   └── theme_provider.dart        # 테마 상태 관리
│   ├── router/
│   │   └── app_router.dart            # GoRouter 설정 + ShellRoute
│   ├── utils/
│   │   ├── validators.dart
│   │   ├── formatters.dart
│   │   ├── fitness_calculator.dart    # 1RM, 볼륨, 강도 계산
│   │   ├── haptic_feedback.dart
│   │   ├── animation_config.dart      # 화면 전환 애니메이션 설정
│   │   ├── session_notes_formatter.dart
│   │   └── workout_share_utils.dart   # 공유 카드 유틸
│   └── extensions/
│       ├── context_extension.dart     # context.bgColor, isDarkMode 등
│       └── string_extension.dart
│
├── data/
│   ├── models/                        # 모두 Freezed + JsonSerializable
│   │   ├── user_model.dart
│   │   ├── exercise_model.dart
│   │   ├── routine_model.dart
│   │   ├── preset_routine_model.dart
│   │   ├── workout_session_model.dart
│   │   ├── workout_set_model.dart
│   │   ├── body_record_model.dart
│   │   ├── notification_settings_model.dart
│   │   └── sync_queue_model.dart
│   ├── repositories/
│   │   ├── auth_repository.dart
│   │   ├── user_repository.dart
│   │   ├── exercise_repository.dart
│   │   ├── routine_repository.dart
│   │   ├── preset_routine_repository.dart
│   │   └── workout_repository.dart
│   ├── services/
│   │   ├── supabase_service.dart
│   │   ├── local_storage_service.dart
│   │   ├── notification_service.dart
│   │   └── sync_service.dart
│   └── dummy/                         # 테스트용 더미 데이터
│       ├── dummy_exercises.dart
│       ├── dummy_preset_routines.dart
│       └── dummy_routines.dart
│
├── domain/
│   └── providers/                     # 모두 @riverpod
│       ├── auth_provider.dart
│       ├── user_provider.dart
│       ├── exercise_provider.dart
│       ├── routine_provider.dart
│       ├── preset_routine_provider.dart
│       ├── workout_provider.dart
│       ├── timer_provider.dart
│       ├── notification_provider.dart
│       └── sync_provider.dart
│
└── presentation/
    ├── widgets/
    │   ├── atoms/                     # 기본 위젯
    │   │   ├── v2_button.dart
    │   │   ├── v2_text_field.dart
    │   │   ├── v2_card.dart
    │   │   ├── v2_switch.dart
    │   │   ├── number_stepper.dart
    │   │   └── animated_wrappers.dart
    │   └── molecules/                 # 조합 위젯
    │       ├── set_row.dart
    │       ├── rest_timer.dart
    │       ├── quick_input_control.dart
    │       ├── preset_routine_card.dart
    │       ├── exercise_animation_widget.dart
    │       ├── mini_muscle_map.dart
    │       └── workout_share_card.dart
    └── screens/
        ├── splash/splash_screen.dart
        ├── onboarding/onboarding_screen.dart
        ├── auth/login_screen.dart
        ├── auth/register_screen.dart
        ├── home/home_screen.dart
        ├── workout/workout_screen.dart
        ├── workout/workout_summary_screen.dart
        ├── routine/routine_library_screen.dart
        ├── routine/preset_routine_detail_sheet.dart
        ├── exercise/exercise_detail_screen.dart
        ├── history/history_screen.dart
        ├── stats/stats_screen.dart
        ├── profile/profile_screen.dart
        ├── profile/edit_profile_screen.dart
        └── profile/notification_settings_screen.dart
```

---

## 라우트 맵 (GoRouter)

| 경로 | 이름 | 화면 | 비고 |
|------|------|------|------|
| `/` | splash | SplashScreen | 앱 시작 |
| `/onboarding` | onboarding | OnboardingScreen | 최초 설정 |
| `/auth/login` | login | LoginScreen | |
| `/auth/register` | register | RegisterScreen | |
| `/home` | home | HomeScreen | ShellRoute (하단탭) |
| `/history` | history | HistoryScreen | ShellRoute (하단탭) |
| `/history/:sessionId` | history-detail | HistoryDetailScreen | |
| `/stats` | stats | StatsScreen | ShellRoute (하단탭) |
| `/profile` | profile | ProfileScreen | ShellRoute (하단탭) |
| `/workout/ai` | workout-ai | WorkoutScreen | Shell 외부, 슬라이드업 |
| `/workout/free` | workout-free | WorkoutScreen | Shell 외부, 슬라이드업 |
| `/workout/session/:id` | workout-session | WorkoutScreen | |
| `/workout/summary` | workout-summary | WorkoutSummaryScreen | 운동 완료 요약 |
| `/routine/library` | routine-library | RoutineLibraryScreen | |
| `/routine/create` | routine-create | (플레이스홀더) | 미구현 |
| `/routine/:routineId` | routine-detail | (플레이스홀더) | 루틴 상세 |
| `/exercise/:exerciseId` | exercise-detail | ExerciseDetailScreen | 페이드 전환 |

**하단 네비게이션 탭**: 홈 → 기록 → 통계 → 프로필

---

## 테마 시스템

### 핵심 패턴
```dart
// 다크/라이트 판별 (항상 이 방식 사용!)
final isDark = Theme.of(context).brightness == Brightness.dark;
// 또는
context.isDarkMode  // context_extension.dart

// 테마 반응형 색상 (context_extension.dart)
context.bgColor           // dark: 0xFF0F0F0F / light: 0xFFFAFAFA
context.cardColor         // dark: 0xFF1A1A1A / light: 0xFFFFFFFF
context.cardElevatedColor // dark: 0xFF242424 / light: 0xFFF4F4F5
context.borderColor       // dark: 0xFF2A2A2A / light: 0xFFE4E4E7
context.textColor         // dark: 0xFFFFFFFF / light: 0xFF18181B
context.textSecondaryColor
context.textTertiaryColor
```

### 주의사항
- `MediaQuery.of(context).platformBrightness` = **시스템 설정** (사용 금지)
- `Theme.of(context).brightness` = **앱 설정** (이것만 사용)
- Atom 위젯: factory constructor에서 null 전달 → `build()`에서 테마 기반 기본값 결정
- `context_extension.dart`의 `push()`/`pop()`은 GoRouter와 충돌 → 제거됨. 라우팅은 `context.go()` / `context.push()` (GoRouter 것) 사용

---

## 데이터베이스 스키마 (Supabase)

### 테이블 관계도
```
auth.users ← users (1:1)
users ← routines ← routine_exercises → exercises
users ← workout_sessions ← workout_sets → exercises
users ← exercise_records → exercises
users ← body_records
preset_routines ← preset_routine_exercises → exercises
preset_routines ← routines (source_type='PRESET')
```

### 테이블 DDL

```sql
-- 사용자
CREATE TABLE users (
  id UUID PRIMARY KEY REFERENCES auth.users(id),
  email TEXT UNIQUE NOT NULL,
  nickname TEXT NOT NULL,
  profile_image_url TEXT,
  gender TEXT CHECK (gender IN ('MALE', 'FEMALE', 'OTHER')),
  birth_date DATE,
  height DECIMAL(5,2),
  weight DECIMAL(5,2),
  experience_level TEXT DEFAULT 'BEGINNER'
    CHECK (experience_level IN ('BEGINNER', 'INTERMEDIATE', 'ADVANCED')),
  fitness_goal TEXT DEFAULT 'HYPERTROPHY'
    CHECK (fitness_goal IN ('STRENGTH', 'HYPERTROPHY', 'ENDURANCE', 'WEIGHT_LOSS')),
  preferred_mode TEXT DEFAULT 'HYBRID'
    CHECK (preferred_mode IN ('PRESET', 'FREE', 'HYBRID')),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 운동 라이브러리
CREATE TABLE exercises (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  name_en TEXT,
  category TEXT CHECK (category IN ('STRENGTH', 'CARDIO', 'FLEXIBILITY')),
  primary_muscle TEXT NOT NULL,
  secondary_muscles TEXT[],
  equipment_required TEXT[],
  difficulty TEXT CHECK (difficulty IN ('BEGINNER', 'INTERMEDIATE', 'ADVANCED')),
  instructions TEXT[],
  tips TEXT[],
  animation_url TEXT,
  video_url TEXT,
  thumbnail_url TEXT,
  calories_per_minute DECIMAL(5,2),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 프리셋 루틴 (전문가 큐레이션)
CREATE TABLE preset_routines (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  name_en TEXT,
  description TEXT,
  difficulty TEXT CHECK (difficulty IN ('BEGINNER', 'INTERMEDIATE', 'ADVANCED')),
  target_goal TEXT CHECK (target_goal IN ('STRENGTH', 'HYPERTROPHY', 'ENDURANCE', 'WEIGHT_LOSS')),
  days_per_week INTEGER NOT NULL,
  estimated_duration_minutes INTEGER,
  target_muscles TEXT[],
  equipment_required TEXT[],
  thumbnail_url TEXT,
  popularity_score INTEGER DEFAULT 0,
  is_featured BOOLEAN DEFAULT FALSE,
  created_by TEXT DEFAULT 'V2log Team',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 프리셋 루틴 ↔ 운동 연결
CREATE TABLE preset_routine_exercises (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  preset_routine_id UUID REFERENCES preset_routines(id) ON DELETE CASCADE,
  exercise_id UUID REFERENCES exercises(id),
  day_number INTEGER NOT NULL,
  day_name TEXT,
  order_index INTEGER NOT NULL,
  target_sets INTEGER DEFAULT 3,
  target_reps TEXT DEFAULT '10-12',
  rest_seconds INTEGER DEFAULT 90,
  notes TEXT
);

-- 사용자 루틴
CREATE TABLE routines (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  source_type TEXT DEFAULT 'CUSTOM'
    CHECK (source_type IN ('PRESET', 'CUSTOM', 'TEMPLATE')),
  is_ai_generated BOOLEAN DEFAULT FALSE,
  preset_routine_id UUID REFERENCES preset_routines(id),
  target_muscles TEXT[],
  estimated_duration INTEGER,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 루틴 ↔ 운동 연결
CREATE TABLE routine_exercises (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  routine_id UUID REFERENCES routines(id) ON DELETE CASCADE,
  exercise_id UUID REFERENCES exercises(id),
  order_index INTEGER NOT NULL,
  target_sets INTEGER DEFAULT 3,
  target_reps TEXT DEFAULT '10-12',
  target_weight DECIMAL(6,2),
  rest_seconds INTEGER DEFAULT 90,
  notes TEXT
);

-- 운동 세션
CREATE TABLE workout_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  routine_id UUID REFERENCES routines(id),
  session_number INTEGER DEFAULT 1,
  mode TEXT CHECK (mode IN ('PRESET', 'FREE')),
  started_at TIMESTAMPTZ DEFAULT NOW(),
  finished_at TIMESTAMPTZ,
  is_cancelled BOOLEAN DEFAULT FALSE,
  total_volume DECIMAL(10,2),
  total_sets INTEGER,
  total_duration_seconds INTEGER,
  calories_burned INTEGER,
  notes TEXT,
  mood_rating INTEGER CHECK (mood_rating >= 1 AND mood_rating <= 5),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 세트 기록
CREATE TABLE workout_sets (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id UUID REFERENCES workout_sessions(id) ON DELETE CASCADE,
  exercise_id UUID REFERENCES exercises(id),
  set_number INTEGER NOT NULL,
  set_type TEXT DEFAULT 'WORKING'
    CHECK (set_type IN ('WARMUP', 'WORKING', 'DROP', 'FAILURE', 'SUPERSET')),
  weight DECIMAL(6,2),
  reps INTEGER,
  target_weight DECIMAL(6,2),
  target_reps INTEGER,
  rpe DECIMAL(3,1) CHECK (rpe >= 1 AND rpe <= 10),
  rest_seconds INTEGER,
  is_pr BOOLEAN DEFAULT FALSE,
  notes TEXT,
  completed_at TIMESTAMPTZ DEFAULT NOW()
);

-- 운동별 기록 집계 (1RM 추적)
CREATE TABLE exercise_records (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  exercise_id UUID REFERENCES exercises(id),
  estimated_1rm DECIMAL(6,2),
  max_weight DECIMAL(6,2),
  max_reps INTEGER,
  max_volume DECIMAL(10,2),
  total_volume DECIMAL(12,2) DEFAULT 0,
  total_sets INTEGER DEFAULT 0,
  last_performed_at TIMESTAMPTZ,
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, exercise_id)
);

-- 신체 기록
CREATE TABLE body_records (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  weight DECIMAL(5,2),
  body_fat_percentage DECIMAL(4,2),
  muscle_mass DECIMAL(5,2),
  skeletal_muscle_mass DECIMAL(5,2),
  bmi DECIMAL(4,2),
  chest DECIMAL(5,2),
  waist DECIMAL(5,2),
  hip DECIMAL(5,2),
  thigh DECIMAL(5,2),
  arm DECIMAL(5,2),
  notes TEXT,
  photo_url TEXT,
  recorded_at DATE DEFAULT CURRENT_DATE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

### FK 구조 요약
| FK 컬럼 | 참조 | NOT NULL |
|---------|------|----------|
| `workout_sessions.user_id` | `users.id` | YES |
| `workout_sessions.routine_id` | `routines.id` | NO |
| `workout_sets.session_id` | `workout_sessions.id` | YES |
| `workout_sets.exercise_id` | `exercises.id` | YES |
| `routines.user_id` | `users.id` | YES |
| `routine_exercises.routine_id` | `routines.id` | YES |
| `routine_exercises.exercise_id` | `exercises.id` | YES |

### CHECK 제약조건
| 테이블 | 컬럼 | 허용값 |
|--------|------|--------|
| users | fitness_goal | STRENGTH, HYPERTROPHY, ENDURANCE, WEIGHT_LOSS |
| users | preferred_mode | PRESET, FREE, HYBRID |
| users | experience_level | BEGINNER, INTERMEDIATE, ADVANCED |
| users | gender | MALE, FEMALE, OTHER |
| exercises | category | STRENGTH, CARDIO, FLEXIBILITY |
| exercises | difficulty | BEGINNER, INTERMEDIATE, ADVANCED |
| preset_routines | difficulty | BEGINNER, INTERMEDIATE, ADVANCED |
| preset_routines | target_goal | STRENGTH, HYPERTROPHY, ENDURANCE, WEIGHT_LOSS |
| routines | source_type | PRESET, CUSTOM, TEMPLATE |
| workout_sessions | mode | PRESET, FREE |
| workout_sets | set_type | WARMUP, WORKING, DROP, FAILURE, SUPERSET |

---

## 필수 개발 규칙

### DB 작업 규칙
1. INSERT/UPDATE 전 **반드시** 위 CHECK 제약조건, NOT NULL, FK 확인
2. `user_id` = `Supabase.instance.client.auth.currentUser?.id`
3. 회원가입 시 Auth + users 테이블 **동시** INSERT
4. Exercise ID는 반드시 **UUID** 형식 (ex-001 스타일 금지)
5. `debugPrint()` 사용 금지 → `print('=== 에러: $e ===')` 사용 (터미널에 보임)

### 코드 작성 규칙
- Provider: `@riverpod` 어노테이션 사용
- 에러 처리: 비동기 작업에 try-catch + AsyncValue 활용
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

### Phase 1: MVP 기본 기능 - **완료**
- [x] 프로젝트 설정, Supabase 연동, 디자인 시스템
- [x] 인증 (이메일 로그인/회원가입), 온보딩
- [x] DB 테이블 생성, 운동 라이브러리, 프리셋 루틴 5개
- [x] 모든 모델 (Freezed), Repository, Provider
- [x] 홈 화면 (듀얼 모드), 프리셋 루틴 라이브러리/상세
- [x] 운동 진행 화면, 세트 기록, 빠른 입력, 휴식 타이머, 요약
- [x] 히스토리 캘린더, 기록 상세, 통계 대시보드, 1RM/PR
- [x] 프로필, 테마 (다크/라이트), 버그 수정

### Phase 2: 확장 기능 - **완료**
- [x] 운동 애니메이션 (시범 이미지), 상세 가이드, 운동 검색/필터
- [x] 주간/월간 볼륨 차트, 부위별 분석, 1RM 진행도 (6개월)
- [x] 운동 메모 기능, 세트 타입 구분 (웜업/본세트/드롭)
- [x] 알림 설정 UI, 오운완 공유 카드 위젯
- [x] **근육 맵 시각화** (muscle_selector 패키지 + MiniMuscleMap 위젯, workout 헤더 적용)
- [x] **운동 강도 분석 UI** (stats 강도 존 카드 + workout 실시간 강도 표시바)
- [x] **슈퍼세트** (세트 타입 선택 + 파트너 운동 선택 + A↔B 자동 전환)
- [x] **이미지 저장/공유** (RepaintBoundary 캡처 + gal 갤러리 저장 + share_plus 공유)
- [x] **로컬 알림** (flutter_local_notifications + 요일별 시간 설정 + 테스트 알림)
