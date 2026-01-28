import 'package:freezed_annotation/freezed_annotation.dart';

import 'workout_set_model.dart';

part 'workout_session_model.freezed.dart';
part 'workout_session_model.g.dart';

/// 운동 세션 모델
@freezed
class WorkoutSessionModel with _$WorkoutSessionModel {
  const WorkoutSessionModel._();

  const factory WorkoutSessionModel({
    required String id,
    required String userId,
    String? routineId,
    @Default(1) int sessionNumber,
    required WorkoutMode mode,
    required DateTime startedAt,
    DateTime? finishedAt,
    @Default(false) bool isCancelled,
    double? totalVolume,
    int? totalSets,
    int? totalDurationSeconds,
    int? caloriesBurned,
    String? notes,
    int? moodRating,
    @Default([]) List<WorkoutSetModel> sets,
    DateTime? createdAt,
  }) = _WorkoutSessionModel;

  factory WorkoutSessionModel.fromJson(Map<String, dynamic> json) =>
      _$WorkoutSessionModelFromJson(json);

  /// 세션이 진행 중인지 확인
  bool get isInProgress => finishedAt == null && !isCancelled;

  /// 세션이 완료되었는지 확인
  bool get isCompleted => finishedAt != null && !isCancelled;

  /// 운동 시간 (Duration)
  Duration? get duration {
    if (finishedAt == null) return null;
    return finishedAt!.difference(startedAt);
  }

  /// 현재까지 운동 시간 (진행 중일 때)
  Duration get currentDuration => DateTime.now().difference(startedAt);

  /// 운동별 세트 그룹화
  Map<String, List<WorkoutSetModel>> get setsByExercise {
    final map = <String, List<WorkoutSetModel>>{};
    for (final set in sets) {
      map.putIfAbsent(set.exerciseId, () => []).add(set);
    }
    return map;
  }

  /// 총 볼륨 계산
  double get calculatedVolume {
    return sets.fold(0.0, (sum, set) {
      return sum + (set.weight ?? 0) * (set.reps ?? 0);
    });
  }
}

/// 운동 모드
@JsonEnum(valueField: 'value')
enum WorkoutMode {
  ai('AI', 'AI 추천 모드'),
  free('FREE', '자유 기록 모드');

  final String value;
  final String label;

  const WorkoutMode(this.value, this.label);
}
