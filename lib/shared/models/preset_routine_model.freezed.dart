// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'preset_routine_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PresetRoutineModel _$PresetRoutineModelFromJson(Map<String, dynamic> json) {
  return _PresetRoutineModel.fromJson(json);
}

/// @nodoc
mixin _$PresetRoutineModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get nameEn => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  ExperienceLevel get difficulty => throw _privateConstructorUsedError;
  FitnessGoal get targetGoal => throw _privateConstructorUsedError;
  int get daysPerWeek => throw _privateConstructorUsedError;
  int? get estimatedDurationMinutes => throw _privateConstructorUsedError;
  List<String> get targetMuscles => throw _privateConstructorUsedError;
  List<String> get equipmentRequired => throw _privateConstructorUsedError;
  String? get thumbnailUrl => throw _privateConstructorUsedError;
  int get popularityScore => throw _privateConstructorUsedError;
  bool get isFeatured => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt =>
      throw _privateConstructorUsedError; // 연관 데이터 (조인 시 사용)
  List<PresetRoutineExerciseModel> get exercises =>
      throw _privateConstructorUsedError;

  /// Serializes this PresetRoutineModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PresetRoutineModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PresetRoutineModelCopyWith<PresetRoutineModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PresetRoutineModelCopyWith<$Res> {
  factory $PresetRoutineModelCopyWith(
    PresetRoutineModel value,
    $Res Function(PresetRoutineModel) then,
  ) = _$PresetRoutineModelCopyWithImpl<$Res, PresetRoutineModel>;
  @useResult
  $Res call({
    String id,
    String name,
    String? nameEn,
    String? description,
    ExperienceLevel difficulty,
    FitnessGoal targetGoal,
    int daysPerWeek,
    int? estimatedDurationMinutes,
    List<String> targetMuscles,
    List<String> equipmentRequired,
    String? thumbnailUrl,
    int popularityScore,
    bool isFeatured,
    bool isActive,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<PresetRoutineExerciseModel> exercises,
  });
}

/// @nodoc
class _$PresetRoutineModelCopyWithImpl<$Res, $Val extends PresetRoutineModel>
    implements $PresetRoutineModelCopyWith<$Res> {
  _$PresetRoutineModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PresetRoutineModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? nameEn = freezed,
    Object? description = freezed,
    Object? difficulty = null,
    Object? targetGoal = null,
    Object? daysPerWeek = null,
    Object? estimatedDurationMinutes = freezed,
    Object? targetMuscles = null,
    Object? equipmentRequired = null,
    Object? thumbnailUrl = freezed,
    Object? popularityScore = null,
    Object? isFeatured = null,
    Object? isActive = null,
    Object? createdBy = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? exercises = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            nameEn: freezed == nameEn
                ? _value.nameEn
                : nameEn // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            difficulty: null == difficulty
                ? _value.difficulty
                : difficulty // ignore: cast_nullable_to_non_nullable
                      as ExperienceLevel,
            targetGoal: null == targetGoal
                ? _value.targetGoal
                : targetGoal // ignore: cast_nullable_to_non_nullable
                      as FitnessGoal,
            daysPerWeek: null == daysPerWeek
                ? _value.daysPerWeek
                : daysPerWeek // ignore: cast_nullable_to_non_nullable
                      as int,
            estimatedDurationMinutes: freezed == estimatedDurationMinutes
                ? _value.estimatedDurationMinutes
                : estimatedDurationMinutes // ignore: cast_nullable_to_non_nullable
                      as int?,
            targetMuscles: null == targetMuscles
                ? _value.targetMuscles
                : targetMuscles // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            equipmentRequired: null == equipmentRequired
                ? _value.equipmentRequired
                : equipmentRequired // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            thumbnailUrl: freezed == thumbnailUrl
                ? _value.thumbnailUrl
                : thumbnailUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            popularityScore: null == popularityScore
                ? _value.popularityScore
                : popularityScore // ignore: cast_nullable_to_non_nullable
                      as int,
            isFeatured: null == isFeatured
                ? _value.isFeatured
                : isFeatured // ignore: cast_nullable_to_non_nullable
                      as bool,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdBy: freezed == createdBy
                ? _value.createdBy
                : createdBy // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            exercises: null == exercises
                ? _value.exercises
                : exercises // ignore: cast_nullable_to_non_nullable
                      as List<PresetRoutineExerciseModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PresetRoutineModelImplCopyWith<$Res>
    implements $PresetRoutineModelCopyWith<$Res> {
  factory _$$PresetRoutineModelImplCopyWith(
    _$PresetRoutineModelImpl value,
    $Res Function(_$PresetRoutineModelImpl) then,
  ) = __$$PresetRoutineModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String? nameEn,
    String? description,
    ExperienceLevel difficulty,
    FitnessGoal targetGoal,
    int daysPerWeek,
    int? estimatedDurationMinutes,
    List<String> targetMuscles,
    List<String> equipmentRequired,
    String? thumbnailUrl,
    int popularityScore,
    bool isFeatured,
    bool isActive,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<PresetRoutineExerciseModel> exercises,
  });
}

/// @nodoc
class __$$PresetRoutineModelImplCopyWithImpl<$Res>
    extends _$PresetRoutineModelCopyWithImpl<$Res, _$PresetRoutineModelImpl>
    implements _$$PresetRoutineModelImplCopyWith<$Res> {
  __$$PresetRoutineModelImplCopyWithImpl(
    _$PresetRoutineModelImpl _value,
    $Res Function(_$PresetRoutineModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PresetRoutineModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? nameEn = freezed,
    Object? description = freezed,
    Object? difficulty = null,
    Object? targetGoal = null,
    Object? daysPerWeek = null,
    Object? estimatedDurationMinutes = freezed,
    Object? targetMuscles = null,
    Object? equipmentRequired = null,
    Object? thumbnailUrl = freezed,
    Object? popularityScore = null,
    Object? isFeatured = null,
    Object? isActive = null,
    Object? createdBy = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? exercises = null,
  }) {
    return _then(
      _$PresetRoutineModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        nameEn: freezed == nameEn
            ? _value.nameEn
            : nameEn // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        difficulty: null == difficulty
            ? _value.difficulty
            : difficulty // ignore: cast_nullable_to_non_nullable
                  as ExperienceLevel,
        targetGoal: null == targetGoal
            ? _value.targetGoal
            : targetGoal // ignore: cast_nullable_to_non_nullable
                  as FitnessGoal,
        daysPerWeek: null == daysPerWeek
            ? _value.daysPerWeek
            : daysPerWeek // ignore: cast_nullable_to_non_nullable
                  as int,
        estimatedDurationMinutes: freezed == estimatedDurationMinutes
            ? _value.estimatedDurationMinutes
            : estimatedDurationMinutes // ignore: cast_nullable_to_non_nullable
                  as int?,
        targetMuscles: null == targetMuscles
            ? _value._targetMuscles
            : targetMuscles // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        equipmentRequired: null == equipmentRequired
            ? _value._equipmentRequired
            : equipmentRequired // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        thumbnailUrl: freezed == thumbnailUrl
            ? _value.thumbnailUrl
            : thumbnailUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        popularityScore: null == popularityScore
            ? _value.popularityScore
            : popularityScore // ignore: cast_nullable_to_non_nullable
                  as int,
        isFeatured: null == isFeatured
            ? _value.isFeatured
            : isFeatured // ignore: cast_nullable_to_non_nullable
                  as bool,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdBy: freezed == createdBy
            ? _value.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        exercises: null == exercises
            ? _value._exercises
            : exercises // ignore: cast_nullable_to_non_nullable
                  as List<PresetRoutineExerciseModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PresetRoutineModelImpl extends _PresetRoutineModel {
  const _$PresetRoutineModelImpl({
    required this.id,
    required this.name,
    this.nameEn,
    this.description,
    required this.difficulty,
    required this.targetGoal,
    required this.daysPerWeek,
    this.estimatedDurationMinutes,
    final List<String> targetMuscles = const [],
    final List<String> equipmentRequired = const [],
    this.thumbnailUrl,
    this.popularityScore = 0,
    this.isFeatured = false,
    this.isActive = true,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    final List<PresetRoutineExerciseModel> exercises = const [],
  }) : _targetMuscles = targetMuscles,
       _equipmentRequired = equipmentRequired,
       _exercises = exercises,
       super._();

  factory _$PresetRoutineModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PresetRoutineModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? nameEn;
  @override
  final String? description;
  @override
  final ExperienceLevel difficulty;
  @override
  final FitnessGoal targetGoal;
  @override
  final int daysPerWeek;
  @override
  final int? estimatedDurationMinutes;
  final List<String> _targetMuscles;
  @override
  @JsonKey()
  List<String> get targetMuscles {
    if (_targetMuscles is EqualUnmodifiableListView) return _targetMuscles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_targetMuscles);
  }

  final List<String> _equipmentRequired;
  @override
  @JsonKey()
  List<String> get equipmentRequired {
    if (_equipmentRequired is EqualUnmodifiableListView)
      return _equipmentRequired;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_equipmentRequired);
  }

  @override
  final String? thumbnailUrl;
  @override
  @JsonKey()
  final int popularityScore;
  @override
  @JsonKey()
  final bool isFeatured;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final String? createdBy;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  // 연관 데이터 (조인 시 사용)
  final List<PresetRoutineExerciseModel> _exercises;
  // 연관 데이터 (조인 시 사용)
  @override
  @JsonKey()
  List<PresetRoutineExerciseModel> get exercises {
    if (_exercises is EqualUnmodifiableListView) return _exercises;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_exercises);
  }

  @override
  String toString() {
    return 'PresetRoutineModel(id: $id, name: $name, nameEn: $nameEn, description: $description, difficulty: $difficulty, targetGoal: $targetGoal, daysPerWeek: $daysPerWeek, estimatedDurationMinutes: $estimatedDurationMinutes, targetMuscles: $targetMuscles, equipmentRequired: $equipmentRequired, thumbnailUrl: $thumbnailUrl, popularityScore: $popularityScore, isFeatured: $isFeatured, isActive: $isActive, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt, exercises: $exercises)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PresetRoutineModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.nameEn, nameEn) || other.nameEn == nameEn) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            (identical(other.targetGoal, targetGoal) ||
                other.targetGoal == targetGoal) &&
            (identical(other.daysPerWeek, daysPerWeek) ||
                other.daysPerWeek == daysPerWeek) &&
            (identical(
                  other.estimatedDurationMinutes,
                  estimatedDurationMinutes,
                ) ||
                other.estimatedDurationMinutes == estimatedDurationMinutes) &&
            const DeepCollectionEquality().equals(
              other._targetMuscles,
              _targetMuscles,
            ) &&
            const DeepCollectionEquality().equals(
              other._equipmentRequired,
              _equipmentRequired,
            ) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.popularityScore, popularityScore) ||
                other.popularityScore == popularityScore) &&
            (identical(other.isFeatured, isFeatured) ||
                other.isFeatured == isFeatured) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(
              other._exercises,
              _exercises,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    nameEn,
    description,
    difficulty,
    targetGoal,
    daysPerWeek,
    estimatedDurationMinutes,
    const DeepCollectionEquality().hash(_targetMuscles),
    const DeepCollectionEquality().hash(_equipmentRequired),
    thumbnailUrl,
    popularityScore,
    isFeatured,
    isActive,
    createdBy,
    createdAt,
    updatedAt,
    const DeepCollectionEquality().hash(_exercises),
  );

  /// Create a copy of PresetRoutineModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PresetRoutineModelImplCopyWith<_$PresetRoutineModelImpl> get copyWith =>
      __$$PresetRoutineModelImplCopyWithImpl<_$PresetRoutineModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PresetRoutineModelImplToJson(this);
  }
}

abstract class _PresetRoutineModel extends PresetRoutineModel {
  const factory _PresetRoutineModel({
    required final String id,
    required final String name,
    final String? nameEn,
    final String? description,
    required final ExperienceLevel difficulty,
    required final FitnessGoal targetGoal,
    required final int daysPerWeek,
    final int? estimatedDurationMinutes,
    final List<String> targetMuscles,
    final List<String> equipmentRequired,
    final String? thumbnailUrl,
    final int popularityScore,
    final bool isFeatured,
    final bool isActive,
    final String? createdBy,
    final DateTime? createdAt,
    final DateTime? updatedAt,
    final List<PresetRoutineExerciseModel> exercises,
  }) = _$PresetRoutineModelImpl;
  const _PresetRoutineModel._() : super._();

  factory _PresetRoutineModel.fromJson(Map<String, dynamic> json) =
      _$PresetRoutineModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get nameEn;
  @override
  String? get description;
  @override
  ExperienceLevel get difficulty;
  @override
  FitnessGoal get targetGoal;
  @override
  int get daysPerWeek;
  @override
  int? get estimatedDurationMinutes;
  @override
  List<String> get targetMuscles;
  @override
  List<String> get equipmentRequired;
  @override
  String? get thumbnailUrl;
  @override
  int get popularityScore;
  @override
  bool get isFeatured;
  @override
  bool get isActive;
  @override
  String? get createdBy;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt; // 연관 데이터 (조인 시 사용)
  @override
  List<PresetRoutineExerciseModel> get exercises;

  /// Create a copy of PresetRoutineModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PresetRoutineModelImplCopyWith<_$PresetRoutineModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PresetRoutineExerciseModel _$PresetRoutineExerciseModelFromJson(
  Map<String, dynamic> json,
) {
  return _PresetRoutineExerciseModel.fromJson(json);
}

/// @nodoc
mixin _$PresetRoutineExerciseModel {
  String get id => throw _privateConstructorUsedError;
  String get presetRoutineId => throw _privateConstructorUsedError;
  String get exerciseId => throw _privateConstructorUsedError;
  int get dayNumber => throw _privateConstructorUsedError;
  String? get dayName => throw _privateConstructorUsedError;
  int get orderIndex => throw _privateConstructorUsedError;
  int get targetSets => throw _privateConstructorUsedError;
  String get targetReps => throw _privateConstructorUsedError;
  int get restSeconds => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  DateTime? get createdAt =>
      throw _privateConstructorUsedError; // 연관 데이터 (조인 시 사용)
  ExerciseModel? get exercise => throw _privateConstructorUsedError;

  /// Serializes this PresetRoutineExerciseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PresetRoutineExerciseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PresetRoutineExerciseModelCopyWith<PresetRoutineExerciseModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PresetRoutineExerciseModelCopyWith<$Res> {
  factory $PresetRoutineExerciseModelCopyWith(
    PresetRoutineExerciseModel value,
    $Res Function(PresetRoutineExerciseModel) then,
  ) =
      _$PresetRoutineExerciseModelCopyWithImpl<
        $Res,
        PresetRoutineExerciseModel
      >;
  @useResult
  $Res call({
    String id,
    String presetRoutineId,
    String exerciseId,
    int dayNumber,
    String? dayName,
    int orderIndex,
    int targetSets,
    String targetReps,
    int restSeconds,
    String? notes,
    DateTime? createdAt,
    ExerciseModel? exercise,
  });

  $ExerciseModelCopyWith<$Res>? get exercise;
}

/// @nodoc
class _$PresetRoutineExerciseModelCopyWithImpl<
  $Res,
  $Val extends PresetRoutineExerciseModel
>
    implements $PresetRoutineExerciseModelCopyWith<$Res> {
  _$PresetRoutineExerciseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PresetRoutineExerciseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? presetRoutineId = null,
    Object? exerciseId = null,
    Object? dayNumber = null,
    Object? dayName = freezed,
    Object? orderIndex = null,
    Object? targetSets = null,
    Object? targetReps = null,
    Object? restSeconds = null,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? exercise = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            presetRoutineId: null == presetRoutineId
                ? _value.presetRoutineId
                : presetRoutineId // ignore: cast_nullable_to_non_nullable
                      as String,
            exerciseId: null == exerciseId
                ? _value.exerciseId
                : exerciseId // ignore: cast_nullable_to_non_nullable
                      as String,
            dayNumber: null == dayNumber
                ? _value.dayNumber
                : dayNumber // ignore: cast_nullable_to_non_nullable
                      as int,
            dayName: freezed == dayName
                ? _value.dayName
                : dayName // ignore: cast_nullable_to_non_nullable
                      as String?,
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
            restSeconds: null == restSeconds
                ? _value.restSeconds
                : restSeconds // ignore: cast_nullable_to_non_nullable
                      as int,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            exercise: freezed == exercise
                ? _value.exercise
                : exercise // ignore: cast_nullable_to_non_nullable
                      as ExerciseModel?,
          )
          as $Val,
    );
  }

  /// Create a copy of PresetRoutineExerciseModel
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
abstract class _$$PresetRoutineExerciseModelImplCopyWith<$Res>
    implements $PresetRoutineExerciseModelCopyWith<$Res> {
  factory _$$PresetRoutineExerciseModelImplCopyWith(
    _$PresetRoutineExerciseModelImpl value,
    $Res Function(_$PresetRoutineExerciseModelImpl) then,
  ) = __$$PresetRoutineExerciseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String presetRoutineId,
    String exerciseId,
    int dayNumber,
    String? dayName,
    int orderIndex,
    int targetSets,
    String targetReps,
    int restSeconds,
    String? notes,
    DateTime? createdAt,
    ExerciseModel? exercise,
  });

  @override
  $ExerciseModelCopyWith<$Res>? get exercise;
}

/// @nodoc
class __$$PresetRoutineExerciseModelImplCopyWithImpl<$Res>
    extends
        _$PresetRoutineExerciseModelCopyWithImpl<
          $Res,
          _$PresetRoutineExerciseModelImpl
        >
    implements _$$PresetRoutineExerciseModelImplCopyWith<$Res> {
  __$$PresetRoutineExerciseModelImplCopyWithImpl(
    _$PresetRoutineExerciseModelImpl _value,
    $Res Function(_$PresetRoutineExerciseModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PresetRoutineExerciseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? presetRoutineId = null,
    Object? exerciseId = null,
    Object? dayNumber = null,
    Object? dayName = freezed,
    Object? orderIndex = null,
    Object? targetSets = null,
    Object? targetReps = null,
    Object? restSeconds = null,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? exercise = freezed,
  }) {
    return _then(
      _$PresetRoutineExerciseModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        presetRoutineId: null == presetRoutineId
            ? _value.presetRoutineId
            : presetRoutineId // ignore: cast_nullable_to_non_nullable
                  as String,
        exerciseId: null == exerciseId
            ? _value.exerciseId
            : exerciseId // ignore: cast_nullable_to_non_nullable
                  as String,
        dayNumber: null == dayNumber
            ? _value.dayNumber
            : dayNumber // ignore: cast_nullable_to_non_nullable
                  as int,
        dayName: freezed == dayName
            ? _value.dayName
            : dayName // ignore: cast_nullable_to_non_nullable
                  as String?,
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
        restSeconds: null == restSeconds
            ? _value.restSeconds
            : restSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
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
class _$PresetRoutineExerciseModelImpl extends _PresetRoutineExerciseModel {
  const _$PresetRoutineExerciseModelImpl({
    required this.id,
    required this.presetRoutineId,
    required this.exerciseId,
    required this.dayNumber,
    this.dayName,
    required this.orderIndex,
    this.targetSets = 3,
    this.targetReps = '10-12',
    this.restSeconds = 90,
    this.notes,
    this.createdAt,
    this.exercise,
  }) : super._();

  factory _$PresetRoutineExerciseModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$PresetRoutineExerciseModelImplFromJson(json);

  @override
  final String id;
  @override
  final String presetRoutineId;
  @override
  final String exerciseId;
  @override
  final int dayNumber;
  @override
  final String? dayName;
  @override
  final int orderIndex;
  @override
  @JsonKey()
  final int targetSets;
  @override
  @JsonKey()
  final String targetReps;
  @override
  @JsonKey()
  final int restSeconds;
  @override
  final String? notes;
  @override
  final DateTime? createdAt;
  // 연관 데이터 (조인 시 사용)
  @override
  final ExerciseModel? exercise;

  @override
  String toString() {
    return 'PresetRoutineExerciseModel(id: $id, presetRoutineId: $presetRoutineId, exerciseId: $exerciseId, dayNumber: $dayNumber, dayName: $dayName, orderIndex: $orderIndex, targetSets: $targetSets, targetReps: $targetReps, restSeconds: $restSeconds, notes: $notes, createdAt: $createdAt, exercise: $exercise)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PresetRoutineExerciseModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.presetRoutineId, presetRoutineId) ||
                other.presetRoutineId == presetRoutineId) &&
            (identical(other.exerciseId, exerciseId) ||
                other.exerciseId == exerciseId) &&
            (identical(other.dayNumber, dayNumber) ||
                other.dayNumber == dayNumber) &&
            (identical(other.dayName, dayName) || other.dayName == dayName) &&
            (identical(other.orderIndex, orderIndex) ||
                other.orderIndex == orderIndex) &&
            (identical(other.targetSets, targetSets) ||
                other.targetSets == targetSets) &&
            (identical(other.targetReps, targetReps) ||
                other.targetReps == targetReps) &&
            (identical(other.restSeconds, restSeconds) ||
                other.restSeconds == restSeconds) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.exercise, exercise) ||
                other.exercise == exercise));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    presetRoutineId,
    exerciseId,
    dayNumber,
    dayName,
    orderIndex,
    targetSets,
    targetReps,
    restSeconds,
    notes,
    createdAt,
    exercise,
  );

  /// Create a copy of PresetRoutineExerciseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PresetRoutineExerciseModelImplCopyWith<_$PresetRoutineExerciseModelImpl>
  get copyWith =>
      __$$PresetRoutineExerciseModelImplCopyWithImpl<
        _$PresetRoutineExerciseModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PresetRoutineExerciseModelImplToJson(this);
  }
}

abstract class _PresetRoutineExerciseModel extends PresetRoutineExerciseModel {
  const factory _PresetRoutineExerciseModel({
    required final String id,
    required final String presetRoutineId,
    required final String exerciseId,
    required final int dayNumber,
    final String? dayName,
    required final int orderIndex,
    final int targetSets,
    final String targetReps,
    final int restSeconds,
    final String? notes,
    final DateTime? createdAt,
    final ExerciseModel? exercise,
  }) = _$PresetRoutineExerciseModelImpl;
  const _PresetRoutineExerciseModel._() : super._();

  factory _PresetRoutineExerciseModel.fromJson(Map<String, dynamic> json) =
      _$PresetRoutineExerciseModelImpl.fromJson;

  @override
  String get id;
  @override
  String get presetRoutineId;
  @override
  String get exerciseId;
  @override
  int get dayNumber;
  @override
  String? get dayName;
  @override
  int get orderIndex;
  @override
  int get targetSets;
  @override
  String get targetReps;
  @override
  int get restSeconds;
  @override
  String? get notes;
  @override
  DateTime? get createdAt; // 연관 데이터 (조인 시 사용)
  @override
  ExerciseModel? get exercise;

  /// Create a copy of PresetRoutineExerciseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PresetRoutineExerciseModelImplCopyWith<_$PresetRoutineExerciseModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PresetRoutineFilter {
  ExperienceLevel? get difficulty => throw _privateConstructorUsedError;
  FitnessGoal? get targetGoal => throw _privateConstructorUsedError;
  bool? get isFeatured => throw _privateConstructorUsedError;
  String? get searchQuery => throw _privateConstructorUsedError;

  /// Create a copy of PresetRoutineFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PresetRoutineFilterCopyWith<PresetRoutineFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PresetRoutineFilterCopyWith<$Res> {
  factory $PresetRoutineFilterCopyWith(
    PresetRoutineFilter value,
    $Res Function(PresetRoutineFilter) then,
  ) = _$PresetRoutineFilterCopyWithImpl<$Res, PresetRoutineFilter>;
  @useResult
  $Res call({
    ExperienceLevel? difficulty,
    FitnessGoal? targetGoal,
    bool? isFeatured,
    String? searchQuery,
  });
}

/// @nodoc
class _$PresetRoutineFilterCopyWithImpl<$Res, $Val extends PresetRoutineFilter>
    implements $PresetRoutineFilterCopyWith<$Res> {
  _$PresetRoutineFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PresetRoutineFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? difficulty = freezed,
    Object? targetGoal = freezed,
    Object? isFeatured = freezed,
    Object? searchQuery = freezed,
  }) {
    return _then(
      _value.copyWith(
            difficulty: freezed == difficulty
                ? _value.difficulty
                : difficulty // ignore: cast_nullable_to_non_nullable
                      as ExperienceLevel?,
            targetGoal: freezed == targetGoal
                ? _value.targetGoal
                : targetGoal // ignore: cast_nullable_to_non_nullable
                      as FitnessGoal?,
            isFeatured: freezed == isFeatured
                ? _value.isFeatured
                : isFeatured // ignore: cast_nullable_to_non_nullable
                      as bool?,
            searchQuery: freezed == searchQuery
                ? _value.searchQuery
                : searchQuery // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PresetRoutineFilterImplCopyWith<$Res>
    implements $PresetRoutineFilterCopyWith<$Res> {
  factory _$$PresetRoutineFilterImplCopyWith(
    _$PresetRoutineFilterImpl value,
    $Res Function(_$PresetRoutineFilterImpl) then,
  ) = __$$PresetRoutineFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    ExperienceLevel? difficulty,
    FitnessGoal? targetGoal,
    bool? isFeatured,
    String? searchQuery,
  });
}

/// @nodoc
class __$$PresetRoutineFilterImplCopyWithImpl<$Res>
    extends _$PresetRoutineFilterCopyWithImpl<$Res, _$PresetRoutineFilterImpl>
    implements _$$PresetRoutineFilterImplCopyWith<$Res> {
  __$$PresetRoutineFilterImplCopyWithImpl(
    _$PresetRoutineFilterImpl _value,
    $Res Function(_$PresetRoutineFilterImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PresetRoutineFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? difficulty = freezed,
    Object? targetGoal = freezed,
    Object? isFeatured = freezed,
    Object? searchQuery = freezed,
  }) {
    return _then(
      _$PresetRoutineFilterImpl(
        difficulty: freezed == difficulty
            ? _value.difficulty
            : difficulty // ignore: cast_nullable_to_non_nullable
                  as ExperienceLevel?,
        targetGoal: freezed == targetGoal
            ? _value.targetGoal
            : targetGoal // ignore: cast_nullable_to_non_nullable
                  as FitnessGoal?,
        isFeatured: freezed == isFeatured
            ? _value.isFeatured
            : isFeatured // ignore: cast_nullable_to_non_nullable
                  as bool?,
        searchQuery: freezed == searchQuery
            ? _value.searchQuery
            : searchQuery // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$PresetRoutineFilterImpl implements _PresetRoutineFilter {
  const _$PresetRoutineFilterImpl({
    this.difficulty,
    this.targetGoal,
    this.isFeatured,
    this.searchQuery,
  });

  @override
  final ExperienceLevel? difficulty;
  @override
  final FitnessGoal? targetGoal;
  @override
  final bool? isFeatured;
  @override
  final String? searchQuery;

  @override
  String toString() {
    return 'PresetRoutineFilter(difficulty: $difficulty, targetGoal: $targetGoal, isFeatured: $isFeatured, searchQuery: $searchQuery)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PresetRoutineFilterImpl &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            (identical(other.targetGoal, targetGoal) ||
                other.targetGoal == targetGoal) &&
            (identical(other.isFeatured, isFeatured) ||
                other.isFeatured == isFeatured) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, difficulty, targetGoal, isFeatured, searchQuery);

  /// Create a copy of PresetRoutineFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PresetRoutineFilterImplCopyWith<_$PresetRoutineFilterImpl> get copyWith =>
      __$$PresetRoutineFilterImplCopyWithImpl<_$PresetRoutineFilterImpl>(
        this,
        _$identity,
      );
}

abstract class _PresetRoutineFilter implements PresetRoutineFilter {
  const factory _PresetRoutineFilter({
    final ExperienceLevel? difficulty,
    final FitnessGoal? targetGoal,
    final bool? isFeatured,
    final String? searchQuery,
  }) = _$PresetRoutineFilterImpl;

  @override
  ExperienceLevel? get difficulty;
  @override
  FitnessGoal? get targetGoal;
  @override
  bool? get isFeatured;
  @override
  String? get searchQuery;

  /// Create a copy of PresetRoutineFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PresetRoutineFilterImplCopyWith<_$PresetRoutineFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
