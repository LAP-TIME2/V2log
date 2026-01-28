import 'package:flutter/services.dart';

/// 햅틱 피드백 유틸리티
class AppHaptics {
  AppHaptics._();

  /// 가벼운 탭 피드백
  static Future<void> lightImpact() async {
    await HapticFeedback.lightImpact();
  }

  /// 중간 탭 피드백
  static Future<void> mediumImpact() async {
    await HapticFeedback.mediumImpact();
  }

  /// 강한 탭 피드백 (세트 완료 등)
  static Future<void> heavyImpact() async {
    await HapticFeedback.heavyImpact();
  }

  /// 선택 변경 피드백
  static Future<void> selectionClick() async {
    await HapticFeedback.selectionClick();
  }

  /// 성공 피드백 (PR 달성 등)
  static Future<void> success() async {
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.mediumImpact();
  }

  /// 에러 피드백
  static Future<void> error() async {
    await HapticFeedback.vibrate();
  }

  /// 경고 피드백 (타이머 종료 등)
  static Future<void> warning() async {
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.mediumImpact();
  }
}
