// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'routine_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RoutineModel _$RoutineModelFromJson(Map<String, dynamic> json) {
  return _RoutineModel.fromJson(json);
}

/// @nodoc
mixin _$RoutineModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  RoutineSourceType get sourceType => throw _privateConstructorUsedError;
  bool get isAiGenerated => throw _privateConstructorUsedError;
  List<MuscleGroup> get targetMuscles => throw _privateConstructorUsedError;
  int? get estimatedDuration => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  List<RoutineExerciseModel> get exercises =>
      throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this RoutineModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RoutineModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RoutineModelCopyWith<RoutineModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoutineModelCopyWith<$Res> {
  factory $RoutineModelCopyWith(
    RoutineModel value,
    $Res Function(RoutineModel) then,
  ) = _$RoutineModelCopyWithImpl<$Res, RoutineModel>;
  @useResult
  $Res call({
    String id,
    String userId,
    String name,
    String? description,
    RoutineSourceType sourceType,
    bool isAiGenerated,
    List<MuscleGroup> targetMuscles,
    int? estimatedDuration,
    bool isActive,
    List<RoutineExerciseModel> exercises,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$RoutineModelCopyWithImpl<$Res, $Val extends RoutineModel>
    implements $RoutineModelCopyWith<$Res> {
  _$RoutineModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RoutineModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? description = freezed,
    Object? sourceType = null,
    Object? isAiGenerated = null,
    Object? targetMuscles = null,
    Object? estimatedDuration = freezed,
    Object? isActive = null,
    Object? exercises = null,
    Object? createdAt = null,
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
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            sourceType: null == sourceType
                ? _value.sourceType
                : sourceType // ignore: cast_nullable_to_non_nullable
                      as RoutineSourceType,
            isAiGenerated: null == isAiGenerated
                ? _value.isAiGenerated
                : isAiGenerated // ignore: cast_nullable_to_non_nullable
                      as bool,
            targetMuscles: null == targetMuscles
                ? _value.targetMuscles
                : targetMuscles // ignore: cast_nullable_to_non_nullable
                      as List<MuscleGroup>,
            estimatedDuration: freezed == estimatedDuration
                ? _value.estimatedDuration
                : estimatedDuration // ignore: cast_nullable_to_non_nullable
                      as int?,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            exercises: null == exercises
                ? _value.exercises
                : exercises // ignore: cast_nullable_to_non_nullable
                      as List<RoutineExerciseModel>,
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
abstract class _$$RoutineModelImplCopyWith<$Res>
    implements $RoutineModelCopyWith<$Res> {
  factory _$$RoutineModelImplCopyWith(
    _$RoutineModelImpl value,
    $Res Function(_$RoutineModelImpl) then,
  ) = __$$RoutineModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String name,
    String? description,
    RoutineSourceType sourceType,
    bool isAiGenerated,
    List<MuscleGroup> targetMuscles,
    int? estimatedDuration,
    bool isActive,
    List<RoutineExerciseModel> exercises,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$RoutineModelImplCopyWithImpl<$Res>
    extends _$RoutineModelCopyWithImpl<$Res, _$RoutineModelImpl>
    implements _$$RoutineModelImplCopyWith<$Res> {
  __$$RoutineModelImplCopyWithImpl(
    _$RoutineModelImpl _value,
    $Res Function(_$RoutineModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RoutineModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? description = freezed,
    Object? sourceType = null,
    Object? isAiGenerated = null,
    Object? targetMuscles = null,
    Object? estimatedDuration = freezed,
    Object? isActive = null,
    Object? exercises = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$RoutineModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        sourceType: null == sourceType
            ? _value.sourceType
            : sourceType // ignore: cast_nullable_to_non_nullable
                  as RoutineSourceType,
        isAiGenerated: null == isAiGenerated
            ? _value.isAiGenerated
            : isAiGenerated // ignore: cast_nullable_to_non_nullable
                  as bool,
        targetMuscles: null == targetMuscles
            ? _value._targetMuscles
            : targetMuscles // ignore: cast_nullable_to_non_nullable
                  as List<MuscleGroup>,
        estimatedDuration: freezed == estimatedDuration
            ? _value.estimatedDuration
            : estimatedDuration // ignore: cast_nullable_to_non_nullable
                  as int?,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        exercises: null == exercises
            ? _value._exercises
            : exercises // ignore: cast_nullable_to_non_nullable
                  as List<RoutineExerciseModel>,
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
class _$RoutineModelImpl implements _RoutineModel {
  const _$RoutineModelImpl({
    required this.id,
    required this.userId,
    required this.name,
    this.description,
    this.sourceType = RoutineSourceType.custom,
    this.isAiGenerated = false,
    final List<MuscleGroup> targetMuscles = const [],
    this.estimatedDuration,
    this.isActive = true,
    final List<RoutineExerciseModel> exercises = const [],
    required this.createdAt,
    required this.updatedAt,
  }) : _targetMuscles = targetMuscles,
       _exercises = exercises;

  factory _$RoutineModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RoutineModelImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String name;
  @override
  final String? description;
  @override
  @JsonKey()
  final RoutineSourceType sourceType;
  @override
  @JsonKey()
  final bool isAiGenerated;
  final List<MuscleGroup> _targetMuscles;
  @override
  @JsonKey()
  List<MuscleGroup> get targetMuscles {
    if (_targetMuscles is EqualUnmodifiableListView) return _targetMuscles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_targetMuscles);
  }

  @override
  final int? estimatedDuration;
  @override
  @JsonKey()
  final bool isActive;
  final List<RoutineExerciseModel> _exercises;
  @override
  @JsonKey()
  List<RoutineExerciseModel> get exercises {
    if (_exercises is EqualUnmodifiableListView) return _exercises;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_exercises);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'RoutineModel(id: $id, userId: $userId, name: $name, description: $description, sourceType: $sourceType, isAiGenerated: $isAiGenerated, targetMuscles: $targetMuscles, estimatedDuration: $estimatedDuration, isActive: $isActive, exercises: $exercises, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoutineModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.sourceType, sourceType) ||
                other.sourceType == sourceType) &&
            (identical(other.isAiGenerated, isAiGenerated) ||
                other.isAiGenerated == isAiGenerated) &&
            const DeepCollectionEquality().equals(
              other._targetMuscles,
              _targetMuscles,
            ) &&
            (identical(other.estimatedDuration, estimatedDuration) ||
                other.estimatedDuration == estimatedDuration) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            const DeepCollectionEquality().equals(
              other._exercises,
              _exercises,
            ) &&
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
    userId,
    name,
    description,
    sourceType,
    isAiGenerated,
    const DeepCollectionEquality().hash(_targetMuscles),
    estimatedDuration,
    isActive,
    const DeepCollectionEquality().hash(_exercises),
    createdAt,
    updatedAt,
  );

  /// Create a copy of RoutineModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RoutineModelImplCopyWith<_$RoutineModelImpl> get copyWith =>
      __$$RoutineModelImplCopyWithImpl<_$RoutineModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RoutineModelImplToJson(this);
  }
}

abstract class _RoutineModel implements RoutineModel {
  const factory _RoutineModel({
    required final String id,
    required final String userId,
    required final String name,
    final String? description,
    final RoutineSourceType sourceType,
    final bool isAiGenerated,
    final List<MuscleGroup> targetMuscles,
    final int? estimatedDuration,
    final bool isActive,
    final List<RoutineExerciseModel> exercises,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$RoutineModelImpl;

  factory _RoutineModel.fromJson(Map<String, dynamic> json) =
      _$RoutineModelImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get name;
  @override
  String? get description;
  @override
  RoutineSourceType get sourceType;
  @override
  bool get isAiGenerated;
  @override
  List<MuscleGroup> get targetMuscles;
  @override
  int? get estimatedDuration;
  @override
  bool get isActive;
  @override
  List<RoutineExerciseModel> get exercises;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of RoutineModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RoutineModelImplCopyWith<_$RoutineModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RoutineExerciseModel _$RoutineExerciseModelFromJson(Map<String, dynamic> json) {
  return _RoutineExerciseModel.fromJson(json);
}

/// @nodoc
mixin _$RoutineExerciseModel {
  String get id => throw _privateConstructorUsedError;
  String get routineId => throw _privateConstructorUsedError;
  String get exerciseId => throw _privateConstructorUsedError;
  int get orderIndex => throw _privateConstructorUsedError;
  int get targetSets => throw _privateConstructorUsedError;
  String get targetReps => throw _privateConstructorUsedError;
  double? get targetWeight => throw _privateConstructorUsedError;
  int get restSeconds => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError; // 조인된 운동 정보 (선택적)
  ExerciseModel? get exercise => throw _privateConstructorUsedError;

  /// Serializes this RoutineExerciseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RoutineExerciseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RoutineExerciseModelCopyWith<RoutineExerciseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoutineExerciseModelCopyWith<$Res> {
  factory $RoutineExerciseModelCopyWith(
    RoutineExerciseModel value,
    $Res Function(RoutineExerciseModel) then,
  ) = _$RoutineExerciseModelCopyWithImpl<$Res, RoutineExerciseModel>;
  @useResult
  $Res call({
    String id,
    String routineId,
    String exerciseId,
    int orderIndex,
    int targetSets,
    String targetReps,
    double? targetWeight,
    int restSeconds,
    String? notes,
    ExerciseModel? exercise,
  });

  $ExerciseModelCopyWith<$Res>? get exercise;
}

/// @nodoc
class _$RoutineExerciseModelCopyWithImpl<
  $Res,
  $Val extends RoutineExerciseModel
>
    implements $RoutineExerciseModelCopyWith<$Res> {
  _$RoutineExerciseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RoutineExerciseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? routineId = null,
    Object? exerciseId = null,
    Object? orderIndex = null,
    Object? targetSets = null,
    Object? targetReps = null,
    Object? targetWeight = freezed,
    Object? restSeconds = null,
    Object? notes = freezed,
    Object? exercise = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            routineId: null == routineId
                ? _value.routineId
                : routineId // ignore: cast_nullable_to_non_nullable
                      as String,
            exerciseId: null == exerciseId
                ? _value.exerciseId
                : exerciseId // ignore: cast_nullable_to_non_nullable
                      as String,
            orderIndex: null == orderIndex
                ? _value.orderIndex
                : orderIndex // ignore: cast_nullable_to_non_nullable
                      as int,
            targetSets: null == targetSets
                ? _value.targetSets
                : targetSets // ignore: cast_nullable_to_non_nullable
                      as int,
            targetReps: null == targetReps
                ? _value.targetReps
                : targetReps // ignore: cast_nullable_to_non_nullable
                      as String,
            targetWeight: freezed == targetWeight
                ? _value.targetWeight
                : targetWeight // ignore: cast_nullable_to_non_nullable
                      as double?,
            restSeconds: null == restSeconds
                ? _value.restSeconds
                : restSeconds // ignore: cast_nullable_to_non_nullable
                      as int,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            exercise: freezed == exercise
                ? _value.exercise
                : exercise // ignore: cast_nullable_to_non_nullable
                      as ExerciseModel?,
          )
          as $Val,
    );
  }

  /// Create a copy of RoutineExerciseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ExerciseModelCopyWith<$Res>? get exercise {
    if (_value.exercise == null) {
      return null;
    }

    return $ExerciseModelCopyWith<$Res>(_value.exercise!, (value) {
      return _then(_value.copyWith(exercise: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RoutineExerciseModelImplCopyWith<$Res>
    implements $RoutineExerciseModelCopyWith<$Res> {
  factory _$$RoutineExerciseModelImplCopyWith(
    _$RoutineExerciseModelImpl value,
    $Res Function(_$RoutineExerciseModelImpl) then,
  ) = __$$RoutineExerciseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String routineId,
    String exerciseId,
    int orderIndex,
    int targetSets,
    String targetReps,
    double? targetWeight,
    int restSeconds,
    String? notes,
    ExerciseModel? exercise,
  });

  @override
  $ExerciseModelCopyWith<$Res>? get exercise;
}

/// @nodoc
class __$$RoutineExerciseModelImplCopyWithImpl<$Res>
    extends _$RoutineExerciseModelCopyWithImpl<$Res, _$RoutineExerciseModelImpl>
    implements _$$RoutineExerciseModelImplCopyWith<$Res> {
  __$$RoutineExerciseModelImplCopyWithImpl(
    _$RoutineExerciseModelImpl _value,
    $Res Function(_$RoutineExerciseModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RoutineExerciseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? routineId = null,
    Object? exerciseId = null,
    Object? orderIndex = null,
    Object? targetSets = null,
    Object? targetReps = null,
    Object? targetWeight = freezed,
    Object? restSeconds = null,
    Object? notes = freezed,
    Object? exercise = freezed,
  }) {
    return _then(
      _$RoutineExerciseModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        routineId: null == routineId
            ? _value.routineId
            : routineId // ignore: cast_nullable_to_non_nullable
                  as String,
        exerciseId: null == exerciseId
            ? _value.exerciseId
            : exerciseId // ignore: cast_nullable_to_non_nullable
                  as String,
        orderIndex: null == orderIndex
            ? _value.orderIndex
            : orderIndex // ignore: cast_nullable_to_non_nullable
                  as int,
        targetSets: null == targetSets
            ? _value.targetSets
            : targetSets // ignore: cast_nullable_to_non_nullable
                  as int,
        targetReps: null == targetReps
            ? _value.targetReps
            : targetReps // ignore: cast_nullable_to_non_nullable
                  as String,
        targetWeight: freezed == targetWeight
            ? _value.targetWeight
            : targetWeight // ignore: cast_nullable_to_non_nullable
                  as double?,
        restSeconds: null == restSeconds
            ? _value.restSeconds
            : restSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        exercise: freezed == exercise
            ? _value.exercise
            : exercise // ignore: cast_nullable_to_non_nullable
                  as ExerciseModel?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RoutineExerciseModelImpl implements _RoutineExerciseModel {
  const _$RoutineExerciseModelImpl({
    required this.id,
    required this.routineId,
    required this.exerciseId,
    required this.orderIndex,
    this.targetSets = 3,
    this.targetReps = '10-12',
    this.targetWeight,
    this.restSeconds = 90,
    this.notes,
    this.exercise,
  });

  factory _$RoutineExerciseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RoutineExerciseModelImplFromJson(json);

  @override
  final String id;
  @override
  final String routineId;
  @override
  final String exerciseId;
  @override
  final int orderIndex;
  @override
  @JsonKey()
  final int targetSets;
  @override
  @JsonKey()
  final String targetReps;
  @override
  final double? targetWeight;
  @override
  @JsonKey()
  final int restSeconds;
  @override
  final String? notes;
  // 조인된 운동 정보 (선택적)
  @override
  final ExerciseModel? exercise;

  @override
  String toString() {
    return 'RoutineExerciseModel(id: $id, routineId: $routineId, exerciseId: $exerciseId, orderIndex: $orderIndex, targetSets: $targetSets, targetReps: $targetReps, targetWeight: $targetWeight, restSeconds: $restSeconds, notes: $notes, exercise: $exercise)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoutineExerciseModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.routineId, routineId) ||
                other.routineId == routineId) &&
            (identical(other.exerciseId, exerciseId) ||
                other.exerciseId == exerciseId) &&
            (identical(other.orderIndex, orderIndex) ||
                other.orderIndex == orderIndex) &&
            (identical(other.targetSets, targetSets) ||
                other.targetSets == targetSets) &&
            (identical(other.targetReps, targetReps) ||
                other.targetReps == targetReps) &&
            (identical(other.targetWeight, targetWeight) ||
                other.targetWeight == targetWeight) &&
            (identical(other.restSeconds, restSeconds) ||
                other.restSeconds == restSeconds) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.exercise, exercise) ||
                other.exercise == exercise));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    routineId,
    exerciseId,
    orderIndex,
    targetSets,
    targetReps,
    targetWeight,
    restSeconds,
    notes,
    exercise,
  );

  /// Create a copy of RoutineExerciseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RoutineExerciseModelImplCopyWith<_$RoutineExerciseModelImpl>
  get copyWith =>
      __$$RoutineExerciseModelImplCopyWithImpl<_$RoutineExerciseModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RoutineExerciseModelImplToJson(this);
  }
}

abstract class _RoutineExerciseModel implements RoutineExerciseModel {
  const factory _RoutineExerciseModel({
    required final String id,
    required final String routineId,
    required final String exerciseId,
    required final int orderIndex,
    final int targetSets,
    final String targetReps,
    final double? targetWeight,
    final int restSeconds,
    final String? notes,
    final ExerciseModel? exercise,
  }) = _$RoutineExerciseModelImpl;

  factory _RoutineExerciseModel.fromJson(Map<String, dynamic> json) =
      _$RoutineExerciseModelImpl.fromJson;

  @override
  String get id;
  @override
  String get routineId;
  @override
  String get exerciseId;
  @override
  int get orderIndex;
  @override
  int get targetSets;
  @override
  String get targetReps;
  @override
  double? get targetWeight;
  @override
  int get restSeconds;
  @override
  String? get notes; // 조인된 운동 정보 (선택적)
  @override
  ExerciseModel? get exercise;

  /// Create a copy of RoutineExerciseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RoutineExerciseModelImplCopyWith<_$RoutineExerciseModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
