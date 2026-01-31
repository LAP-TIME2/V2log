// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExerciseModelImpl _$$ExerciseModelImplFromJson(Map<String, dynamic> json) =>
    _$ExerciseModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      nameEn: json['name_en'] as String?,
      category: $enumDecode(_$ExerciseCategoryEnumMap, json['category']),
      primaryMuscle: $enumDecode(_$MuscleGroupEnumMap, json['primary_muscle']),
      secondaryMuscles:
          (json['secondary_muscles'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$MuscleGroupEnumMap, e))
              .toList() ??
          const [],
      equipmentRequired:
          (json['equipment_required'] as List<dynamic>?)
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
      animationUrl: json['animation_url'] as String?,
      videoUrl: json['video_url'] as String?,
      thumbnailUrl: json['thumbnail_url'] as String?,
      caloriesPerMinute: (json['calories_per_minute'] as num?)?.toDouble(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$ExerciseModelImplToJson(_$ExerciseModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'name_en': instance.nameEn,
      'category': _$ExerciseCategoryEnumMap[instance.category]!,
      'primary_muscle': _$MuscleGroupEnumMap[instance.primaryMuscle]!,
      'secondary_muscles': instance.secondaryMuscles
          .map((e) => _$MuscleGroupEnumMap[e]!)
          .toList(),
      'equipment_required': instance.equipmentRequired,
      'difficulty': _$ExperienceLevelEnumMap[instance.difficulty]!,
      'instructions': instance.instructions,
      'tips': instance.tips,
      'animation_url': instance.animationUrl,
      'video_url': instance.videoUrl,
      'thumbnail_url': instance.thumbnailUrl,
      'calories_per_minute': instance.caloriesPerMinute,
      'created_at': instance.createdAt?.toIso8601String(),
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
  MuscleGroup.core: 'CORE',
  MuscleGroup.abs: 'ABS',
  MuscleGroup.obliques: 'OBLIQUES',
  MuscleGroup.quadriceps: 'QUADRICEPS',
  MuscleGroup.quads: 'QUADS',
  MuscleGroup.hamstrings: 'HAMSTRINGS',
  MuscleGroup.glutes: 'GLUTES',
  MuscleGroup.calves: 'CALVES',
  MuscleGroup.traps: 'TRAPS',
  MuscleGroup.lats: 'LATS',
  MuscleGroup.lowerBack: 'LOWER_BACK',
  MuscleGroup.rearDelts: 'REAR_DELTS',
  MuscleGroup.hipFlexors: 'HIP_FLEXORS',
  MuscleGroup.fullBody: 'FULL_BODY',
};

const _$ExperienceLevelEnumMap = {
  ExperienceLevel.beginner: 'BEGINNER',
  ExperienceLevel.intermediate: 'INTERMEDIATE',
  ExperienceLevel.advanced: 'ADVANCED',
};
