import 'package:freezed_annotation/freezed_annotation.dart';

import 'exercise_model.dart';
import 'user_model.dart';

part 'preset_routine_model.freezed.dart';
part 'preset_routine_model.g.dart';

/// 프리셋 루틴 모델 (전문가 큐레이션 루틴)
@freezed
class PresetRoutineModel with _$PresetRoutineModel {
  const PresetRoutineModel._();

  const factory PresetRoutineModel({
    required String id,
    required String name,
    String? nameEn,
    String? description,
    required ExperienceLevel difficulty,
    required FitnessGoal targetGoal,
    required int daysPerWeek,
    int? estimatedDurationMinutes,
    @Default([]) List<String> targetMuscles,
    @Default([]) List<String> equipmentRequired,
    String? thumbnailUrl,
    @Default(0) int popularityScore,
    @Default(false) bool isFeatured,
    @Default(true) bool isActive,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    // 연관 데이터 (조인 시 사용)
    @Default([]) List<PresetRoutineExerciseModel> exercises,
  }) = _PresetRoutineModel;

  factory PresetRoutineModel.fromJson(Map<String, dynamic> json) =>
      _$PresetRoutineModelFromJson(json);

  /// Day별로 그룹화된 운동 목록
  Map<int, List<PresetRoutineExerciseModel>> get exercisesByDay {
    final Map<int, List<PresetRoutineExerciseModel>> grouped = {};
    for (final exercise in exercises) {
      grouped.putIfAbsent(exercise.dayNumber, () => []);
      grouped[exercise.dayNumber]!.add(exercise);
    }
    // 각 Day 내에서 order_index로 정렬
    for (final day in grouped.keys) {
      grouped[day]!.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    }
    return grouped;
  }

  /// Day 이름 목록
  List<String> get dayNames {
    final names = <String>[];
    final byDay = exercisesByDay;
    for (int i = 1; i <= daysPerWeek; i++) {
      final exercises = byDay[i];
      if (exercises != null && exercises.isNotEmpty && exercises.first.dayName != null) {
        names.add(exercises.first.dayName!);
      } else {
        names.add('Day $i');
      }
    }
    return names;
  }

  /// 총 운동 개수
  int get totalExerciseCount => exercises.length;

  /// 난이도 라벨
  String get difficultyLabel => difficulty.label;

  /// 목표 라벨
  String get targetGoalLabel => targetGoal.label;
}

/// 프리셋 루틴 운동 연결 모델
@freezed
class PresetRoutineExerciseModel with _$PresetRoutineExerciseModel {
  const PresetRoutineExerciseModel._();

  const factory PresetRoutineExerciseModel({
    required String id,
    required String presetRoutineId,
    required String exerciseId,
    required int dayNumber,
    String? dayName,
    required int orderIndex,
    @Default(3) int targetSets,
    @Default('10-12') String targetReps,
    @Default(90) int restSeconds,
    String? notes,
    DateTime? createdAt,
    // 연관 데이터 (조인 시 사용)
    ExerciseModel? exercise,
  }) = _PresetRoutineExerciseModel;

  factory PresetRoutineExerciseModel.fromJson(Map<String, dynamic> json) =>
      _$PresetRoutineExerciseModelFromJson(json);

  /// 운동 이름 (exercise가 있으면 해당 이름, 없으면 null)
  String? get exerciseName => exercise?.name;

  /// 세트 x 반복 문자열
  String get setsRepsText => '$targetSets세트 x $targetReps';

  /// 휴식 시간 포맷 (분:초)
  String get restTimeFormatted {
    final minutes = restSeconds ~/ 60;
    final seconds = restSeconds % 60;
    if (minutes > 0) {
      return seconds > 0 ? '$minutes분 $seconds초' : '$minutes분';
    }
    return '$seconds초';
  }
}

/// 프리셋 루틴 필터
@freezed
class PresetRoutineFilter with _$PresetRoutineFilter {
  const factory PresetRoutineFilter({
    ExperienceLevel? difficulty,
    FitnessGoal? targetGoal,
    bool? isFeatured,
    String? searchQuery,
  }) = _PresetRoutineFilter;
}
