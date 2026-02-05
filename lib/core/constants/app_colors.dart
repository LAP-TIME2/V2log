import 'package:flutter/material.dart';

/// V2log 앱 컬러 팔레트
/// 다크 테마 기본
abstract class AppColors {
  // Primary - AI 모드 (인디고)
  static const primary50 = Color(0xFFEEF2FF);
  static const primary100 = Color(0xFFE0E7FF);
  static const primary200 = Color(0xFFC7D2FE);
  static const primary300 = Color(0xFFA5B4FC);
  static const primary400 = Color(0xFF818CF8);
  static const primary500 = Color(0xFF6366F1); // Main
  static const primary600 = Color(0xFF4F46E5);
  static const primary700 = Color(0xFF4338CA);
  static const primary800 = Color(0xFF3730A3);
  static const primary900 = Color(0xFF312E81);

  // Secondary - 자유 모드 (오렌지)
  static const secondary50 = Color(0xFFFFF7ED);
  static const secondary100 = Color(0xFFFFEDD5);
  static const secondary200 = Color(0xFFFED7AA);
  static const secondary300 = Color(0xFFFDBA74);
  static const secondary400 = Color(0xFFFB923C);
  static const secondary500 = Color(0xFFF97316); // Main
  static const secondary600 = Color(0xFFEA580C);
  static const secondary700 = Color(0xFFC2410C);
  static const secondary800 = Color(0xFF9A3412);
  static const secondary900 = Color(0xFF7C2D12);

  // Success - 완료, PR
  static const success = Color(0xFF22C55E);
  static const successLight = Color(0xFF4ADE80);
  static const successDark = Color(0xFF16A34A);

  // Warning
  static const warning = Color(0xFFF59E0B);
  static const warningLight = Color(0xFFFBBF24);
  static const warningDark = Color(0xFFD97706);

  // Error
  static const error = Color(0xFFEF4444);
  static const errorLight = Color(0xFFF87171);
  static const errorDark = Color(0xFFDC2626);

  // Info
  static const info = Color(0xFF3B82F6);
  static const infoLight = Color(0xFF60A5FA);
  static const infoDark = Color(0xFF2563EB);

  // 다크 테마 Neutral
  static const darkBg = Color(0xFF0F0F0F);
  static const darkCard = Color(0xFF1A1A1A);
  static const darkCardElevated = Color(0xFF242424);
  static const darkBorder = Color(0xFF2A2A2A);
  static const darkText = Color(0xFFFFFFFF);
  static const darkTextSecondary = Color(0xFFA1A1AA);
  static const darkTextTertiary = Color(0xFF71717A);

  // 라이트 테마 Neutral (추후 사용)
  static const lightBg = Color(0xFFFAFAFA);
  static const lightCard = Color(0xFFFFFFFF);
  static const lightCardElevated = Color(0xFFF4F4F5);
  static const lightBorder = Color(0xFFE4E4E7);
  static const lightText = Color(0xFF18181B);
  static const lightTextSecondary = Color(0xFF71717A);
  static const lightTextTertiary = Color(0xFFA1A1AA);

  // 근육 부위별 컬러
  static const muscleChest = Color(0xFFEF4444);
  static const muscleBack = Color(0xFF3B82F6);
  static const muscleShoulders = Color(0xFF8B5CF6);
  static const muscleBiceps = Color(0xFFF59E0B);
  static const muscleTriceps = Color(0xFF10B981);
  static const muscleLegs = Color(0xFFEC4899);
  static const muscleAbs = Color(0xFF6366F1);
  static const muscleGlutes = Color(0xFFF472B6);
  static const muscleCalves = Color(0xFF06B6D4);
  static const muscleTraps = Color(0xFF84CC16);
  static const muscleForearms = Color(0xFFA855F7);
  // 팔 (이두 + 삼두) - 보라색
  static const muscleArms = Color(0xFFA855F7);
  // 코어 - 핑크색
  static const muscleCore = Color(0xFFEC4899);

  // 세트 타입별 컬러
  static const setWarmup = Color(0xFF94A3B8);
  static const setWorking = Color(0xFF6366F1);
  static const setDrop = Color(0xFFF59E0B);
  static const setFailure = Color(0xFFEF4444);
  static const setSuperset = Color(0xFF8B5CF6);

  // 강도 존 컬러
  static const zoneMaxStrength = Color(0xFFEF4444);
  static const zoneStrength = Color(0xFFF97316);
  static const zoneHypertrophy = Color(0xFF22C55E);
  static const zoneEndurance = Color(0xFF3B82F6);
  static const zoneWarmup = Color(0xFF94A3B8);

  // Gradient
  static const primaryGradient = LinearGradient(
    colors: [primary600, primary700],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const secondaryGradient = LinearGradient(
    colors: [secondary500, secondary600],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const successGradient = LinearGradient(
    colors: [success, successDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
