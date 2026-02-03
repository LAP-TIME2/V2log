import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../data/models/exercise_model.dart';
import '../../../domain/providers/exercise_provider.dart';

/// 운동 상세 화면
class ExerciseDetailScreen extends ConsumerWidget {
  final String exerciseId;

  const ExerciseDetailScreen({
    required this.exerciseId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exerciseAsync = ref.watch(exerciseDetailProvider(exerciseId));

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg,
        title: Text(
          '운동 상세',
          style: AppTypography.h3.copyWith(color: AppColors.darkText),
        ),
        elevation: 0,
      ),
      body: exerciseAsync.when(
        data: (exercise) {
          if (exercise == null) {
            return _buildNotFound();
          }
          return _buildContent(exercise);
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary500),
        ),
        error: (error, _) {
          print('=== 에러: $error ===');
          return _buildError();
        },
      ),
    );
  }

  Widget _buildNotFound() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: AppColors.darkTextTertiary,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            '운동 정보를 찾을 수 없습니다',
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.darkTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
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
              color: AppColors.darkTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(ExerciseModel exercise) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 운동 헤더 (이름 + 아이콘)
          _buildHeader(exercise),
          const SizedBox(height: AppSpacing.xl),

          // 주요 근육
          _buildMuscleSection(exercise),
          const SizedBox(height: AppSpacing.xl),

          // 운동 방법 (instructions)
          if (exercise.instructions.isNotEmpty) ...[
            _buildInstructionsSection(exercise),
            const SizedBox(height: AppSpacing.xl),
          ],

          // 팁 (tips)
          if (exercise.tips.isNotEmpty) ...[
            _buildTipsSection(exercise),
            const SizedBox(height: AppSpacing.xl),
          ],

          // 추가 정보
          _buildMetaSection(exercise),
        ],
      ),
    );
  }

  Widget _buildHeader(ExerciseModel exercise) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Row(
        children: [
          // 운동 아이콘
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: exercise.primaryMuscle.color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Icon(
              Icons.fitness_center,
              color: exercise.primaryMuscle.color,
              size: 40,
            ),
          ),
          const SizedBox(width: AppSpacing.lg),

          // 운동 이름
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise.name,
                  style: AppTypography.h2.copyWith(
                    color: AppColors.darkText,
                  ),
                ),
                if (exercise.nameEn != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    exercise.nameEn!,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.darkTextSecondary,
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.sm),
                // 카테고리 & 난이도
                Row(
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
    );
  }

  Widget _buildMuscleSection(ExerciseModel exercise) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('타겟 근육'),
        const SizedBox(height: AppSpacing.md),

        // 주요 근육
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.darkCard,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(color: AppColors.darkBorder),
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
                      color: AppColors.darkTextSecondary,
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
                const Divider(color: AppColors.darkBorder),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.darkTextSecondary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      '보조 근육',
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.darkTextSecondary,
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

  Widget _buildInstructionsSection(ExerciseModel exercise) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('운동 방법'),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.darkCard,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(color: AppColors.darkBorder),
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
                          color: AppColors.darkText,
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

  Widget _buildTipsSection(ExerciseModel exercise) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('팁'),
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
                          color: AppColors.darkText,
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

  Widget _buildMetaSection(ExerciseModel exercise) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('추가 정보'),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.darkCard,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(color: AppColors.darkBorder),
          ),
          child: Column(
            children: [
              // 필요 장비
              if (exercise.equipmentRequired.isNotEmpty)
                _buildMetaRow(
                  icon: Icons.sports_gymnastics,
                  label: '필요 장비',
                  value: exercise.equipmentRequired.join(', '),
                ),
              // 칼로리
              if (exercise.caloriesPerMinute != null) ...[
                const SizedBox(height: AppSpacing.md),
                _buildMetaRow(
                  icon: Icons.local_fire_department,
                  label: '소모 칼로리',
                  value: '${exercise.caloriesPerMinute!.toStringAsFixed(1)} kcal/분',
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTypography.h4.copyWith(
        color: AppColors.darkText,
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
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.darkTextSecondary),
        const SizedBox(width: AppSpacing.md),
        Text(
          label,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.darkTextSecondary,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.darkText,
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
