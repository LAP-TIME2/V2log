import 'package:flutter/material.dart';

/// 앱 전체 애니메이션 상수 및 유틸리티
class AnimationConfig {
  AnimationConfig._();

  // Duration 상수
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 400);
  static const Duration slower = Duration(milliseconds: 600);

  // Curve 상수
  static const Curve defaultCurve = Curves.easeOutCubic;
  static const Curve entryCurve = Curves.easeOut;
  static const Curve exitCurve = Curves.easeIn;
  static const Curve bounceCurve = Curves.elasticOut;

  // 스케일 탭 피드백
  static const double tapScale = 0.96;
  static const Duration tapDuration = Duration(milliseconds: 100);

  // 리스트 stagger (순차 등장)
  /// 처음 [maxAnimatedItems]개만 stagger 애니메이션 적용
  static const int maxAnimatedItems = 10;

  /// index에 따른 stagger 딜레이 계산
  static Duration staggerDelay(int index) {
    if (index >= maxAnimatedItems) return Duration.zero;
    return Duration(milliseconds: 50 * index);
  }

  /// 시스템 reduce-motion 설정 확인 (접근성)
  static bool shouldAnimate(BuildContext context) {
    return !MediaQuery.of(context).disableAnimations;
  }
}
