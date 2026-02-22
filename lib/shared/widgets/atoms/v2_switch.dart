import 'package:flutter/material.dart';

import 'package:v2log/core/constants/app_colors.dart';
import 'package:v2log/core/extensions/context_extension.dart';

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
    final isDark = context.isDarkMode;
    return Transform.scale(
      scale: 0.8,
      child: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: Colors.white,
        activeTrackColor: AppColors.primary500,
        inactiveThumbColor: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
        inactiveTrackColor: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
