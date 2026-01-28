import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// 사용자 모델
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    required String nickname,
    String? profileImageUrl,
    Gender? gender,
    DateTime? birthDate,
    double? height,
    double? weight,
    @Default(ExperienceLevel.beginner) ExperienceLevel experienceLevel,
    @Default(FitnessGoal.hypertrophy) FitnessGoal fitnessGoal,
    @Default(PreferredMode.hybrid) PreferredMode preferredMode,
    String? gymId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

/// 성별
@JsonEnum(valueField: 'value')
enum Gender {
  male('MALE', '남성'),
  female('FEMALE', '여성'),
  other('OTHER', '기타');

  final String value;
  final String label;

  const Gender(this.value, this.label);
}

/// 운동 경험 수준
@JsonEnum(valueField: 'value')
enum ExperienceLevel {
  beginner('BEGINNER', '초급', '0-6개월'),
  intermediate('INTERMEDIATE', '중급', '6개월-2년'),
  advanced('ADVANCED', '고급', '2년 이상');

  final String value;
  final String label;
  final String description;

  const ExperienceLevel(this.value, this.label, this.description);
}

/// 피트니스 목표
@JsonEnum(valueField: 'value')
enum FitnessGoal {
  strength('STRENGTH', '근력 향상'),
  hypertrophy('HYPERTROPHY', '근비대'),
  endurance('ENDURANCE', '근지구력'),
  weightLoss('WEIGHT_LOSS', '체중 감량');

  final String value;
  final String label;

  const FitnessGoal(this.value, this.label);
}

/// 선호 모드
@JsonEnum(valueField: 'value')
enum PreferredMode {
  ai('AI', 'AI 추천'),
  free('FREE', '자유 기록'),
  hybrid('HYBRID', '혼합');

  final String value;
  final String label;

  const PreferredMode(this.value, this.label);
}
