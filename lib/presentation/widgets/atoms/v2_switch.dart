import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';

/// V2 스타일 스위치 위젯
class V2Switch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const V2Switch({
    required this.value,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 0.8,
      child: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary500,
        activeTrackColor: AppColors.primary500.withValues(alpha: 0.5),
        inactiveThumbColor: AppColors.darkTextTertiary,
        inactiveTrackColor: AppColors.darkBorder,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
