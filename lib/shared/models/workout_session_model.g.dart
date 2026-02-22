// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkoutSessionModelImpl _$$WorkoutSessionModelImplFromJson(
  Map<String, dynamic> json,
) => _$WorkoutSessionModelImpl(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  routineId: json['routine_id'] as String?,
  sessionNumber: (json['session_number'] as num?)?.toInt() ?? 1,
  mode: $enumDecode(_$WorkoutModeEnumMap, json['mode']),
  startedAt: DateTime.parse(json['started_at'] as String),
  finishedAt: json['finished_at'] == null
      ? null
      : DateTime.parse(json['finished_at'] as String),
  isCancelled: json['is_cancelled'] as bool? ?? false,
  totalVolume: (json['total_volume'] as num?)?.toDouble(),
  totalSets: (json['total_sets'] as num?)?.toInt(),
  totalDurationSeconds: (json['total_duration_seconds'] as num?)?.toInt(),
  caloriesBurned: (json['calories_burned'] as num?)?.toInt(),
  notes: json['notes'] as String?,
  moodRating: (json['mood_rating'] as num?)?.toInt(),
  sets:
      (json['sets'] as List<dynamic>?)
          ?.map((e) => WorkoutSetModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$$WorkoutSessionModelImplToJson(
  _$WorkoutSessionModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'routine_id': instance.routineId,
  'session_number': instance.sessionNumber,
  'mode': _$WorkoutModeEnumMap[instance.mode]!,
  'started_at': instance.startedAt.toIso8601String(),
  'finished_at': instance.finishedAt?.toIso8601String(),
  'is_cancelled': instance.isCancelled,
  'total_volume': instance.totalVolume,
  'total_sets': instance.totalSets,
  'total_duration_seconds': instance.totalDurationSeconds,
  'calories_burned': instance.caloriesBurned,
  'notes': instance.notes,
  'mood_rating': instance.moodRating,
  'sets': instance.sets.map((e) => e.toJson()).toList(),
  'created_at': instance.createdAt?.toIso8601String(),
};

const _$WorkoutModeEnumMap = {
  WorkoutMode.preset: 'PRESET',
  WorkoutMode.free: 'FREE',
};
