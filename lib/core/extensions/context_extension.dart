import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// BuildContext 확장
extension ContextExtension on BuildContext {
  // Theme shortcuts
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;

  // Media query shortcuts
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screenSize => mediaQuery.size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
  EdgeInsets get padding => mediaQuery.padding;
  EdgeInsets get viewInsets => mediaQuery.viewInsets;
  EdgeInsets get viewPadding => mediaQuery.viewPadding;
  double get statusBarHeight => padding.top;
  double get bottomSafeArea => padding.bottom;
  bool get isKeyboardVisible => viewInsets.bottom > 0;
  bool get isDarkMode => theme.brightness == Brightness.dark;

  // Theme-responsive color getters
  Color get bgColor => isDarkMode ? AppColors.darkBg : AppColors.lightBg;
  Color get cardColor => isDarkMode ? AppColors.darkCard : AppColors.lightCard;
  Color get cardElevatedColor => isDarkMode ? AppColors.darkCardElevated : AppColors.lightCardElevated;
  Color get borderColor => isDarkMode ? AppColors.darkBorder : AppColors.lightBorder;
  Color get textColor => isDarkMode ? AppColors.darkText : AppColors.lightText;
  Color get textSecondaryColor => isDarkMode ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
  Color get textTertiaryColor => isDarkMode ? AppColors.darkTextTertiary : AppColors.lightTextTertiary;

  // Screen size helpers
  bool get isSmallScreen => screenWidth < 360;
  bool get isMediumScreen => screenWidth >= 360 && screenWidth < 600;
  bool get isLargeScreen => screenWidth >= 600;
  bool get isTablet => screenWidth >= 600;

  // Navigation shortcuts (use GoRouter context.go/push/pop for route-based navigation)
  NavigatorState get navigator => Navigator.of(this);

  // Focus
  void unfocus() => FocusScope.of(this).unfocus();

  // Snackbar
  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: duration,
          action: action,
        ),
      );
  }

  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: colorScheme.error,
          duration: const Duration(seconds: 4),
        ),
      );
  }

  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
  }

  // Bottom sheet
  Future<T?> showBottomSheet<T>({
    required Widget child,
    bool isScrollControlled = true,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: this,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      builder: (_) => child,
    );
  }

  // Dialog
  Future<T?> showAlertDialog<T>({
    required String title,
    required String content,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return showDialog<T>(
      context: this,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          if (cancelText != null)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onCancel?.call();
              },
              child: Text(cancelText),
            ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm?.call();
            },
            child: Text(confirmText ?? '확인'),
          ),
        ],
      ),
    );
  }
}
