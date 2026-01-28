import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// 피트니스 계산 유틸리티
class FitnessCalculator {
  FitnessCalculator._();

  /// 1RM 계산 (Brzycki, Epley, Lander 공식 평균)
  /// [weight]: 사용한 무게 (kg)
  /// [reps]: 반복 횟수
  static double calculate1RM(double weight, int reps) {
    if (reps <= 0) return 0;
    if (reps == 1) return weight;
    if (reps > 30) {
      throw ArgumentError('반복 수가 너무 많습니다 (최대 30회)');
    }

    final brzycki = weight * (36 / (37 - reps));
    final epley = weight * (1 + reps / 30);
    final lander = (100 * weight) / (101.3 - 2.67123 * reps);

    return ((brzycki + epley + lander) / 3 * 10).round() / 10;
  }

  /// 목표 무게 계산 (1RM 기준 퍼센트)
  static double calculateTargetWeight(double oneRepMax, double percentage) {
    return (oneRepMax * percentage / 100 * 2).round() / 2; // 2.5kg 단위로 반올림
  }

  /// 볼륨 계산 (무게 x 반복 x 세트)
  static double calculateVolume({
    required double weight,
    required int reps,
    int sets = 1,
  }) {
    return weight * reps * sets;
  }

  /// 세트 리스트로 총 볼륨 계산
  static double calculateTotalVolume(List<SetData> sets) {
    return sets.fold(0.0, (sum, set) {
      return sum + (set.weight ?? 0) * (set.reps ?? 0);
    });
  }

  /// 강도 존 분석
  static IntensityZone analyzeIntensity(double weight, double estimated1RM) {
    if (estimated1RM <= 0) return IntensityZone.warmup;

    final percent = (weight / estimated1RM) * 100;

    if (percent >= 90) return IntensityZone.maxStrength;
    if (percent >= 80) return IntensityZone.strength;
    if (percent >= 65) return IntensityZone.hypertrophy;
    if (percent >= 50) return IntensityZone.endurance;
    return IntensityZone.warmup;
  }

  /// RPE를 퍼센트로 변환
  static double rpeToPercentage(double rpe) {
    // RPE 10 = 100%, RPE 6 = 약 75%
    const Map<int, double> rpeChart = {
      10: 100,
      9: 96,
      8: 93,
      7: 89,
      6: 86,
      5: 82,
    };

    final rounded = rpe.round();
    return rpeChart[rounded] ?? 85;
  }

  /// 예상 반복 횟수 계산 (무게와 1RM 기준)
  static int estimateReps(double weight, double oneRepMax) {
    if (oneRepMax <= 0 || weight <= 0) return 0;
    if (weight >= oneRepMax) return 1;

    final percentage = weight / oneRepMax;

    // Brzycki 공식 역산
    final reps = (37 - (36 * percentage)).round();
    return reps.clamp(1, 30);
  }

  /// BMI 계산
  static double calculateBMI(double weightKg, double heightCm) {
    final heightM = heightCm / 100;
    return weightKg / (heightM * heightM);
  }

  /// BMI 카테고리
  static BmiCategory getBmiCategory(double bmi) {
    if (bmi < 18.5) return BmiCategory.underweight;
    if (bmi < 23) return BmiCategory.normal;
    if (bmi < 25) return BmiCategory.overweight;
    return BmiCategory.obese;
  }

  /// 칼로리 소모 추정 (MET 기반)
  static double estimateCaloriesBurned({
    required double weightKg,
    required int durationMinutes,
    required double metValue,
  }) {
    // 칼로리 = MET x 체중(kg) x 시간(시)
    return metValue * weightKg * (durationMinutes / 60);
  }
}

/// 세트 데이터 (볼륨 계산용)
class SetData {
  final double? weight;
  final int? reps;

  const SetData({this.weight, this.reps});
}

/// 강도 존
enum IntensityZone {
  maxStrength('최대 근력', '1-3회', AppColors.zoneMaxStrength, 0.90),
  strength('근력 향상', '3-6회', AppColors.zoneStrength, 0.80),
  hypertrophy('근비대', '6-12회', AppColors.zoneHypertrophy, 0.65),
  endurance('근지구력', '12-20회', AppColors.zoneEndurance, 0.50),
  warmup('웜업', '15회 이상', AppColors.zoneWarmup, 0.0);

  final String label;
  final String suggestedReps;
  final Color color;
  final double minPercentage;

  const IntensityZone(
    this.label,
    this.suggestedReps,
    this.color,
    this.minPercentage,
  );
}

/// BMI 카테고리
enum BmiCategory {
  underweight('저체중', '18.5 미만'),
  normal('정상', '18.5 - 22.9'),
  overweight('과체중', '23 - 24.9'),
  obese('비만', '25 이상');

  final String label;
  final String range;

  const BmiCategory(this.label, this.range);
}

/// 운동 강도 (MET 값)
class ExerciseMet {
  static const double lightWeightTraining = 3.5;
  static const double moderateWeightTraining = 5.0;
  static const double vigorousWeightTraining = 6.0;
  static const double circuitTraining = 8.0;
}
