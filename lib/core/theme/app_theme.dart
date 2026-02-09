import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';
import '../constants/app_spacing.dart';

/// V2log 앱 테마 시스템
/// 다크 테마 기본
class AppTheme {
  AppTheme._();

  /// 다크 테마 (기본)
  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: AppTypography.fontFamily,

      // Colors
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary500,
        onPrimary: Colors.white,
        primaryContainer: AppColors.primary700,
        onPrimaryContainer: AppColors.primary100,
        secondary: AppColors.secondary500,
        onSecondary: Colors.white,
        secondaryContainer: AppColors.secondary700,
        onSecondaryContainer: AppColors.secondary100,
        surface: AppColors.darkCard,
        onSurface: AppColors.darkText,
        error: AppColors.error,
        onError: Colors.white,
      ),

      // Scaffold
      scaffoldBackgroundColor: AppColors.darkBg,

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkBg,
        foregroundColor: AppColors.darkText,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: AppTypography.h4.copyWith(color: AppColors.darkText),
        iconTheme: const IconThemeData(color: AppColors.darkText),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),

      // Card
      cardTheme: CardThemeData(
        color: AppColors.darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        margin: EdgeInsets.zero,
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary500,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(0, AppSpacing.buttonHeightLg),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          textStyle: AppTypography.button,
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary500,
          elevation: 0,
          minimumSize: const Size(0, AppSpacing.buttonHeightLg),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          side: const BorderSide(color: AppColors.primary500, width: 1.5),
          textStyle: AppTypography.button,
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary500,
          minimumSize: const Size(0, AppSpacing.buttonHeightMd),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          textStyle: AppTypography.button,
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkCard,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(color: AppColors.primary500, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.darkTextSecondary,
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.darkTextTertiary,
        ),
        errorStyle: AppTypography.caption.copyWith(color: AppColors.error),
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.darkCard,
        selectedColor: AppColors.primary500,
        disabledColor: AppColors.darkCard,
        labelStyle: AppTypography.labelMedium.copyWith(
          color: AppColors.darkText,
        ),
        secondaryLabelStyle: AppTypography.labelMedium.copyWith(
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          side: const BorderSide(color: AppColors.darkBorder),
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkCard,
        selectedItemColor: AppColors.primary500,
        unselectedItemColor: AppColors.darkTextTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),

      // Bottom Sheet
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.darkCard,
        modalBackgroundColor: AppColors.darkCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusXl),
          ),
        ),
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        ),
        titleTextStyle: AppTypography.h3.copyWith(color: AppColors.darkText),
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.darkTextSecondary,
        ),
      ),

      // Snack Bar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkCardElevated,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.darkText,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: AppColors.darkBorder,
        thickness: 1,
        space: 0,
      ),

      // Progress Indicator
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary500,
        linearTrackColor: AppColors.darkBorder,
        circularTrackColor: AppColors.darkBorder,
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          return AppColors.darkTextTertiary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary500;
          }
          return AppColors.darkBorder;
        }),
      ),

      // Slider
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.primary500,
        inactiveTrackColor: AppColors.darkBorder,
        thumbColor: AppColors.primary500,
        overlayColor: AppColors.primary500.withValues(alpha: 0.2),
        valueIndicatorColor: AppColors.primary500,
        valueIndicatorTextStyle: AppTypography.labelMedium.copyWith(
          color: Colors.white,
        ),
      ),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: AppTypography.display1.copyWith(color: AppColors.darkText),
        displayMedium: AppTypography.display2.copyWith(color: AppColors.darkText),
        headlineLarge: AppTypography.h1.copyWith(color: AppColors.darkText),
        headlineMedium: AppTypography.h2.copyWith(color: AppColors.darkText),
        headlineSmall: AppTypography.h3.copyWith(color: AppColors.darkText),
        titleLarge: AppTypography.h4.copyWith(color: AppColors.darkText),
        titleMedium: AppTypography.bodyLarge.copyWith(
          color: AppColors.darkText,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: AppTypography.bodyMedium.copyWith(
          color: AppColors.darkText,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: AppTypography.bodyLarge.copyWith(color: AppColors.darkText),
        bodyMedium: AppTypography.bodyMedium.copyWith(color: AppColors.darkText),
        bodySmall: AppTypography.bodySmall.copyWith(
          color: AppColors.darkTextSecondary,
        ),
        labelLarge: AppTypography.labelLarge.copyWith(color: AppColors.darkText),
        labelMedium: AppTypography.labelMedium.copyWith(color: AppColors.darkText),
        labelSmall: AppTypography.labelSmall.copyWith(
          color: AppColors.darkTextSecondary,
        ),
      ),
    );
  }

  /// 라이트 테마
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: AppTypography.fontFamily,

      // Colors
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary500,
        onPrimary: Colors.white,
        primaryContainer: AppColors.primary100,
        onPrimaryContainer: AppColors.primary700,
        secondary: AppColors.secondary500,
        onSecondary: Colors.white,
        secondaryContainer: AppColors.secondary100,
        onSecondaryContainer: AppColors.secondary700,
        surface: AppColors.lightCard,
        onSurface: AppColors.lightText,
        error: AppColors.error,
        onError: Colors.white,
      ),

      // Scaffold
      scaffoldBackgroundColor: AppColors.lightBg,

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightBg,
        foregroundColor: AppColors.lightText,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: AppTypography.h4.copyWith(color: AppColors.lightText),
        iconTheme: const IconThemeData(color: AppColors.lightText),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),

      // Card
      cardTheme: CardThemeData(
        color: AppColors.lightCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        margin: EdgeInsets.zero,
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary500,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(0, AppSpacing.buttonHeightLg),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          textStyle: AppTypography.button,
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary500,
          elevation: 0,
          minimumSize: const Size(0, AppSpacing.buttonHeightLg),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          side: const BorderSide(color: AppColors.primary500, width: 1.5),
          textStyle: AppTypography.button,
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary500,
          minimumSize: const Size(0, AppSpacing.buttonHeightMd),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          textStyle: AppTypography.button,
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightCard,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(color: AppColors.primary500, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.lightTextSecondary,
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.lightTextTertiary,
        ),
        errorStyle: AppTypography.caption.copyWith(color: AppColors.error),
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.lightCardElevated,
        selectedColor: AppColors.primary500,
        disabledColor: AppColors.lightCardElevated,
        labelStyle: AppTypography.labelMedium.copyWith(
          color: AppColors.lightText,
        ),
        secondaryLabelStyle: AppTypography.labelMedium.copyWith(
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          side: const BorderSide(color: AppColors.lightBorder),
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.lightCard,
        selectedItemColor: AppColors.primary500,
        unselectedItemColor: AppColors.lightTextTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),

      // Bottom Sheet
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.lightCard,
        modalBackgroundColor: AppColors.lightCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusXl),
          ),
        ),
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.lightCard,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        ),
        titleTextStyle: AppTypography.h3.copyWith(color: AppColors.lightText),
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.lightTextSecondary,
        ),
      ),

      // Snack Bar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.lightText,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.lightCard,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: AppColors.lightBorder,
        thickness: 1,
        space: 0,
      ),

      // Progress Indicator
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary500,
        linearTrackColor: AppColors.lightBorder,
        circularTrackColor: AppColors.lightBorder,
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          return AppColors.lightTextTertiary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary500;
          }
          return AppColors.lightBorder;
        }),
      ),

      // Slider
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.primary500,
        inactiveTrackColor: AppColors.lightBorder,
        thumbColor: AppColors.primary500,
        overlayColor: AppColors.primary500.withValues(alpha: 0.2),
        valueIndicatorColor: AppColors.primary500,
        valueIndicatorTextStyle: AppTypography.labelMedium.copyWith(
          color: Colors.white,
        ),
      ),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: AppTypography.display1.copyWith(color: AppColors.lightText),
        displayMedium: AppTypography.display2.copyWith(color: AppColors.lightText),
        headlineLarge: AppTypography.h1.copyWith(color: AppColors.lightText),
        headlineMedium: AppTypography.h2.copyWith(color: AppColors.lightText),
        headlineSmall: AppTypography.h3.copyWith(color: AppColors.lightText),
        titleLarge: AppTypography.h4.copyWith(color: AppColors.lightText),
        titleMedium: AppTypography.bodyLarge.copyWith(
          color: AppColors.lightText,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: AppTypography.bodyMedium.copyWith(
          color: AppColors.lightText,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: AppTypography.bodyLarge.copyWith(color: AppColors.lightText),
        bodyMedium: AppTypography.bodyMedium.copyWith(color: AppColors.lightText),
        bodySmall: AppTypography.bodySmall.copyWith(
          color: AppColors.lightTextSecondary,
        ),
        labelLarge: AppTypography.labelLarge.copyWith(color: AppColors.lightText),
        labelMedium: AppTypography.labelMedium.copyWith(color: AppColors.lightText),
        labelSmall: AppTypography.labelSmall.copyWith(
          color: AppColors.lightTextSecondary,
        ),
      ),
    );
  }
}
