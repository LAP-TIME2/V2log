// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExerciseModelImpl _$$ExerciseModelImplFromJson(Map<String, dynamic> json) =>
    _$ExerciseModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      nameEn: json['nameEn'] as String?,
      category: $enumDecode(_$ExerciseCategoryEnumMap, json['category']),
      primaryMuscle: $enumDecode(_$MuscleGroupEnumMap, json['primaryMuscle']),
      secondaryMuscles:
          (json['secondaryMuscles'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$MuscleGroupEnumMap, e))
              .toList() ??
          const [],
      equipmentRequired:
          (json['equipmentRequired'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      difficulty: $enumDecode(_$ExperienceLevelEnumMap, json['difficulty']),
      instructions:
          (json['instructions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      tips:
          (json['tips'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      animationUrl: json['animationUrl'] as String?,
      videoUrl: json['videoUrl'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      caloriesPerMinute: (json['caloriesPerMinute'] as num?)?.toDouble(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$ExerciseModelImplToJson(_$ExerciseModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'nameEn': instance.nameEn,
      'category': _$ExerciseCategoryEnumMap[instance.category]!,
      'primaryMuscle': _$MuscleGroupEnumMap[instance.primaryMuscle]!,
      'secondaryMuscles': instance.secondaryMuscles
          .map((e) => _$MuscleGroupEnumMap[e]!)
          .toList(),
      'equipmentRequired': instance.equipmentRequired,
      'difficulty': _$ExperienceLevelEnumMap[instance.difficulty]!,
      'instructions': instance.instructions,
      'tips': instance.tips,
      'animationUrl': instance.animationUrl,
      'videoUrl': instance.videoUrl,
      'thumbnailUrl': instance.thumbnailUrl,
      'caloriesPerMinute': instance.caloriesPerMinute,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

const _$ExerciseCategoryEnumMap = {
  ExerciseCategory.strength: 'STRENGTH',
  ExerciseCategory.cardio: 'CARDIO',
  ExerciseCategory.flexibility: 'FLEXIBILITY',
};

const _$MuscleGroupEnumMap = {
  MuscleGroup.chest: 'CHEST',
  MuscleGroup.back: 'BACK',
  MuscleGroup.shoulders: 'SHOULDERS',
  MuscleGroup.biceps: 'BICEPS',
  MuscleGroup.triceps: 'TRICEPS',
  MuscleGroup.forearms: 'FOREARMS',
  MuscleGroup.abs: 'ABS',
  MuscleGroup.obliques: 'OBLIQUES',
  MuscleGroup.quads: 'QUADS',
  MuscleGroup.hamstrings: 'HAMSTRINGS',
  MuscleGroup.glutes: 'GLUTES',
  MuscleGroup.calves: 'CALVES',
  MuscleGroup.traps: 'TRAPS',
  MuscleGroup.lats: 'LATS',
  MuscleGroup.lowerBack: 'LOWER_BACK',
  MuscleGroup.fullBody: 'FULL_BODY',
};

const _$ExperienceLevelEnumMap = {
  ExperienceLevel.beginner: 'BEGINNER',
  ExperienceLevel.intermediate: 'INTERMEDIATE',
  ExperienceLevel.advanced: 'ADVANCED',
};
