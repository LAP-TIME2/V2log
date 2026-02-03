# CLAUDE.md - V2log 헬스 앱 개발 가이드

## 🎯 프로젝트 개요

**V2log**는 번핏(BurnFit)의 빠른 기록 UX와 검증된 전문가 루틴을 결합한 직관적인 헬스 앱입니다.

### 핵심 슬로건
> "전문가 루틴으로 시작하고, 기록은 10초 만에"

### 핵심 차별점
- **듀얼 모드 시스템**: 전문가 큐레이션 루틴 + 자유 기록 모드
- **10초 빠른 기록**: 세트 완료까지 최소 터치
- **상세 가이드**: 초보자를 위한 운동 가이드 및 애니메이션
- **검증된 프로그램**: 경험 수준별 5~10개 프리셋 루틴 제공

### 기술 스택
- **Framework**: Flutter 3.24+ (Dart 3.5+)
- **State Management**: Riverpod 2.5+
- **Backend**: Supabase (Auth, Database, Storage)
- **Local Storage**: Hive, SharedPreferences
- **Charts**: fl_chart
- **Animations**: Rive, Lottie
- **Router**: GoRouter

---

## 📁 프로젝트 구조

v2log/ ├── lib/ │ ├── main.dart # 앱 진입점 │ ├── app.dart # MaterialApp 설정 │ │ │ ├── core/ # 핵심 공통 모듈 │ │ ├── constants/ # 상수 정의 │ │ │ ├── app_colors.dart # 컬러 팔레트 │ │ │ ├── app_typography.dart # 타이포그래피 │ │ │ ├── app_spacing.dart # 간격 시스템 │ │ │ └── app_assets.dart # 에셋 경로 │ │ │ │ │ ├── theme/ # 테마 시스템 │ │ │ ├── app_theme.dart # 라이트/다크 테마 │ │ │ └── theme_provider.dart # 테마 상태 관리 │ │ │ │ │ ├── router/ # 라우팅 │ │ │ └── app_router.dart # GoRouter 설정 │ │ │ │ │ ├── utils/ # 유틸리티 │ │ │ ├── validators.dart # 입력 검증 │ │ │ ├── formatters.dart # 포맷터 │ │ │ ├── fitness_calculator.dart # 1RM, 볼륨 계산 │ │ │ └── haptic_feedback.dart # 햅틱 피드백 │ │ │ │ │ └── extensions/ # Dart 확장 │ │ ├── context_extension.dart │ │ └── string_extension.dart │ │ │ ├── data/ # 데이터 레이어 │ │ ├── models/ # 데이터 모델 │ │ │ ├── user_model.dart │ │ │ ├── exercise_model.dart │ │ │ ├── routine_model.dart │ │ │ ├── preset_routine_model.dart # 프리셋 루틴 모델 │ │ │ ├── workout_session_model.dart │ │ │ ├── workout_set_model.dart │ │ │ └── body_record_model.dart │ │ │ │ │ ├── repositories/ # 저장소 │ │ │ ├── auth_repository.dart │ │ │ ├── exercise_repository.dart │ │ │ ├── routine_repository.dart │ │ │ ├── preset_routine_repository.dart # 프리셋 루틴 저장소 │ │ │ ├── workout_repository.dart │ │ │ └── stats_repository.dart │ │ │ │ │ └── services/ # 외부 서비스 │ │ ├── supabase_service.dart │ │ └── local_storage_service.dart │ │ │ ├── domain/ # 비즈니스 로직 │ │ ├── providers/ # Riverpod Providers │ │ │ ├── auth_provider.dart │ │ │ ├── user_provider.dart │ │ │ ├── exercise_provider.dart │ │ │ ├── routine_provider.dart │ │ │ ├── preset_routine_provider.dart # 프리셋 루틴 Provider │ │ │ ├── workout_provider.dart │ │ │ └── timer_provider.dart │ │ │ │ │ └── usecases/ # 유스케이스 │ │ ├── calculate_1rm_usecase.dart │ │ ├── copy_preset_routine_usecase.dart # 프리셋 복사 로직 │ │ └── analyze_workout_usecase.dart │ │ │ ├── presentation/ # UI 레이어 │ │ ├── widgets/ # 공통 위젯 │ │ │ ├── atoms/ # 기본 위젯 │ │ │ │ ├── v2_button.dart │ │ │ │ ├── v2_text_field.dart │ │ │ │ ├── v2_card.dart │ │ │ │ ├── v2_chip.dart │ │ │ │ └── number_stepper.dart │ │ │ │ │ │ │ ├── molecules/ # 조합 위젯 │ │ │ │ ├── exercise_card.dart │ │ │ │ ├── set_row.dart │ │ │ │ ├── rest_timer.dart │ │ │ │ ├── mode_selector.dart │ │ │ │ ├── preset_routine_card.dart # 프리셋 루틴 카드 │ │ │ │ └── stat_card.dart │ │ │ │ │ │ │ └── organisms/ # 복합 위젯 │ │ │ ├── workout_logger.dart │ │ │ ├── exercise_guide.dart │ │ │ ├── muscle_map.dart │ │ │ └── weekly_chart.dart │ │ │ │ │ └── screens/ # 화면 │ │ ├── splash/ │ │ ├── onboarding/ │ │ ├── auth/ │ │ ├── home/ │ │ ├── workout/ # 운동 진행 │ │ ├── routine/ # 루틴 관리 │ │ │ ├── routine_library_screen.dart # 프리셋 루틴 라이브러리 │ │ │ └── custom_routine_screen.dart # 커스텀 루틴 생성 │ │ ├── history/ # 기록 히스토리 │ │ ├── stats/ # 통계 │ │ └── profile/ # 프로필 │ │ │ └── generated/ # 자동 생성 파일 │ └── assets.gen.dart │ ├── assets/ │ ├── images/ │ ├── icons/ │ ├── animations/ # Rive/Lottie 파일 │ │ └── exercises/ # 운동 애니메이션 │ └── fonts/ │ ├── test/ # 테스트 ├── pubspec.yaml └── analysis_options.yaml


---

## 🎨 디자인 시스템

### 컬러 팔레트 (다크 테마 기본)

```dart
// lib/core/constants/app_colors.dart
abstract class AppColors {
  // Primary - 전문가 루틴 모드 (인디고)
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
    CHECK (preferred_mode IN ('PRESET', 'FREE', 'HYBRID')),
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

-- 프리셋 루틴 - 운동 연결
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

-- 사용자 루틴 (커스텀 또는 프리셋 복사본)
CREATE TABLE routines (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  source_type TEXT DEFAULT 'CUSTOM' 
    CHECK (source_type IN ('PRESET', 'CUSTOM')),
  preset_routine_id UUID REFERENCES preset_routines(id),
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
        // 전문가 루틴 모드 카드
        Expanded(
          child: _ModeCard(
            icon: Icons.book_outlined,
            title: '전문가 루틴',
            description: '검증된 프로그램으로\n체계적으로 시작해요',
            gradient: [AppColors.primary600, AppColors.primary700],
            onTap: () => context.push('/routine/library'),
          ),
        ),
        const SizedBox(width: 12),
        // 자유 모드 카드
        Expanded(
          child: _ModeCard(
            icon: Icons.edit_outlined,
            title: '자유 기록',
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
2. 프리셋 루틴 라이브러리 화면
Copy// lib/presentation/screens/routine/routine_library_screen.dart

class RoutineLibraryScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final presetRoutines = ref.watch(presetRoutineProvider);
    
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        title: Text('전문가 루틴'),
      ),
      body: presetRoutines.when(
        data: (routines) => _buildRoutineList(context, routines),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('에러: $error')),
      ),
    );
  }

  Widget _buildRoutineList(BuildContext context, List<PresetRoutine> routines) {
    // 필터링 탭
    return Column(
      children: [
        // 필터 탭바 (초보자/중급자/고급자)
        _buildFilterTabs(),
        
        // 루틴 카드 리스트
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(20),
            itemCount: routines.length,
            itemBuilder: (context, index) {
              final routine = routines[index];
              return PresetRoutineCard(
                routine: routine,
                onTap: () => _showRoutineDetail(context, routine),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showRoutineDetail(BuildContext context, PresetRoutine routine) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.darkCard,
      builder: (context) => PresetRoutineDetailSheet(routine: routine),
    );
  }
}
Copy
3. 프리셋 루틴 카드 위젯
Copy// lib/presentation/widgets/molecules/preset_routine_card.dart

class PresetRoutineCard extends StatelessWidget {
  final PresetRoutine routine;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.darkBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 난이도 뱃지
            Row(
              children: [
                _DifficultyBadge(difficulty: routine.difficulty),
                SizedBox(width: 8),
                if (routine.isFeatured)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary500.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '추천',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.primary500,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                Spacer(),
                Icon(Icons.chevron_right, color: AppColors.darkTextSecondary),
              ],
            ),
            SizedBox(height: 12),
            
            // 루틴 이름
            Text(
              routine.name,
              style: AppTypography.h3.copyWith(color: AppColors.darkText),
            ),
            SizedBox(height: 8),
            
            // 설명
            Text(
              routine.description,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.darkTextSecondary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 16),
            
            // 메타 정보
            Row(
              children: [
                _MetaInfo(
                  icon: Icons.calendar_today_outlined,
                  text: '주 ${routine.daysPerWeek}회',
                ),
                SizedBox(width: 16),
                _MetaInfo(
                  icon: Icons.timer_outlined,
                  text: '${routine.estimatedDurationMinutes}분',
                ),
                SizedBox(width: 16),
                _MetaInfo(
                  icon: Icons.fitness_center_outlined,
                  text: '${routine.targetMuscles.length}개 부위',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
Copy
4. 운동 진행 화면 (빠른 기록)
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
          // 운동 가이드 (애니메이션)
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
5. 빠른 입력 컴포넌트 (번핏 스타일)
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

# Chrome에서 실행
flutter run -d chrome

# 릴리즈 빌드
flutter build apk --release
flutter build ios --release
⚠️ 개발 시 주의사항
상태 관리: 모든 Provider는 @riverpod 어노테이션 사용
에러 처리: 모든 비동기 작업에 try-catch 및 AsyncValue 활용
성능: ListView.builder 사용, const 위젯 활용
접근성: Semantics 위젯 사용, 충분한 터치 영역 확보
테스트: Widget 테스트, Provider 테스트 작성
오프라인 지원: 중요 데이터는 Hive로 로컬 캐싱
📋 개발 체크리스트
Phase 1: MVP 기본 기능 (6주)
1주차: 프로젝트 설정 및 인증

 프로젝트 초기 설정
 Supabase 프로젝트 생성 및 연동
 디자인 시스템 구축 (색상, 타이포그래피, 컴포넌트)
 인증 (이메일 로그인/회원가입)
 온보딩 플로우 (목표 설정, 경험 수준 선택)
2주차: 데이터베이스 및 운동 라이브러리

 Supabase 테이블 생성 (모든 테이블)
 운동 라이브러리 데이터 입력 (100+ 운동)
 프리셋 루틴 5개 생성 및 입력
초보자 3분할 (주 3회)
중급자 4분할 (주 4회)
상체 집중 푸시풀 (주 4회)
하체 집중 프로그램 (주 3회)
홈트레이닝 덤벨 루틴 (주 3회)
 Exercise, PresetRoutine 모델 생성 (Freezed)
 Repository 및 Provider 구현
3주차: 홈 화면 및 루틴 선택

 홈 화면 UI (듀얼 모드 선택)
 프리셋 루틴 라이브러리 화면
 프리셋 루틴 상세 보기 (Bottom Sheet)
 프리셋 루틴 → 내 루틴 복사 기능
 커스텀 루틴 생성 화면 (자유 모드)
4주차: 운동 진행 화면 (핵심 기능)

 운동 진행 화면 UI
 세트 기록 리스트
 빠른 입력 컨트롤 (NumberStepper)
 세트 완료 로직
 휴식 타이머
 다음 운동으로 이동
 운동 완료 요약 화면
5주차: 히스토리 및 통계

 운동 기록 캘린더
 기록 상세 보기
 기본 통계 대시보드
이번 주 총 볼륨
운동 일수
가장 많이 한 운동
 운동별 1RM 추적
 개인 기록 (PR) 표시
6주차: 프로필 및 마무리

 프로필 화면
 신체 정보 입력/수정
 목표 수정
 테마 설정 (다크/라이트)
 버그 수정 및 UX 개선
 기본 에러 처리
Phase 2: 확장 기능 (4주)
7주차: 운동 가이드 강화

 운동 애니메이션 (Rive 또는 Lottie)
 운동 상세 가이드 (이미지, 설명, 팁)
 근육 맵 시각화
 운동 검색 기능
8주차: 통계 고도화

 주간/월간 볼륨 차트 (fl_chart)
 부위별 운동 분석
 1RM 진행도 그래프
 운동 강도 분석 (볼륨, 빈도, 강도)
9주차: 사용성 개선

 오프라인 지원 (Hive 캐싱)
 운동 메모 기능
 세트 타입 구분 (웜업/본세트/드롭세트)
 슈퍼세트 지원
 휴식 타이머 알림
10주차: 소셜 및 공유

 오운완 공유 카드 생성
 이미지로 저장 기능
 친구에게 루틴 공유
 푸시 알림 (운동 리마인더)
Phase 3: 프리미엄 기능 (선택 사항)
추후 확장 가능 기능:

 AI 루틴 추천 (OpenAI API 연동)
사용자 맞춤 루틴 생성
채팅 기반 트레이너
월 구독 모델로 제공
 커뮤니티 기능
운동 기록 피드
챌린지 시스템
 웨어러블 연동
Apple Watch
Galaxy Watch
 식단 기록
 체성분 분석 연동
🎯 프리셋 루틴 예시 데이터
1. 초보자 3분할 (주 3회)
CopyINSERT INTO preset_routines (name, description, difficulty, target_goal, days_per_week, estimated_duration_minutes, target_muscles, equipment_required, is_featured)
VALUES (
  '초보자 3분할 프로그램',
  '헬스 입문자를 위한 기본 루틴. 가슴/등/하체를 나누어 주 3회 진행합니다.',
  'BEGINNER',
  'HYPERTROPHY',
  3,
  60,
  ARRAY['CHEST', 'BACK', 'LEGS', 'SHOULDERS', 'ARMS'],
  ARRAY['BARBELL', 'DUMBBELL', 'MACHINE'],
  TRUE
);

-- Day 1: 가슴 + 삼두
INSERT INTO preset_routine_exercises (preset_routine_id, exercise_id, day_number, day_name, order_index, target_sets, target_reps, rest_seconds)
VALUES
  ((SELECT id FROM preset_routines WHERE name = '초보자 3분할 프로그램'), 
   (SELECT id FROM exercises WHERE name = '벤치프레스'), 
   1, 'Day 1 - 가슴/삼두', 1, 3, '8-12', 90),
  -- ... 추가 운동들
(전체 5개 프리셋 루틴 데이터는 별도 SQL 파일로 제공)

💾 Supabase 초기 데이터 입력 순서
exercises 테이블 먼저 입력 (운동 라이브러리 100~300개)
preset_routines 테이블 입력 (전문가 루틴 5~10개)
preset_routine_exercises 테이블 입력 (루틴별 운동 연결)
앱에서 테스트: 프리셋 루틴 불러오기 → 내 루틴 복사 → 운동 시작
📌 핵심 차이점 요약
항목	기존 (AI 기반)	수정 (프리셋 기반)
루틴 추천 방식	OpenAI API로 실시간 생성	전문가 큐레이션 5~10개 제공
개발 시간	2~3주	2~3일
운영 비용	월 $5~20	$0
사용자 경험	AI 생성 대기 시간 필요	즉시 선택 가능
초보자 신뢰도	낮음 (AI 불신)	높음 (검증된 프로그램)
확장성	무한 조합 가능	프리셋 개수 제한적
차별화 요소	AI 개인화	빠른 기록 + 검증된 루틴
## 🔴 필수 개발 규칙

### DB 작업 전 필수 확인
새로운 기능 구현 전에 반드시:
1) 관련 테이블의 FK(Foreign Key) 제약조건 확인
2) NOT NULL 컬럼 확인
3) Auth 유저와 users 테이블 동기화 여부 확인

### Supabase 인증 구조
- Supabase Auth: 로그인/회원가입 처리
- users 테이블: Auth 유저와 1:1 매핑 필요
- 회원가입 시 Auth + users 테이블 동시 INSERT

### 데이터 저장 시 체크리스트
- [ ] user_id = Supabase.instance.client.auth.currentUser?.id 사용
- [ ] FK 참조하는 테이블에 데이터 존재 여부 확인
- [ ] NULL 허용 여부에 따라 null 처리

### 현재 FK 구조
- workout_sessions.user_id → users.id (NOT NULL)
- workout_sessions.routine_id → routines.id (NULL 허용)
- workout_sets.session_id → workout_sessions.id (NOT NULL)
- workout_sets.exercise_id → exercises.id (NOT NULL)

### users 테이블 구조
| 컬럼 | 타입 | NOT NULL | 기본값 | CHECK 제약조건 |
|------|------|----------|--------|----------------|
| id | uuid | ✅ | - | - |
| email | text | ✅ | - | - |
| nickname | text | ✅ | - | - |
| fitness_goal | text | ✅ | 'HYPERTROPHY' | STRENGTH, HYPERTROPHY, ENDURANCE, WEIGHT_LOSS |
| preferred_mode | text | ✅ | 'HYBRID' | PRESET, FREE, HYBRID |
| experience_level | text | ✅ | 'BEGINNER' | BEGINNER, INTERMEDIATE, ADVANCED |
| profile_image_url | text | ❌ | NULL | - |
| gender | text | ❌ | NULL | MALE, FEMALE, OTHER |
| birth_date | date | ❌ | NULL | - |
| height | numeric | ❌ | NULL | - |
| weight | numeric | ❌ | NULL | - |
| created_at | timestamp | ✅ | NOW() | - |
| updated_at | timestamp | ✅ | NOW() | - |

## 🔴 DB 작업 필수 규칙

### 에러 로그 규칙
- ❌ `debugPrint()` 사용 금지 (터미널에 안 보임)
- ✅ `print('=== 에러: $e ===')` 사용 (터미널에 보임)

### INSERT/UPDATE 전 필수 확인
1) CLAUDE.md에서 테이블 구조 확인
2) NOT NULL 컬럼 모두 값 넣기
3) CHECK 제약조건 허용값 확인
4) FK 참조 테이블에 데이터 존재 확인

### CHECK 제약조건 허용값 정리
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
| workout_sessions | mode | PRESET, FREE |
| workout_sets | set_type | WARMUP, WORKING, DROP, FAILURE, SUPERSET |

### DB 변경 시 체크리스트
- [ ] NOT NULL 컬럼 확인
- [ ] CHECK 제약조건 확인  
- [ ] FK 제약조건 확인
- [ ] 기본값 확인
- [ ] CLAUDE.md에 모두 기록



🎓 개발 가이드
Claude Code 사용 시 프롬프트 예시
CLAUDE.md와 context7.md를 참고해서 다음 작업을 해줘:

1) Supabase에 preset_routines 테이블과 preset_routine_exercises 테이블 생성 SQL 작성
2) lib/data/models/preset_routine_model.dart 생성 (Freezed)
3) lib/data/repositories/preset_routine_repository.dart 구현
4) lib/domain/providers/preset_routine_provider.dart 생성
5) lib/presentation/screens/routine/routine_library_screen.dart 구현
6) lib/presentation/widgets/molecules/preset_routine_card.dart 위젯 생성

dart run build_runner build --delete-conflicting-outputs 실행
flutter run -d chrome으로 테스트
📞 지원 및 문의
GitHub: https://github.com/LAP-TIME/V2log
문의: v2log@example.com
이 문서는 V2log 프로젝트의 단일 진실 공급원(Single Source of Truth)입니다. 모든 개발 결정은 이 문서를 기준으로 합니다.