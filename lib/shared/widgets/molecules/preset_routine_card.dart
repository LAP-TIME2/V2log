import 'package:flutter/material.dart';

import 'package:v2log/core/constants/app_colors.dart';
import 'package:v2log/core/constants/app_spacing.dart';
import 'package:v2log/core/constants/app_typography.dart';
import 'package:v2log/core/extensions/context_extension.dart';
import 'package:v2log/shared/models/preset_routine_model.dart';
import 'package:v2log/shared/models/user_model.dart';
import '../atoms/v2_card.dart';

/// 프리셋 루틴 카드 위젯
class PresetRoutineCard extends StatelessWidget {
  final PresetRoutineModel routine;
  final VoidCallback? onTap;

  const PresetRoutineCard({
    required this.routine,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return V2Card(
      padding: const EdgeInsets.all(AppSpacing.xl),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단: 난이도 뱃지 + 추천 뱃지 + 화살표
          Row(
            children: [
              _DifficultyBadge(difficulty: routine.difficulty),
              const SizedBox(width: AppSpacing.sm),
              if (routine.isFeatured) ...[
                _FeaturedBadge(),
                const SizedBox(width: AppSpacing.sm),
              ],
              const Spacer(),
              Icon(
                Icons.chevron_right,
                color: context.textSecondaryColor,
                size: 24,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // 루틴 이름
          Text(
            routine.name,
            style: AppTypography.h3.copyWith(
              color: context.textColor,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // 설명
          if (routine.description != null && routine.description!.isNotEmpty)
            Text(
              routine.description!,
              style: AppTypography.bodyMedium.copyWith(
                color: context.textSecondaryColor,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          const SizedBox(height: AppSpacing.lg),

          // 메타 정보
          Row(
            children: [
              _MetaInfo(
                icon: Icons.calendar_today_outlined,
                text: '주 ${routine.daysPerWeek}회',
              ),
              const SizedBox(width: AppSpacing.lg),
              if (routine.estimatedDurationMinutes != null)
                _MetaInfo(
                  icon: Icons.timer_outlined,
                  text: '${routine.estimatedDurationMinutes}분',
                ),
              if (routine.estimatedDurationMinutes != null)
                const SizedBox(width: AppSpacing.lg),
              _MetaInfo(
                icon: Icons.fitness_center_outlined,
                text: '${routine.targetMuscles.length}개 부위',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 난이도 뱃지
class _DifficultyBadge extends StatelessWidget {
  final ExperienceLevel difficulty;

  const _DifficultyBadge({required this.difficulty});

  Color get _backgroundColor {
    switch (difficulty) {
      case ExperienceLevel.beginner:
        return AppColors.success.withValues(alpha: 0.15);
      case ExperienceLevel.intermediate:
        return AppColors.warning.withValues(alpha: 0.15);
      case ExperienceLevel.advanced:
        return AppColors.error.withValues(alpha: 0.15);
    }
  }

  Color get _textColor {
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
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Text(
        difficulty.label,
        style: AppTypography.labelSmall.copyWith(
          color: _textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// 추천 뱃지
class _FeaturedBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary500.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star,
            size: 12,
            color: AppColors.primary500,
          ),
          const SizedBox(width: 2),
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

/// 메타 정보 (아이콘 + 텍스트)
class _MetaInfo extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MetaInfo({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: context.textTertiaryColor,
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          text,
          style: AppTypography.bodySmall.copyWith(
            color: context.textSecondaryColor,
          ),
        ),
      ],
    );
  }
}

/// 컴팩트 프리셋 루틴 카드 (홈 화면용)
class PresetRoutineCardCompact extends StatelessWidget {
  final PresetRoutineModel routine;
  final VoidCallback? onTap;

  const PresetRoutineCardCompact({
    required this.routine,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return V2Card(
      padding: const EdgeInsets.all(AppSpacing.lg),
      onTap: onTap,
      child: Row(
        children: [
          // 왼쪽: 아이콘
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary500.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Icon(
              Icons.fitness_center,
              color: AppColors.primary500,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.lg),

          // 가운데: 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _DifficultyBadge(difficulty: routine.difficulty),
                    if (routine.isFeatured) ...[
                      const SizedBox(width: AppSpacing.xs),
                      Icon(Icons.star, size: 14, color: AppColors.primary500),
                    ],
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  routine.name,
                  style: AppTypography.labelLarge.copyWith(
                    color: context.textColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  '주 ${routine.daysPerWeek}회 • ${routine.estimatedDurationMinutes ?? 60}분',
                  style: AppTypography.bodySmall.copyWith(
                    color: context.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),

          // 오른쪽: 화살표
          Icon(
            Icons.chevron_right,
            color: context.textTertiaryColor,
          ),
        ],
      ),
    );
  }
}
