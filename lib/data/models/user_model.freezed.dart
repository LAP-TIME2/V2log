// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  String get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get nickname => throw _privateConstructorUsedError;
  String? get profileImageUrl => throw _privateConstructorUsedError;
  Gender? get gender => throw _privateConstructorUsedError;
  DateTime? get birthDate => throw _privateConstructorUsedError;
  double? get height => throw _privateConstructorUsedError;
  double? get weight => throw _privateConstructorUsedError;
  ExperienceLevel get experienceLevel => throw _privateConstructorUsedError;
  FitnessGoal get fitnessGoal => throw _privateConstructorUsedError;
  PreferredMode get preferredMode => throw _privateConstructorUsedError;
  String? get gymId => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call({
    String id,
    String email,
    String nickname,
    String? profileImageUrl,
    Gender? gender,
    DateTime? birthDate,
    double? height,
    double? weight,
    ExperienceLevel experienceLevel,
    FitnessGoal fitnessGoal,
    PreferredMode preferredMode,
    String? gymId,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? nickname = null,
    Object? profileImageUrl = freezed,
    Object? gender = freezed,
    Object? birthDate = freezed,
    Object? height = freezed,
    Object? weight = freezed,
    Object? experienceLevel = null,
    Object? fitnessGoal = null,
    Object? preferredMode = null,
    Object? gymId = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            nickname: null == nickname
                ? _value.nickname
                : nickname // ignore: cast_nullable_to_non_nullable
                      as String,
            profileImageUrl: freezed == profileImageUrl
                ? _value.profileImageUrl
                : profileImageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            gender: freezed == gender
                ? _value.gender
                : gender // ignore: cast_nullable_to_non_nullable
                      as Gender?,
            birthDate: freezed == birthDate
                ? _value.birthDate
                : birthDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            height: freezed == height
                ? _value.height
                : height // ignore: cast_nullable_to_non_nullable
                      as double?,
            weight: freezed == weight
                ? _value.weight
                : weight // ignore: cast_nullable_to_non_nullable
                      as double?,
            experienceLevel: null == experienceLevel
                ? _value.experienceLevel
                : experienceLevel // ignore: cast_nullable_to_non_nullable
                      as ExperienceLevel,
            fitnessGoal: null == fitnessGoal
                ? _value.fitnessGoal
                : fitnessGoal // ignore: cast_nullable_to_non_nullable
                      as FitnessGoal,
            preferredMode: null == preferredMode
                ? _value.preferredMode
                : preferredMode // ignore: cast_nullable_to_non_nullable
                      as PreferredMode,
            gymId: freezed == gymId
                ? _value.gymId
                : gymId // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserModelImplCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelImplCopyWith(
    _$UserModelImpl value,
    $Res Function(_$UserModelImpl) then,
  ) = __$$UserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String email,
    String nickname,
    String? profileImageUrl,
    Gender? gender,
    DateTime? birthDate,
    double? height,
    double? weight,
    ExperienceLevel experienceLevel,
    FitnessGoal fitnessGoal,
    PreferredMode preferredMode,
    String? gymId,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$UserModelImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelImpl>
    implements _$$UserModelImplCopyWith<$Res> {
  __$$UserModelImplCopyWithImpl(
    _$UserModelImpl _value,
    $Res Function(_$UserModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? nickname = null,
    Object? profileImageUrl = freezed,
    Object? gender = freezed,
    Object? birthDate = freezed,
    Object? height = freezed,
    Object? weight = freezed,
    Object? experienceLevel = null,
    Object? fitnessGoal = null,
    Object? preferredMode = null,
    Object? gymId = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$UserModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        nickname: null == nickname
            ? _value.nickname
            : nickname // ignore: cast_nullable_to_non_nullable
                  as String,
        profileImageUrl: freezed == profileImageUrl
            ? _value.profileImageUrl
            : profileImageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        gender: freezed == gender
            ? _value.gender
            : gender // ignore: cast_nullable_to_non_nullable
                  as Gender?,
        birthDate: freezed == birthDate
            ? _value.birthDate
            : birthDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        height: freezed == height
            ? _value.height
            : height // ignore: cast_nullable_to_non_nullable
                  as double?,
        weight: freezed == weight
            ? _value.weight
            : weight // ignore: cast_nullable_to_non_nullable
                  as double?,
        experienceLevel: null == experienceLevel
            ? _value.experienceLevel
            : experienceLevel // ignore: cast_nullable_to_non_nullable
                  as ExperienceLevel,
        fitnessGoal: null == fitnessGoal
            ? _value.fitnessGoal
            : fitnessGoal // ignore: cast_nullable_to_non_nullable
                  as FitnessGoal,
        preferredMode: null == preferredMode
            ? _value.preferredMode
            : preferredMode // ignore: cast_nullable_to_non_nullable
                  as PreferredMode,
        gymId: freezed == gymId
            ? _value.gymId
            : gymId // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserModelImpl implements _UserModel {
  const _$UserModelImpl({
    required this.id,
    required this.email,
    required this.nickname,
    this.profileImageUrl,
    this.gender,
    this.birthDate,
    this.height,
    this.weight,
    this.experienceLevel = ExperienceLevel.beginner,
    this.fitnessGoal = FitnessGoal.hypertrophy,
    this.preferredMode = PreferredMode.hybrid,
    this.gymId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory _$UserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserModelImplFromJson(json);

  @override
  final String id;
  @override
  final String email;
  @override
  final String nickname;
  @override
  final String? profileImageUrl;
  @override
  final Gender? gender;
  @override
  final DateTime? birthDate;
  @override
  final double? height;
  @override
  final double? weight;
  @override
  @JsonKey()
  final ExperienceLevel experienceLevel;
  @override
  @JsonKey()
  final FitnessGoal fitnessGoal;
  @override
  @JsonKey()
  final PreferredMode preferredMode;
  @override
  final String? gymId;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, nickname: $nickname, profileImageUrl: $profileImageUrl, gender: $gender, birthDate: $birthDate, height: $height, weight: $weight, experienceLevel: $experienceLevel, fitnessGoal: $fitnessGoal, preferredMode: $preferredMode, gymId: $gymId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.birthDate, birthDate) ||
                other.birthDate == birthDate) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.experienceLevel, experienceLevel) ||
                other.experienceLevel == experienceLevel) &&
            (identical(other.fitnessGoal, fitnessGoal) ||
                other.fitnessGoal == fitnessGoal) &&
            (identical(other.preferredMode, preferredMode) ||
                other.preferredMode == preferredMode) &&
            (identical(other.gymId, gymId) || other.gymId == gymId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    email,
    nickname,
    profileImageUrl,
    gender,
    birthDate,
    height,
    weight,
    experienceLevel,
    fitnessGoal,
    preferredMode,
    gymId,
    createdAt,
    updatedAt,
  );

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      __$$UserModelImplCopyWithImpl<_$UserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelImplToJson(this);
  }
}

abstract class _UserModel implements UserModel {
  const factory _UserModel({
    required final String id,
    required final String email,
    required final String nickname,
    final String? profileImageUrl,
    final Gender? gender,
    final DateTime? birthDate,
    final double? height,
    final double? weight,
    final ExperienceLevel experienceLevel,
    final FitnessGoal fitnessGoal,
    final PreferredMode preferredMode,
    final String? gymId,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$UserModelImpl;

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$UserModelImpl.fromJson;

  @override
  String get id;
  @override
  String get email;
  @override
  String get nickname;
  @override
  String? get profileImageUrl;
  @override
  Gender? get gender;
  @override
  DateTime? get birthDate;
  @override
  double? get height;
  @override
  double? get weight;
  @override
  ExperienceLevel get experienceLevel;
  @override
  FitnessGoal get fitnessGoal;
  @override
  PreferredMode get preferredMode;
  @override
  String? get gymId;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
