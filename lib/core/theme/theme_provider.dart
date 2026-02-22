import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 테마 모드 StateNotifier
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.dark) {
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDark = prefs.getBool('is_dark_mode') ?? true;
      state = isDark ? ThemeMode.dark : ThemeMode.light;
    } catch (_) {
      // Error logged silently
    }
  }

  Future<void> toggle() async {
    final newMode =
        state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    state = newMode;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_dark_mode', newMode == ThemeMode.dark);
    } catch (_) {
      // Error logged silently
    }
  }

  bool get isDark => state == ThemeMode.dark;
}

/// 테마 모드 Provider
final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(),
);
