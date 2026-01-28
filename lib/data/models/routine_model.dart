import 'package:freezed_annotation/freezed_annotation.dart';

import 'exercise_model.dart';

part 'routine_model.freezed.dart';
part 'routine_model.g.dart';

/// 루틴 모델
@freezed
class RoutineModel with _$RoutineModel {
  const factory RoutineModel({
    required String id,
    required String userId,
    required String name,
    String? description,
    @Default(RoutineSourceType.custom) RoutineSourceType sourceType,
    @Default(false) bool isAiGenerated,
    @Default([]) List<MuscleGroup> targetMuscles,
    int? estimatedDuration,
    @Default(true) bool isActive,
    @Default([]) List<RoutineExerciseModel> exercises,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _RoutineModel;

  factory RoutineModel.fromJson(Map<String, dynamic> json) =>
      _$RoutineModelFromJson(json);
}

/// 루틴-운동 연결 모델
@freezed
class RoutineExerciseModel with _$RoutineExerciseModel {
  const factory RoutineExerciseModel({
    required String id,
    required String routineId,
    required String exerciseId,
    required int orderIndex,
    @Default(3) int targetSets,
    @Default('10-12') String targetReps,
    double? targetWeight,
    @Default(90) int restSeconds,
    String? notes,
    // 조인된 운동 정보 (선택적)
    ExerciseModel? exercise,
  }) = _RoutineExerciseModel;

  factory RoutineExerciseModel.fromJson(Map<String, dynamic> json) =>
      _$RoutineExerciseModelFromJson(json);
}

/// 루틴 소스 타입
@JsonEnum(valueField: 'value')
enum RoutineSourceType {
  ai('AI', 'AI 생성'),
  custom('CUSTOM', '직접 생성'),
  template('TEMPLATE', '템플릿');

  final String value;
  final String label;

  const RoutineSourceType(this.value, this.label);
}
