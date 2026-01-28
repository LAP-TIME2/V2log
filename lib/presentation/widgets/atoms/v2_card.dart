import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/utils/haptic_feedback.dart';

/// V2log 카드 위젯
class V2Card extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderRadius;
  final double? borderWidth;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool elevated;
  final bool hapticFeedback;

  const V2Card({
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.borderWidth,
    this.onTap,
    this.onLongPress,
    this.elevated = false,
    this.hapticFeedback = true,
    super.key,
  });

  /// 기본 카드
  factory V2Card.basic({
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    VoidCallback? onTap,
    Key? key,
  }) {
    return V2Card(
      padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
      margin: margin,
      onTap: onTap,
      key: key,
      child: child,
    );
  }

  /// 강조 카드 (elevated)
  factory V2Card.elevated({
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    VoidCallback? onTap,
    Key? key,
  }) {
    return V2Card(
      padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
      margin: margin,
      elevated: true,
      onTap: onTap,
      key: key,
      child: child,
    );
  }

  /// 테두리 카드
  factory V2Card.outlined({
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? borderColor,
    VoidCallback? onTap,
    Key? key,
  }) {
    return V2Card(
      padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
      margin: margin,
      backgroundColor: Colors.transparent,
      borderColor: borderColor ?? AppColors.darkBorder,
      borderWidth: 1,
      onTap: onTap,
      key: key,
      child: child,
    );
  }

  /// 선택 가능 카드 (모드 선택 등)
  factory V2Card.selectable({
    required Widget child,
    required bool isSelected,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? selectedColor,
    VoidCallback? onTap,
    Key? key,
  }) {
    return V2Card(
      padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
      margin: margin,
      backgroundColor: isSelected
          ? (selectedColor ?? AppColors.primary500).withValues(alpha: 0.1)
          : AppColors.darkCard,
      borderColor:
          isSelected ? (selectedColor ?? AppColors.primary500) : AppColors.darkBorder,
      borderWidth: isSelected ? 2 : 1,
      onTap: onTap,
      key: key,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = elevated
        ? AppColors.darkCardElevated
        : (backgroundColor ?? AppColors.darkCard);

    final effectiveBorderRadius = borderRadius ?? AppSpacing.radiusLg;

    Widget card = Container(
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        border: borderColor != null || borderWidth != null
            ? Border.all(
                color: borderColor ?? AppColors.darkBorder,
                width: borderWidth ?? 1,
              )
            : null,
      ),
      child: child,
    );

    if (onTap != null || onLongPress != null) {
      card = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap != null
              ? () {
                  if (hapticFeedback) AppHaptics.lightImpact();
                  onTap!();
                }
              : null,
          onLongPress: onLongPress != null
              ? () {
                  if (hapticFeedback) AppHaptics.mediumImpact();
                  onLongPress!();
                }
              : null,
          borderRadius: BorderRadius.circular(effectiveBorderRadius),
          child: card,
        ),
      );
    }

    return card;
  }
}

/// 그라데이션 카드 (모드 선택 카드용)
class V2GradientCard extends StatelessWidget {
  final Widget child;
  final List<Color> gradientColors;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final VoidCallback? onTap;
  final bool hapticFeedback;

  const V2GradientCard({
    required this.child,
    required this.gradientColors,
    this.padding,
    this.margin,
    this.borderRadius,
    this.onTap,
    this.hapticFeedback = true,
    super.key,
  });

  /// AI 모드 카드
  factory V2GradientCard.aiMode({
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    VoidCallback? onTap,
    Key? key,
  }) {
    return V2GradientCard(
      gradientColors: [AppColors.primary600, AppColors.primary700],
      padding: padding ?? const EdgeInsets.all(AppSpacing.xl),
      margin: margin,
      onTap: onTap,
      key: key,
      child: child,
    );
  }

  /// 자유 모드 카드
  factory V2GradientCard.freeMode({
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    VoidCallback? onTap,
    Key? key,
  }) {
    return V2GradientCard(
      gradientColors: [AppColors.secondary500, AppColors.secondary600],
      padding: padding ?? const EdgeInsets.all(AppSpacing.xl),
      margin: margin,
      onTap: onTap,
      key: key,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = borderRadius ?? AppSpacing.radiusLg;

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap != null
              ? () {
                  if (hapticFeedback) AppHaptics.mediumImpact();
                  onTap!();
                }
              : null,
          borderRadius: BorderRadius.circular(effectiveBorderRadius),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
            child: child,
          ),
        ),
      ),
    );
  }
}
