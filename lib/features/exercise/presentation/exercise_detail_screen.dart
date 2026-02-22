import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:v2log/core/constants/app_colors.dart';
import 'package:v2log/core/constants/app_spacing.dart';
import 'package:v2log/core/constants/app_typography.dart';
import 'package:v2log/core/extensions/context_extension.dart';
import 'package:v2log/shared/models/exercise_model.dart';
import 'package:v2log/features/exercise/domain/exercise_provider.dart';
import 'package:v2log/shared/widgets/atoms/animated_wrappers.dart';
import 'package:v2log/shared/widgets/molecules/exercise_animation_widget.dart';

/// 운동 상세 화면
class ExerciseDetailScreen extends ConsumerWidget {
  final String exerciseId;

  const ExerciseDetailScreen({
    required this.exerciseId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDarkMode;
    final exerciseAsync = ref.watch(exerciseDetailProvider(exerciseId));

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
        title: Text(
          '운동 상세',
          style: AppTypography.h3.copyWith(color: isDark ? AppColors.darkText : AppColors.lightText),
        ),
        elevation: 0,
      ),
      body: exerciseAsync.when(
        data: (exercise) {
          if (exercise == null) {
            return _buildNotFound(isDark);
          }
          return _buildContent(exercise, isDark);
        },
        loading: () => Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            children: [
              ShimmerLoading(height: 120, borderRadius: 12),
              const SizedBox(height: AppSpacing.xl),
              ShimmerLoading(height: 100, borderRadius: 12),
              const SizedBox(height: AppSpacing.xl),
              ShimmerLoading(height: 200, borderRadius: 12),
            ],
          ),
        ),
        error: (error, _) {
          return _buildError(isDark);
        },
      ),
    );
  }

  Widget _buildNotFound(bool isDark) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            '운동 정보를 찾을 수 없습니다',
            style: AppTypography.bodyLarge.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(bool isDark) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.error,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            '운동 정보를 불러오는데 실패했습니다',
            style: AppTypography.bodyLarge.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(ExerciseModel exercise, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 운동 헤더 (이름 + 아이콘)
          _buildHeader(exercise, isDark),
          const SizedBox(height: AppSpacing.xl),

          // 주요 근육
          _buildMuscleSection(exercise, isDark),
          const SizedBox(height: AppSpacing.xl),

          // 운동 방법 (instructions)
          if (exercise.instructions.isNotEmpty) ...[
            _buildInstructionsSection(exercise, isDark),
            const SizedBox(height: AppSpacing.xl),
          ],

          // 팁 (tips)
          if (exercise.tips.isNotEmpty) ...[
            _buildTipsSection(exercise, isDark),
            const SizedBox(height: AppSpacing.xl),
          ],

          // 추가 정보
          _buildMetaSection(exercise, isDark),
        ],
      ),
    );
  }

  Widget _buildHeader(ExerciseModel exercise, bool isDark) {
    final hasImage = exercise.animationUrl != null && exercise.animationUrl!.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        children: [
          // 운동 시범 이미지 (이미지가 있으면 크게 표시)
          if (hasImage) ...[
            ExerciseAnimationWidget(
              exercise: exercise,
              size: 200,
            ),
            const SizedBox(height: AppSpacing.lg),
          ],

          // 운동 이름 + 아이콘 (이미지 없으면 기존 레이아웃)
          Row(
            children: [
              if (!hasImage) ...[
                ExerciseAnimationWidget(
                  exercise: exercise,
                  size: 80,
                ),
                const SizedBox(width: AppSpacing.lg),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: hasImage
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name,
                      style: AppTypography.h2.copyWith(
                        color: isDark ? AppColors.darkText : AppColors.lightText,
                      ),
                      textAlign: hasImage ? TextAlign.center : TextAlign.start,
                    ),
                    if (exercise.nameEn != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        exercise.nameEn!,
                        style: AppTypography.bodyMedium.copyWith(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                        textAlign: hasImage ? TextAlign.center : TextAlign.start,
                      ),
                    ],
                    const SizedBox(height: AppSpacing.sm),
                    // 카테고리 & 난이도
                    Row(
                      mainAxisAlignment: hasImage
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.start,
                      children: [
                        _buildBadge(
                          exercise.category.label,
                          AppColors.primary500,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        _buildBadge(
                          _getDifficultyLabel(exercise.difficulty),
                          _getDifficultyColor(exercise.difficulty),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMuscleSection(ExerciseModel exercise, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('타겟 근육', isDark),
        const SizedBox(height: AppSpacing.md),

        // 주요 근육
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.lightCard,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: exercise.primaryMuscle.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    '주요 근육',
                    style: AppTypography.labelMedium.copyWith(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                exercise.primaryMuscle.label,
                style: AppTypography.h4.copyWith(
                  color: exercise.primaryMuscle.color,
                ),
              ),

              // 보조 근육
              if (exercise.secondaryMuscles.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.lg),
                Divider(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      '보조 근육',
                      style: AppTypography.labelMedium.copyWith(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: exercise.secondaryMuscles.map((muscle) {
                    return _buildBadge(muscle.label, muscle.color);
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInstructionsSection(ExerciseModel exercise, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('운동 방법', isDark),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.lightCard,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          child: Column(
            children: exercise.instructions.asMap().entries.map((entry) {
              final index = entry.key;
              final instruction = entry.value;
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index < exercise.instructions.length - 1
                      ? AppSpacing.md
                      : 0,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: AppColors.primary500.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: AppTypography.labelMedium.copyWith(
                            color: AppColors.primary500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        instruction,
                        style: AppTypography.bodyMedium.copyWith(
                          color: isDark ? AppColors.darkText : AppColors.lightText,
                          height: 1.6,
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
    );
  }

  Widget _buildTipsSection(ExerciseModel exercise, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('팁', isDark),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.secondary500.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(
              color: AppColors.secondary500.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            children: exercise.tips.map((tip) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: AppColors.secondary500,
                      size: 20,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        tip,
                        style: AppTypography.bodyMedium.copyWith(
                          color: isDark ? AppColors.darkText : AppColors.lightText,
                          height: 1.5,
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
    );
  }

  Widget _buildMetaSection(ExerciseModel exercise, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('추가 정보', isDark),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.lightCard,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          child: Column(
            children: [
              // 필요 장비
              if (exercise.equipmentRequired.isNotEmpty)
                _buildMetaRow(
                  icon: Icons.sports_gymnastics,
                  label: '필요 장비',
                  value: exercise.equipmentRequired.join(', '),
                  isDark: isDark,
                ),
              // 칼로리
              if (exercise.caloriesPerMinute != null) ...[
                const SizedBox(height: AppSpacing.md),
                _buildMetaRow(
                  icon: Icons.local_fire_department,
                  label: '소모 칼로리',
                  value: '${exercise.caloriesPerMinute!.toStringAsFixed(1)} kcal/분',
                  isDark: isDark,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: AppTypography.h4.copyWith(
        color: isDark ? AppColors.darkText : AppColors.lightText,
      ),
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Text(
        label,
        style: AppTypography.labelSmall.copyWith(color: color),
      ),
    );
  }

  Widget _buildMetaRow({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
        const SizedBox(width: AppSpacing.md),
        Text(
          label,
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.darkText : AppColors.lightText,
          ),
        ),
      ],
    );
  }

  String _getDifficultyLabel(dynamic difficulty) {
    final value = difficulty?.value ?? difficulty.toString();
    switch (value) {
      case 'BEGINNER':
        return '초보자';
      case 'INTERMEDIATE':
        return '중급자';
      case 'ADVANCED':
        return '고급자';
      default:
        return '초보자';
    }
  }

  Color _getDifficultyColor(dynamic difficulty) {
    final value = difficulty?.value ?? difficulty.toString();
    switch (value) {
      case 'BEGINNER':
        return AppColors.success;
      case 'INTERMEDIATE':
        return AppColors.secondary500;
      case 'ADVANCED':
        return AppColors.error;
      default:
        return AppColors.success;
    }
  }
}
