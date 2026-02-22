// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout_session_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

WorkoutSessionModel _$WorkoutSessionModelFromJson(Map<String, dynamic> json) {
  return _WorkoutSessionModel.fromJson(json);
}

/// @nodoc
mixin _$WorkoutSessionModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String? get routineId => throw _privateConstructorUsedError;
  int get sessionNumber => throw _privateConstructorUsedError;
  WorkoutMode get mode => throw _privateConstructorUsedError;
  DateTime get startedAt => throw _privateConstructorUsedError;
  DateTime? get finishedAt => throw _privateConstructorUsedError;
  bool get isCancelled => throw _privateConstructorUsedError;
  double? get totalVolume => throw _privateConstructorUsedError;
  int? get totalSets => throw _privateConstructorUsedError;
  int? get totalDurationSeconds => throw _privateConstructorUsedError;
  int? get caloriesBurned => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  int? get moodRating => throw _privateConstructorUsedError;
  List<WorkoutSetModel> get sets => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this WorkoutSessionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkoutSessionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkoutSessionModelCopyWith<WorkoutSessionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkoutSessionModelCopyWith<$Res> {
  factory $WorkoutSessionModelCopyWith(
    WorkoutSessionModel value,
    $Res Function(WorkoutSessionModel) then,
  ) = _$WorkoutSessionModelCopyWithImpl<$Res, WorkoutSessionModel>;
  @useResult
  $Res call({
    String id,
    String userId,
    String? routineId,
    int sessionNumber,
    WorkoutMode mode,
    DateTime startedAt,
    DateTime? finishedAt,
    bool isCancelled,
    double? totalVolume,
    int? totalSets,
    int? totalDurationSeconds,
    int? caloriesBurned,
    String? notes,
    int? moodRating,
    List<WorkoutSetModel> sets,
    DateTime? createdAt,
  });
}

/// @nodoc
class _$WorkoutSessionModelCopyWithImpl<$Res, $Val extends WorkoutSessionModel>
    implements $WorkoutSessionModelCopyWith<$Res> {
  _$WorkoutSessionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkoutSessionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? routineId = freezed,
    Object? sessionNumber = null,
    Object? mode = null,
    Object? startedAt = null,
    Object? finishedAt = freezed,
    Object? isCancelled = null,
    Object? totalVolume = freezed,
    Object? totalSets = freezed,
    Object? totalDurationSeconds = freezed,
    Object? caloriesBurned = freezed,
    Object? notes = freezed,
    Object? moodRating = freezed,
    Object? sets = null,
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
            routineId: freezed == routineId
                ? _value.routineId
                : routineId // ignore: cast_nullable_to_non_nullable
                      as String?,
            sessionNumber: null == sessionNumber
                ? _value.sessionNumber
                : sessionNumber // ignore: cast_nullable_to_non_nullable
                      as int,
            mode: null == mode
                ? _value.mode
                : mode // ignore: cast_nullable_to_non_nullable
                      as WorkoutMode,
            startedAt: null == startedAt
                ? _value.startedAt
                : startedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            finishedAt: freezed == finishedAt
                ? _value.finishedAt
                : finishedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            isCancelled: null == isCancelled
                ? _value.isCancelled
                : isCancelled // ignore: cast_nullable_to_non_nullable
                      as bool,
            totalVolume: freezed == totalVolume
                ? _value.totalVolume
                : totalVolume // ignore: cast_nullable_to_non_nullable
                      as double?,
            totalSets: freezed == totalSets
                ? _value.totalSets
                : totalSets // ignore: cast_nullable_to_non_nullable
                      as int?,
            totalDurationSeconds: freezed == totalDurationSeconds
                ? _value.totalDurationSeconds
                : totalDurationSeconds // ignore: cast_nullable_to_non_nullable
                      as int?,
            caloriesBurned: freezed == caloriesBurned
                ? _value.caloriesBurned
                : caloriesBurned // ignore: cast_nullable_to_non_nullable
                      as int?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            moodRating: freezed == moodRating
                ? _value.moodRating
                : moodRating // ignore: cast_nullable_to_non_nullable
                      as int?,
            sets: null == sets
                ? _value.sets
                : sets // ignore: cast_nullable_to_non_nullable
                      as List<WorkoutSetModel>,
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
abstract class _$$WorkoutSessionModelImplCopyWith<$Res>
    implements $WorkoutSessionModelCopyWith<$Res> {
  factory _$$WorkoutSessionModelImplCopyWith(
    _$WorkoutSessionModelImpl value,
    $Res Function(_$WorkoutSessionModelImpl) then,
  ) = __$$WorkoutSessionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String? routineId,
    int sessionNumber,
    WorkoutMode mode,
    DateTime startedAt,
    DateTime? finishedAt,
    bool isCancelled,
    double? totalVolume,
    int? totalSets,
    int? totalDurationSeconds,
    int? caloriesBurned,
    String? notes,
    int? moodRating,
    List<WorkoutSetModel> sets,
    DateTime? createdAt,
  });
}

/// @nodoc
class __$$WorkoutSessionModelImplCopyWithImpl<$Res>
    extends _$WorkoutSessionModelCopyWithImpl<$Res, _$WorkoutSessionModelImpl>
    implements _$$WorkoutSessionModelImplCopyWith<$Res> {
  __$$WorkoutSessionModelImplCopyWithImpl(
    _$WorkoutSessionModelImpl _value,
    $Res Function(_$WorkoutSessionModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WorkoutSessionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? routineId = freezed,
    Object? sessionNumber = null,
    Object? mode = null,
    Object? startedAt = null,
    Object? finishedAt = freezed,
    Object? isCancelled = null,
    Object? totalVolume = freezed,
    Object? totalSets = freezed,
    Object? totalDurationSeconds = freezed,
    Object? caloriesBurned = freezed,
    Object? notes = freezed,
    Object? moodRating = freezed,
    Object? sets = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$WorkoutSessionModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        routineId: freezed == routineId
            ? _value.routineId
            : routineId // ignore: cast_nullable_to_non_nullable
                  as String?,
        sessionNumber: null == sessionNumber
            ? _value.sessionNumber
            : sessionNumber // ignore: cast_nullable_to_non_nullable
                  as int,
        mode: null == mode
            ? _value.mode
            : mode // ignore: cast_nullable_to_non_nullable
                  as WorkoutMode,
        startedAt: null == startedAt
            ? _value.startedAt
            : startedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        finishedAt: freezed == finishedAt
            ? _value.finishedAt
            : finishedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        isCancelled: null == isCancelled
            ? _value.isCancelled
            : isCancelled // ignore: cast_nullable_to_non_nullable
                  as bool,
        totalVolume: freezed == totalVolume
            ? _value.totalVolume
            : totalVolume // ignore: cast_nullable_to_non_nullable
                  as double?,
        totalSets: freezed == totalSets
            ? _value.totalSets
            : totalSets // ignore: cast_nullable_to_non_nullable
                  as int?,
        totalDurationSeconds: freezed == totalDurationSeconds
            ? _value.totalDurationSeconds
            : totalDurationSeconds // ignore: cast_nullable_to_non_nullable
                  as int?,
        caloriesBurned: freezed == caloriesBurned
            ? _value.caloriesBurned
            : caloriesBurned // ignore: cast_nullable_to_non_nullable
                  as int?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        moodRating: freezed == moodRating
            ? _value.moodRating
            : moodRating // ignore: cast_nullable_to_non_nullable
                  as int?,
        sets: null == sets
            ? _value._sets
            : sets // ignore: cast_nullable_to_non_nullable
                  as List<WorkoutSetModel>,
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
class _$WorkoutSessionModelImpl extends _WorkoutSessionModel {
  const _$WorkoutSessionModelImpl({
    required this.id,
    required this.userId,
    this.routineId,
    this.sessionNumber = 1,
    required this.mode,
    required this.startedAt,
    this.finishedAt,
    this.isCancelled = false,
    this.totalVolume,
    this.totalSets,
    this.totalDurationSeconds,
    this.caloriesBurned,
    this.notes,
    this.moodRating,
    final List<WorkoutSetModel> sets = const [],
    this.createdAt,
  }) : _sets = sets,
       super._();

  factory _$WorkoutSessionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkoutSessionModelImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String? routineId;
  @override
  @JsonKey()
  final int sessionNumber;
  @override
  final WorkoutMode mode;
  @override
  final DateTime startedAt;
  @override
  final DateTime? finishedAt;
  @override
  @JsonKey()
  final bool isCancelled;
  @override
  final double? totalVolume;
  @override
  final int? totalSets;
  @override
  final int? totalDurationSeconds;
  @override
  final int? caloriesBurned;
  @override
  final String? notes;
  @override
  final int? moodRating;
  final List<WorkoutSetModel> _sets;
  @override
  @JsonKey()
  List<WorkoutSetModel> get sets {
    if (_sets is EqualUnmodifiableListView) return _sets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sets);
  }

  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'WorkoutSessionModel(id: $id, userId: $userId, routineId: $routineId, sessionNumber: $sessionNumber, mode: $mode, startedAt: $startedAt, finishedAt: $finishedAt, isCancelled: $isCancelled, totalVolume: $totalVolume, totalSets: $totalSets, totalDurationSeconds: $totalDurationSeconds, caloriesBurned: $caloriesBurned, notes: $notes, moodRating: $moodRating, sets: $sets, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkoutSessionModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.routineId, routineId) ||
                other.routineId == routineId) &&
            (identical(other.sessionNumber, sessionNumber) ||
                other.sessionNumber == sessionNumber) &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.finishedAt, finishedAt) ||
                other.finishedAt == finishedAt) &&
            (identical(other.isCancelled, isCancelled) ||
                other.isCancelled == isCancelled) &&
            (identical(other.totalVolume, totalVolume) ||
                other.totalVolume == totalVolume) &&
            (identical(other.totalSets, totalSets) ||
                other.totalSets == totalSets) &&
            (identical(other.totalDurationSeconds, totalDurationSeconds) ||
                other.totalDurationSeconds == totalDurationSeconds) &&
            (identical(other.caloriesBurned, caloriesBurned) ||
                other.caloriesBurned == caloriesBurned) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.moodRating, moodRating) ||
                other.moodRating == moodRating) &&
            const DeepCollectionEquality().equals(other._sets, _sets) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    routineId,
    sessionNumber,
    mode,
    startedAt,
    finishedAt,
    isCancelled,
    totalVolume,
    totalSets,
    totalDurationSeconds,
    caloriesBurned,
    notes,
    moodRating,
    const DeepCollectionEquality().hash(_sets),
    createdAt,
  );

  /// Create a copy of WorkoutSessionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkoutSessionModelImplCopyWith<_$WorkoutSessionModelImpl> get copyWith =>
      __$$WorkoutSessionModelImplCopyWithImpl<_$WorkoutSessionModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkoutSessionModelImplToJson(this);
  }
}

abstract class _WorkoutSessionModel extends WorkoutSessionModel {
  const factory _WorkoutSessionModel({
    required final String id,
    required final String userId,
    final String? routineId,
    final int sessionNumber,
    required final WorkoutMode mode,
    required final DateTime startedAt,
    final DateTime? finishedAt,
    final bool isCancelled,
    final double? totalVolume,
    final int? totalSets,
    final int? totalDurationSeconds,
    final int? caloriesBurned,
    final String? notes,
    final int? moodRating,
    final List<WorkoutSetModel> sets,
    final DateTime? createdAt,
  }) = _$WorkoutSessionModelImpl;
  const _WorkoutSessionModel._() : super._();

  factory _WorkoutSessionModel.fromJson(Map<String, dynamic> json) =
      _$WorkoutSessionModelImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String? get routineId;
  @override
  int get sessionNumber;
  @override
  WorkoutMode get mode;
  @override
  DateTime get startedAt;
  @override
  DateTime? get finishedAt;
  @override
  bool get isCancelled;
  @override
  double? get totalVolume;
  @override
  int? get totalSets;
  @override
  int? get totalDurationSeconds;
  @override
  int? get caloriesBurned;
  @override
  String? get notes;
  @override
  int? get moodRating;
  @override
  List<WorkoutSetModel> get sets;
  @override
  DateTime? get createdAt;

  /// Create a copy of WorkoutSessionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkoutSessionModelImplCopyWith<_$WorkoutSessionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
