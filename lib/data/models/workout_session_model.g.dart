// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkoutSessionModelImpl _$$WorkoutSessionModelImplFromJson(
  Map<String, dynamic> json,
) => _$WorkoutSessionModelImpl(
  id: json['id'] as String,
  userId: json['userId'] as String,
  routineId: json['routineId'] as String?,
  sessionNumber: (json['sessionNumber'] as num?)?.toInt() ?? 1,
  mode: $enumDecode(_$WorkoutModeEnumMap, json['mode']),
  startedAt: DateTime.parse(json['startedAt'] as String),
  finishedAt: json['finishedAt'] == null
      ? null
      : DateTime.parse(json['finishedAt'] as String),
  isCancelled: json['isCancelled'] as bool? ?? false,
  totalVolume: (json['totalVolume'] as num?)?.toDouble(),
  totalSets: (json['totalSets'] as num?)?.toInt(),
  totalDurationSeconds: (json['totalDurationSeconds'] as num?)?.toInt(),
  caloriesBurned: (json['caloriesBurned'] as num?)?.toInt(),
  notes: json['notes'] as String?,
  moodRating: (json['moodRating'] as num?)?.toInt(),
  sets:
      (json['sets'] as List<dynamic>?)
          ?.map((e) => WorkoutSetModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$WorkoutSessionModelImplToJson(
  _$WorkoutSessionModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'routineId': instance.routineId,
  'sessionNumber': instance.sessionNumber,
  'mode': _$WorkoutModeEnumMap[instance.mode]!,
  'startedAt': instance.startedAt.toIso8601String(),
  'finishedAt': instance.finishedAt?.toIso8601String(),
  'isCancelled': instance.isCancelled,
  'totalVolume': instance.totalVolume,
  'totalSets': instance.totalSets,
  'totalDurationSeconds': instance.totalDurationSeconds,
  'caloriesBurned': instance.caloriesBurned,
  'notes': instance.notes,
  'moodRating': instance.moodRating,
  'sets': instance.sets,
  'createdAt': instance.createdAt?.toIso8601String(),
};

const _$WorkoutModeEnumMap = {WorkoutMode.ai: 'AI', WorkoutMode.free: 'FREE'};
