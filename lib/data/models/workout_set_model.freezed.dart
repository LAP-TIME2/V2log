// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout_set_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

WorkoutSetModel _$WorkoutSetModelFromJson(Map<String, dynamic> json) {
  return _WorkoutSetModel.fromJson(json);
}

/// @nodoc
mixin _$WorkoutSetModel {
  String get id => throw _privateConstructorUsedError;
  String get sessionId => throw _privateConstructorUsedError;
  String get exerciseId => throw _privateConstructorUsedError;
  int get setNumber => throw _privateConstructorUsedError;
  SetType get setType => throw _privateConstructorUsedError;
  double? get weight => throw _privateConstructorUsedError;
  int? get reps => throw _privateConstructorUsedError;
  double? get targetWeight => throw _privateConstructorUsedError;
  int? get targetReps => throw _privateConstructorUsedError;
  double? get rpe => throw _privateConstructorUsedError;
  int? get restSeconds => throw _privateConstructorUsedError;
  bool get isPr => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  DateTime get completedAt => throw _privateConstructorUsedError;

  /// Serializes this WorkoutSetModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkoutSetModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkoutSetModelCopyWith<WorkoutSetModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkoutSetModelCopyWith<$Res> {
  factory $WorkoutSetModelCopyWith(
    WorkoutSetModel value,
    $Res Function(WorkoutSetModel) then,
  ) = _$WorkoutSetModelCopyWithImpl<$Res, WorkoutSetModel>;
  @useResult
  $Res call({
    String id,
    String sessionId,
    String exerciseId,
    int setNumber,
    SetType setType,
    double? weight,
    int? reps,
    double? targetWeight,
    int? targetReps,
    double? rpe,
    int? restSeconds,
    bool isPr,
    String? notes,
    DateTime completedAt,
  });
}

/// @nodoc
class _$WorkoutSetModelCopyWithImpl<$Res, $Val extends WorkoutSetModel>
    implements $WorkoutSetModelCopyWith<$Res> {
  _$WorkoutSetModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkoutSetModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sessionId = null,
    Object? exerciseId = null,
    Object? setNumber = null,
    Object? setType = null,
    Object? weight = freezed,
    Object? reps = freezed,
    Object? targetWeight = freezed,
    Object? targetReps = freezed,
    Object? rpe = freezed,
    Object? restSeconds = freezed,
    Object? isPr = null,
    Object? notes = freezed,
    Object? completedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            sessionId: null == sessionId
                ? _value.sessionId
                : sessionId // ignore: cast_nullable_to_non_nullable
                      as String,
            exerciseId: null == exerciseId
                ? _value.exerciseId
                : exerciseId // ignore: cast_nullable_to_non_nullable
                      as String,
            setNumber: null == setNumber
                ? _value.setNumber
                : setNumber // ignore: cast_nullable_to_non_nullable
                      as int,
            setType: null == setType
                ? _value.setType
                : setType // ignore: cast_nullable_to_non_nullable
                      as SetType,
            weight: freezed == weight
                ? _value.weight
                : weight // ignore: cast_nullable_to_non_nullable
                      as double?,
            reps: freezed == reps
                ? _value.reps
                : reps // ignore: cast_nullable_to_non_nullable
                      as int?,
            targetWeight: freezed == targetWeight
                ? _value.targetWeight
                : targetWeight // ignore: cast_nullable_to_non_nullable
                      as double?,
            targetReps: freezed == targetReps
                ? _value.targetReps
                : targetReps // ignore: cast_nullable_to_non_nullable
                      as int?,
            rpe: freezed == rpe
                ? _value.rpe
                : rpe // ignore: cast_nullable_to_non_nullable
                      as double?,
            restSeconds: freezed == restSeconds
                ? _value.restSeconds
                : restSeconds // ignore: cast_nullable_to_non_nullable
                      as int?,
            isPr: null == isPr
                ? _value.isPr
                : isPr // ignore: cast_nullable_to_non_nullable
                      as bool,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            completedAt: null == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WorkoutSetModelImplCopyWith<$Res>
    implements $WorkoutSetModelCopyWith<$Res> {
  factory _$$WorkoutSetModelImplCopyWith(
    _$WorkoutSetModelImpl value,
    $Res Function(_$WorkoutSetModelImpl) then,
  ) = __$$WorkoutSetModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String sessionId,
    String exerciseId,
    int setNumber,
    SetType setType,
    double? weight,
    int? reps,
    double? targetWeight,
    int? targetReps,
    double? rpe,
    int? restSeconds,
    bool isPr,
    String? notes,
    DateTime completedAt,
  });
}

/// @nodoc
class __$$WorkoutSetModelImplCopyWithImpl<$Res>
    extends _$WorkoutSetModelCopyWithImpl<$Res, _$WorkoutSetModelImpl>
    implements _$$WorkoutSetModelImplCopyWith<$Res> {
  __$$WorkoutSetModelImplCopyWithImpl(
    _$WorkoutSetModelImpl _value,
    $Res Function(_$WorkoutSetModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WorkoutSetModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sessionId = null,
    Object? exerciseId = null,
    Object? setNumber = null,
    Object? setType = null,
    Object? weight = freezed,
    Object? reps = freezed,
    Object? targetWeight = freezed,
    Object? targetReps = freezed,
    Object? rpe = freezed,
    Object? restSeconds = freezed,
    Object? isPr = null,
    Object? notes = freezed,
    Object? completedAt = null,
  }) {
    return _then(
      _$WorkoutSetModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        sessionId: null == sessionId
            ? _value.sessionId
            : sessionId // ignore: cast_nullable_to_non_nullable
                  as String,
        exerciseId: null == exerciseId
            ? _value.exerciseId
            : exerciseId // ignore: cast_nullable_to_non_nullable
                  as String,
        setNumber: null == setNumber
            ? _value.setNumber
            : setNumber // ignore: cast_nullable_to_non_nullable
                  as int,
        setType: null == setType
            ? _value.setType
            : setType // ignore: cast_nullable_to_non_nullable
                  as SetType,
        weight: freezed == weight
            ? _value.weight
            : weight // ignore: cast_nullable_to_non_nullable
                  as double?,
        reps: freezed == reps
            ? _value.reps
            : reps // ignore: cast_nullable_to_non_nullable
                  as int?,
        targetWeight: freezed == targetWeight
            ? _value.targetWeight
            : targetWeight // ignore: cast_nullable_to_non_nullable
                  as double?,
        targetReps: freezed == targetReps
            ? _value.targetReps
            : targetReps // ignore: cast_nullable_to_non_nullable
                  as int?,
        rpe: freezed == rpe
            ? _value.rpe
            : rpe // ignore: cast_nullable_to_non_nullable
                  as double?,
        restSeconds: freezed == restSeconds
            ? _value.restSeconds
            : restSeconds // ignore: cast_nullable_to_non_nullable
                  as int?,
        isPr: null == isPr
            ? _value.isPr
            : isPr // ignore: cast_nullable_to_non_nullable
                  as bool,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        completedAt: null == completedAt
            ? _value.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkoutSetModelImpl extends _WorkoutSetModel {
  const _$WorkoutSetModelImpl({
    required this.id,
    required this.sessionId,
    required this.exerciseId,
    required this.setNumber,
    this.setType = SetType.working,
    this.weight,
    this.reps,
    this.targetWeight,
    this.targetReps,
    this.rpe,
    this.restSeconds,
    this.isPr = false,
    this.notes,
    required this.completedAt,
  }) : super._();

  factory _$WorkoutSetModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkoutSetModelImplFromJson(json);

  @override
  final String id;
  @override
  final String sessionId;
  @override
  final String exerciseId;
  @override
  final int setNumber;
  @override
  @JsonKey()
  final SetType setType;
  @override
  final double? weight;
  @override
  final int? reps;
  @override
  final double? targetWeight;
  @override
  final int? targetReps;
  @override
  final double? rpe;
  @override
  final int? restSeconds;
  @override
  @JsonKey()
  final bool isPr;
  @override
  final String? notes;
  @override
  final DateTime completedAt;

  @override
  String toString() {
    return 'WorkoutSetModel(id: $id, sessionId: $sessionId, exerciseId: $exerciseId, setNumber: $setNumber, setType: $setType, weight: $weight, reps: $reps, targetWeight: $targetWeight, targetReps: $targetReps, rpe: $rpe, restSeconds: $restSeconds, isPr: $isPr, notes: $notes, completedAt: $completedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkoutSetModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.exerciseId, exerciseId) ||
                other.exerciseId == exerciseId) &&
            (identical(other.setNumber, setNumber) ||
                other.setNumber == setNumber) &&
            (identical(other.setType, setType) || other.setType == setType) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.reps, reps) || other.reps == reps) &&
            (identical(other.targetWeight, targetWeight) ||
                other.targetWeight == targetWeight) &&
            (identical(other.targetReps, targetReps) ||
                other.targetReps == targetReps) &&
            (identical(other.rpe, rpe) || other.rpe == rpe) &&
            (identical(other.restSeconds, restSeconds) ||
                other.restSeconds == restSeconds) &&
            (identical(other.isPr, isPr) || other.isPr == isPr) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    sessionId,
    exerciseId,
    setNumber,
    setType,
    weight,
    reps,
    targetWeight,
    targetReps,
    rpe,
    restSeconds,
    isPr,
    notes,
    completedAt,
  );

  /// Create a copy of WorkoutSetModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkoutSetModelImplCopyWith<_$WorkoutSetModelImpl> get copyWith =>
      __$$WorkoutSetModelImplCopyWithImpl<_$WorkoutSetModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkoutSetModelImplToJson(this);
  }
}

abstract class _WorkoutSetModel extends WorkoutSetModel {
  const factory _WorkoutSetModel({
    required final String id,
    required final String sessionId,
    required final String exerciseId,
    required final int setNumber,
    final SetType setType,
    final double? weight,
    final int? reps,
    final double? targetWeight,
    final int? targetReps,
    final double? rpe,
    final int? restSeconds,
    final bool isPr,
    final String? notes,
    required final DateTime completedAt,
  }) = _$WorkoutSetModelImpl;
  const _WorkoutSetModel._() : super._();

  factory _WorkoutSetModel.fromJson(Map<String, dynamic> json) =
      _$WorkoutSetModelImpl.fromJson;

  @override
  String get id;
  @override
  String get sessionId;
  @override
  String get exerciseId;
  @override
  int get setNumber;
  @override
  SetType get setType;
  @override
  double? get weight;
  @override
  int? get reps;
  @override
  double? get targetWeight;
  @override
  int? get targetReps;
  @override
  double? get rpe;
  @override
  int? get restSeconds;
  @override
  bool get isPr;
  @override
  String? get notes;
  @override
  DateTime get completedAt;

  /// Create a copy of WorkoutSetModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkoutSetModelImplCopyWith<_$WorkoutSetModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ExerciseRecordModel _$ExerciseRecordModelFromJson(Map<String, dynamic> json) {
  return _ExerciseRecordModel.fromJson(json);
}

/// @nodoc
mixin _$ExerciseRecordModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get exerciseId => throw _privateConstructorUsedError;
  double? get estimated1rm => throw _privateConstructorUsedError;
  double? get maxWeight => throw _privateConstructorUsedError;
  int? get maxReps => throw _privateConstructorUsedError;
  double? get maxVolume => throw _privateConstructorUsedError;
  double get totalVolume => throw _privateConstructorUsedError;
  int get totalSets => throw _privateConstructorUsedError;
  DateTime? get lastPerformedAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ExerciseRecordModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExerciseRecordModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExerciseRecordModelCopyWith<ExerciseRecordModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExerciseRecordModelCopyWith<$Res> {
  factory $ExerciseRecordModelCopyWith(
    ExerciseRecordModel value,
    $Res Function(ExerciseRecordModel) then,
  ) = _$ExerciseRecordModelCopyWithImpl<$Res, ExerciseRecordModel>;
  @useResult
  $Res call({
    String id,
    String userId,
    String exerciseId,
    double? estimated1rm,
    double? maxWeight,
    int? maxReps,
    double? maxVolume,
    double totalVolume,
    int totalSets,
    DateTime? lastPerformedAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$ExerciseRecordModelCopyWithImpl<$Res, $Val extends ExerciseRecordModel>
    implements $ExerciseRecordModelCopyWith<$Res> {
  _$ExerciseRecordModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExerciseRecordModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? exerciseId = null,
    Object? estimated1rm = freezed,
    Object? maxWeight = freezed,
    Object? maxReps = freezed,
    Object? maxVolume = freezed,
    Object? totalVolume = null,
    Object? totalSets = null,
    Object? lastPerformedAt = freezed,
    Object? updatedAt = null,
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
            exerciseId: null == exerciseId
                ? _value.exerciseId
                : exerciseId // ignore: cast_nullable_to_non_nullable
                      as String,
            estimated1rm: freezed == estimated1rm
                ? _value.estimated1rm
                : estimated1rm // ignore: cast_nullable_to_non_nullable
                      as double?,
            maxWeight: freezed == maxWeight
                ? _value.maxWeight
                : maxWeight // ignore: cast_nullable_to_non_nullable
                      as double?,
            maxReps: freezed == maxReps
                ? _value.maxReps
                : maxReps // ignore: cast_nullable_to_non_nullable
                      as int?,
            maxVolume: freezed == maxVolume
                ? _value.maxVolume
                : maxVolume // ignore: cast_nullable_to_non_nullable
                      as double?,
            totalVolume: null == totalVolume
                ? _value.totalVolume
                : totalVolume // ignore: cast_nullable_to_non_nullable
                      as double,
            totalSets: null == totalSets
                ? _value.totalSets
                : totalSets // ignore: cast_nullable_to_non_nullable
                      as int,
            lastPerformedAt: freezed == lastPerformedAt
                ? _value.lastPerformedAt
                : lastPerformedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
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
abstract class _$$ExerciseRecordModelImplCopyWith<$Res>
    implements $ExerciseRecordModelCopyWith<$Res> {
  factory _$$ExerciseRecordModelImplCopyWith(
    _$ExerciseRecordModelImpl value,
    $Res Function(_$ExerciseRecordModelImpl) then,
  ) = __$$ExerciseRecordModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String exerciseId,
    double? estimated1rm,
    double? maxWeight,
    int? maxReps,
    double? maxVolume,
    double totalVolume,
    int totalSets,
    DateTime? lastPerformedAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$ExerciseRecordModelImplCopyWithImpl<$Res>
    extends _$ExerciseRecordModelCopyWithImpl<$Res, _$ExerciseRecordModelImpl>
    implements _$$ExerciseRecordModelImplCopyWith<$Res> {
  __$$ExerciseRecordModelImplCopyWithImpl(
    _$ExerciseRecordModelImpl _value,
    $Res Function(_$ExerciseRecordModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ExerciseRecordModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? exerciseId = null,
    Object? estimated1rm = freezed,
    Object? maxWeight = freezed,
    Object? maxReps = freezed,
    Object? maxVolume = freezed,
    Object? totalVolume = null,
    Object? totalSets = null,
    Object? lastPerformedAt = freezed,
    Object? updatedAt = null,
  }) {
    return _then(
      _$ExerciseRecordModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        exerciseId: null == exerciseId
            ? _value.exerciseId
            : exerciseId // ignore: cast_nullable_to_non_nullable
                  as String,
        estimated1rm: freezed == estimated1rm
            ? _value.estimated1rm
            : estimated1rm // ignore: cast_nullable_to_non_nullable
                  as double?,
        maxWeight: freezed == maxWeight
            ? _value.maxWeight
            : maxWeight // ignore: cast_nullable_to_non_nullable
                  as double?,
        maxReps: freezed == maxReps
            ? _value.maxReps
            : maxReps // ignore: cast_nullable_to_non_nullable
                  as int?,
        maxVolume: freezed == maxVolume
            ? _value.maxVolume
            : maxVolume // ignore: cast_nullable_to_non_nullable
                  as double?,
        totalVolume: null == totalVolume
            ? _value.totalVolume
            : totalVolume // ignore: cast_nullable_to_non_nullable
                  as double,
        totalSets: null == totalSets
            ? _value.totalSets
            : totalSets // ignore: cast_nullable_to_non_nullable
                  as int,
        lastPerformedAt: freezed == lastPerformedAt
            ? _value.lastPerformedAt
            : lastPerformedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
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
class _$ExerciseRecordModelImpl implements _ExerciseRecordModel {
  const _$ExerciseRecordModelImpl({
    required this.id,
    required this.userId,
    required this.exerciseId,
    this.estimated1rm,
    this.maxWeight,
    this.maxReps,
    this.maxVolume,
    this.totalVolume = 0,
    this.totalSets = 0,
    this.lastPerformedAt,
    required this.updatedAt,
  });

  factory _$ExerciseRecordModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExerciseRecordModelImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String exerciseId;
  @override
  final double? estimated1rm;
  @override
  final double? maxWeight;
  @override
  final int? maxReps;
  @override
  final double? maxVolume;
  @override
  @JsonKey()
  final double totalVolume;
  @override
  @JsonKey()
  final int totalSets;
  @override
  final DateTime? lastPerformedAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'ExerciseRecordModel(id: $id, userId: $userId, exerciseId: $exerciseId, estimated1rm: $estimated1rm, maxWeight: $maxWeight, maxReps: $maxReps, maxVolume: $maxVolume, totalVolume: $totalVolume, totalSets: $totalSets, lastPerformedAt: $lastPerformedAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExerciseRecordModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.exerciseId, exerciseId) ||
                other.exerciseId == exerciseId) &&
            (identical(other.estimated1rm, estimated1rm) ||
                other.estimated1rm == estimated1rm) &&
            (identical(other.maxWeight, maxWeight) ||
                other.maxWeight == maxWeight) &&
            (identical(other.maxReps, maxReps) || other.maxReps == maxReps) &&
            (identical(other.maxVolume, maxVolume) ||
                other.maxVolume == maxVolume) &&
            (identical(other.totalVolume, totalVolume) ||
                other.totalVolume == totalVolume) &&
            (identical(other.totalSets, totalSets) ||
                other.totalSets == totalSets) &&
            (identical(other.lastPerformedAt, lastPerformedAt) ||
                other.lastPerformedAt == lastPerformedAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    exerciseId,
    estimated1rm,
    maxWeight,
    maxReps,
    maxVolume,
    totalVolume,
    totalSets,
    lastPerformedAt,
    updatedAt,
  );

  /// Create a copy of ExerciseRecordModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExerciseRecordModelImplCopyWith<_$ExerciseRecordModelImpl> get copyWith =>
      __$$ExerciseRecordModelImplCopyWithImpl<_$ExerciseRecordModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ExerciseRecordModelImplToJson(this);
  }
}

abstract class _ExerciseRecordModel implements ExerciseRecordModel {
  const factory _ExerciseRecordModel({
    required final String id,
    required final String userId,
    required final String exerciseId,
    final double? estimated1rm,
    final double? maxWeight,
    final int? maxReps,
    final double? maxVolume,
    final double totalVolume,
    final int totalSets,
    final DateTime? lastPerformedAt,
    required final DateTime updatedAt,
  }) = _$ExerciseRecordModelImpl;

  factory _ExerciseRecordModel.fromJson(Map<String, dynamic> json) =
      _$ExerciseRecordModelImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get exerciseId;
  @override
  double? get estimated1rm;
  @override
  double? get maxWeight;
  @override
  int? get maxReps;
  @override
  double? get maxVolume;
  @override
  double get totalVolume;
  @override
  int get totalSets;
  @override
  DateTime? get lastPerformedAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of ExerciseRecordModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExerciseRecordModelImplCopyWith<_$ExerciseRecordModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
