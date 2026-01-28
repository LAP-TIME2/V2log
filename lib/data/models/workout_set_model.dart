import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/constants/app_colors.dart';

part 'workout_set_model.freezed.dart';
part 'workout_set_model.g.dart';

/// 운동 세트 모델
@freezed
class WorkoutSetModel with _$WorkoutSetModel {
  const WorkoutSetModel._();

  const factory WorkoutSetModel({
    required String id,
    required String sessionId,
    required String exerciseId,
    required int setNumber,
    @Default(SetType.working) SetType setType,
    double? weight,
    int? reps,
    double? targetWeight,
    int? targetReps,
    double? rpe,
    int? restSeconds,
    @Default(false) bool isPr,
    String? notes,
    required DateTime completedAt,
  }) = _WorkoutSetModel;

  factory WorkoutSetModel.fromJson(Map<String, dynamic> json) =>
      _$WorkoutSetModelFromJson(json);

  /// 볼륨 계산 (무게 x 반복)
  double get volume => (weight ?? 0) * (reps ?? 0);

  /// 목표 달성 여부
  bool get isTargetMet {
    if (targetWeight == null || targetReps == null) return true;
    return (weight ?? 0) >= targetWeight! && (reps ?? 0) >= targetReps!;
  }

  /// 세트 완료 여부
  bool get isCompleted => weight != null && reps != null;
}

/// 세트 타입
@JsonEnum(valueField: 'value')
enum SetType {
  warmup('WARMUP', '웜업', AppColors.setWarmup),
  working('WORKING', '본세트', AppColors.setWorking),
  drop('DROP', '드롭세트', AppColors.setDrop),
  failure('FAILURE', '실패', AppColors.setFailure),
  superset('SUPERSET', '슈퍼세트', AppColors.setSuperset);

  final String value;
  final String label;
  final Color color;

  const SetType(this.value, this.label, this.color);
}

/// 운동별 기록 집계 모델 (1RM 추적)
@freezed
class ExerciseRecordModel with _$ExerciseRecordModel {
  const factory ExerciseRecordModel({
    required String id,
    required String userId,
    required String exerciseId,
    double? estimated1rm,
    double? maxWeight,
    int? maxReps,
    double? maxVolume,
    @Default(0) double totalVolume,
    @Default(0) int totalSets,
    DateTime? lastPerformedAt,
    required DateTime updatedAt,
  }) = _ExerciseRecordModel;

  factory ExerciseRecordModel.fromJson(Map<String, dynamic> json) =>
      _$ExerciseRecordModelFromJson(json);
}
