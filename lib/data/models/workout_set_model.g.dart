// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_set_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkoutSetModelImpl _$$WorkoutSetModelImplFromJson(
  Map<String, dynamic> json,
) => _$WorkoutSetModelImpl(
  id: json['id'] as String,
  sessionId: json['sessionId'] as String,
  exerciseId: json['exerciseId'] as String,
  setNumber: (json['setNumber'] as num).toInt(),
  setType:
      $enumDecodeNullable(_$SetTypeEnumMap, json['setType']) ?? SetType.working,
  weight: (json['weight'] as num?)?.toDouble(),
  reps: (json['reps'] as num?)?.toInt(),
  targetWeight: (json['targetWeight'] as num?)?.toDouble(),
  targetReps: (json['targetReps'] as num?)?.toInt(),
  rpe: (json['rpe'] as num?)?.toDouble(),
  restSeconds: (json['restSeconds'] as num?)?.toInt(),
  isPr: json['isPr'] as bool? ?? false,
  notes: json['notes'] as String?,
  completedAt: DateTime.parse(json['completedAt'] as String),
);

Map<String, dynamic> _$$WorkoutSetModelImplToJson(
  _$WorkoutSetModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'sessionId': instance.sessionId,
  'exerciseId': instance.exerciseId,
  'setNumber': instance.setNumber,
  'setType': _$SetTypeEnumMap[instance.setType]!,
  'weight': instance.weight,
  'reps': instance.reps,
  'targetWeight': instance.targetWeight,
  'targetReps': instance.targetReps,
  'rpe': instance.rpe,
  'restSeconds': instance.restSeconds,
  'isPr': instance.isPr,
  'notes': instance.notes,
  'completedAt': instance.completedAt.toIso8601String(),
};

const _$SetTypeEnumMap = {
  SetType.warmup: 'WARMUP',
  SetType.working: 'WORKING',
  SetType.drop: 'DROP',
  SetType.failure: 'FAILURE',
  SetType.superset: 'SUPERSET',
};

_$ExerciseRecordModelImpl _$$ExerciseRecordModelImplFromJson(
  Map<String, dynamic> json,
) => _$ExerciseRecordModelImpl(
  id: json['id'] as String,
  userId: json['userId'] as String,
  exerciseId: json['exerciseId'] as String,
  estimated1rm: (json['estimated1rm'] as num?)?.toDouble(),
  maxWeight: (json['maxWeight'] as num?)?.toDouble(),
  maxReps: (json['maxReps'] as num?)?.toInt(),
  maxVolume: (json['maxVolume'] as num?)?.toDouble(),
  totalVolume: (json['totalVolume'] as num?)?.toDouble() ?? 0,
  totalSets: (json['totalSets'] as num?)?.toInt() ?? 0,
  lastPerformedAt: json['lastPerformedAt'] == null
      ? null
      : DateTime.parse(json['lastPerformedAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$ExerciseRecordModelImplToJson(
  _$ExerciseRecordModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'exerciseId': instance.exerciseId,
  'estimated1rm': instance.estimated1rm,
  'maxWeight': instance.maxWeight,
  'maxReps': instance.maxReps,
  'maxVolume': instance.maxVolume,
  'totalVolume': instance.totalVolume,
  'totalSets': instance.totalSets,
  'lastPerformedAt': instance.lastPerformedAt?.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};
