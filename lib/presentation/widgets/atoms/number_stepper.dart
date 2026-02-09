import 'package:flutter/material.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/extensions/context_extension.dart';
import '../../../core/utils/haptic_feedback.dart';

/// 숫자 스테퍼 (무게/횟수 조절용)
class NumberStepper extends StatelessWidget {
  final double value;
  final String unit;
  final double step;
  final double minValue;
  final double maxValue;
  final ValueChanged<double> onChanged;
  final List<double>? quickButtons;
  final int decimalPlaces;

  const NumberStepper({
    required this.value,
    required this.unit,
    required this.onChanged,
    this.step = 1,
    this.minValue = 0,
    this.maxValue = double.infinity,
    this.quickButtons,
    this.decimalPlaces = 1,
    super.key,
  });

  /// 무게 조절 스테퍼
  factory NumberStepper.weight({
    required double value,
    required ValueChanged<double> onChanged,
    double step = 2.5,
    double minValue = 0,
    double maxValue = 500,
    Key? key,
  }) {
    return NumberStepper(
      value: value,
      unit: 'kg',
      step: step,
      minValue: minValue,
      maxValue: maxValue,
      onChanged: onChanged,
      quickButtons: const [-2.5, 2.5],
      decimalPlaces: 1,
      key: key,
    );
  }

  /// 횟수 조절 스테퍼
  factory NumberStepper.reps({
    required int value,
    required ValueChanged<int> onChanged,
    int minValue = 1,
    int maxValue = 100,
    Key? key,
  }) {
    return NumberStepper(
      value: value.toDouble(),
      unit: '회',
      step: 1,
      minValue: minValue.toDouble(),
      maxValue: maxValue.toDouble(),
      onChanged: (v) => onChanged(v.toInt()),
      quickButtons: const [-1, 1],
      decimalPlaces: 0,
      key: key,
    );
  }

  /// 시간 조절 스테퍼 (초)
  factory NumberStepper.seconds({
    required int value,
    required ValueChanged<int> onChanged,
    int step = 15,
    int minValue = 0,
    int maxValue = 600,
    Key? key,
  }) {
    return NumberStepper(
      value: value.toDouble(),
      unit: '초',
      step: step.toDouble(),
      minValue: minValue.toDouble(),
      maxValue: maxValue.toDouble(),
      onChanged: (v) => onChanged(v.toInt()),
      quickButtons: const [-30, -15, 15, 30],
      decimalPlaces: 0,
      key: key,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 빠른 조절 버튼
        if (quickButtons != null && quickButtons!.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: quickButtons!.map((delta) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: _QuickButton(
                  label: _formatDelta(delta),
                  onTap: () => _handleChange(delta),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],

        // 현재 값 및 +/- 버튼
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 감소 버튼
            _StepButton(
              icon: Icons.remove,
              onTap: () => _handleChange(-step),
              enabled: value > minValue,
            ),
            const SizedBox(width: AppSpacing.lg),

            // 현재 값
            GestureDetector(
              onTap: _showInputDialog,
              child: Container(
                constraints: const BoxConstraints(minWidth: 100),
                child: Text(
                  '${_formatValue(value)} $unit',
                  style: AppTypography.h2.copyWith(
                    color: context.textColor,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            const SizedBox(width: AppSpacing.lg),

            // 증가 버튼
            _StepButton(
              icon: Icons.add,
              onTap: () => _handleChange(step),
              enabled: value < maxValue,
            ),
          ],
        ),
      ],
    );
  }

  void _handleChange(double delta) {
    final newValue = (value + delta).clamp(minValue, maxValue);
    if (newValue != value) {
      AppHaptics.lightImpact();
      onChanged(newValue);
    }
  }

  String _formatValue(double val) {
    if (decimalPlaces == 0) {
      return val.toInt().toString();
    }
    // 불필요한 소수점 제거
    if (val == val.roundToDouble()) {
      return val.toInt().toString();
    }
    return val.toStringAsFixed(decimalPlaces);
  }

  String _formatDelta(double delta) {
    final prefix = delta > 0 ? '+' : '';
    if (delta == delta.roundToDouble()) {
      return '$prefix${delta.toInt()}';
    }
    return '$prefix${delta.toStringAsFixed(1)}';
  }

  void _showInputDialog() {
    // TODO: 직접 입력 다이얼로그
  }
}

/// 빠른 조절 버튼
class _QuickButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _QuickButton({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.cardColor,
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Text(
            label,
            style: AppTypography.labelMedium.copyWith(
              color: context.textSecondaryColor,
            ),
          ),
        ),
      ),
    );
  }
}

/// +/- 버튼
class _StepButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;

  const _StepButton({
    required this.icon,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: enabled ? context.cardColor : context.cardColor.withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: enabled
                ? context.textColor
                : context.textTertiaryColor,
            size: 24,
          ),
        ),
      ),
    );
  }
}

/// 컴팩트 숫자 스테퍼 (세트 행 내 사용)
class CompactNumberStepper extends StatelessWidget {
  final double value;
  final String unit;
  final double step;
  final ValueChanged<double> onChanged;
  final int decimalPlaces;

  const CompactNumberStepper({
    required this.value,
    required this.unit,
    required this.onChanged,
    this.step = 1,
    this.decimalPlaces = 0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _CompactButton(
          icon: Icons.remove,
          onTap: () {
            AppHaptics.lightImpact();
            onChanged(value - step);
          },
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          _formatValue(),
          style: AppTypography.bodyLarge.copyWith(
            color: context.textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          unit,
          style: AppTypography.bodySmall.copyWith(
            color: context.textSecondaryColor,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        _CompactButton(
          icon: Icons.add,
          onTap: () {
            AppHaptics.lightImpact();
            onChanged(value + step);
          },
        ),
      ],
    );
  }

  String _formatValue() {
    if (decimalPlaces == 0 || value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(decimalPlaces);
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
      color: context.borderColor,
      borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
        child: SizedBox(
          width: 28,
          height: 28,
          child: Icon(
            icon,
            color: context.textColor,
            size: 16,
          ),
        ),
      ),
    );
  }
}
