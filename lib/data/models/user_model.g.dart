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
      profileImageUrl: json['profileImageUrl'] as String?,
      gender: $enumDecodeNullable(_$GenderEnumMap, json['gender']),
      birthDate: json['birthDate'] == null
          ? null
          : DateTime.parse(json['birthDate'] as String),
      height: (json['height'] as num?)?.toDouble(),
      weight: (json['weight'] as num?)?.toDouble(),
      experienceLevel:
          $enumDecodeNullable(
            _$ExperienceLevelEnumMap,
            json['experienceLevel'],
          ) ??
          ExperienceLevel.beginner,
      fitnessGoal:
          $enumDecodeNullable(_$FitnessGoalEnumMap, json['fitnessGoal']) ??
          FitnessGoal.hypertrophy,
      preferredMode:
          $enumDecodeNullable(_$PreferredModeEnumMap, json['preferredMode']) ??
          PreferredMode.hybrid,
      gymId: json['gymId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'nickname': instance.nickname,
      'profileImageUrl': instance.profileImageUrl,
      'gender': _$GenderEnumMap[instance.gender],
      'birthDate': instance.birthDate?.toIso8601String(),
      'height': instance.height,
      'weight': instance.weight,
      'experienceLevel': _$ExperienceLevelEnumMap[instance.experienceLevel]!,
      'fitnessGoal': _$FitnessGoalEnumMap[instance.fitnessGoal]!,
      'preferredMode': _$PreferredModeEnumMap[instance.preferredMode]!,
      'gymId': instance.gymId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
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
  PreferredMode.ai: 'AI',
  PreferredMode.free: 'FREE',
  PreferredMode.hybrid: 'HYBRID',
};
