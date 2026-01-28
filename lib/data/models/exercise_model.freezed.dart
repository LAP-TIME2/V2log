// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ExerciseModel _$ExerciseModelFromJson(Map<String, dynamic> json) {
  return _ExerciseModel.fromJson(json);
}

/// @nodoc
mixin _$ExerciseModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get nameEn => throw _privateConstructorUsedError;
  ExerciseCategory get category => throw _privateConstructorUsedError;
  MuscleGroup get primaryMuscle => throw _privateConstructorUsedError;
  List<MuscleGroup> get secondaryMuscles => throw _privateConstructorUsedError;
  List<String> get equipmentRequired => throw _privateConstructorUsedError;
  ExperienceLevel get difficulty => throw _privateConstructorUsedError;
  List<String> get instructions => throw _privateConstructorUsedError;
  List<String> get tips => throw _privateConstructorUsedError;
  String? get animationUrl => throw _privateConstructorUsedError;
  String? get videoUrl => throw _privateConstructorUsedError;
  String? get thumbnailUrl => throw _privateConstructorUsedError;
  double? get caloriesPerMinute => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this ExerciseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExerciseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExerciseModelCopyWith<ExerciseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExerciseModelCopyWith<$Res> {
  factory $ExerciseModelCopyWith(
    ExerciseModel value,
    $Res Function(ExerciseModel) then,
  ) = _$ExerciseModelCopyWithImpl<$Res, ExerciseModel>;
  @useResult
  $Res call({
    String id,
    String name,
    String? nameEn,
    ExerciseCategory category,
    MuscleGroup primaryMuscle,
    List<MuscleGroup> secondaryMuscles,
    List<String> equipmentRequired,
    ExperienceLevel difficulty,
    List<String> instructions,
    List<String> tips,
    String? animationUrl,
    String? videoUrl,
    String? thumbnailUrl,
    double? caloriesPerMinute,
    DateTime? createdAt,
  });
}

/// @nodoc
class _$ExerciseModelCopyWithImpl<$Res, $Val extends ExerciseModel>
    implements $ExerciseModelCopyWith<$Res> {
  _$ExerciseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExerciseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? nameEn = freezed,
    Object? category = null,
    Object? primaryMuscle = null,
    Object? secondaryMuscles = null,
    Object? equipmentRequired = null,
    Object? difficulty = null,
    Object? instructions = null,
    Object? tips = null,
    Object? animationUrl = freezed,
    Object? videoUrl = freezed,
    Object? thumbnailUrl = freezed,
    Object? caloriesPerMinute = freezed,
    Object? createdAt = freezed,
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
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as ExerciseCategory,
            primaryMuscle: null == primaryMuscle
                ? _value.primaryMuscle
                : primaryMuscle // ignore: cast_nullable_to_non_nullable
                      as MuscleGroup,
            secondaryMuscles: null == secondaryMuscles
                ? _value.secondaryMuscles
                : secondaryMuscles // ignore: cast_nullable_to_non_nullable
                      as List<MuscleGroup>,
            equipmentRequired: null == equipmentRequired
                ? _value.equipmentRequired
                : equipmentRequired // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            difficulty: null == difficulty
                ? _value.difficulty
                : difficulty // ignore: cast_nullable_to_non_nullable
                      as ExperienceLevel,
            instructions: null == instructions
                ? _value.instructions
                : instructions // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            tips: null == tips
                ? _value.tips
                : tips // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            animationUrl: freezed == animationUrl
                ? _value.animationUrl
                : animationUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            videoUrl: freezed == videoUrl
                ? _value.videoUrl
                : videoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            thumbnailUrl: freezed == thumbnailUrl
                ? _value.thumbnailUrl
                : thumbnailUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            caloriesPerMinute: freezed == caloriesPerMinute
                ? _value.caloriesPerMinute
                : caloriesPerMinute // ignore: cast_nullable_to_non_nullable
                      as double?,
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
abstract class _$$ExerciseModelImplCopyWith<$Res>
    implements $ExerciseModelCopyWith<$Res> {
  factory _$$ExerciseModelImplCopyWith(
    _$ExerciseModelImpl value,
    $Res Function(_$ExerciseModelImpl) then,
  ) = __$$ExerciseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String? nameEn,
    ExerciseCategory category,
    MuscleGroup primaryMuscle,
    List<MuscleGroup> secondaryMuscles,
    List<String> equipmentRequired,
    ExperienceLevel difficulty,
    List<String> instructions,
    List<String> tips,
    String? animationUrl,
    String? videoUrl,
    String? thumbnailUrl,
    double? caloriesPerMinute,
    DateTime? createdAt,
  });
}

/// @nodoc
class __$$ExerciseModelImplCopyWithImpl<$Res>
    extends _$ExerciseModelCopyWithImpl<$Res, _$ExerciseModelImpl>
    implements _$$ExerciseModelImplCopyWith<$Res> {
  __$$ExerciseModelImplCopyWithImpl(
    _$ExerciseModelImpl _value,
    $Res Function(_$ExerciseModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ExerciseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? nameEn = freezed,
    Object? category = null,
    Object? primaryMuscle = null,
    Object? secondaryMuscles = null,
    Object? equipmentRequired = null,
    Object? difficulty = null,
    Object? instructions = null,
    Object? tips = null,
    Object? animationUrl = freezed,
    Object? videoUrl = freezed,
    Object? thumbnailUrl = freezed,
    Object? caloriesPerMinute = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$ExerciseModelImpl(
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
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as ExerciseCategory,
        primaryMuscle: null == primaryMuscle
            ? _value.primaryMuscle
            : primaryMuscle // ignore: cast_nullable_to_non_nullable
                  as MuscleGroup,
        secondaryMuscles: null == secondaryMuscles
            ? _value._secondaryMuscles
            : secondaryMuscles // ignore: cast_nullable_to_non_nullable
                  as List<MuscleGroup>,
        equipmentRequired: null == equipmentRequired
            ? _value._equipmentRequired
            : equipmentRequired // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        difficulty: null == difficulty
            ? _value.difficulty
            : difficulty // ignore: cast_nullable_to_non_nullable
                  as ExperienceLevel,
        instructions: null == instructions
            ? _value._instructions
            : instructions // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        tips: null == tips
            ? _value._tips
            : tips // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        animationUrl: freezed == animationUrl
            ? _value.animationUrl
            : animationUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        videoUrl: freezed == videoUrl
            ? _value.videoUrl
            : videoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        thumbnailUrl: freezed == thumbnailUrl
            ? _value.thumbnailUrl
            : thumbnailUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        caloriesPerMinute: freezed == caloriesPerMinute
            ? _value.caloriesPerMinute
            : caloriesPerMinute // ignore: cast_nullable_to_non_nullable
                  as double?,
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
class _$ExerciseModelImpl implements _ExerciseModel {
  const _$ExerciseModelImpl({
    required this.id,
    required this.name,
    this.nameEn,
    required this.category,
    required this.primaryMuscle,
    final List<MuscleGroup> secondaryMuscles = const [],
    final List<String> equipmentRequired = const [],
    required this.difficulty,
    final List<String> instructions = const [],
    final List<String> tips = const [],
    this.animationUrl,
    this.videoUrl,
    this.thumbnailUrl,
    this.caloriesPerMinute,
    this.createdAt,
  }) : _secondaryMuscles = secondaryMuscles,
       _equipmentRequired = equipmentRequired,
       _instructions = instructions,
       _tips = tips;

  factory _$ExerciseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExerciseModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? nameEn;
  @override
  final ExerciseCategory category;
  @override
  final MuscleGroup primaryMuscle;
  final List<MuscleGroup> _secondaryMuscles;
  @override
  @JsonKey()
  List<MuscleGroup> get secondaryMuscles {
    if (_secondaryMuscles is EqualUnmodifiableListView)
      return _secondaryMuscles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_secondaryMuscles);
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
  final ExperienceLevel difficulty;
  final List<String> _instructions;
  @override
  @JsonKey()
  List<String> get instructions {
    if (_instructions is EqualUnmodifiableListView) return _instructions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_instructions);
  }

  final List<String> _tips;
  @override
  @JsonKey()
  List<String> get tips {
    if (_tips is EqualUnmodifiableListView) return _tips;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tips);
  }

  @override
  final String? animationUrl;
  @override
  final String? videoUrl;
  @override
  final String? thumbnailUrl;
  @override
  final double? caloriesPerMinute;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'ExerciseModel(id: $id, name: $name, nameEn: $nameEn, category: $category, primaryMuscle: $primaryMuscle, secondaryMuscles: $secondaryMuscles, equipmentRequired: $equipmentRequired, difficulty: $difficulty, instructions: $instructions, tips: $tips, animationUrl: $animationUrl, videoUrl: $videoUrl, thumbnailUrl: $thumbnailUrl, caloriesPerMinute: $caloriesPerMinute, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExerciseModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.nameEn, nameEn) || other.nameEn == nameEn) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.primaryMuscle, primaryMuscle) ||
                other.primaryMuscle == primaryMuscle) &&
            const DeepCollectionEquality().equals(
              other._secondaryMuscles,
              _secondaryMuscles,
            ) &&
            const DeepCollectionEquality().equals(
              other._equipmentRequired,
              _equipmentRequired,
            ) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            const DeepCollectionEquality().equals(
              other._instructions,
              _instructions,
            ) &&
            const DeepCollectionEquality().equals(other._tips, _tips) &&
            (identical(other.animationUrl, animationUrl) ||
                other.animationUrl == animationUrl) &&
            (identical(other.videoUrl, videoUrl) ||
                other.videoUrl == videoUrl) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.caloriesPerMinute, caloriesPerMinute) ||
                other.caloriesPerMinute == caloriesPerMinute) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    nameEn,
    category,
    primaryMuscle,
    const DeepCollectionEquality().hash(_secondaryMuscles),
    const DeepCollectionEquality().hash(_equipmentRequired),
    difficulty,
    const DeepCollectionEquality().hash(_instructions),
    const DeepCollectionEquality().hash(_tips),
    animationUrl,
    videoUrl,
    thumbnailUrl,
    caloriesPerMinute,
    createdAt,
  );

  /// Create a copy of ExerciseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExerciseModelImplCopyWith<_$ExerciseModelImpl> get copyWith =>
      __$$ExerciseModelImplCopyWithImpl<_$ExerciseModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExerciseModelImplToJson(this);
  }
}

abstract class _ExerciseModel implements ExerciseModel {
  const factory _ExerciseModel({
    required final String id,
    required final String name,
    final String? nameEn,
    required final ExerciseCategory category,
    required final MuscleGroup primaryMuscle,
    final List<MuscleGroup> secondaryMuscles,
    final List<String> equipmentRequired,
    required final ExperienceLevel difficulty,
    final List<String> instructions,
    final List<String> tips,
    final String? animationUrl,
    final String? videoUrl,
    final String? thumbnailUrl,
    final double? caloriesPerMinute,
    final DateTime? createdAt,
  }) = _$ExerciseModelImpl;

  factory _ExerciseModel.fromJson(Map<String, dynamic> json) =
      _$ExerciseModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get nameEn;
  @override
  ExerciseCategory get category;
  @override
  MuscleGroup get primaryMuscle;
  @override
  List<MuscleGroup> get secondaryMuscles;
  @override
  List<String> get equipmentRequired;
  @override
  ExperienceLevel get difficulty;
  @override
  List<String> get instructions;
  @override
  List<String> get tips;
  @override
  String? get animationUrl;
  @override
  String? get videoUrl;
  @override
  String? get thumbnailUrl;
  @override
  double? get caloriesPerMinute;
  @override
  DateTime? get createdAt;

  /// Create a copy of ExerciseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExerciseModelImplCopyWith<_$ExerciseModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
