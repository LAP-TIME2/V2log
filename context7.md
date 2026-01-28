## 📄 context7.md 파일

```markdown
# context7.md - V2log 상세 컨텍스트 문서

## 📌 이 문서의 목적

이 문서는 V2log 앱 개발 시 Claude Code가 참조해야 하는 상세한 컨텍스트 정보를 담고 있습니다.
코드 생성, 디버깅, 아키텍처 결정 시 이 문서를 참조하세요.

---

## 1. 벤치마킹 앱 분석

### 플랜핏 (Planfit) - 가져올 장점

| 기능 | 설명 | 구현 우선순위 |
|------|------|-------------|
| AI 맞춤 루틴 | 신체정보/목표 기반 자동 생성 | ⭐⭐⭐ MVP |
| 헬스장 기구 연동 | 등록된 헬스장 기구 기반 추천 | ⭐⭐ Phase 2 |
| 3D 애니메이션 가이드 | Rive/Lottie 운동 동작 가이드 | ⭐⭐⭐ MVP |
| 음성 코칭 | TTS 세트/휴식 안내 | ⭐⭐ Phase 2 |
| AI 트레이너 챗봇 | GPT-4 기반 상담 | ⭐ Phase 3 |
| 커뮤니티 | 클럽/챌린지/피드 | ⭐ Phase 3 |
| Apple Watch | 워치 연동 | ⭐ Phase 3 |

### 번핏 (BurnFit) - 가져올 장점

| 기능 | 설명 | 구현 우선순위 |
|------|------|-------------|
| 10초 빠른 기록 | 최적화된 입력 UX | ⭐⭐⭐ MVP |
| 커스텀 루틴 | 완전 자유 루틴 구성 | ⭐⭐⭐ MVP |
| 세트 타입 구분 | 웜업/본세트/드롭세트/실패 | ⭐⭐⭐ MVP |
| 1RM 분석 | 자동 1RM 계산 및 강도 분석 | ⭐⭐⭐ MVP |
| 회차별 기록 | 하루 3회 운동 기록 | ⭐⭐ Phase 2 |
| 메모 검색 | 세트별 메모 및 검색 | ⭐⭐ Phase 2 |
| 식단 기록 | 간편 식단 기록 | ⭐⭐ Phase 2 |

### 단점 상쇄

| 플랜핏 단점 | 해결책 |
|------------|--------|
| 루틴 시작 후 취소 불가 | 언제든 취소/수정 가능 버튼 추가 |
| 단일 운동 기록 불가 | "빠른 기록" 버튼으로 루틴 없이 즉시 기록 |
| 자유로운 기록 제한 | AI 추천 + 완전 커스텀 모드 병행 |
| 식단 기록 없음 | Phase 2에서 식단 기록 추가 |

| 번핏 단점 | 해결책 |
|----------|--------|
| AI 루틴 추천 없음 | GPT-4 기반 AI 추천 시스템 |
| 동작 가이드 없음 | 3D Rive 애니메이션 가이드 |
| 스마트워치 미지원 | Apple Watch + Galaxy Watch 지원 |
| 커뮤니티 약함 | 클럽/챌린지/피드 기능 |

---

## 2. 핵심 UX 플로우

### 2.1 듀얼 모드 시스템

┌─────────────────────────────────────────────┐ │ 앱 홈 화면 │ └─────────────────┬───────────────────────────┘ │ ┌────────────┴────────────┐ ▼ ▼ ┌─────────────┐ ┌─────────────┐ │ 🤖 AI 모드 │ │ ✍️ 자유 모드 │ │ (플랜핏式) │ │ (번핏式) │ └──────┬──────┘ └──────┬──────┘ │ │ ▼ ▼ ┌─────────────────────────────────────────────┐ │ 통합 운동 진행 화면 (공통 UI) │ │ • 10초 빠른 기록 (번핏) │ │ • 세트 타입 구분 (번핏) │ │ • 1RM 자동 계산 (번핏) │ │ • 3D 가이드 (플랜핏) │ │ • 루틴 중간 취소 가능 (단점 상쇄) │ └─────────────────────────────────────────────┘


### 2.2 빠른 기록 UX (10초 목표)

**목표**: 세트 완료 후 10초 이내 기록 완료

**UX 원칙**:
1. **이전 기록 자동 로드**: 마지막 수행 무게/횟수가 기본값
2. **원탭 완료**: 큰 "세트 완료" 버튼 한 번으로 기록
3. **빠른 조절**: ±2.5kg, ±1회 버튼으로 즉시 조절
4. **햅틱 피드백**: 모든 상호작용에 진동 피드백
5. **타이머 자동 시작**: 세트 완료 시 휴식 타이머 자동 시작

```dart
// 빠른 기록 플로우
1. 세트 완료 버튼 탭
   ↓
2. 현재 무게/횟수로 자동 저장 (기본값은 이전 기록)
   ↓
3. 햅틱 피드백 (Heavy Impact)
   ↓
4. 휴식 타이머 자동 시작
   ↓
5. 다음 세트 준비 (무게/횟수 유지)
2.3 세트 타입 시스템
Copyenum SetType {
  warmup,    // 웜업 세트 - 회색
  working,   // 본세트 - 인디고 (Primary)
  drop,      // 드롭세트 - 앰버
  failure,   // 실패 세트 - 레드
  superset,  // 슈퍼세트 - 퍼플
}
세트 타입 변경 UX:

기본값: working (본세트)
롱프레스로 타입 선택 모달 표시
또는 좌우 스와이프로 순환
3. 데이터 모델 상세
3.1 User Model
Copy@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    required String nickname,
    String? profileImageUrl,
    Gender? gender,
    DateTime? birthDate,
    double? height,
    double? weight,
    @Default(ExperienceLevel.beginner) ExperienceLevel experienceLevel,
    @Default(FitnessGoal.hypertrophy) FitnessGoal fitnessGoal,
    @Default(PreferredMode.hybrid) PreferredMode preferredMode,
    String? gymId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => 
    _$UserModelFromJson(json);
}

enum Gender { male, female, other }

enum ExperienceLevel {
  beginner,      // 0-6개월
  intermediate,  // 6개월-2년
  advanced,      // 2년 이상
}

enum FitnessGoal {
  strength,     // 근력
  hypertrophy,  // 근비대
  endurance,    // 근지구력
  weightLoss,   // 체중 감량
}

enum PreferredMode {
  ai,      // AI 추천 선호
  free,    // 자유 기록 선호
  hybrid,  // 혼합
}
Copy
3.2 Exercise Model
Copy@freezed
class ExerciseModel with _$ExerciseModel {
  const factory ExerciseModel({
    required String id,
    required String name,
    String? nameEn,
    required ExerciseCategory category,
    required MuscleGroup primaryMuscle,
    @Default([]) List<MuscleGroup> secondaryMuscles,
    @Default([]) List<String> equipmentRequired,
    required ExperienceLevel difficulty,
    @Default([]) List<String> instructions,
    @Default([]) List<String> tips,
    String? animationUrl,
    String? videoUrl,
    String? thumbnailUrl,
    double? caloriesPerMinute,
  }) = _ExerciseModel;

  factory ExerciseModel.fromJson(Map<String, dynamic> json) => 
    _$ExerciseModelFromJson(json);
}

enum ExerciseCategory { strength, cardio, flexibility }

enum MuscleGroup {
  chest,
  back,
  shoulders,
  biceps,
  triceps,
  forearms,
  abs,
  obliques,
  quads,
  hamstrings,
  glutes,
  calves,
  traps,
  lats,
  lowerBack,
  fullBody,
}
Copy
3.3 WorkoutSession Model
Copy@freezed
class WorkoutSessionModel with _$WorkoutSessionModel {
  const factory WorkoutSessionModel({
    required String id,
    required String userId,
    String? routineId,
    @Default(1) int sessionNumber,  // 당일 회차 (하루 3회까지)
    required WorkoutMode mode,
    required DateTime startedAt,
    DateTime? finishedAt,
    @Default(false) bool isCancelled,
    double? totalVolume,
    int? totalSets,
    int? totalDurationSeconds,
    int? caloriesBurned,
    String? notes,
    int? moodRating,  // 1-5
    @Default([]) List<WorkoutSetModel> sets,
  }) = _WorkoutSessionModel;

  factory WorkoutSessionModel.fromJson(Map<String, dynamic> json) => 
    _$WorkoutSessionModelFromJson(json);
}

enum WorkoutMode { ai, free }
3.4 WorkoutSet Model
Copy@freezed
class WorkoutSetModel with _$WorkoutSetModel {
  const factory WorkoutSetModel({
    required String id,
    required String sessionId,
    required String exerciseId,
    required int setNumber,
    @Default(SetType.working) SetType setType,
    double? weight,
    int? reps,
    double? targetWeight,
    int? targetReps,
    double? rpe,  // 1-10
    int? restSeconds,
    @Default(false) bool isPr,
    String? notes,
    required DateTime completedAt,
  }) = _WorkoutSetModel;

  factory WorkoutSetModel.fromJson(Map<String, dynamic> json) => 
    _$WorkoutSetModelFromJson(json);
}

enum SetType {
  warmup,
  working,
  drop,
  failure,
  superset,
}
Copy
4. Provider 구조
4.1 Auth Provider
Copy// lib/domain/providers/auth_provider.dart

@riverpod
class Auth extends _$Auth {
  @override
  FutureOr<UserModel?> build() async {
    final supabase = ref.watch(supabaseServiceProvider);
    final session = supabase.client.auth.currentSession;
    
    if (session == null) return null;
    
    return await ref.watch(userRepositoryProvider)
        .getUserById(session.user.id);
  }

  Future<void> signInWithEmail(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final supabase = ref.read(supabaseServiceProvider);
      final response = await supabase.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return await ref.read(userRepositoryProvider)
          .getUserById(response.user!.id);
    });
  }

  Future<void> signOut() async {
    await ref.read(supabaseServiceProvider).client.auth.signOut();
    state = const AsyncData(null);
  }
}
Copy
4.2 Workout Provider
Copy// lib/domain/providers/workout_provider.dart

@riverpod
class ActiveWorkout extends _$ActiveWorkout {
  @override
  WorkoutSessionModel? build() => null;

  Future<void> startWorkout({
    String? routineId,
    required WorkoutMode mode,
  }) async {
    final user = ref.read(authProvider).valueOrNull;
    if (user == null) throw Exception('로그인이 필요합니다');

    final session = WorkoutSessionModel(
      id: const Uuid().v4(),
      userId: user.id,
      routineId: routineId,
      mode: mode,
      startedAt: DateTime.now(),
    );

    // Supabase에 세션 생성
    await ref.read(workoutRepositoryProvider).createSession(session);
    
    state = session;
  }

  Future<void> addSet(WorkoutSetModel set) async {
    if (state == null) return;
    
    // 1RM 업데이트 체크
    await _checkAndUpdatePR(set);
    
    // Supabase에 세트 저장
    await ref.read(workoutRepositoryProvider).addSet(set);
    
    // 로컬 상태 업데이트
    state = state!.copyWith(
      sets: [...state!.sets, set],
      totalSets: (state!.totalSets ?? 0) + 1,
      totalVolume: (state!.totalVolume ?? 0) + 
          (set.weight ?? 0) * (set.reps ?? 0),
    );
  }

  Future<void> finishWorkout() async {
    if (state == null) return;
    
    final finishedSession = state!.copyWith(
      finishedAt: DateTime.now(),
      totalDurationSeconds: DateTime.now()
          .difference(state!.startedAt)
          .inSeconds,
    );

    await ref.read(workoutRepositoryProvider)
        .updateSession(finishedSession);
    
    state = null;
  }

  Future<void> cancelWorkout() async {
    if (state == null) return;
    
    final cancelledSession = state!.copyWith(
      isCancelled: true,
      finishedAt: DateTime.now(),
    );

    await ref.read(workoutRepositoryProvider)
        .updateSession(cancelledSession);
    
    state = null;
  }
}
Copy
4.3 Timer Provider
Copy// lib/domain/providers/timer_provider.dart

@riverpod
class RestTimer extends _$RestTimer {
  Timer? _timer;
  
  @override
  int build() => 0;  // 남은 초

  void start(int seconds) {
    _timer?.cancel();
    state = seconds;
    
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state > 0) {
        state = state - 1;
      } else {
        _timer?.cancel();
        // 타이머 완료 알림
        ref.read(hapticProvider).heavyImpact();
      }
    });
  }

  void pause() {
    _timer?.cancel();
  }

  void resume() {
    if (state > 0) {
      start(state);
    }
  }

  void skip() {
    _timer?.cancel();
    state = 0;
  }

  void addTime(int seconds) {
    state = state + seconds;
  }
}
Copy
5. Supabase 설정
5.1 초기화
Copy// lib/data/services/supabase_service.dart

@riverpod
SupabaseService supabaseService(SupabaseServiceRef ref) {
  return SupabaseService();
}

class SupabaseService {
  late final SupabaseClient client;

  Future<void> initialize() async {
    await Supabase.initialize(
      url: const String.fromEnvironment('SUPABASE_URL'),
      anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
    );
    client = Supabase.instance.client;
  }
}
5.2 main.dart
Copy// lib/main.dart

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Supabase 초기화
  await Supabase.initialize(
    url: const String.fromEnvironment('SUPABASE_URL'),
    anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
  );
  
  // Hive 초기화 (로컬 캐싱)
  await Hive.initFlutter();
  await Hive.openBox('settings');
  await Hive.openBox('cache');
  
  runApp(
    const ProviderScope(
      child: V2logApp(),
    ),
  );
}
6. 핵심 위젯 구현
6.1 V2Button
Copy// lib/presentation/widgets/atoms/v2_button.dart

class V2Button extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool fullWidth;
  final V2ButtonStyle style;
  final bool isLoading;

  const V2Button({
    required this.text,
    this.icon,
    this.onPressed,
    this.fullWidth = false,
    this.style = V2ButtonStyle.primary,
    this.isLoading = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: style.backgroundColor,
          foregroundColor: style.foregroundColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: AppTypography.labelLarge.copyWith(
                      color: style.foregroundColor,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

enum V2ButtonStyle {
  primary(AppColors.primary500, Colors.white),
  secondary(AppColors.secondary500, Colors.white),
  outline(Colors.transparent, AppColors.primary500),
  ghost(Colors.transparent, AppColors.darkTextSecondary);

  final Color backgroundColor;
  final Color foregroundColor;

  const V2ButtonStyle(this.backgroundColor, this.foregroundColor);
}
Copy
6.2 SetRow (빠른 기록 행)
Copy// lib/presentation/widgets/molecules/set_row.dart

class SetRow extends ConsumerWidget {
  final int setNumber;
  final SetType setType;
  final double? weight;
  final int? reps;
  final bool isCompleted;
  final bool isCurrent;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const SetRow({
    required this.setNumber,
    required this.setType,
    this.weight,
    this.reps,
    this.isCompleted = false,
    this.isCurrent = false,
    this.onTap,
    this.onLongPress,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isCurrent 
              ? AppColors.primary500.withOpacity(0.1)
              : Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: AppColors.darkBorder,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            // 세트 번호
            SizedBox(
              width: 40,
              child: Text(
                '$setNumber',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.darkTextSecondary,
                ),
              ),
            ),
            
            // 세트 타입 뱃지
            SetTypeBadge(type: setType),
            const SizedBox(width: 12),
            
            // 무게
            Expanded(
              child: Text(
                weight != null ? '${weight}kg' : '-',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.darkText,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            // 횟수
            Expanded(
              child: Text(
                reps != null ? '$reps회' : '-',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.darkText,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            // 완료 상태
            SizedBox(
              width: 40,
              child: isCompleted
                  ? const Icon(
                      Icons.check_circle,
                      color: AppColors.success,
                      size: 24,
                    )
                  : Icon(
                      Icons.radio_button_unchecked,
                      color: AppColors.darkTextTertiary,
                      size: 24,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
Copy
6.3 RestTimer
Copy// lib/presentation/widgets/molecules/rest_timer.dart

class RestTimer extends ConsumerWidget {
  const RestTimer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seconds = ref.watch(restTimerProvider);
    final isRunning = seconds > 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // 타이머 표시
          Text(
            _formatTime(seconds),
            style: AppTypography.timer.copyWith(
              color: isRunning 
                  ? AppColors.primary500 
                  : AppColors.darkTextSecondary,
            ),
          ),
          const SizedBox(height: 16),
          
          // 컨트롤 버튼들
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _TimerButton(
                icon: Icons.remove,
                label: '-15초',
                onTap: () {
                  HapticFeedback.lightImpact();
                  ref.read(restTimerProvider.notifier).addTime(-15);
                },
              ),
              const SizedBox(width: 16),
              
              // 시작/일시정지
              _TimerButton(
                icon: isRunning ? Icons.pause : Icons.play_arrow,
                label: isRunning ? '일시정지' : '시작',
                isPrimary: true,
                onTap: () {
                  HapticFeedback.mediumImpact();
                  if (isRunning) {
                    ref.read(restTimerProvider.notifier).pause();
                  } else {
                    ref.read(restTimerProvider.notifier).start(90);
                  }
                },
              ),
              const SizedBox(width: 16),
              
              _TimerButton(
                icon: Icons.add,
                label: '+15초',
                onTap: () {
                  HapticFeedback.lightImpact();
                  ref.read(restTimerProvider.notifier).addTime(15);
                },
              ),
              const SizedBox(width: 16),
              
              _TimerButton(
                icon: Icons.skip_next,
                label: '건너뛰기',
                onTap: () {
                  HapticFeedback.lightImpact();
                  ref.read(restTimerProvider.notifier).skip();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}
Copy
7. 에러 처리 패턴
Copy// 모든 비동기 작업에 적용

// Repository에서
Future<Result<UserModel, AppError>> getUserById(String id) async {
  try {
    final response = await supabase
        .from('users')
        .select()
        .eq('id', id)
        .single();
    return Result.success(UserModel.fromJson(response));
  } on PostgrestException catch (e) {
    return Result.failure(AppError.database(e.message));
  } catch (e) {
    return Result.failure(AppError.unknown(e.toString()));
  }
}

// Provider에서
@riverpod
class User extends _$User {
  @override
  FutureOr<UserModel?> build() async {
    return await _fetchUser();
  }

  Future<UserModel?> _fetchUser() async {
    final result = await ref.read(userRepositoryProvider).getCurrentUser();
    return result.when(
      success: (user) => user,
      failure: (error) {
        // 에러 로깅
        ref.read(loggerProvider).error(error);
        return null;
      },
    );
  }
}

// UI에서
class ProfileScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);
    
    return userAsync.when(
      data: (user) => user != null 
          ? ProfileContent(user: user)
          : const LoginPrompt(),
      loading: () => const LoadingIndicator(),
      error: (error, stack) => ErrorView(
        message: error.toString(),
        onRetry: () => ref.invalidate(userProvider),
      ),
    );
  }
}
Copy
8. 테스트 가이드
Widget 테스트
Copy// test/presentation/widgets/set_row_test.dart

void main() {
  testWidgets('SetRow displays correctly', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: SetRow(
              setNumber: 1,
              setType: SetType.working,
              weight: 60,
              reps: 10,
              isCompleted: true,
            ),
          ),
        ),
      ),
    );

    expect(find.text('1'), findsOneWidget);
    expect(find.text('60kg'), findsOneWidget);
    expect(find.text('10회'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
  });
}
Provider 테스트
Copy// test/domain/providers/workout_provider_test.dart

void main() {
  test('startWorkout creates a new session', () async {
    final container = ProviderContainer(
      overrides: [
        workoutRepositoryProvider.overrideWithValue(MockWorkoutRepository()),
      ],
    );

    await container.read(activeWorkoutProvider.notifier).startWorkout(
      mode: WorkoutMode.free,
    );

    final session = container.read(activeWorkoutProvider);
    expect(session, isNotNull);
    expect(session!.mode, WorkoutMode.free);
  });
}
9. 성능 최적화
9.1 ListView 최적화
Copy// 항상 ListView.builder 사용
ListView.builder(
  itemCount: exercises.length,
  itemBuilder: (context, index) {
    return ExerciseCard(exercise: exercises[index]);
  },
)

// const 생성자 활용
const SizedBox(height: 16),
const Divider(),
9.2 이미지 캐싱
Copy// cached_network_image 사용
CachedNetworkImage(
  imageUrl: exercise.thumbnailUrl ?? '',
  placeholder: (context, url) => const ShimmerBox(),
  errorWidget: (context, url, error) => const Icon(Icons.error),
  memCacheWidth: 200,  // 메모리 최적화
)
9.3 Provider 최적화
Copy// select로 필요한 부분만 구독
final userName = ref.watch(
  userProvider.select((user) => user.valueOrNull?.nickname),
);

// keepAlive로 불필요한 재생성 방지
@Riverpod(keepAlive: true)
class ExerciseLibrary extends _$ExerciseLibrary {
  // ...
}
10. 배포 체크리스트
Android
 android/app/build.gradle - applicationId 설정
 android/app/src/main/AndroidManifest.xml - 권한 설정
 서명 키 생성 및 설정
 ProGuard 규칙 추가
iOS
 ios/Runner/Info.plist - 권한 설명 추가
 Bundle Identifier 설정
 Capabilities 설정 (HealthKit 등)
 App Store Connect 설정
환경 변수
Copy# .env 파일 (gitignore에 추가)
SUPABASE_URL=https://xxx.supabase.co
SUPABASE_ANON_KEY=xxx
OPENAI_API_KEY=xxx
Copy# 빌드 시 환경 변수 전달
flutter run --dart-define=SUPABASE_URL=xxx --dart-define=SUPABASE_ANON_KEY=xxx