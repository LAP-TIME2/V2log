import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../data/models/preset_routine_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/workout_session_model.dart';
import '../../../domain/providers/preset_routine_provider.dart';
import '../../../domain/providers/workout_provider.dart';
import '../../widgets/atoms/v2_button.dart';
import '../../widgets/atoms/v2_card.dart';

/// 프리셋 루틴 상세 Bottom Sheet
class PresetRoutineDetailSheet extends ConsumerStatefulWidget {
  final String routineId;

  const PresetRoutineDetailSheet({
    required this.routineId,
    super.key,
  });

  @override
  ConsumerState<PresetRoutineDetailSheet> createState() =>
      _PresetRoutineDetailSheetState();
}

class _PresetRoutineDetailSheetState extends ConsumerState<PresetRoutineDetailSheet> {
  int _selectedDay = 1;

  @override
  Widget build(BuildContext context) {
    final routineAsync = ref.watch(presetRoutineDetailProvider(widget.routineId));

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.darkCard,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppSpacing.radiusXxl),
            ),
          ),
          child: routineAsync.when(
            data: (routine) => _buildContent(context, routine, scrollController),
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.primary500),
            ),
            error: (error, _) => _buildError(error.toString()),
          ),
        );
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    PresetRoutineModel routine,
    ScrollController scrollController,
  ) {
    final exercisesByDay = routine.exercisesByDay;
    final dayNumbers = exercisesByDay.keys.toList()..sort();

    return Column(
      children: [
        // 드래그 핸들
        _buildDragHandle(),

        // 스크롤 가능한 콘텐츠
        Expanded(
          child: SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 헤더 (루틴 정보)
                _buildHeader(routine),
                const SizedBox(height: AppSpacing.xxl),

                // 메타 정보 카드
                _buildMetaCards(routine),
                const SizedBox(height: AppSpacing.xxl),

                // Day 선택 탭
                if (dayNumbers.length > 1) ...[
                  _buildDayTabs(routine, dayNumbers),
                  const SizedBox(height: AppSpacing.lg),
                ],

                // Day 제목
                _buildDayTitle(routine, _selectedDay),
                const SizedBox(height: AppSpacing.lg),

                // 운동 목록
                _buildExerciseList(exercisesByDay[_selectedDay] ?? []),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ),

        // 하단 버튼
        _buildBottomButton(context, routine),
      ],
    );
  }

  Widget _buildDragHandle() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.darkTextTertiary,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildHeader(PresetRoutineModel routine) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 난이도 + 추천 뱃지
        Row(
          children: [
            _DifficultyChip(difficulty: routine.difficulty),
            if (routine.isFeatured) ...[
              const SizedBox(width: AppSpacing.sm),
              _FeaturedChip(),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.md),

        // 루틴 이름
        Text(
          routine.name,
          style: AppTypography.h2.copyWith(color: AppColors.darkText),
        ),
        const SizedBox(height: AppSpacing.sm),

        // 설명
        if (routine.description != null)
          Text(
            routine.description!,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.darkTextSecondary,
            ),
          ),

        // 만든 사람
        if (routine.createdBy != null) ...[
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Icon(
                Icons.verified,
                size: 16,
                color: AppColors.primary500,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                routine.createdBy!,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.primary500,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildMetaCards(PresetRoutineModel routine) {
    return Row(
      children: [
        Expanded(
          child: _MetaCard(
            icon: Icons.calendar_today_outlined,
            label: '주간 횟수',
            value: '${routine.daysPerWeek}회',
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _MetaCard(
            icon: Icons.timer_outlined,
            label: '예상 시간',
            value: '${routine.estimatedDurationMinutes ?? 60}분',
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _MetaCard(
            icon: Icons.fitness_center,
            label: '운동 수',
            value: '${routine.totalExerciseCount}개',
          ),
        ),
      ],
    );
  }

  Widget _buildDayTabs(PresetRoutineModel routine, List<int> dayNumbers) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: dayNumbers.map((day) {
          final isSelected = _selectedDay == day;
          final dayExercises = routine.exercisesByDay[day];
          final dayName = dayExercises?.isNotEmpty == true
              ? dayExercises!.first.dayName ?? 'Day $day'
              : 'Day $day';

          return Padding(
            padding: EdgeInsets.only(
              right: day != dayNumbers.last ? AppSpacing.sm : 0,
            ),
            child: _DayTab(
              dayNumber: day,
              dayName: dayName,
              isSelected: isSelected,
              onTap: () => setState(() => _selectedDay = day),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDayTitle(PresetRoutineModel routine, int day) {
    final dayExercises = routine.exercisesByDay[day];
    final dayName = dayExercises?.isNotEmpty == true
        ? dayExercises!.first.dayName
        : null;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: AppColors.primary500,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          child: Text(
            'Day $day',
            style: AppTypography.labelSmall.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        if (dayName != null) ...[
          const SizedBox(width: AppSpacing.sm),
          Text(
            dayName.replaceFirst('Day $day - ', ''),
            style: AppTypography.h4.copyWith(color: AppColors.darkText),
          ),
        ],
      ],
    );
  }

  Widget _buildExerciseList(List<PresetRoutineExerciseModel> exercises) {
    if (exercises.isEmpty) {
      return Center(
        child: Text(
          '이 Day에는 운동이 없습니다',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.darkTextSecondary,
          ),
        ),
      );
    }

    return Column(
      children: exercises.asMap().entries.map((entry) {
        final index = entry.key;
        final exercise = entry.value;
        return Padding(
          padding: EdgeInsets.only(
            bottom: index < exercises.length - 1 ? AppSpacing.md : 0,
          ),
          child: _ExerciseItem(
            index: index + 1,
            exercise: exercise,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomButton(BuildContext context, PresetRoutineModel routine) {
    return Container(
      padding: EdgeInsets.only(
        left: AppSpacing.screenPadding,
        right: AppSpacing.screenPadding,
        bottom: MediaQuery.of(context).padding.bottom + AppSpacing.lg,
        top: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        border: Border(
          top: BorderSide(color: AppColors.darkBorder, width: 1),
        ),
      ),
      child: V2Button.primary(
        text: '이 루틴으로 시작하기',
        icon: Icons.play_arrow,
        fullWidth: true,
        onPressed: () => _startRoutine(context, routine),
      ),
    );
  }

  Widget _buildError(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: AppColors.error,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              '루틴을 불러오는데 실패했어요',
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.darkTextSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              error,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.darkTextTertiary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _startRoutine(BuildContext context, PresetRoutineModel routine) async {
    // Bottom sheet 닫기
    Navigator.of(context).pop();

    try {
      // 프리셋 루틴으로 운동 시작
      await ref.read(activeWorkoutProvider.notifier).startWorkout(
            routineId: routine.id,
            mode: WorkoutMode.preset,
          );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${routine.name} 루틴을 시작합니다'),
            backgroundColor: AppColors.primary500,
          ),
        );
        // 운동 화면으로 이동
        context.push('/workout/session/active');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('운동을 시작할 수 없습니다: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}

/// 난이도 칩
class _DifficultyChip extends StatelessWidget {
  final ExperienceLevel difficulty;

  const _DifficultyChip({required this.difficulty});

  Color get _color {
    switch (difficulty) {
      case ExperienceLevel.beginner:
        return AppColors.success;
      case ExperienceLevel.intermediate:
        return AppColors.warning;
      case ExperienceLevel.advanced:
        return AppColors.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Text(
        difficulty.label,
        style: AppTypography.labelSmall.copyWith(
          color: _color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// 추천 칩
class _FeaturedChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary500.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, size: 14, color: AppColors.primary500),
          const SizedBox(width: AppSpacing.xs),
          Text(
            '추천',
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.primary500,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// 메타 정보 카드
class _MetaCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _MetaCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return V2Card(
      padding: const EdgeInsets.all(AppSpacing.lg),
      backgroundColor: AppColors.darkCardElevated,
      child: Column(
        children: [
          Icon(icon, size: 24, color: AppColors.primary500),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: AppTypography.h4.copyWith(
              color: AppColors.darkText,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: AppColors.darkTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Day 탭
class _DayTab extends StatelessWidget {
  final int dayNumber;
  final String dayName;
  final bool isSelected;
  final VoidCallback onTap;

  const _DayTab({
    required this.dayNumber,
    required this.dayName,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary500 : AppColors.darkCardElevated,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: isSelected
              ? null
              : Border.all(color: AppColors.darkBorder, width: 1),
        ),
        child: Text(
          'Day $dayNumber',
          style: AppTypography.labelMedium.copyWith(
            color: isSelected ? Colors.white : AppColors.darkTextSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

/// 운동 아이템
class _ExerciseItem extends StatelessWidget {
  final int index;
  final PresetRoutineExerciseModel exercise;

  const _ExerciseItem({
    required this.index,
    required this.exercise,
  });

  @override
  Widget build(BuildContext context) {
    return V2Card(
      padding: const EdgeInsets.all(AppSpacing.lg),
      backgroundColor: AppColors.darkCardElevated,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 순번
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.primary500.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            alignment: Alignment.center,
            child: Text(
              '$index',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.primary500,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.lg),

          // 운동 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 운동 이름
                Text(
                  exercise.exercise?.name ?? '운동 ${exercise.exerciseId}',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.darkText,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),

                // 세트 x 반복
                Row(
                  children: [
                    _InfoChip(
                      icon: Icons.repeat,
                      text: exercise.setsRepsText,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    _InfoChip(
                      icon: Icons.timer_outlined,
                      text: '휴식 ${exercise.restTimeFormatted}',
                    ),
                  ],
                ),

                // 메모
                if (exercise.notes != null && exercise.notes!.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 14,
                        color: AppColors.darkTextTertiary,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          exercise.notes!,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.darkTextTertiary,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 정보 칩
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoChip({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.darkTextSecondary),
        const SizedBox(width: AppSpacing.xxs),
        Text(
          text,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.darkTextSecondary,
          ),
        ),
      ],
    );
  }
}
