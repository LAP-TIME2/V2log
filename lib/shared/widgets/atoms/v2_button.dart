import 'package:flutter/material.dart';

import 'package:v2log/core/constants/app_colors.dart';
import 'package:v2log/core/constants/app_spacing.dart';
import 'package:v2log/core/constants/app_typography.dart';
import 'package:v2log/core/extensions/context_extension.dart';
import 'package:v2log/core/utils/haptic_feedback.dart';

/// V2log 기본 버튼
class V2Button extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool fullWidth;
  final V2ButtonVariant variant;
  final V2ButtonSize size;
  final bool isLoading;
  final bool hapticFeedback;

  const V2Button({
    required this.text,
    this.icon,
    this.onPressed,
    this.fullWidth = false,
    this.variant = V2ButtonVariant.primary,
    this.size = V2ButtonSize.large,
    this.isLoading = false,
    this.hapticFeedback = true,
    super.key,
  });

  /// Primary 버튼 팩토리
  factory V2Button.primary({
    required String text,
    IconData? icon,
    VoidCallback? onPressed,
    bool fullWidth = false,
    V2ButtonSize size = V2ButtonSize.large,
    bool isLoading = false,
    Key? key,
  }) {
    return V2Button(
      text: text,
      icon: icon,
      onPressed: onPressed,
      fullWidth: fullWidth,
      variant: V2ButtonVariant.primary,
      size: size,
      isLoading: isLoading,
      key: key,
    );
  }

  /// Secondary 버튼 팩토리
  factory V2Button.secondary({
    required String text,
    IconData? icon,
    VoidCallback? onPressed,
    bool fullWidth = false,
    V2ButtonSize size = V2ButtonSize.large,
    bool isLoading = false,
    Key? key,
  }) {
    return V2Button(
      text: text,
      icon: icon,
      onPressed: onPressed,
      fullWidth: fullWidth,
      variant: V2ButtonVariant.secondary,
      size: size,
      isLoading: isLoading,
      key: key,
    );
  }

  /// Outline 버튼 팩토리
  factory V2Button.outline({
    required String text,
    IconData? icon,
    VoidCallback? onPressed,
    bool fullWidth = false,
    V2ButtonSize size = V2ButtonSize.large,
    bool isLoading = false,
    Key? key,
  }) {
    return V2Button(
      text: text,
      icon: icon,
      onPressed: onPressed,
      fullWidth: fullWidth,
      variant: V2ButtonVariant.outline,
      size: size,
      isLoading: isLoading,
      key: key,
    );
  }

  /// Ghost 버튼 팩토리
  factory V2Button.ghost({
    required String text,
    IconData? icon,
    VoidCallback? onPressed,
    bool fullWidth = false,
    V2ButtonSize size = V2ButtonSize.medium,
    bool isLoading = false,
    Key? key,
  }) {
    return V2Button(
      text: text,
      icon: icon,
      onPressed: onPressed,
      fullWidth: fullWidth,
      variant: V2ButtonVariant.ghost,
      size: size,
      isLoading: isLoading,
      key: key,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: size.height,
      child: _buildButton(context),
    );
  }

  Widget _buildButton(BuildContext context) {
    final isDisabled = onPressed == null || isLoading;
    final isDark = context.isDarkMode;

    switch (variant) {
      case V2ButtonVariant.primary:
      case V2ButtonVariant.secondary:
        return ElevatedButton(
          onPressed: isDisabled ? null : _handlePress,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                isDisabled ? variant.backgroundColor.withValues(alpha: 0.5) : variant.backgroundColor,
            foregroundColor: variant.foregroundColor,
            elevation: 0,
            padding: EdgeInsets.symmetric(horizontal: size.horizontalPadding),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
          ),
          child: _buildContent(),
        );

      case V2ButtonVariant.outline:
        return OutlinedButton(
          onPressed: isDisabled ? null : _handlePress,
          style: OutlinedButton.styleFrom(
            foregroundColor: variant.foregroundColor,
            elevation: 0,
            padding: EdgeInsets.symmetric(horizontal: size.horizontalPadding),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            side: BorderSide(
              color: isDisabled
                  ? variant.foregroundColor.withValues(alpha: 0.5)
                  : variant.foregroundColor,
              width: 1.5,
            ),
          ),
          child: _buildContent(),
        );

      case V2ButtonVariant.ghost:
        final ghostForeground = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
        return TextButton(
          onPressed: isDisabled ? null : _handlePress,
          style: TextButton.styleFrom(
            foregroundColor: ghostForeground,
            padding: EdgeInsets.symmetric(horizontal: size.horizontalPadding),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
          ),
          child: _buildContent(isDark: isDark),
        );
    }
  }

  Widget _buildContent({bool isDark = true}) {
    final effectiveForeground = variant == V2ButtonVariant.ghost
        ? (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)
        : variant.foregroundColor;

    if (isLoading) {
      return SizedBox(
        width: size.iconSize,
        height: size.iconSize,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation(effectiveForeground),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: size.iconSize),
          SizedBox(width: AppSpacing.sm),
        ],
        Text(
          text,
          style: size.textStyle.copyWith(color: effectiveForeground),
        ),
      ],
    );
  }

  void _handlePress() {
    if (hapticFeedback) {
      AppHaptics.lightImpact();
    }
    onPressed?.call();
  }
}

/// 버튼 변형
enum V2ButtonVariant {
  primary(AppColors.primary500, Colors.white),
  secondary(AppColors.secondary500, Colors.white),
  outline(Colors.transparent, AppColors.primary500),
  ghost(Colors.transparent, AppColors.darkTextSecondary);

  final Color backgroundColor;
  final Color foregroundColor;

  const V2ButtonVariant(this.backgroundColor, this.foregroundColor);
}

/// 버튼 크기
enum V2ButtonSize {
  small(AppSpacing.buttonHeightSm, AppSpacing.lg, AppSpacing.iconSm, AppTypography.labelMedium),
  medium(AppSpacing.buttonHeightMd, AppSpacing.xl, AppSpacing.iconMd, AppTypography.labelLarge),
  large(AppSpacing.buttonHeightLg, AppSpacing.xxl, AppSpacing.iconLg, AppTypography.buttonLarge);

  final double height;
  final double horizontalPadding;
  final double iconSize;
  final TextStyle textStyle;

  const V2ButtonSize(
    this.height,
    this.horizontalPadding,
    this.iconSize,
    this.textStyle,
  );
}

/// 아이콘 버튼
class V2IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? backgroundColor;
  final double size;
  final bool hapticFeedback;

  const V2IconButton({
    required this.icon,
    this.onPressed,
    this.color,
    this.backgroundColor,
    this.size = 48,
    this.hapticFeedback = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final defaultColor = isDark ? AppColors.darkText : AppColors.lightText;

    return Material(
      color: backgroundColor ?? Colors.transparent,
      borderRadius: BorderRadius.circular(size / 2),
      child: InkWell(
        onTap: onPressed != null
            ? () {
                if (hapticFeedback) AppHaptics.lightImpact();
                onPressed?.call();
              }
            : null,
        borderRadius: BorderRadius.circular(size / 2),
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(
            icon,
            color: color ?? defaultColor,
            size: size * 0.5,
          ),
        ),
      ),
    );
  }
}
