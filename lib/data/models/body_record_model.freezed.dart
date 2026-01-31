// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'body_record_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BodyRecordModel _$BodyRecordModelFromJson(Map<String, dynamic> json) {
  return _BodyRecordModel.fromJson(json);
}

/// @nodoc
mixin _$BodyRecordModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  double? get weight => throw _privateConstructorUsedError;
  double? get bodyFatPercentage => throw _privateConstructorUsedError;
  double? get muscleMass => throw _privateConstructorUsedError;
  double? get skeletalMuscleMass => throw _privateConstructorUsedError;
  double? get bmi => throw _privateConstructorUsedError;
  double? get chest => throw _privateConstructorUsedError;
  double? get waist => throw _privateConstructorUsedError;
  double? get hip => throw _privateConstructorUsedError;
  double? get thigh => throw _privateConstructorUsedError;
  double? get arm => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String? get photoUrl => throw _privateConstructorUsedError;
  DateTime get recordedAt => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this BodyRecordModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BodyRecordModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BodyRecordModelCopyWith<BodyRecordModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BodyRecordModelCopyWith<$Res> {
  factory $BodyRecordModelCopyWith(
    BodyRecordModel value,
    $Res Function(BodyRecordModel) then,
  ) = _$BodyRecordModelCopyWithImpl<$Res, BodyRecordModel>;
  @useResult
  $Res call({
    String id,
    String userId,
    double? weight,
    double? bodyFatPercentage,
    double? muscleMass,
    double? skeletalMuscleMass,
    double? bmi,
    double? chest,
    double? waist,
    double? hip,
    double? thigh,
    double? arm,
    String? notes,
    String? photoUrl,
    DateTime recordedAt,
    DateTime? createdAt,
  });
}

/// @nodoc
class _$BodyRecordModelCopyWithImpl<$Res, $Val extends BodyRecordModel>
    implements $BodyRecordModelCopyWith<$Res> {
  _$BodyRecordModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BodyRecordModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? weight = freezed,
    Object? bodyFatPercentage = freezed,
    Object? muscleMass = freezed,
    Object? skeletalMuscleMass = freezed,
    Object? bmi = freezed,
    Object? chest = freezed,
    Object? waist = freezed,
    Object? hip = freezed,
    Object? thigh = freezed,
    Object? arm = freezed,
    Object? notes = freezed,
    Object? photoUrl = freezed,
    Object? recordedAt = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            weight: freezed == weight
                ? _value.weight
                : weight // ignore: cast_nullable_to_non_nullable
                      as double?,
            bodyFatPercentage: freezed == bodyFatPercentage
                ? _value.bodyFatPercentage
                : bodyFatPercentage // ignore: cast_nullable_to_non_nullable
                      as double?,
            muscleMass: freezed == muscleMass
                ? _value.muscleMass
                : muscleMass // ignore: cast_nullable_to_non_nullable
                      as double?,
            skeletalMuscleMass: freezed == skeletalMuscleMass
                ? _value.skeletalMuscleMass
                : skeletalMuscleMass // ignore: cast_nullable_to_non_nullable
                      as double?,
            bmi: freezed == bmi
                ? _value.bmi
                : bmi // ignore: cast_nullable_to_non_nullable
                      as double?,
            chest: freezed == chest
                ? _value.chest
                : chest // ignore: cast_nullable_to_non_nullable
                      as double?,
            waist: freezed == waist
                ? _value.waist
                : waist // ignore: cast_nullable_to_non_nullable
                      as double?,
            hip: freezed == hip
                ? _value.hip
                : hip // ignore: cast_nullable_to_non_nullable
                      as double?,
            thigh: freezed == thigh
                ? _value.thigh
                : thigh // ignore: cast_nullable_to_non_nullable
                      as double?,
            arm: freezed == arm
                ? _value.arm
                : arm // ignore: cast_nullable_to_non_nullable
                      as double?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            photoUrl: freezed == photoUrl
                ? _value.photoUrl
                : photoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            recordedAt: null == recordedAt
                ? _value.recordedAt
                : recordedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BodyRecordModelImplCopyWith<$Res>
    implements $BodyRecordModelCopyWith<$Res> {
  factory _$$BodyRecordModelImplCopyWith(
    _$BodyRecordModelImpl value,
    $Res Function(_$BodyRecordModelImpl) then,
  ) = __$$BodyRecordModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    double? weight,
    double? bodyFatPercentage,
    double? muscleMass,
    double? skeletalMuscleMass,
    double? bmi,
    double? chest,
    double? waist,
    double? hip,
    double? thigh,
    double? arm,
    String? notes,
    String? photoUrl,
    DateTime recordedAt,
    DateTime? createdAt,
  });
}

/// @nodoc
class __$$BodyRecordModelImplCopyWithImpl<$Res>
    extends _$BodyRecordModelCopyWithImpl<$Res, _$BodyRecordModelImpl>
    implements _$$BodyRecordModelImplCopyWith<$Res> {
  __$$BodyRecordModelImplCopyWithImpl(
    _$BodyRecordModelImpl _value,
    $Res Function(_$BodyRecordModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BodyRecordModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? weight = freezed,
    Object? bodyFatPercentage = freezed,
    Object? muscleMass = freezed,
    Object? skeletalMuscleMass = freezed,
    Object? bmi = freezed,
    Object? chest = freezed,
    Object? waist = freezed,
    Object? hip = freezed,
    Object? thigh = freezed,
    Object? arm = freezed,
    Object? notes = freezed,
    Object? photoUrl = freezed,
    Object? recordedAt = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$BodyRecordModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        weight: freezed == weight
            ? _value.weight
            : weight // ignore: cast_nullable_to_non_nullable
                  as double?,
        bodyFatPercentage: freezed == bodyFatPercentage
            ? _value.bodyFatPercentage
            : bodyFatPercentage // ignore: cast_nullable_to_non_nullable
                  as double?,
        muscleMass: freezed == muscleMass
            ? _value.muscleMass
            : muscleMass // ignore: cast_nullable_to_non_nullable
                  as double?,
        skeletalMuscleMass: freezed == skeletalMuscleMass
            ? _value.skeletalMuscleMass
            : skeletalMuscleMass // ignore: cast_nullable_to_non_nullable
                  as double?,
        bmi: freezed == bmi
            ? _value.bmi
            : bmi // ignore: cast_nullable_to_non_nullable
                  as double?,
        chest: freezed == chest
            ? _value.chest
            : chest // ignore: cast_nullable_to_non_nullable
                  as double?,
        waist: freezed == waist
            ? _value.waist
            : waist // ignore: cast_nullable_to_non_nullable
                  as double?,
        hip: freezed == hip
            ? _value.hip
            : hip // ignore: cast_nullable_to_non_nullable
                  as double?,
        thigh: freezed == thigh
            ? _value.thigh
            : thigh // ignore: cast_nullable_to_non_nullable
                  as double?,
        arm: freezed == arm
            ? _value.arm
            : arm // ignore: cast_nullable_to_non_nullable
                  as double?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        photoUrl: freezed == photoUrl
            ? _value.photoUrl
            : photoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        recordedAt: null == recordedAt
            ? _value.recordedAt
            : recordedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BodyRecordModelImpl extends _BodyRecordModel {
  const _$BodyRecordModelImpl({
    required this.id,
    required this.userId,
    this.weight,
    this.bodyFatPercentage,
    this.muscleMass,
    this.skeletalMuscleMass,
    this.bmi,
    this.chest,
    this.waist,
    this.hip,
    this.thigh,
    this.arm,
    this.notes,
    this.photoUrl,
    required this.recordedAt,
    this.createdAt,
  }) : super._();

  factory _$BodyRecordModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BodyRecordModelImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final double? weight;
  @override
  final double? bodyFatPercentage;
  @override
  final double? muscleMass;
  @override
  final double? skeletalMuscleMass;
  @override
  final double? bmi;
  @override
  final double? chest;
  @override
  final double? waist;
  @override
  final double? hip;
  @override
  final double? thigh;
  @override
  final double? arm;
  @override
  final String? notes;
  @override
  final String? photoUrl;
  @override
  final DateTime recordedAt;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'BodyRecordModel(id: $id, userId: $userId, weight: $weight, bodyFatPercentage: $bodyFatPercentage, muscleMass: $muscleMass, skeletalMuscleMass: $skeletalMuscleMass, bmi: $bmi, chest: $chest, waist: $waist, hip: $hip, thigh: $thigh, arm: $arm, notes: $notes, photoUrl: $photoUrl, recordedAt: $recordedAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BodyRecordModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.bodyFatPercentage, bodyFatPercentage) ||
                other.bodyFatPercentage == bodyFatPercentage) &&
            (identical(other.muscleMass, muscleMass) ||
                other.muscleMass == muscleMass) &&
            (identical(other.skeletalMuscleMass, skeletalMuscleMass) ||
                other.skeletalMuscleMass == skeletalMuscleMass) &&
            (identical(other.bmi, bmi) || other.bmi == bmi) &&
            (identical(other.chest, chest) || other.chest == chest) &&
            (identical(other.waist, waist) || other.waist == waist) &&
            (identical(other.hip, hip) || other.hip == hip) &&
            (identical(other.thigh, thigh) || other.thigh == thigh) &&
            (identical(other.arm, arm) || other.arm == arm) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.recordedAt, recordedAt) ||
                other.recordedAt == recordedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    weight,
    bodyFatPercentage,
    muscleMass,
    skeletalMuscleMass,
    bmi,
    chest,
    waist,
    hip,
    thigh,
    arm,
    notes,
    photoUrl,
    recordedAt,
    createdAt,
  );

  /// Create a copy of BodyRecordModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BodyRecordModelImplCopyWith<_$BodyRecordModelImpl> get copyWith =>
      __$$BodyRecordModelImplCopyWithImpl<_$BodyRecordModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$BodyRecordModelImplToJson(this);
  }
}

abstract class _BodyRecordModel extends BodyRecordModel {
  const factory _BodyRecordModel({
    required final String id,
    required final String userId,
    final double? weight,
    final double? bodyFatPercentage,
    final double? muscleMass,
    final double? skeletalMuscleMass,
    final double? bmi,
    final double? chest,
    final double? waist,
    final double? hip,
    final double? thigh,
    final double? arm,
    final String? notes,
    final String? photoUrl,
    required final DateTime recordedAt,
    final DateTime? createdAt,
  }) = _$BodyRecordModelImpl;
  const _BodyRecordModel._() : super._();

  factory _BodyRecordModel.fromJson(Map<String, dynamic> json) =
      _$BodyRecordModelImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  double? get weight;
  @override
  double? get bodyFatPercentage;
  @override
  double? get muscleMass;
  @override
  double? get skeletalMuscleMass;
  @override
  double? get bmi;
  @override
  double? get chest;
  @override
  double? get waist;
  @override
  double? get hip;
  @override
  double? get thigh;
  @override
  double? get arm;
  @override
  String? get notes;
  @override
  String? get photoUrl;
  @override
  DateTime get recordedAt;
  @override
  DateTime? get createdAt;

  /// Create a copy of BodyRecordModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BodyRecordModelImplCopyWith<_$BodyRecordModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
