import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';

/// 빠른 입력 컨트롤 (무게/횟수) - 휠 피커 방식
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
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        border: Border(
          top: BorderSide(color: AppColors.darkBorder, width: 1),
        ),
      ),
      child: Row(
        children: [
          // 무게 입력
          Expanded(
            child: _WeightInput(
              value: weight,
              onChanged: onWeightChanged,
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          // 횟수 입력
          Expanded(
            child: _RepsInput(
              value: reps,
              onChanged: onRepsChanged,
            ),
          ),
        ],
      ),
    );
  }
}

/// 무게 입력 위젯 - 휠 피커 + 좌우 버튼
class _WeightInput extends StatefulWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const _WeightInput({
    required this.value,
    required this.onChanged,
  });

  @override
  State<_WeightInput> createState() => _WeightInputState();
}

class _WeightInputState extends State<_WeightInput> {
  late FixedExtentScrollController _controller;
  late int _selectedValue;

  // 무게 범위: 0kg ~ 1000kg, 2.5kg 단위
  static const double minValue = 0;
  static const double maxValue = 1000;
  static const double step = 2.5;
  static const int itemCount = 401; // (1000 / 2.5) + 1

  @override
  void initState() {
    super.initState();
    _selectedValue = (widget.value / step).round().clamp(0, itemCount - 1);
    _controller = FixedExtentScrollController(initialItem: _selectedValue);
  }

  @override
  void didUpdateWidget(_WeightInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newValue = (widget.value / step).round().clamp(0, itemCount - 1);
    if (newValue != _selectedValue) {
      _selectedValue = newValue;
      _controller.animateToItem(
        _selectedValue,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateValue(int delta) {
    final newIndex = _selectedValue + delta;
    if (newIndex >= 0 && newIndex < itemCount) {
      setState(() {
        _selectedValue = newIndex;
      });
      _controller.animateToItem(
        _selectedValue,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
      widget.onChanged(_selectedValue * step);
      HapticFeedback.lightImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 라벨
        Text(
          '무게',
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.darkTextSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),

        // 휠 피커 + 좌우 버튼
        SizedBox(
          height: 80,
          child: Row(
            children: [
              // 왼쪽 버튼 세로
              _VerticalButtonColumn(
                topLabel: '-20',
                bottomLabel: '-10',
                topOnTap: () => _updateValue(-8), // 20 / 2.5 = 8
                bottomOnTap: () => _updateValue(-4), // 10 / 2.5 = 4
              ),
              const SizedBox(width: AppSpacing.sm),

              // 중앙 휠 피커
              Expanded(
                child: ListWheelScrollView.useDelegate(
                  controller: _controller,
                  itemExtent: 40,
                  perspective: 0.005,
                  diameterRatio: 1.5,
                  physics: const FixedExtentScrollPhysics(),
                  onSelectedItemChanged: (index) {
                    setState(() {
                      _selectedValue = index;
                    });
                    widget.onChanged(index * step);
                  },
                  childDelegate: ListWheelChildBuilderDelegate(
                    builder: (context, index) {
                      final value = (index * step);
                      final isSelected = index == _selectedValue;
                      return Center(
                        child: Text(
                          _formatValue(value),
                          style: AppTypography.h3.copyWith(
                            color: isSelected
                                ? AppColors.darkText
                                : AppColors.darkTextSecondary,
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w400,
                            fontSize: isSelected ? 20 : 16,
                          ),
                        ),
                      );
                    },
                    childCount: itemCount,
                  ),
                ),
              ),

              const SizedBox(width: AppSpacing.sm),

              // 오른쪽 버튼 세로
              _VerticalButtonColumn(
                topLabel: '+20',
                bottomLabel: '+10',
                topOnTap: () => _updateValue(8), // 20 / 2.5 = 8
                bottomOnTap: () => _updateValue(4), // 10 / 2.5 = 4
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.xs),

        // 단위 표시
        Text(
          'kg',
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.darkTextTertiary,
          ),
        ),
      ],
    );
  }

  String _formatValue(double val) {
    if (val == val.roundToDouble()) {
      return val.toInt().toString();
    }
    return val.toStringAsFixed(1);
  }
}

/// 횟수 입력 위젯 - 휠 피커 + 좌우 버튼
class _RepsInput extends StatefulWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const _RepsInput({
    required this.value,
    required this.onChanged,
  });

  @override
  State<_RepsInput> createState() => _RepsInputState();
}

class _RepsInputState extends State<_RepsInput> {
  late FixedExtentScrollController _controller;
  late int _selectedValue;

  // 횟수 범위: 1회 ~ 100회
  static const int minValue = 1;
  static const int maxValue = 100;
  static const int itemCount = 100;

  @override
  void initState() {
    super.initState();
    _selectedValue = (widget.value - minValue).clamp(0, itemCount - 1);
    _controller = FixedExtentScrollController(initialItem: _selectedValue);
  }

  @override
  void didUpdateWidget(_RepsInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newValue = (widget.value - minValue).clamp(0, itemCount - 1);
    if (newValue != _selectedValue) {
      _selectedValue = newValue;
      _controller.animateToItem(
        _selectedValue,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateValue(int delta) {
    final newIndex = _selectedValue + delta;
    if (newIndex >= 0 && newIndex < itemCount) {
      setState(() {
        _selectedValue = newIndex;
      });
      _controller.animateToItem(
        _selectedValue,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
      widget.onChanged(_selectedValue + minValue);
      HapticFeedback.lightImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 라벨
        Text(
          '횟수',
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.darkTextSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),

        // 휠 피커 + 좌우 버튼
        SizedBox(
          height: 80,
          child: Row(
            children: [
              // 왼쪽 버튼 세로
              _VerticalButtonColumn(
                topLabel: '-10',
                bottomLabel: '-5',
                topOnTap: () => _updateValue(-10),
                bottomOnTap: () => _updateValue(-5),
              ),
              const SizedBox(width: AppSpacing.sm),

              // 중앙 휠 피커
              Expanded(
                child: ListWheelScrollView.useDelegate(
                  controller: _controller,
                  itemExtent: 40,
                  perspective: 0.005,
                  diameterRatio: 1.5,
                  physics: const FixedExtentScrollPhysics(),
                  onSelectedItemChanged: (index) {
                    setState(() {
                      _selectedValue = index;
                    });
                    widget.onChanged(index + minValue);
                  },
                  childDelegate: ListWheelChildBuilderDelegate(
                    builder: (context, index) {
                      final value = index + minValue;
                      final isSelected = index == _selectedValue;
                      return Center(
                        child: Text(
                          '$value',
                          style: AppTypography.h3.copyWith(
                            color: isSelected
                                ? AppColors.darkText
                                : AppColors.darkTextSecondary,
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w400,
                            fontSize: isSelected ? 20 : 16,
                          ),
                        ),
                      );
                    },
                    childCount: itemCount,
                  ),
                ),
              ),

              const SizedBox(width: AppSpacing.sm),

              // 오른쪽 버튼 세로
              _VerticalButtonColumn(
                topLabel: '+10',
                bottomLabel: '+5',
                topOnTap: () => _updateValue(10),
                bottomOnTap: () => _updateValue(5),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.xs),

        // 단위 표시
        Text(
          '회',
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.darkTextTertiary,
          ),
        ),
      ],
    );
  }
}

/// 세로 버튼 컬럼 (위아래 2개 버튼)
class _VerticalButtonColumn extends StatelessWidget {
  final String topLabel;
  final String bottomLabel;
  final VoidCallback topOnTap;
  final VoidCallback bottomOnTap;

  const _VerticalButtonColumn({
    required this.topLabel,
    required this.bottomLabel,
    required this.topOnTap,
    required this.bottomOnTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _WheelButton(label: topLabel, onTap: topOnTap),
        const SizedBox(height: AppSpacing.xs),
        _WheelButton(label: bottomLabel, onTap: bottomOnTap),
      ],
    );
  }
}

/// 휠 피커용 작은 버튼
class _WheelButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _WheelButton({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.darkCardElevated,
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(6),
        child: Container(
          width: 36,
          height: 32,
          alignment: Alignment.center,
          child: Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.darkText,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ),
      ),
    );
  }
}
