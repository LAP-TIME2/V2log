// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      nickname: json['nickname'] as String,
      profileImageUrl: json['profile_image_url'] as String?,
      gender: $enumDecodeNullable(_$GenderEnumMap, json['gender']),
      birthDate: json['birth_date'] == null
          ? null
          : DateTime.parse(json['birth_date'] as String),
      height: (json['height'] as num?)?.toDouble(),
      weight: (json['weight'] as num?)?.toDouble(),
      experienceLevel:
          $enumDecodeNullable(
            _$ExperienceLevelEnumMap,
            json['experience_level'],
          ) ??
          ExperienceLevel.beginner,
      fitnessGoal:
          $enumDecodeNullable(_$FitnessGoalEnumMap, json['fitness_goal']) ??
          FitnessGoal.hypertrophy,
      preferredMode:
          $enumDecodeNullable(_$PreferredModeEnumMap, json['preferred_mode']) ??
          PreferredMode.hybrid,
      gymId: json['gym_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'nickname': instance.nickname,
      'profile_image_url': instance.profileImageUrl,
      'gender': _$GenderEnumMap[instance.gender],
      'birth_date': instance.birthDate?.toIso8601String(),
      'height': instance.height,
      'weight': instance.weight,
      'experience_level': _$ExperienceLevelEnumMap[instance.experienceLevel]!,
      'fitness_goal': _$FitnessGoalEnumMap[instance.fitnessGoal]!,
      'preferred_mode': _$PreferredModeEnumMap[instance.preferredMode]!,
      'gym_id': instance.gymId,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$GenderEnumMap = {
  Gender.male: 'MALE',
  Gender.female: 'FEMALE',
  Gender.other: 'OTHER',
};

const _$ExperienceLevelEnumMap = {
  ExperienceLevel.beginner: 'BEGINNER',
  ExperienceLevel.intermediate: 'INTERMEDIATE',
  ExperienceLevel.advanced: 'ADVANCED',
};

const _$FitnessGoalEnumMap = {
  FitnessGoal.strength: 'STRENGTH',
  FitnessGoal.hypertrophy: 'HYPERTROPHY',
  FitnessGoal.endurance: 'ENDURANCE',
  FitnessGoal.weightLoss: 'WEIGHT_LOSS',
};

const _$PreferredModeEnumMap = {
  PreferredMode.preset: 'PRESET',
  PreferredMode.free: 'FREE',
  PreferredMode.hybrid: 'HYBRID',
};
