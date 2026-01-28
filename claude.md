# CLAUDE.md - V2log 헬스 앱 개발 가이드

## 🎯 프로젝트 개요

**V2log**는 플랜핏(Planfit)의 AI 기반 맞춤 루틴 추천과 번핏(BurnFit)의 빠른 기록 UX를 결합한 프리미엄 헬스 앱입니다.

### 핵심 슬로건
> "AI가 루틴을 추천하고, 기록은 10초 만에"

### 기술 스택
- **Framework**: Flutter 3.24+ (Dart 3.5+)
- **State Management**: Riverpod 2.5+
- **Backend**: Supabase (Auth, Database, Storage, Edge Functions)
- **AI**: OpenAI GPT-4 API (루틴 추천, 챗봇)
- **Local Storage**: Hive, SharedPreferences
- **Charts**: fl_chart
- **Animations**: Rive, Lottie

---

## 📁 프로젝트 구조

v2log/ ├── lib/ │ ├── main.dart # 앱 진입점 │ ├── app.dart # MaterialApp 설정 │ │ │ ├── core/ # 핵심 공통 모듈 │ │ ├── constants/ # 상수 정의 │ │ │ ├── app_colors.dart # 컬러 팔레트 │ │ │ ├── app_typography.dart # 타이포그래피 │ │ │ ├── app_spacing.dart # 간격 시스템 │ │ │ └── app_assets.dart # 에셋 경로 │ │ │ │ │ ├── theme/ # 테마 시스템 │ │ │ ├── app_theme.dart # 라이트/다크 테마 │ │ │ └── theme_provider.dart # 테마 상태 관리 │ │ │ │ │ ├── router/ # 라우팅 │ │ │ └── app_router.dart # GoRouter 설정 │ │ │ │ │ ├── utils/ # 유틸리티 │ │ │ ├── validators.dart # 입력 검증 │ │ │ ├── formatters.dart # 포맷터 │ │ │ ├── fitness_calculator.dart # 1RM, 볼륨 계산 │ │ │ └── haptic_feedback.dart # 햅틱 피드백 │ │ │ │ │ └── extensions/ # Dart 확장 │ │ ├── context_extension.dart │ │ └── string_extension.dart │ │ │ ├── data/ # 데이터 레이어 │ │ ├── models/ # 데이터 모델 │ │ │ ├── user_model.dart │ │ │ ├── exercise_model.dart │ │ │ ├── routine_model.dart │ │ │ ├── workout_session_model.dart │ │ │ ├── workout_set_model.dart │ │ │ └── body_record_model.dart │ │ │ │ │ ├── repositories/ # 저장소 │ │ │ ├── auth_repository.dart │ │ │ ├── exercise_repository.dart │ │ │ ├── routine_repository.dart │ │ │ ├── workout_repository.dart │ │ │ └── stats_repository.dart │ │ │ │ │ └── services/ # 외부 서비스 │ │ ├── supabase_service.dart │ │ ├── ai_service.dart # OpenAI 연동 │ │ └── local_storage_service.dart │ │ │ ├── domain/ # 비즈니스 로직 │ │ ├── providers/ # Riverpod Providers │ │ │ ├── auth_provider.dart │ │ │ ├── user_provider.dart │ │ │ ├── exercise_provider.dart │ │ │ ├── routine_provider.dart │ │ │ ├── workout_provider.dart │ │ │ ├── timer_provider.dart │ │ │ └── ai_provider.dart │ │ │ │ │ └── usecases/ # 유스케이스 │ │ ├── calculate_1rm_usecase.dart │ │ ├── generate_routine_usecase.dart │ │ └── analyze_workout_usecase.dart │ │ │ ├── presentation/ # UI 레이어 │ │ ├── widgets/ # 공통 위젯 │ │ │ ├── atoms/ # 기본 위젯 │ │ │ │ ├── v2_button.dart │ │ │ │ ├── v2_text_field.dart │ │ │ │ ├── v2_card.dart │ │ │ │ ├── v2_chip.dart │ │ │ │ └── number_stepper.dart # 무게/횟수 조절 │ │ │ │ │ │ │ ├── molecules/ # 조합 위젯 │ │ │ │ ├── exercise_card.dart │ │ │ │ ├── set_row.dart # 빠른 기록 행 │ │ │ │ ├── rest_timer.dart # 휴식 타이머 │ │ │ │ ├── mode_selector.dart # AI/자유 모드 │ │ │ │ └── stat_card.dart │ │ │ │ │ │ │ └── organisms/ # 복합 위젯 │ │ │ ├── workout_logger.dart │ │ │ ├── exercise_guide.dart # 3D 가이드 │ │ │ ├── muscle_map.dart # 근육맵 │ │ │ └── weekly_chart.dart │ │ │ │ │ └── screens/ # 화면 │ │ ├── splash/ │ │ ├── onboarding/ │ │ ├── auth/ │ │ ├── home/ │ │ ├── workout/ # 운동 진행 │ │ ├── routine/ # 루틴 관리 │ │ ├── history/ # 기록 히스토리 │ │ ├── stats/ # 통계 │ │ └── profile/ # 프로필 │ │ │ └── generated/ # 자동 생성 파일 │ └── assets.gen.dart │ ├── assets/ │ ├── images/ │ ├── icons/ │ ├── animations/ # Rive/Lottie 파일 │ │ └── exercises/ # 운동 애니메이션 │ └── fonts/ │ ├── test/ # 테스트 ├── pubspec.yaml └── analysis_options.yaml


---

## 🎨 디자인 시스템

### 컬러 팔레트 (다크 테마 기본)

```dart
// lib/core/constants/app_colors.dart
abstract class AppColors {
  // Primary - AI 모드 (인디고)
  static const primary50 = Color(0xFFEEF2FF);
  static const primary100 = Color(0xFFE0E7FF);
  static const primary500 = Color(0xFF6366F1);  // Main
  static const primary600 = Color(0xFF4F46E5);
  static const primary700 = Color(0xFF4338CA);

  // Secondary - 자유 모드 (오렌지)
  static const secondary500 = Color(0xFFF97316);
  static const secondary600 = Color(0xFFEA580C);

  // Success - 완료, PR
  static const success = Color(0xFF22C55E);
  
  // Error
  static const error = Color(0xFFEF4444);

  // 다크 테마 Neutral
  static const darkBg = Color(0xFF0F0F0F);
  static const darkCard = Color(0xFF1A1A1A);
  static const darkCardElevated = Color(0xFF242424);
  static const darkBorder = Color(0xFF2A2A2A);
  static const darkText = Color(0xFFFFFFFF);
  static const darkTextSecondary = Color(0xFFA1A1AA);
  static const darkTextTertiary = Color(0xFF71717A);

  // 근육 부위별 컬러
  static const muscleChest = Color(0xFFEF4444);
  static const muscleBack = Color(0xFF3B82F6);
  static const muscleShoulders = Color(0xFF8B5CF6);
  static const muscleBiceps = Color(0xFFF59E0B);
  static const muscleTriceps = Color(0xFF10B981);
  static const muscleLegs = Color(0xFFEC4899);
  static const muscleAbs = Color(0xFF6366F1);

  // 세트 타입별 컬러
  static const setWarmup = Color(0xFF94A3B8);
  static const setWorking = Color(0xFF6366F1);
  static const setDrop = Color(0xFFF59E0B);
  static const setFailure = Color(0xFFEF4444);
}
타이포그래피
Copy// lib/core/constants/app_typography.dart
abstract class AppTypography {
  static const fontFamily = 'Pretendard';
  
  // Display
  static const display1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 48,
    fontWeight: FontWeight.w800,
    height: 1.2,
  );
  
  // Headings
  static const h1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );
  
  static const h2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );
  
  static const h3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );
  
  // Body
  static const bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );
  
  static const bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );
  
  static const bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );
  
  // Labels
  static const labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );
  
  // Timer (특수)
  static const timer = TextStyle(
    fontFamily: 'JetBrains Mono',
    fontSize: 64,
    fontWeight: FontWeight.w700,
    height: 1.0,
  );
}
Copy
🗄️ 데이터베이스 스키마 (Supabase)
테이블 구조
Copy-- 사용자
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
    CHECK (preferred_mode IN ('AI', 'FREE', 'HYBRID')),
  gym_id UUID REFERENCES gyms(id),
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

-- 루틴
CREATE TABLE routines (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  source_type TEXT DEFAULT 'CUSTOM' 
    CHECK (source_type IN ('AI', 'CUSTOM', 'TEMPLATE')),
  is_ai_generated BOOLEAN DEFAULT FALSE,
  target_muscles TEXT[],
  estimated_duration INTEGER,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 루틴-운동 연결
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
  mode TEXT CHECK (mode IN ('AI', 'FREE')),
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
  recorded_at DATE DEFAULT CURRENT_DATE
);
Copy
🔧 핵심 알고리즘
1RM 계산
Copy// lib/core/utils/fitness_calculator.dart

/// 1RM 계산 (Brzycki, Epley, Lander 공식 평균)
double calculate1RM(double weight, int reps) {
  if (reps == 1) return weight;
  if (reps > 30) throw ArgumentError('반복 수가 너무 많습니다');

  final brzycki = weight * (36 / (37 - reps));
  final epley = weight * (1 + reps / 30);
  final lander = (100 * weight) / (101.3 - 2.67123 * reps);

  return ((brzycki + epley + lander) / 3 * 10).round() / 10;
}

/// 볼륨 계산
double calculateVolume(List<WorkoutSet> sets) {
  return sets.fold(0.0, (sum, set) => 
    sum + (set.weight ?? 0) * (set.reps ?? 0));
}

/// 강도 분석
IntensityZone analyzeIntensity(double weight, double estimated1RM) {
  final percent = (weight / estimated1RM) * 100;
  
  if (percent >= 90) return IntensityZone.maxStrength;
  if (percent >= 80) return IntensityZone.strength;
  if (percent >= 65) return IntensityZone.hypertrophy;
  if (percent >= 50) return IntensityZone.endurance;
  return IntensityZone.warmup;
}

enum IntensityZone {
  maxStrength('최대 근력', '1-3회', Color(0xFFEF4444)),
  strength('근력 향상', '3-6회', Color(0xFFF97316)),
  hypertrophy('근비대', '6-12회', Color(0xFF22C55E)),
  endurance('근지구력', '12-20회', Color(0xFF3B82F6)),
  warmup('웜업', '15회 이상', Color(0xFF94A3B8));

  final String label;
  final String suggestedReps;
  final Color color;
  
  const IntensityZone(this.label, this.suggestedReps, this.color);
}
Copy
📱 핵심 화면 구현 가이드
1. 홈 화면 (듀얼 모드 선택)
Copy// lib/presentation/screens/home/home_screen.dart

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 상단 인사
              _buildGreeting(user),
              const SizedBox(height: 24),
              
              // 모드 선택 카드 (핵심!)
              _buildModeSelector(context),
              const SizedBox(height: 16),
              
              // 빠른 기록 버튼
              _buildQuickRecordButton(context),
              const SizedBox(height: 24),
              
              // 이번 주 요약
              _buildWeeklySummary(ref),
              const SizedBox(height: 24),
              
              // 최근 운동
              Expanded(child: _buildRecentWorkouts(ref)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeSelector(BuildContext context) {
    return Row(
      children: [
        // AI 모드 카드
        Expanded(
          child: _ModeCard(
            icon: Icons.smart_toy_outlined,
            title: 'AI 추천 모드',
            description: 'AI가 오늘의\n루틴을 추천해요',
            gradient: [AppColors.primary600, AppColors.primary700],
            onTap: () => context.push('/workout/ai'),
          ),
        ),
        const SizedBox(width: 12),
        // 자유 모드 카드
        Expanded(
          child: _ModeCard(
            icon: Icons.edit_outlined,
            title: '자유 기록 모드',
            description: '내 루틴으로\n자유롭게 기록해요',
            gradient: [AppColors.secondary500, AppColors.secondary600],
            onTap: () => context.push('/workout/free'),
          ),
        ),
      ],
    );
  }
}
Copy
2. 운동 진행 화면 (빠른 기록)
Copy// lib/presentation/screens/workout/workout_screen.dart

class WorkoutScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends ConsumerState<WorkoutScreen> {
  @override
  Widget build(BuildContext context) {
    final session = ref.watch(activeWorkoutProvider);
    final currentExercise = ref.watch(currentExerciseProvider);
    
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: _buildAppBar(session),
      body: Column(
        children: [
          // 운동 가이드 (3D 애니메이션)
          ExerciseGuide(exercise: currentExercise),
          
          // 이전 기록 & 1RM
          _buildPreviousRecord(currentExercise),
          
          // 세트 기록 리스트
          Expanded(
            child: SetLogger(
              exercise: currentExercise,
              onSetComplete: _handleSetComplete,
            ),
          ),
          
          // 빠른 입력 컨트롤
          QuickInputControl(
            onWeightChange: _handleWeightChange,
            onRepsChange: _handleRepsChange,
          ),
          
          // 휴식 타이머
          RestTimer(),
          
          // 세트 완료 버튼
          _buildCompleteButton(),
        ],
      ),
    );
  }

  Widget _buildCompleteButton() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: V2Button(
        text: '세트 완료',
        icon: Icons.check_circle,
        onPressed: () {
          HapticFeedback.heavyImpact();
          ref.read(workoutProvider.notifier).completeSet();
        },
        fullWidth: true,
      ),
    );
  }
}
Copy
3. 빠른 입력 컴포넌트 (번핏 스타일)
Copy// lib/presentation/widgets/molecules/quick_input_control.dart

class QuickInputControl extends StatelessWidget {
  final Function(double) onWeightChange;
  final Function(int) onRepsChange;
  final double currentWeight;
  final int currentReps;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        border: Border(
          top: BorderSide(color: AppColors.darkBorder),
        ),
      ),
      child: Row(
        children: [
          // 무게 조절
          Expanded(
            child: NumberStepper(
              value: currentWeight,
              unit: 'kg',
              step: 2.5,
              onChanged: onWeightChange,
              quickButtons: [-5, -2.5, 2.5, 5],
            ),
          ),
          const SizedBox(width: 24),
          // 횟수 조절
          Expanded(
            child: NumberStepper(
              value: currentReps.toDouble(),
              unit: '회',
              step: 1,
              onChanged: (v) => onRepsChange(v.toInt()),
              quickButtons: [-1, 1],
            ),
          ),
        ],
      ),
    );
  }
}

// NumberStepper 위젯
class NumberStepper extends StatelessWidget {
  final double value;
  final String unit;
  final double step;
  final Function(double) onChanged;
  final List<double> quickButtons;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 빠른 조절 버튼들
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: quickButtons.map((delta) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: _QuickButton(
                label: delta > 0 ? '+${delta.toStringAsFixed(delta % 1 == 0 ? 0 : 1)}' 
                                : delta.toStringAsFixed(delta % 1 == 0 ? 0 : 1),
                onTap: () {
                  HapticFeedback.lightImpact();
                  onChanged(value + delta);
                },
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        // 현재 값 표시
        Text(
          '${value.toStringAsFixed(value % 1 == 0 ? 0 : 1)} $unit',
          style: AppTypography.h2.copyWith(
            color: AppColors.darkText,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
Copy
🚀 개발 명령어
프로젝트 생성 및 초기 설정
Copy# Flutter 프로젝트 생성
flutter create v2log --org com.v2log --platforms android,ios

# 의존성 설치
cd v2log
flutter pub add flutter_riverpod
flutter pub add riverpod_annotation
flutter pub add go_router
flutter pub add supabase_flutter
flutter pub add hive_flutter
flutter pub add fl_chart
flutter pub add rive
flutter pub add lottie
flutter pub add google_fonts
flutter pub add flutter_svg
flutter pub add cached_network_image
flutter pub add intl
flutter pub add uuid
flutter pub add freezed_annotation
flutter pub add json_annotation

# dev dependencies
flutter pub add --dev build_runner
flutter pub add --dev riverpod_generator
flutter pub add --dev freezed
flutter pub add --dev json_serializable
flutter pub add --dev flutter_gen_runner
코드 생성
Copy# Freezed, Riverpod 코드 생성
dart run build_runner build --delete-conflicting-outputs

# 에셋 코드 생성
dart run flutter_gen
실행
Copy# 개발 모드 실행
flutter run

# 릴리즈 빌드
flutter build apk --release
flutter build ios --release
⚠️ 개발 시 주의사항
상태 관리: 모든 Provider는 @riverpod 어노테이션 사용
에러 처리: 모든 비동기 작업에 try-catch 및 AsyncValue 활용
성능: ListView.builder 사용, const 위젯 활용
접근성: Semantics 위젯 사용, 충분한 터치 영역 확보
테스트: Widget 테스트, Provider 테스트 작성
📋 체크리스트
Phase 1: MVP (8주)
 프로젝트 초기 설정
 Supabase 연동
 인증 (이메일, 소셜 로그인)
 온보딩 플로우
 운동 라이브러리 (300+ 운동)
 AI/자유 모드 선택 홈 화면
 운동 기록 화면 (빠른 입력)
 세트 타입 구분 (웜업/본세트/드롭세트)
 1RM 자동 계산
 휴식 타이머
 캘린더 & 히스토리
 기본 통계 대시보드
Phase 2: 확장 (4주)
 AI 루틴 추천 (OpenAI 연동)
 3D 운동 가이드 (Rive)
 음성 코칭
 회차별 기록 (하루 3회)
 메모 검색
 푸시 알림
 오운완 공유 카드
Phase 3: 차별화 (8주)
 AI 트레이너 챗봇
 커뮤니티 (클럽/챌린지)
 Apple Watch 연동
 Galaxy Watch 연동
 식단 기록
 프리미엄 구독