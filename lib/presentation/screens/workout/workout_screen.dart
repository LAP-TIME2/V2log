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

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final session = ref.read(activeWorkoutProvider);
      if (session != null) {
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

    if (session == null) {
      return Scaffold(
        backgroundColor: AppColors.darkBg,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '진행 중인 운동이 없습니다',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.darkTextSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              V2Button.primary(
                text: '홈으로 돌아가기',
                onPressed: () => context.go('/home'),
              ),
            ],
          ),
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
        backgroundColor: AppColors.darkBg,
        appBar: _buildAppBar(context, session, workoutTimer),
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.primary500),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: _buildAppBar(context, session, workoutTimer),
      body: Column(
        children: [
          // 운동 진행 상태 표시 (프리셋 모드)
          if (session.mode == WorkoutMode.preset && routineExercises.isNotEmpty)
            _buildExerciseProgress(routineExercises, currentExerciseIndex),

          // 운동 가이드 영역
          _buildExerciseHeader(session, currentExercise),

          // 세트 기록 리스트
          Expanded(
            child: _buildSetList(currentSets),
          ),

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
          _buildBottomButtons(session, routineExercises, currentExerciseIndex, currentSets),
        ],
      ),
    );
  }

  /// 운동 진행 상태 표시 (1/6 운동)
  Widget _buildExerciseProgress(
    List<PresetRoutineExerciseModel> exercises,
    int currentIndex,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      color: AppColors.darkCard,
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
                  color: AppColors.darkTextSecondary,
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
              backgroundColor: AppColors.darkCardElevated,
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
  ) {
    return AppBar(
      backgroundColor: AppColors.darkBg,
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => _showCancelDialog(context),
      ),
      title: Column(
        children: [
          Text(
            session.mode.label,
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.darkTextSecondary,
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

  Widget _buildExerciseHeader(WorkoutSessionModel session, ExerciseModel? exercise) {
    if (exercise == null) {
      // 프리셋 모드에서 운동 정보 로딩 중
      final routineExercise = ref.watch(currentRoutineExerciseProvider);
      if (routineExercise != null) {
        return Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.darkCard,
            border: Border(
              bottom: BorderSide(color: AppColors.darkBorder, width: 1),
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
                      style: AppTypography.h4.copyWith(color: AppColors.darkText),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      routineExercise.setsRepsText,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.darkTextSecondary,
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
      onChangeExercise: session.mode == WorkoutMode.free ? _showExerciseSelector : null,
      routineExercise: session.mode == WorkoutMode.preset
          ? ref.watch(currentRoutineExerciseProvider)
          : null,
    );
  }

  Widget _buildTag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
      ),
      child: Text(
        label,
        style: AppTypography.labelSmall.copyWith(
          color: color,
        ),
      ),
    );
  }

  Widget _buildSetList(List<WorkoutSetModel> sets) {
    return Column(
      children: [
        // 헤더
        const SetRowHeader(),

        // 세트 리스트
        Expanded(
          child: sets.isEmpty
              ? _buildEmptySetMessage()
              : ListView.builder(
                  itemCount: sets.length + 1, // +1 for current set
                  itemBuilder: (context, index) {
                    if (index < sets.length) {
                      final set = sets[index];
                      return SetRow(
                        setNumber: set.setNumber,
                        setType: set.setType,
                        weight: set.weight,
                        reps: set.reps,
                        isCompleted: true,
                        isPr: set.isPr,
                        onLongPress: () => _showSetOptions(set),
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

  Widget _buildEmptySetMessage() {
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
              color: AppColors.darkTextTertiary,
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
  ) {
    final isPresetMode = session.mode == WorkoutMode.preset;
    final isLastExercise = currentExerciseIndex >= routineExercises.length - 1;
    final routineExercise = isPresetMode ? ref.watch(currentRoutineExerciseProvider) : null;
    final targetSets = routineExercise?.targetSets ?? 3;
    final completedSets = currentSets.length;
    final isTargetReached = completedSets >= targetSets;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        border: Border(
          top: BorderSide(color: AppColors.darkBorder, width: 1),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 세트 완료 버튼
            V2Button.primary(
              text: '세트 완료 ($completedSets${isPresetMode ? '/$targetSets' : ''})',
              icon: Icons.check_circle,
              onPressed: _completeSet,
              fullWidth: true,
            ),

            // 프리셋 모드에서 다음 운동 버튼
            if (isPresetMode && routineExercises.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  // 이전 운동 버튼
                  if (currentExerciseIndex > 0)
                    Expanded(
                      child: V2Button.outline(
                        text: '이전 운동',
                        icon: Icons.arrow_back,
                        onPressed: () {
                          ref.read(currentExerciseIndexProvider.notifier).previous();
                        },
                      ),
                    ),
                  if (currentExerciseIndex > 0) const SizedBox(width: AppSpacing.md),

                  // 다음 운동 버튼
                  Expanded(
                    child: isLastExercise
                        ? V2Button.secondary(
                            text: '운동 완료',
                            icon: Icons.flag,
                            onPressed: () => _showFinishDialog(context),
                          )
                        : V2Button.secondary(
                            text: isTargetReached ? '다음 운동' : '다음 운동으로',
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
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkCard,
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
                    color: AppColors.darkText,
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
                        color: AppColors.darkText,
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

  void _showSetOptions(WorkoutSetModel set) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXl),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit, color: AppColors.darkText),
                title: Text(
                  '수정',
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.darkText,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: 수정 다이얼로그
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: AppColors.error),
                title: Text(
                  '삭제',
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.error,
                  ),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  await ref
                      .read(activeWorkoutProvider.notifier)
                      .deleteSet(set.id);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showExerciseSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkCard,
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.darkCard,
        title: Text(
          '운동 취소',
          style: AppTypography.h4.copyWith(color: AppColors.darkText),
        ),
        content: Text(
          '진행 중인 운동을 취소하시겠습니까?\n기록된 세트는 저장되지 않습니다.',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.darkTextSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('계속하기'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(activeWorkoutProvider.notifier).cancelWorkout();
              ref.read(workoutTimerProvider.notifier).stop();

              // 루틴 운동 및 인덱스 초기화
              ref.read(routineExercisesProvider.notifier).clear();
              ref.read(currentExerciseIndexProvider.notifier).reset();

              if (mounted) context.go('/home');
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

  void _showFinishDialog(BuildContext context) {
    final session = ref.read(activeWorkoutProvider);
    if (session == null || session.sets.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('최소 1개의 세트를 완료해주세요')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.darkCard,
        title: Text(
          '운동 완료',
          style: AppTypography.h4.copyWith(color: AppColors.darkText),
        ),
        content: Text(
          '운동을 완료하시겠습니까?\n총 ${session.sets.length}세트, ${Formatters.volume(session.calculatedVolume)} 볼륨',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.darkTextSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('계속하기'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final finishedSession = await ref
                  .read(activeWorkoutProvider.notifier)
                  .finishWorkout();
              ref.read(workoutTimerProvider.notifier).stop();

              // 루틴 운동 및 인덱스 초기화
              ref.read(routineExercisesProvider.notifier).clear();
              ref.read(currentExerciseIndexProvider.notifier).reset();

              // 기록/통계 Provider 새로고침 (Supabase에서 다시 로드)
              ref.invalidate(workoutHistoryProvider);
              ref.invalidate(recentWorkoutsProvider);
              ref.invalidate(weeklyStatsProvider);
              ref.invalidate(userStatsProvider);

              if (mounted && finishedSession != null) {
                // 요약 화면으로 이동
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => WorkoutSummaryScreen(
                      session: finishedSession,
                    ),
                  ),
                );
              } else if (mounted) {
                context.go('/home');
              }
            },
            child: Text(
              '완료하기',
              style: TextStyle(color: AppColors.success),
            ),
          ),
        ],
      ),
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

    return Column(
      children: [
        // 헤더
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.darkBorder, width: 1),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    '운동 선택',
                    style: AppTypography.h4.copyWith(
                      color: AppColors.darkText,
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
                    color: AppColors.darkTextSecondary,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              // 검색바
              TextField(
                controller: _searchController,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.darkText,
                ),
                decoration: InputDecoration(
                  hintText: '운동 검색 (예: 벤치프레스, 스쿼트)',
                  hintStyle: AppTypography.bodyMedium.copyWith(
                    color: AppColors.darkTextTertiary,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.darkTextSecondary,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                          },
                          color: AppColors.darkTextSecondary,
                        )
                      : null,
                  filled: true,
                  fillColor: AppColors.darkCardElevated,
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
              ...MuscleGroup.values.take(8).map((muscle) => _FilterChip(
                    label: muscle.label,
                    isSelected: _selectedMuscle == muscle,
                    onTap: () => _updateMuscleFilter(muscle),
                    color: muscle.color,
                  )),
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
                        color: AppColors.darkTextTertiary,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        '검색 결과가 없습니다',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.darkTextSecondary,
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
                        color: AppColors.darkText,
                      ),
                    ),
                    subtitle: Text(
                      exercise.primaryMuscle.label,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.darkTextSecondary,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.info_outline,
                        color: AppColors.darkTextSecondary,
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
                      color: AppColors.darkTextSecondary,
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
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: FilterChip(
        label: Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: isSelected ? Colors.white : (color ?? AppColors.darkTextSecondary),
          ),
        ),
        selected: isSelected,
        onSelected: (_) => onTap(),
        backgroundColor: AppColors.darkCard,
        selectedColor: color ?? AppColors.primary500,
        checkmarkColor: Colors.white,
        side: BorderSide(
          color: isSelected ? Colors.transparent : (color?.withValues(alpha: 0.3) ?? AppColors.darkBorder),
        ),
      ),
    );
  }
}

/// 운동 가이드 카드 (펼치기/접기 기능)
class _ExerciseGuideCard extends StatefulWidget {
  final ExerciseModel exercise;
  final WorkoutSessionModel session;
  final VoidCallback? onChangeExercise;
  final dynamic routineExercise;

  const _ExerciseGuideCard({
    required this.exercise,
    required this.session,
    this.onChangeExercise,
    this.routineExercise,
  });

  @override
  State<_ExerciseGuideCard> createState() => _ExerciseGuideCardState();
}

class _ExerciseGuideCardState extends State<_ExerciseGuideCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        border: Border(
          bottom: BorderSide(color: AppColors.darkBorder, width: 1),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 헤더 (항상 표시)
          _buildHeader(),

          // 상세 정보 (펼쳐진 상태)
          if (_isExpanded) _buildExpandedContent(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final exercise = widget.exercise;

    return InkWell(
      onTap: () => setState(() => _isExpanded = !_isExpanded),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            // 운동 아이콘
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: exercise.primaryMuscle.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Icon(
                Icons.fitness_center,
                color: exercise.primaryMuscle.color,
                size: 28,
              ),
            ),
            const SizedBox(width: AppSpacing.md),

            // 운동 이름 + 근육
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name,
                    style: AppTypography.h4.copyWith(color: AppColors.darkText),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      _buildMuscleTag(exercise.primaryMuscle.label, exercise.primaryMuscle.color),
                      if (exercise.secondaryMuscles.isNotEmpty) ...[
                        const SizedBox(width: AppSpacing.xs),
                        ...exercise.secondaryMuscles.take(2).map((m) => Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.xs),
                          child: _buildMuscleTag(m.label, m.color),
                        )),
                      ],
                    ],
                  ),
                  // 프리셋 모드 목표
                  if (widget.routineExercise != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '목표: ${widget.routineExercise.setsRepsText}',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.primary500),
                    ),
                  ],
                ],
              ),
            ),

            // 버튼들
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 펼치기/접기 버튼
                IconButton(
                  icon: Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.darkTextSecondary,
                  ),
                  onPressed: () => setState(() => _isExpanded = !_isExpanded),
                  tooltip: _isExpanded ? '접기' : '운동 가이드 보기',
                ),
                // 운동 변경 버튼
                if (widget.onChangeExercise != null)
                  IconButton(
                    icon: const Icon(Icons.swap_horiz),
                    onPressed: widget.onChangeExercise,
                    color: AppColors.darkTextSecondary,
                    tooltip: '운동 변경',
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedContent() {
    final exercise = widget.exercise;

    return Container(
      constraints: const BoxConstraints(maxHeight: 300),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(color: AppColors.darkBorder),
            const SizedBox(height: AppSpacing.md),

            // 운동 방법 (instructions)
            if (exercise.instructions.isNotEmpty) ...[
              _buildSectionTitle('운동 방법', Icons.format_list_numbered),
              const SizedBox(height: AppSpacing.sm),
              ...exercise.instructions.asMap().entries.map((entry) {
                final index = entry.key;
                final instruction = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: AppColors.primary500.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.primary500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          instruction,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.darkText,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: AppSpacing.md),
            ],

            // 팁 (tips)
            if (exercise.tips.isNotEmpty) ...[
              _buildSectionTitle('팁', Icons.lightbulb_outline),
              const SizedBox(height: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.secondary500.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  border: Border.all(
                    color: AppColors.secondary500.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: exercise.tips.map((tip) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 16,
                            color: AppColors.secondary500,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Expanded(
                            child: Text(
                              tip,
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.darkText,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary500),
        const SizedBox(width: AppSpacing.xs),
        Text(
          title,
          style: AppTypography.labelLarge.copyWith(color: AppColors.darkText),
        ),
      ],
    );
  }

  Widget _buildMuscleTag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
      ),
      child: Text(
        label,
        style: AppTypography.labelSmall.copyWith(
          color: color,
          fontSize: 11,
        ),
      ),
    );
  }
}
