import 'package:flutter/material.dart';

import 'package:v2log/core/constants/app_colors.dart';
import 'package:v2log/core/constants/app_spacing.dart';
import 'package:v2log/core/constants/app_typography.dart';
import 'package:v2log/core/extensions/context_extension.dart';
import 'package:v2log/core/utils/haptic_feedback.dart';
import 'package:v2log/shared/models/workout_set_model.dart';
import '../atoms/animated_wrappers.dart';

/// 세트 기록 행
class SetRow extends StatelessWidget {
  final int setNumber;
  final SetType setType;
  final double? weight;
  final int? reps;
  final double? targetWeight;
  final int? targetReps;
  final bool isCompleted;
  final bool isCurrent;
  final bool isPr;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const SetRow({
    required this.setNumber,
    required this.setType,
    this.weight,
    this.reps,
    this.targetWeight,
    this.targetReps,
    this.isCompleted = false,
    this.isCurrent = false,
    this.isPr = false,
    this.onTap,
    this.onLongPress,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap != null
          ? () {
              AppHaptics.lightImpact();
              onTap!();
            }
          : null,
      onLongPress: onLongPress != null
          ? () {
              AppHaptics.mediumImpact();
              onLongPress!();
            }
          : null,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: isCurrent
              ? AppColors.primary500.withValues(alpha: 0.1)
              : Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: context.borderColor,
              width: 1,
            ),
            left: isCurrent
                ? BorderSide(color: AppColors.primary500, width: 3)
                : (isCompleted && setType == SetType.superset)
                    ? BorderSide(color: AppColors.setSuperset, width: 3)
                    : BorderSide.none,
          ),
        ),
        child: Row(
          children: [
            // 세트 번호
            SizedBox(
              width: 32,
              child: Text(
                '$setNumber',
                style: AppTypography.bodyLarge.copyWith(
                  color: context.textSecondaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // 세트 타입 뱃지
            SetTypeBadge(type: setType),
            const SizedBox(width: AppSpacing.md),

            // 무게
            Expanded(
              child: _buildValueCell(
                context: context,
                value: weight,
                target: targetWeight,
                unit: 'kg',
                isCompleted: isCompleted,
              ),
            ),

            // 횟수
            Expanded(
              child: _buildValueCell(
                context: context,
                value: reps?.toDouble(),
                target: targetReps?.toDouble(),
                unit: '회',
                isCompleted: isCompleted,
              ),
            ),

            // 상태 아이콘
            SizedBox(
              width: 32,
              child: _buildStatusIcon(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValueCell({
    required BuildContext context,
    double? value,
    double? target,
    required String unit,
    required bool isCompleted,
  }) {
    final displayValue = value ?? target;
    final hasValue = displayValue != null;

    String text;
    if (!hasValue) {
      text = '-';
    } else if (unit == '회') {
      text = '${displayValue.toInt()}$unit';
    } else {
      text = displayValue == displayValue.roundToDouble()
          ? '${displayValue.toInt()}$unit'
          : '${displayValue.toStringAsFixed(1)}$unit';
    }

    return Text(
      text,
      style: AppTypography.bodyLarge.copyWith(
        color: isCompleted ? context.textColor : context.textTertiaryColor,
        fontWeight: isCompleted ? FontWeight.w600 : FontWeight.w400,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildStatusIcon(BuildContext context) {
    if (isPr) {
      return AnimatedTrophy(
        size: 20,
        color: AppColors.warning,
      );
    }

    if (isCompleted) {
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: AnimatedCheckmark(
          key: const ValueKey('completed'),
          size: 20,
          color: AppColors.success,
        ),
      );
    }

    if (isCurrent) {
      return Icon(
        Icons.radio_button_checked,
        color: AppColors.primary500,
        size: 20,
      );
    }

    return Icon(
      Icons.radio_button_unchecked,
      color: context.textTertiaryColor,
      size: 20,
    );
  }
}

/// 세트 타입 뱃지
class SetTypeBadge extends StatelessWidget {
  final SetType type;
  final bool compact;

  const SetTypeBadge({
    required this.type,
    this.compact = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? AppSpacing.xs : AppSpacing.sm,
        vertical: compact ? 2 : AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: type.color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
      ),
      child: Text(
        _getShortLabel(),
        style: (compact ? AppTypography.labelSmall : AppTypography.labelMedium)
            .copyWith(
          color: type.color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _getShortLabel() {
    switch (type) {
      case SetType.warmup:
        return 'W';
      case SetType.working:
        return 'S';
      case SetType.drop:
        return 'D';
      case SetType.failure:
        return 'F';
      case SetType.superset:
        return 'SS';
    }
  }
}

/// 세트 헤더 행
class SetRowHeader extends StatelessWidget {
  const SetRowHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: context.cardColor,
        border: Border(
          bottom: BorderSide(color: context.borderColor, width: 1),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: Text(
              '세트',
              style: AppTypography.labelSmall.copyWith(
                color: context.textTertiaryColor,
              ),
            ),
          ),
          const SizedBox(width: 40), // 타입 뱃지 공간
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              '무게',
              style: AppTypography.labelSmall.copyWith(
                color: context.textTertiaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              '횟수',
              style: AppTypography.labelSmall.copyWith(
                color: context.textTertiaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 32),
        ],
      ),
    );
  }
}
