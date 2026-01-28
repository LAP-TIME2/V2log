import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/haptic_feedback.dart';
import '../../../data/models/workout_set_model.dart';
import '../../../domain/providers/timer_provider.dart';
import '../../../domain/providers/workout_provider.dart';
import '../../widgets/atoms/v2_button.dart';
import '../../widgets/molecules/quick_input_control.dart';
import '../../widgets/molecules/rest_timer.dart';
import '../../widgets/molecules/set_row.dart';

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

  // 현재 운동 (임시 - 실제로는 Provider에서 관리)
  String _currentExerciseId = 'bench_press';
  String _currentExerciseName = '벤치 프레스';

  @override
  void initState() {
    super.initState();
    // 세션 타이머 시작
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final session = ref.read(activeWorkoutProvider);
      if (session != null) {
        ref.read(workoutTimerProvider.notifier).startFrom(session.startedAt);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(activeWorkoutProvider);
    final workoutTimer = ref.watch(workoutTimerProvider);
    final currentSets = ref.watch(exerciseSetsProvider(_currentExerciseId));

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

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: _buildAppBar(context, session, workoutTimer),
      body: Column(
        children: [
          // 운동 가이드 영역
          _buildExerciseHeader(),

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

          // 세트 완료 버튼
          _buildCompleteButton(),
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

  Widget _buildExerciseHeader() {
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
          // 운동 애니메이션/이미지 자리
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

          // 운동 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _currentExerciseName,
                  style: AppTypography.h4.copyWith(
                    color: AppColors.darkText,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    _buildTag('가슴', AppColors.muscleChest),
                    const SizedBox(width: AppSpacing.sm),
                    _buildTag('삼두', AppColors.muscleTriceps),
                  ],
                ),
              ],
            ),
          ),

          // 운동 변경 버튼
          IconButton(
            icon: const Icon(Icons.swap_horiz),
            onPressed: _showExerciseSelector,
            color: AppColors.darkTextSecondary,
          ),
        ],
      ),
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

  Widget _buildCompleteButton() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        border: Border(
          top: BorderSide(color: AppColors.darkBorder, width: 1),
        ),
      ),
      child: SafeArea(
        child: V2Button.primary(
          text: '세트 완료',
          icon: Icons.check_circle,
          onPressed: _completeSet,
          fullWidth: true,
        ),
      ),
    );
  }

  Future<void> _completeSet() async {
    AppHaptics.heavyImpact();

    try {
      await ref.read(activeWorkoutProvider.notifier).addSet(
            exerciseId: _currentExerciseId,
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
    // TODO: 운동 선택 화면
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
              onSelect: (id, name) {
                setState(() {
                  _currentExerciseId = id;
                  _currentExerciseName = name;
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.darkCard,
        title: Text(
          '운동 완료',
          style: AppTypography.h4.copyWith(color: AppColors.darkText),
        ),
        content: Text(
          '운동을 완료하시겠습니까?',
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
              await ref.read(activeWorkoutProvider.notifier).finishWorkout();
              ref.read(workoutTimerProvider.notifier).stop();
              if (mounted) context.go('/home');
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

/// 운동 선택 시트
class _ExerciseSelectorSheet extends StatelessWidget {
  final ScrollController scrollController;
  final Function(String id, String name) onSelect;

  const _ExerciseSelectorSheet({
    required this.scrollController,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    // 임시 운동 목록
    final exercises = [
      ('bench_press', '벤치 프레스', '가슴'),
      ('squat', '스쿼트', '하체'),
      ('deadlift', '데드리프트', '등'),
      ('shoulder_press', '숄더 프레스', '어깨'),
      ('lat_pulldown', '랫 풀다운', '등'),
      ('leg_press', '레그 프레스', '하체'),
      ('bicep_curl', '바이셉 컬', '이두'),
      ('tricep_pushdown', '트라이셉 푸시다운', '삼두'),
    ];

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
          child: Row(
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
                onPressed: () => Navigator.pop(context),
                color: AppColors.darkTextSecondary,
              ),
            ],
          ),
        ),

        // 운동 목록
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            itemCount: exercises.length,
            itemBuilder: (context, index) {
              final (id, name, muscle) = exercises[index];
              return ListTile(
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary500.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: const Icon(
                    Icons.fitness_center,
                    color: AppColors.primary500,
                  ),
                ),
                title: Text(
                  name,
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.darkText,
                  ),
                ),
                subtitle: Text(
                  muscle,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.darkTextSecondary,
                  ),
                ),
                onTap: () => onSelect(id, name),
              );
            },
          ),
        ),
      ],
    );
  }
}
