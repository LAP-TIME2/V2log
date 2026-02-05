import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/constants/app_colors.dart';
import 'user_model.dart';

part 'exercise_model.freezed.dart';
part 'exercise_model.g.dart';

/// 운동 모델
@freezed
class ExerciseModel with _$ExerciseModel {
  const factory ExerciseModel({
    required String id,
    required String name,
    String? nameEn,
    required ExerciseCategory category,
    required MuscleGroup primaryMuscle,
    @Default([]) List<MuscleGroup> secondaryMuscles,
    @Default([]) List<String> equipmentRequired,
    required ExperienceLevel difficulty,
    @Default([]) List<String> instructions,
    @Default([]) List<String> tips,
    String? animationUrl,
    String? videoUrl,
    String? thumbnailUrl,
    double? caloriesPerMinute,
    DateTime? createdAt,
  }) = _ExerciseModel;

  factory ExerciseModel.fromJson(Map<String, dynamic> json) =>
      _$ExerciseModelFromJson(json);
}

/// 운동 카테고리
@JsonEnum(valueField: 'value')
enum ExerciseCategory {
  strength('STRENGTH', '근력'),
  cardio('CARDIO', '유산소'),
  flexibility('FLEXIBILITY', '유연성');

  final String value;
  final String label;

  const ExerciseCategory(this.value, this.label);
}

/// 근육 그룹
@JsonEnum(valueField: 'value')
enum MuscleGroup {
  chest('CHEST', '가슴', AppColors.muscleChest),
  back('BACK', '등', AppColors.muscleBack),
  shoulders('SHOULDERS', '어깨', AppColors.muscleShoulders),
  biceps('BICEPS', '이두', AppColors.muscleBiceps),
  triceps('TRICEPS', '삼두', AppColors.muscleTriceps),
  forearms('FOREARMS', '전완', AppColors.muscleForearms),
  core('CORE', '코어', AppColors.muscleAbs),
  abs('ABS', '복근', AppColors.muscleAbs),
  obliques('OBLIQUES', '옆구리', AppColors.muscleAbs),
  quadriceps('QUADRICEPS', '대퇴사두', AppColors.muscleLegs),
  quads('QUADS', '대퇴사두', AppColors.muscleLegs),
  hamstrings('HAMSTRINGS', '햄스트링', AppColors.muscleLegs),
  glutes('GLUTES', '둔근', AppColors.muscleGlutes),
  calves('CALVES', '종아리', AppColors.muscleCalves),
  traps('TRAPS', '승모근', AppColors.muscleTraps),
  lats('LATS', '광배근', AppColors.muscleBack),
  lowerBack('LOWER_BACK', '하부 등', AppColors.muscleBack),
  rearDelts('REAR_DELTS', '후면 삼각근', AppColors.muscleShoulders),
  hipFlexors('HIP_FLEXORS', '고관절 굴곡근', AppColors.muscleLegs),
  legs('LEGS', '하체', AppColors.muscleLegs),
  fullBody('FULL_BODY', '전신', AppColors.primary500);

  final String value;
  final String label;
  final Color color;

  const MuscleGroup(this.value, this.label, this.color);
}
