import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:v2log/core/constants/app_colors.dart';
import 'package:v2log/core/constants/app_spacing.dart';
import 'package:v2log/core/constants/app_typography.dart';
import 'package:v2log/core/extensions/context_extension.dart';
import 'package:v2log/core/utils/fitness_calculator.dart';
import 'package:v2log/shared/models/exercise_model.dart';
import 'package:v2log/shared/models/workout_session_model.dart';
import 'package:v2log/shared/models/workout_set_model.dart';
import 'package:v2log/features/exercise/domain/exercise_provider.dart';
import 'package:v2log/features/workout/domain/workout_provider.dart';
import 'package:v2log/shared/widgets/molecules/exercise_animation_widget.dart';
import 'package:v2log/shared/widgets/molecules/mini_muscle_map.dart';

/// 운동 가이드 카드 (간결 버전)
class ExerciseGuideCard extends StatelessWidget {
  final ExerciseModel exercise;
  final WorkoutSessionModel session;
  final String notes;
  final VoidCallback onEditNotes;
  final VoidCallback? onChangeExercise;
  final dynamic routineExercise;
  final ExerciseModel? supersetPartner;
  final bool isDark;

  const ExerciseGuideCard({
    super.key,
    required this.exercise,
    required this.session,
    required this.notes,
    required this.onEditNotes,
    this.onChangeExercise,
    this.routineExercise,
    this.supersetPartner,
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
          bottom: BorderSide(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              width: 1),
        ),
      ),
      child: Row(
        children: [
          // 운동 아이콘 (호흡 애니메이션)
          ExerciseAnimationWidget(
            exercise: exercise,
            size: 40,
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
                    // 슈퍼세트 파트너 표시
                    if (supersetPartner != null) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color:
                              AppColors.setSuperset.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'SS',
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.setSuperset,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 3),
                            Icon(Icons.swap_horiz,
                                size: 10, color: AppColors.setSuperset),
                            const SizedBox(width: 3),
                            Text(
                              supersetPartner!.name,
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.setSuperset,
                                fontSize: 10,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (routineExercise != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color:
                              AppColors.primary500.withValues(alpha: 0.15),
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

          // 미니 근육 맵
          MiniMuscleMap(
            primaryMuscle: exercise.primaryMuscle,
            secondaryMuscles: exercise.secondaryMuscles,
          ),
          const SizedBox(width: 4),

          // 메모 아이콘
          IconButton(
            icon: Icon(
              notes.isEmpty ? Icons.note_outlined : Icons.note,
              color: notes.isEmpty
                  ? (isDark
                      ? AppColors.darkTextTertiary
                      : AppColors.lightTextTertiary)
                  : AppColors.warning,
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
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
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

/// 실시간 강도 존 표시바
class IntensityZoneIndicator extends ConsumerWidget {
  final double currentWeight;
  final String exerciseId;
  final List<WorkoutSetModel> currentSets;

  const IntensityZoneIndicator({
    super.key,
    required this.currentWeight,
    required this.exerciseId,
    required this.currentSets,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDarkMode;
    final estimated1rmAsync =
        ref.watch(exerciseEstimated1rmProvider(exerciseId));

    return estimated1rmAsync.when(
      data: (stored1rm) {
        // 저장된 1RM 사용, 없으면 현재 세션 최고 기록으로 추정
        double? estimated1rm = stored1rm;
        if (estimated1rm == null && currentSets.isNotEmpty) {
          double maxCalc = 0;
          for (final s in currentSets) {
            if (s.weight != null && s.reps != null && s.reps! > 0) {
              final calc =
                  FitnessCalculator.calculate1RM(s.weight!, s.reps!);
              if (calc > maxCalc) maxCalc = calc;
            }
          }
          if (maxCalc > 0) estimated1rm = maxCalc;
        }

        if (estimated1rm == null || estimated1rm <= 0) {
          return _buildNoData(isDark);
        }

        final zone =
            FitnessCalculator.analyzeIntensity(currentWeight, estimated1rm);
        final percent =
            (currentWeight / estimated1rm * 100).clamp(0, 120).toInt();

        return Container(
          margin: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg, vertical: 4),
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: zone.color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: zone.color.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              // 존 컬러 도트
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: zone.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              // 존 이름 + 추천 횟수
              Text(
                zone.label,
                style: AppTypography.labelMedium.copyWith(
                  color: zone.color,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                zone.suggestedReps,
                style: AppTypography.bodySmall.copyWith(
                  color: zone.color.withValues(alpha: 0.7),
                  fontSize: 11,
                ),
              ),
              const Spacer(),
              // 1RM 대비 퍼센트
              Text(
                '$percent% 1RM',
                style: AppTypography.labelMedium.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => _buildNoData(isDark),
    );
  }

  Widget _buildNoData(bool isDark) {
    return Container(
      margin:
          const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: (isDark
            ? AppColors.darkCardElevated
            : AppColors.lightCardElevated),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline,
              size: 14,
              color: isDark
                  ? AppColors.darkTextTertiary
                  : AppColors.lightTextTertiary),
          const SizedBox(width: 6),
          Text(
            '1RM 데이터 없음 — 운동 기록이 쌓이면 강도 분석이 표시됩니다',
            style: AppTypography.bodySmall.copyWith(
              color: isDark
                  ? AppColors.darkTextTertiary
                  : AppColors.lightTextTertiary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

/// 필터 칩
class ExerciseFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;

  const ExerciseFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: FilterChip(
        label: Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: isSelected
                ? Colors.white
                : (color ??
                    (isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary)),
          ),
        ),
        selected: isSelected,
        onSelected: (_) => onTap(),
        backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
        selectedColor: color ?? AppColors.primary500,
        checkmarkColor: Colors.white,
        side: BorderSide(
          color: isSelected
              ? Colors.transparent
              : (color?.withValues(alpha: 0.3) ??
                  (isDark
                      ? AppColors.darkBorder
                      : AppColors.lightBorder)),
        ),
      ),
    );
  }
}

/// 운동 선택 시트 (Supabase 검색 연동)
class ExerciseSelectorSheet extends ConsumerStatefulWidget {
  final ScrollController scrollController;
  final Function(ExerciseModel exercise) onSelect;

  const ExerciseSelectorSheet({
    super.key,
    required this.scrollController,
    required this.onSelect,
  });

  @override
  ConsumerState<ExerciseSelectorSheet> createState() =>
      _ExerciseSelectorSheetState();
}

class _ExerciseSelectorSheetState
    extends ConsumerState<ExerciseSelectorSheet> {
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
    final isDark = context.isDarkMode;

    return Column(
      children: [
        // 헤더
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                  color: isDark
                      ? AppColors.darkBorder
                      : AppColors.lightBorder,
                  width: 1),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    '운동 선택',
                    style: AppTypography.h4.copyWith(
                      color:
                          isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      // 필터 초기화
                      ref
                          .read(exerciseFilterStateProvider.notifier)
                          .clearFilters();
                      Navigator.pop(context);
                    },
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              // 검색바
              TextField(
                controller: _searchController,
                style: AppTypography.bodyMedium.copyWith(
                  color:
                      isDark ? AppColors.darkText : AppColors.lightText,
                ),
                decoration: InputDecoration(
                  hintText: '운동 검색 (예: 벤치프레스, 스쿼트)',
                  hintStyle: AppTypography.bodyMedium.copyWith(
                    color: isDark
                        ? AppColors.darkTextTertiary
                        : AppColors.lightTextTertiary,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                          },
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        )
                      : null,
                  filled: true,
                  fillColor: isDark
                      ? AppColors.darkCardElevated
                      : AppColors.lightCardElevated,
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusMd),
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
              ExerciseFilterChip(
                label: '전체',
                isSelected: _selectedMuscle == null,
                onTap: () => _updateMuscleFilter(null),
              ),
              // 주요 근육 그룹 + 하체
              ExerciseFilterChip(
                label: MuscleGroup.chest.label,
                isSelected: _selectedMuscle == MuscleGroup.chest,
                onTap: () => _updateMuscleFilter(MuscleGroup.chest),
                color: MuscleGroup.chest.color,
              ),
              ExerciseFilterChip(
                label: MuscleGroup.back.label,
                isSelected: _selectedMuscle == MuscleGroup.back,
                onTap: () => _updateMuscleFilter(MuscleGroup.back),
                color: MuscleGroup.back.color,
              ),
              ExerciseFilterChip(
                label: MuscleGroup.shoulders.label,
                isSelected: _selectedMuscle == MuscleGroup.shoulders,
                onTap: () => _updateMuscleFilter(MuscleGroup.shoulders),
                color: MuscleGroup.shoulders.color,
              ),
              ExerciseFilterChip(
                label: MuscleGroup.legs.label,
                isSelected: _selectedMuscle == MuscleGroup.legs,
                onTap: () => _updateMuscleFilter(MuscleGroup.legs),
                color: MuscleGroup.legs.color,
              ),
              ExerciseFilterChip(
                label: MuscleGroup.biceps.label,
                isSelected: _selectedMuscle == MuscleGroup.biceps,
                onTap: () => _updateMuscleFilter(MuscleGroup.biceps),
                color: MuscleGroup.biceps.color,
              ),
              ExerciseFilterChip(
                label: MuscleGroup.triceps.label,
                isSelected: _selectedMuscle == MuscleGroup.triceps,
                onTap: () => _updateMuscleFilter(MuscleGroup.triceps),
                color: MuscleGroup.triceps.color,
              ),
              ExerciseFilterChip(
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
                        color: isDark
                            ? AppColors.darkTextTertiary
                            : AppColors.lightTextTertiary,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        '검색 결과가 없습니다',
                        style: AppTypography.bodyMedium.copyWith(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
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
                        color: exercise.primaryMuscle.color
                            .withValues(alpha: 0.1),
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusSm),
                      ),
                      child: Icon(
                        Icons.fitness_center,
                        color: exercise.primaryMuscle.color,
                      ),
                    ),
                    title: Text(
                      exercise.name,
                      style: AppTypography.bodyLarge.copyWith(
                        color: isDark
                            ? AppColors.darkText
                            : AppColors.lightText,
                      ),
                    ),
                    subtitle: Text(
                      exercise.primaryMuscle.label,
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.info_outline,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                      onPressed: () {
                        // 상세 화면으로 이동
                        context.push('/exercise/${exercise.id}');
                      },
                      tooltip: '상세 정보',
                    ),
                    onTap: () {
                      // 필터 초기화
                      ref
                          .read(exerciseFilterStateProvider.notifier)
                          .clearFilters();
                      widget.onSelect(exercise);
                    },
                  );
                },
              );
            },
            loading: () => const Center(
              child:
                  CircularProgressIndicator(color: AppColors.primary500),
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
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
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
