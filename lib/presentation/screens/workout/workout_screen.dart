import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/haptic_feedback.dart';
import '../../../data/dummy/dummy_exercises.dart';
import '../../../data/models/exercise_model.dart';
import '../../../data/models/preset_routine_model.dart';
import '../../../data/models/workout_session_model.dart';
import '../../../data/models/workout_set_model.dart';
import '../../../domain/providers/exercise_provider.dart';
import '../../../domain/providers/timer_provider.dart';
import '../../../domain/providers/user_provider.dart';
import '../../../domain/providers/workout_provider.dart';
import '../../widgets/atoms/v2_button.dart';
import '../../widgets/molecules/quick_input_control.dart';
import '../../widgets/molecules/rest_timer.dart';
import '../../widgets/molecules/set_row.dart';
import 'workout_summary_screen.dart';

/// 운동 진행 화면 (빠른 기록 UI)
class WorkoutScreen extends ConsumerStatefulWidget {
  final String? sessionId;

  const WorkoutScreen({
    this.sessionId,
    super.key,
  });

  @override
  ConsumerState<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends ConsumerState<WorkoutScreen> {
  // 현재 입력 중인 값
  double _currentWeight = 60.0;
  int _currentReps = 10;
  SetType _currentSetType = SetType.working;

  // 현재 운동 (자유 모드용)
  ExerciseModel? _freeExercise;

  // 운동별 메모 (운동 ID: 메모)
  final Map<String, String> _exerciseNotes = {};

  // _isFinishing 제거: Provider.isFinishing을 SSOT로 사용

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final session = ref.read(activeWorkoutProvider);
      if (session != null) {
        // 세션 메모 로드 (운동별 메모를 위해 session.notes를 사용하지 않음)
        // 운동별 메모는 _exerciseNotes Map으로 관리

        // 세션 타이머 시작
        ref.read(workoutTimerProvider.notifier).startFrom(session.startedAt);

        // 프리셋 모드면 루틴 운동 로드
        if (session.mode == WorkoutMode.preset && session.routineId != null) {
          ref.read(routineExercisesProvider.notifier).loadFromRoutine(
            session.routineId!,
            dayNumber: 1,
          );
        } else {
          // 자유 모드면 기본 운동 설정
          _freeExercise = DummyExercises.exercises.first;
        }
      }
    });
  }

  /// 현재 운동 가져오기
  ExerciseModel? _getCurrentExercise(WorkoutSessionModel session) {
    if (session.mode == WorkoutMode.preset) {
      final routineExercise = ref.watch(currentRoutineExerciseProvider);
      return routineExercise?.exercise;
    }
    return _freeExercise;
  }

  /// 현재 운동 ID 가져오기
  String? _getCurrentExerciseId(WorkoutSessionModel session) {
    if (session.mode == WorkoutMode.preset) {
      final routineExercise = ref.watch(currentRoutineExerciseProvider);
      return routineExercise?.exercise?.id ?? routineExercise?.exerciseId;
    }
    return _freeExercise?.id;
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(activeWorkoutProvider);
    final workoutTimer = ref.watch(workoutTimerProvider);
    final routineExercises = ref.watch(routineExercisesProvider);
    final currentExerciseIndex = ref.watch(currentExerciseIndexProvider);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (session == null) {
      // 진행 중인 운동이 없으면 빈 로딩 UI 표시 (요약 화면으로 이동 후 정리됨)
      return Scaffold(
        backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary500),
        ),
      );
    }

    final currentExercise = _getCurrentExercise(session);
    final currentExerciseId = _getCurrentExerciseId(session);
    final currentSets = currentExerciseId != null
        ? ref.watch(exerciseSetsProvider(currentExerciseId))
        : <WorkoutSetModel>[];

    // 프리셋 모드에서 루틴 운동 로딩 중
    if (session.mode == WorkoutMode.preset && routineExercises.isEmpty) {
      return Scaffold(
        backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
        appBar: _buildAppBar(context, session, workoutTimer, isDark),
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.primary500),
        ),
      );
    }

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: _buildAppBar(context, session, workoutTimer, isDark),
      body: Column(
        children: [
          // 상단 고정 영역 (스크롤 안 됨)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 운동 진행 상태 표시 (프리셋 모드)
              if (session.mode == WorkoutMode.preset && routineExercises.isNotEmpty)
                _buildExerciseProgress(routineExercises, currentExerciseIndex, isDark),

              // 운동 가이드 영역
              _buildExerciseHeader(session, currentExercise, isDark),
            ],
          ),

          // 세트 기록 리스트 (스크롤 가능)
          Expanded(
            child: _buildSetList(currentSets, isDark),
          ),

          // 하단 고정 영역 (스크롤 안 됨)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 휴식 타이머 (컴팩트)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: RestTimerWidget(expanded: false),
              ),

              // 빠른 입력 컨트롤
              QuickInputControl(
                weight: _currentWeight,
                reps: _currentReps,
                previousWeight: currentSets.isNotEmpty ? currentSets.last.weight : null,
                previousReps: currentSets.isNotEmpty ? currentSets.last.reps : null,
                onWeightChanged: (value) => setState(() => _currentWeight = value),
                onRepsChanged: (value) => setState(() => _currentReps = value),
              ),

              // 세트 완료 버튼 + 다음 운동 버튼
              _buildBottomButtons(session, routineExercises, currentExerciseIndex, currentSets, isDark),
            ],
          ),
        ],
      ),
    );
  }

  /// 운동 진행 상태 표시 (1/6 운동)
  Widget _buildExerciseProgress(
    List<PresetRoutineExerciseModel> exercises,
    int currentIndex,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      color: isDark ? AppColors.darkCard : AppColors.lightCard,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '운동 ${currentIndex + 1}/${exercises.length}',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primary500,
                ),
              ),
              Text(
                '${((currentIndex + 1) / exercises.length * 100).toInt()}%',
                style: AppTypography.labelMedium.copyWith(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          // 진행바
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: (currentIndex + 1) / exercises.length,
              backgroundColor: isDark ? AppColors.darkCardElevated : AppColors.lightCardElevated,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary500),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    dynamic session,
    int workoutTimer,
    bool isDark,
  ) {
    return AppBar(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => _showCancelDialog(context),
      ),
      title: Column(
        children: [
          Text(
            session.mode.label,
            style: AppTypography.labelMedium.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
          Text(
            Formatters.timerLong(workoutTimer),
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.primary500,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => _showFinishDialog(context),
          child: Text(
            '완료',
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.success,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExerciseHeader(WorkoutSessionModel session, ExerciseModel? exercise, bool isDark) {
    if (exercise == null) {
      // 프리셋 모드에서 운동 정보 로딩 중
      final routineExercise = ref.watch(currentRoutineExerciseProvider);
      if (routineExercise != null) {
        return Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.lightCard,
            border: Border(
              bottom: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 1),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.primary500.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: const Icon(
                  Icons.fitness_center,
                  color: AppColors.primary500,
                  size: 32,
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      routineExercise.exercise?.name ?? '운동 ${routineExercise.orderIndex + 1}',
                      style: AppTypography.h4.copyWith(color: isDark ? AppColors.darkText : AppColors.lightText),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      routineExercise.setsRepsText,
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
      return const SizedBox.shrink();
    }

    return _ExerciseGuideCard(
      exercise: exercise,
      session: session,
      notes: _getCurrentExerciseNotes(),
      onEditNotes: _showMemoDialog,
      onChangeExercise: session.mode == WorkoutMode.free ? _showExerciseSelector : null,
      routineExercise: session.mode == WorkoutMode.preset
          ? ref.watch(currentRoutineExerciseProvider)
          : null,
      isDark: isDark,
    );
  }

  Widget _buildSetList(List<WorkoutSetModel> sets, bool isDark) {
    return Column(
      children: [
        // 헤더
        const SetRowHeader(),

        // 세트 리스트
        Expanded(
          child: sets.isEmpty
              ? _buildEmptySetMessage(isDark)
              : ListView.builder(
                  itemCount: sets.length + 1, // +1 for current set
                  itemBuilder: (context, index) {
                    if (index < sets.length) {
                      final set = sets[index];
                      // 세션 내 최고 무게 세트에만 PR 표시
                      final isSessionPr = _isSessionMaxWeightSet(set, sets);
                      return SetRow(
                        setNumber: set.setNumber,
                        setType: set.setType,
                        weight: set.weight,
                        reps: set.reps,
                        isCompleted: true,
                        isPr: isSessionPr,
                        onLongPress: () => _showDeleteConfirmDialog(set),
                      );
                    }
                    // 현재 입력 중인 세트
                    return SetRow(
                      setNumber: sets.length + 1,
                      setType: _currentSetType,
                      weight: _currentWeight,
                      reps: _currentReps,
                      isCurrent: true,
                      onTap: () => _showSetTypeSelector(),
                    );
                  },
                ),
        ),
      ],
    );
  }

  /// 세션 내 최고 무게 세트인지 확인 (같은 무게면 첫 번째만 PR)
  bool _isSessionMaxWeightSet(WorkoutSetModel set, List<WorkoutSetModel> allSets) {
    // 같은 운동의 세트만 필터링
    final exerciseSets = allSets.where((s) => s.exerciseId == set.exerciseId).toList();
    if (exerciseSets.isEmpty) return false;

    // setNumber 순으로 정렬
    exerciseSets.sort((a, b) => a.setNumber.compareTo(b.setNumber));

    // 최고 무게 찾기
    double maxWeight = exerciseSets
        .map((s) => s.weight)
        .where((w) => w != null)
        .fold<double>(0, (max, w) => w! > max ? w : max);

    if (maxWeight == 0) return false;

    // 최고 무게를 가진 첫 번째 세트인지 확인
    for (final s in exerciseSets) {
      if (s.weight == maxWeight) {
        return s.id == set.id; // 첫 번째 최고 무게 세트만 true
      }
    }

    return false;
  }

  Widget _buildEmptySetMessage(bool isDark) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 현재 세트 (입력 대기)
          SetRow(
            setNumber: 1,
            setType: _currentSetType,
            weight: _currentWeight,
            reps: _currentReps,
            isCurrent: true,
            onTap: () => _showSetTypeSelector(),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Text(
            '첫 세트를 완료해보세요!',
            style: AppTypography.bodyMedium.copyWith(
              color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons(
    WorkoutSessionModel session,
    List<PresetRoutineExerciseModel> routineExercises,
    int currentExerciseIndex,
    List<WorkoutSetModel> currentSets,
    bool isDark,
  ) {
    final isPresetMode = session.mode == WorkoutMode.preset;
    final isLastExercise = currentExerciseIndex >= routineExercises.length - 1;
    final routineExercise = isPresetMode ? ref.watch(currentRoutineExerciseProvider) : null;
    final targetSets = routineExercise?.targetSets ?? 3;
    final completedSets = currentSets.length;
    final isTargetReached = completedSets >= targetSets;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        border: Border(
          top: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 1),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 세트 완료 버튼
            V2Button.primary(
              text: isPresetMode ? '완료 $completedSets/$targetSets' : '세트 완료',
              icon: Icons.check_circle,
              onPressed: _completeSet,
              fullWidth: true,
            ),

            // 프리셋 모드에서 다음 운동 버튼
            if (isPresetMode && routineExercises.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  // 이전 운동 버튼
                  if (currentExerciseIndex > 0)
                    Expanded(
                      child: V2Button.outline(
                        text: '이전',
                        icon: Icons.arrow_back,
                        onPressed: () {
                          ref.read(currentExerciseIndexProvider.notifier).previous();
                        },
                      ),
                    ),
                  if (currentExerciseIndex > 0) const SizedBox(width: AppSpacing.sm),

                  // 다음 운동 버튼
                  Expanded(
                    child: isLastExercise
                        ? V2Button.secondary(
                            text: '완료',
                            icon: Icons.flag,
                            onPressed: () => _showFinishDialog(context),
                          )
                        : V2Button.secondary(
                            text: isTargetReached ? '다음' : '다음으로',
                            icon: Icons.arrow_forward,
                            onPressed: () {
                              ref.read(currentExerciseIndexProvider.notifier).next();
                            },
                          ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _completeSet() async {
    final session = ref.read(activeWorkoutProvider);
    if (session == null) return;

    final exerciseId = _getCurrentExerciseId(session);
    if (exerciseId == null) return;

    AppHaptics.heavyImpact();

    try {
      await ref.read(activeWorkoutProvider.notifier).addSet(
            exerciseId: exerciseId,
            weight: _currentWeight,
            reps: _currentReps,
            setType: _currentSetType,
          );

      // 휴식 타이머 자동 시작
      ref.read(restTimerProvider.notifier).start();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  void _showSetTypeSelector() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXl),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '세트 타입',
                  style: AppTypography.h4.copyWith(
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                ...SetType.values.map((type) {
                  final isSelected = type == _currentSetType;
                  return ListTile(
                    leading: SetTypeBadge(type: type),
                    title: Text(
                      type.label,
                      style: AppTypography.bodyLarge.copyWith(
                        color: isDark ? AppColors.darkText : AppColors.lightText,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check, color: AppColors.primary500)
                        : null,
                    onTap: () {
                      setState(() => _currentSetType = type);
                      Navigator.pop(context);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 세트 삭제 확인 다이얼로그
  void _showDeleteConfirmDialog(WorkoutSetModel set) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
        title: Text(
          '세트 삭제',
          style: AppTypography.h4.copyWith(color: isDark ? AppColors.darkText : AppColors.lightText),
        ),
        content: Text(
          '${set.setNumber}세트를 삭제하시겠습니까?',
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              '취소',
              style: AppTypography.labelLarge.copyWith(
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              AppHaptics.mediumImpact();
              await ref.read(activeWorkoutProvider.notifier).deleteSet(set.id);
            },
            child: Text(
              '삭제',
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showExerciseSelector() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXl),
        ),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return _ExerciseSelectorSheet(
              scrollController: scrollController,
              onSelect: (exercise) {
                setState(() {
                  _freeExercise = exercise;
                });
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  void _showCancelDialog(BuildContext context) {
    // WorkoutScreen의 GoRouter를 미리 캡처 (다이얼로그 pop 후 stale context 방지)
    final router = GoRouter.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
        title: Text(
          '운동 취소',
          style: AppTypography.h4.copyWith(color: isDark ? AppColors.darkText : AppColors.lightText),
        ),
        content: Text(
          '진행 중인 운동을 취소하시겠습니까?\n기록된 세트는 저장되지 않습니다.',
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('계속하기'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await ref.read(activeWorkoutProvider.notifier).cancelWorkout();
              ref.read(workoutTimerProvider.notifier).stop();

              // 루틴 운동 및 인덱스 초기화
              ref.read(routineExercisesProvider.notifier).clear();
              ref.read(currentExerciseIndexProvider.notifier).reset();

              if (mounted) router.go('/home');
            },
            child: Text(
              '취소하기',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  /// 현재 운동의 메모 가져오기
  String _getCurrentExerciseNotes() {
    final session = ref.read(activeWorkoutProvider);
    if (session == null) return '';
    final exerciseId = _getCurrentExerciseId(session);
    if (exerciseId == null) return '';
    return _exerciseNotes[exerciseId] ?? '';
  }

  /// 현재 운동의 메모 저장
  void _setCurrentExerciseNotes(String notes) {
    final session = ref.read(activeWorkoutProvider);
    if (session == null) return;
    final exerciseId = _getCurrentExerciseId(session);
    if (exerciseId == null) return;
    setState(() {
      if (notes.isEmpty) {
        _exerciseNotes.remove(exerciseId);
      } else {
        _exerciseNotes[exerciseId] = notes;
      }
    });
  }

  /// 메모 입력 다이얼로그
  Future<void> _showMemoDialog() async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentNotes = _getCurrentExerciseNotes();
    final controller = TextEditingController(text: currentNotes);
    final hasMemo = currentNotes.isNotEmpty;

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
        title: Row(
          children: [
            Icon(
              Icons.edit_note,
              color: hasMemo ? AppColors.warning : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
              size: 24,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              '운동 메모',
              style: AppTypography.h4.copyWith(color: isDark ? AppColors.darkText : AppColors.lightText),
            ),
          ],
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: 200,
          maxLines: 4,
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.darkText : AppColors.lightText,
          ),
          decoration: InputDecoration(
            hintText: '예: 어깨 통증 발생',
            hintStyle: AppTypography.bodyMedium.copyWith(
              color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
            ),
            filled: true,
            fillColor: isDark ? AppColors.darkCardElevated : AppColors.lightCardElevated,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              borderSide: BorderSide.none,
            ),
            counterStyle: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              '취소',
              style: AppTypography.labelLarge.copyWith(
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              final newNotes = controller.text.trim();
              _setCurrentExerciseNotes(newNotes);
              if (mounted) Navigator.pop(context);
            },
            child: Text(
              '저장',
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.primary500,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFinishDialog(BuildContext context) {
    final session = ref.read(activeWorkoutProvider);
    if (session == null || session.sets.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('최소 1개의 세트를 완료해주세요')),
      );
      return;
    }

    // Provider SSOT 상태 확인 (추가 방어)
    final isFinishing = ref.read(activeWorkoutProvider.notifier).isFinishing;
    if (isFinishing) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('운동 완료 처리 중입니다...')),
      );
      return;
    }

    // WorkoutScreen의 Navigator를 미리 캡처 (다이얼로그 pop 후 stale context 방지)
    final screenNavigator = Navigator.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return Consumer(
          builder: (dialogContext, ref, child) {
            // Provider의 finishing 상태 구독
            final finishing = ref.read(activeWorkoutProvider.notifier).isFinishing;

            return AlertDialog(
              backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
              title: Text(
                '운동 완료',
                style: AppTypography.h4.copyWith(color: isDark ? AppColors.darkText : AppColors.lightText),
              ),
              content: Text(
                '운동을 완료하시겠습니까?\n총 ${session.sets.length}세트, ${Formatters.volume(session.calculatedVolume)} 볼륨',
                style: AppTypography.bodyMedium.copyWith(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: finishing ? null : () => Navigator.pop(dialogContext),
                  child: const Text('계속하기'),
                ),
                TextButton(
                  onPressed: finishing
                      ? null
                      : () async {
                          print('@@@ UI COMPLETE BUTTON PRESSED @@@');

                          // 다이얼로그 pop 전에 필요한 notifier 참조 캡처
                          final workoutNotifier = ref.read(activeWorkoutProvider.notifier);
                          final timerNotifier = ref.read(workoutTimerProvider.notifier);
                          final routineNotifier = ref.read(routineExercisesProvider.notifier);
                          final indexNotifier = ref.read(currentExerciseIndexProvider.notifier);

                          Navigator.pop(dialogContext);

                          try {
                            // 운동별 메모를 "exerciseId: 메모 / exerciseId: 메모" 형식으로 변환
                            final notesList = _exerciseNotes.entries.map((e) {
                              return '${e.key}: ${e.value}';
                            }).toList();
                            final formattedNotes =
                                notesList.isEmpty ? null : notesList.join(' / ');

                            // finishWorkout 내부에서 lock 획득/해제 처리됨
                            final finishedSession = await workoutNotifier
                                .finishWorkout(notes: formattedNotes);

                            // null 반환 = 중복 호출 차단됨
                            if (finishedSession == null) {
                              if (mounted) {
                                ScaffoldMessenger.of(this.context).showSnackBar(
                                  const SnackBar(content: Text('이미 처리 중입니다')),
                                );
                              }
                              return;
                            }

                            timerNotifier.stop();

                            // 루틴 운동 및 인덱스 초기화
                            routineNotifier.clear();
                            indexNotifier.reset();

                            // 기록/통계 Provider 새로고침 (WorkoutScreen의 ref 사용)
                            if (mounted) {
                              this.ref.invalidate(workoutHistoryProvider);
                              this.ref.invalidate(recentWorkoutsProvider);
                              this.ref.invalidate(weeklyStatsProvider);
                              this.ref.invalidate(userStatsProvider);
                            }

                            // 요약 화면으로 먼저 이동 (state 정리 전에 캡처된 navigator 사용)
                            if (mounted) {
                              screenNavigator.pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => WorkoutSummaryScreen(
                                    session: finishedSession,
                                  ),
                                ),
                              );
                            }

                            // 이동 후 활성 운동 정리 (WorkoutScreen은 이미 대체됨)
                            await workoutNotifier.clearActiveWorkout();
                          } catch (e) {
                            print('=== _showFinishDialog 예외: $e ===');
                            if (mounted) {
                              ScaffoldMessenger.of(this.context).showSnackBar(
                                SnackBar(content: Text('운동 완료 실패: $e')),
                              );
                            }
                          }
                        },
                  child: finishing
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.success,
                          ),
                        )
                      : Text(
                          '완료하기',
                          style: TextStyle(color: AppColors.success),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

/// 운동 선택 시트 (Supabase 검색 연동)
class _ExerciseSelectorSheet extends ConsumerStatefulWidget {
  final ScrollController scrollController;
  final Function(ExerciseModel exercise) onSelect;

  const _ExerciseSelectorSheet({
    required this.scrollController,
    required this.onSelect,
  });

  @override
  ConsumerState<_ExerciseSelectorSheet> createState() => _ExerciseSelectorSheetState();
}

class _ExerciseSelectorSheetState extends ConsumerState<_ExerciseSelectorSheet> {
  MuscleGroup? _selectedMuscle;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 검색어 변경 시 Provider 업데이트
    _searchController.addListener(() {
      ref.read(exerciseFilterStateProvider.notifier).setSearchQuery(
        _searchController.text.isEmpty ? null : _searchController.text,
      );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _updateMuscleFilter(MuscleGroup? muscle) {
    setState(() => _selectedMuscle = muscle);
    ref.read(exerciseFilterStateProvider.notifier).setMuscle(muscle);
  }

  @override
  Widget build(BuildContext context) {
    final exercisesAsync = ref.watch(filteredExercisesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // 헤더
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 1),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    '운동 선택',
                    style: AppTypography.h4.copyWith(
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      // 필터 초기화
                      ref.read(exerciseFilterStateProvider.notifier).clearFilters();
                      Navigator.pop(context);
                    },
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              // 검색바
              TextField(
                controller: _searchController,
                style: AppTypography.bodyMedium.copyWith(
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                ),
                decoration: InputDecoration(
                  hintText: '운동 검색 (예: 벤치프레스, 스쿼트)',
                  hintStyle: AppTypography.bodyMedium.copyWith(
                    color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                          },
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        )
                      : null,
                  filled: true,
                  fillColor: isDark ? AppColors.darkCardElevated : AppColors.lightCardElevated,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                ),
              ),
            ],
          ),
        ),

        // 근육 필터
        SizedBox(
          height: 48,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            children: [
              _FilterChip(
                label: '전체',
                isSelected: _selectedMuscle == null,
                onTap: () => _updateMuscleFilter(null),
              ),
              // 주요 근육 그룹 + 하체
              _FilterChip(
                label: MuscleGroup.chest.label,
                isSelected: _selectedMuscle == MuscleGroup.chest,
                onTap: () => _updateMuscleFilter(MuscleGroup.chest),
                color: MuscleGroup.chest.color,
              ),
              _FilterChip(
                label: MuscleGroup.back.label,
                isSelected: _selectedMuscle == MuscleGroup.back,
                onTap: () => _updateMuscleFilter(MuscleGroup.back),
                color: MuscleGroup.back.color,
              ),
              _FilterChip(
                label: MuscleGroup.shoulders.label,
                isSelected: _selectedMuscle == MuscleGroup.shoulders,
                onTap: () => _updateMuscleFilter(MuscleGroup.shoulders),
                color: MuscleGroup.shoulders.color,
              ),
              _FilterChip(
                label: MuscleGroup.legs.label,
                isSelected: _selectedMuscle == MuscleGroup.legs,
                onTap: () => _updateMuscleFilter(MuscleGroup.legs),
                color: MuscleGroup.legs.color,
              ),
              _FilterChip(
                label: MuscleGroup.biceps.label,
                isSelected: _selectedMuscle == MuscleGroup.biceps,
                onTap: () => _updateMuscleFilter(MuscleGroup.biceps),
                color: MuscleGroup.biceps.color,
              ),
              _FilterChip(
                label: MuscleGroup.triceps.label,
                isSelected: _selectedMuscle == MuscleGroup.triceps,
                onTap: () => _updateMuscleFilter(MuscleGroup.triceps),
                color: MuscleGroup.triceps.color,
              ),
              _FilterChip(
                label: MuscleGroup.core.label,
                isSelected: _selectedMuscle == MuscleGroup.core,
                onTap: () => _updateMuscleFilter(MuscleGroup.core),
                color: MuscleGroup.core.color,
              ),
            ],
          ),
        ),

        // 운동 목록
        Expanded(
          child: exercisesAsync.when(
            data: (exercises) {
              if (exercises.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 48,
                        color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        '검색 결과가 없습니다',
                        style: AppTypography.bodyMedium.copyWith(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                controller: widget.scrollController,
                padding: const EdgeInsets.all(AppSpacing.lg),
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  final exercise = exercises[index];
                  return ListTile(
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: exercise.primaryMuscle.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      ),
                      child: Icon(
                        Icons.fitness_center,
                        color: exercise.primaryMuscle.color,
                      ),
                    ),
                    title: Text(
                      exercise.name,
                      style: AppTypography.bodyLarge.copyWith(
                        color: isDark ? AppColors.darkText : AppColors.lightText,
                      ),
                    ),
                    subtitle: Text(
                      exercise.primaryMuscle.label,
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.info_outline,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                      onPressed: () {
                        // 상세 화면으로 이동
                        context.push('/exercise/${exercise.id}');
                      },
                      tooltip: '상세 정보',
                    ),
                    onTap: () {
                      // 필터 초기화
                      ref.read(exerciseFilterStateProvider.notifier).clearFilters();
                      widget.onSelect(exercise);
                    },
                  );
                },
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.primary500),
            ),
            error: (error, _) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    '운동 목록을 불러오는데 실패했습니다',
                    style: AppTypography.bodyMedium.copyWith(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// 필터 칩
class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: FilterChip(
        label: Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: isSelected ? Colors.white : (color ?? (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
          ),
        ),
        selected: isSelected,
        onSelected: (_) => onTap(),
        backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
        selectedColor: color ?? AppColors.primary500,
        checkmarkColor: Colors.white,
        side: BorderSide(
          color: isSelected ? Colors.transparent : (color?.withValues(alpha: 0.3) ?? (isDark ? AppColors.darkBorder : AppColors.lightBorder)),
        ),
      ),
    );
  }
}

/// 운동 가이드 카드 (간결 버전)
class _ExerciseGuideCard extends StatelessWidget {
  final ExerciseModel exercise;
  final WorkoutSessionModel session;
  final String notes;
  final VoidCallback onEditNotes;
  final VoidCallback? onChangeExercise;
  final dynamic routineExercise;
  final bool isDark;

  const _ExerciseGuideCard({
    required this.exercise,
    required this.session,
    required this.notes,
    required this.onEditNotes,
    this.onChangeExercise,
    this.routineExercise,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    // 근육 태그 텍스트 생성
    final muscleTags = [
      exercise.primaryMuscle.label,
      ...exercise.secondaryMuscles.take(1).map((m) => m.label),
    ].join(' + ');

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        border: Border(
          bottom: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 1),
        ),
      ),
      child: Row(
        children: [
          // 운동 아이콘
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: exercise.primaryMuscle.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Icon(
              Icons.fitness_center,
              color: exercise.primaryMuscle.color,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),

          // 운동 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  exercise.name,
                  style: AppTypography.h4.copyWith(
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      muscleTags,
                      style: AppTypography.bodySmall.copyWith(
                        color: exercise.primaryMuscle.color,
                        fontSize: 11,
                      ),
                    ),
                    if (routineExercise != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary500.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(
                          routineExercise.setsRepsText,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.primary500,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // 메모 아이콘
          IconButton(
            icon: Icon(
              notes.isEmpty ? Icons.note_outlined : Icons.note,
              color: notes.isEmpty ? (isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary) : AppColors.warning,
            ),
            onPressed: onEditNotes,
            tooltip: notes.isEmpty ? '메모 추가' : '메모 편집',
            iconSize: 20,
            padding: const EdgeInsets.all(4),
            constraints: const BoxConstraints(),
          ),

          // 운동 변경 버튼
          if (onChangeExercise != null)
            IconButton(
              icon: const Icon(Icons.swap_horiz),
              onPressed: onChangeExercise,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              tooltip: '운동 변경',
              iconSize: 20,
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }

}
