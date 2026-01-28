import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../atoms/number_stepper.dart';

/// 빠른 입력 컨트롤 (무게/횟수)
class QuickInputControl extends StatelessWidget {
  final double weight;
  final int reps;
  final ValueChanged<double> onWeightChanged;
  final ValueChanged<int> onRepsChanged;
  final double? previousWeight;
  final int? previousReps;

  const QuickInputControl({
    required this.weight,
    required this.reps,
    required this.onWeightChanged,
    required this.onRepsChanged,
    this.previousWeight,
    this.previousReps,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        border: Border(
          top: BorderSide(color: AppColors.darkBorder, width: 1),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 이전 기록 표시
          if (previousWeight != null || previousReps != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.history,
                  size: 14,
                  color: AppColors.darkTextTertiary,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  '이전: ${_formatPrevious()}',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.darkTextTertiary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
          ],

          // 무게/횟수 입력
          Row(
            children: [
              // 무게 입력
              Expanded(
                child: _InputSection(
                  label: '무게',
                  child: NumberStepper.weight(
                    value: weight,
                    onChanged: onWeightChanged,
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 100,
                color: AppColors.darkBorder,
                margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              ),
              // 횟수 입력
              Expanded(
                child: _InputSection(
                  label: '횟수',
                  child: NumberStepper.reps(
                    value: reps,
                    onChanged: onRepsChanged,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatPrevious() {
    final parts = <String>[];
    if (previousWeight != null) {
      final w = previousWeight == previousWeight!.roundToDouble()
          ? '${previousWeight!.toInt()}kg'
          : '${previousWeight!.toStringAsFixed(1)}kg';
      parts.add(w);
    }
    if (previousReps != null) {
      parts.add('$previousReps회');
    }
    return parts.join(' × ');
  }
}

class _InputSection extends StatelessWidget {
  final String label;
  final Widget child;

  const _InputSection({
    required this.label,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.darkTextSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        child,
      ],
    );
  }
}

/// 컴팩트 빠른 입력 (인라인)
class CompactQuickInput extends StatelessWidget {
  final double weight;
  final int reps;
  final ValueChanged<double> onWeightChanged;
  final ValueChanged<int> onRepsChanged;

  const CompactQuickInput({
    required this.weight,
    required this.reps,
    required this.onWeightChanged,
    required this.onRepsChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 무게
        _CompactInput(
          value: weight,
          unit: 'kg',
          step: 2.5,
          onChanged: onWeightChanged,
        ),
        const SizedBox(width: AppSpacing.xl),
        Text(
          '×',
          style: AppTypography.h3.copyWith(
            color: AppColors.darkTextTertiary,
          ),
        ),
        const SizedBox(width: AppSpacing.xl),
        // 횟수
        _CompactInput(
          value: reps.toDouble(),
          unit: '회',
          step: 1,
          onChanged: (v) => onRepsChanged(v.toInt()),
          isInteger: true,
        ),
      ],
    );
  }
}

class _CompactInput extends StatelessWidget {
  final double value;
  final String unit;
  final double step;
  final ValueChanged<double> onChanged;
  final bool isInteger;

  const _CompactInput({
    required this.value,
    required this.unit,
    required this.step,
    required this.onChanged,
    this.isInteger = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _CompactButton(
          icon: Icons.remove,
          onTap: () => onChanged(value - step),
        ),
        const SizedBox(width: AppSpacing.sm),
        Container(
          constraints: const BoxConstraints(minWidth: 70),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isInteger
                    ? value.toInt().toString()
                    : (value == value.roundToDouble()
                        ? value.toInt().toString()
                        : value.toStringAsFixed(1)),
                style: AppTypography.h2.copyWith(
                  color: AppColors.darkText,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                unit,
                style: AppTypography.caption.copyWith(
                  color: AppColors.darkTextSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        _CompactButton(
          icon: Icons.add,
          onTap: () => onChanged(value + step),
        ),
      ],
    );
  }
}

class _CompactButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CompactButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.darkCardElevated,
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(
            icon,
            color: AppColors.darkText,
            size: 20,
          ),
        ),
      ),
    );
  }
}
