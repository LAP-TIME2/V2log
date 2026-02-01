// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentRoutineExerciseHash() =>
    r'82dce533c7425c1374236f2b95f6c03bc9b0be14';

/// 현재 운동 (루틴 모드)
///
/// Copied from [currentRoutineExercise].
@ProviderFor(currentRoutineExercise)
final currentRoutineExerciseProvider =
    AutoDisposeProvider<PresetRoutineExerciseModel?>.internal(
      currentRoutineExercise,
      name: r'currentRoutineExerciseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$currentRoutineExerciseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentRoutineExerciseRef =
    AutoDisposeProviderRef<PresetRoutineExerciseModel?>;
String _$isWorkoutInProgressHash() =>
    r'fc7abc26edd3d125f7f070b74702f60ffd10d981';

/// 운동 진행 상태 Provider
///
/// Copied from [isWorkoutInProgress].
@ProviderFor(isWorkoutInProgress)
final isWorkoutInProgressProvider = AutoDisposeProvider<bool>.internal(
  isWorkoutInProgress,
  name: r'isWorkoutInProgressProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isWorkoutInProgressHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsWorkoutInProgressRef = AutoDisposeProviderRef<bool>;
String _$currentWorkoutSetsHash() =>
    r'c9687a8c0aaaf625b5401b74ad7a21a29766f8fc';

/// 현재 운동의 세트 목록 Provider
///
/// Copied from [currentWorkoutSets].
@ProviderFor(currentWorkoutSets)
final currentWorkoutSetsProvider =
    AutoDisposeProvider<List<WorkoutSetModel>>.internal(
      currentWorkoutSets,
      name: r'currentWorkoutSetsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$currentWorkoutSetsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentWorkoutSetsRef = AutoDisposeProviderRef<List<WorkoutSetModel>>;
String _$exerciseSetsHash() => r'13a7b3e243d21bb84f29c106ea9a0586f7e2ab43';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// 특정 운동의 세트 목록 Provider
///
/// Copied from [exerciseSets].
@ProviderFor(exerciseSets)
const exerciseSetsProvider = ExerciseSetsFamily();

/// 특정 운동의 세트 목록 Provider
///
/// Copied from [exerciseSets].
class ExerciseSetsFamily extends Family<List<WorkoutSetModel>> {
  /// 특정 운동의 세트 목록 Provider
  ///
  /// Copied from [exerciseSets].
  const ExerciseSetsFamily();

  /// 특정 운동의 세트 목록 Provider
  ///
  /// Copied from [exerciseSets].
  ExerciseSetsProvider call(String exerciseId) {
    return ExerciseSetsProvider(exerciseId);
  }

  @override
  ExerciseSetsProvider getProviderOverride(
    covariant ExerciseSetsProvider provider,
  ) {
    return call(provider.exerciseId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'exerciseSetsProvider';
}

/// 특정 운동의 세트 목록 Provider
///
/// Copied from [exerciseSets].
class ExerciseSetsProvider extends AutoDisposeProvider<List<WorkoutSetModel>> {
  /// 특정 운동의 세트 목록 Provider
  ///
  /// Copied from [exerciseSets].
  ExerciseSetsProvider(String exerciseId)
    : this._internal(
        (ref) => exerciseSets(ref as ExerciseSetsRef, exerciseId),
        from: exerciseSetsProvider,
        name: r'exerciseSetsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$exerciseSetsHash,
        dependencies: ExerciseSetsFamily._dependencies,
        allTransitiveDependencies:
            ExerciseSetsFamily._allTransitiveDependencies,
        exerciseId: exerciseId,
      );

  ExerciseSetsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.exerciseId,
  }) : super.internal();

  final String exerciseId;

  @override
  Override overrideWith(
    List<WorkoutSetModel> Function(ExerciseSetsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ExerciseSetsProvider._internal(
        (ref) => create(ref as ExerciseSetsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        exerciseId: exerciseId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<WorkoutSetModel>> createElement() {
    return _ExerciseSetsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ExerciseSetsProvider && other.exerciseId == exerciseId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, exerciseId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ExerciseSetsRef on AutoDisposeProviderRef<List<WorkoutSetModel>> {
  /// The parameter `exerciseId` of this provider.
  String get exerciseId;
}

class _ExerciseSetsProviderElement
    extends AutoDisposeProviderElement<List<WorkoutSetModel>>
    with ExerciseSetsRef {
  _ExerciseSetsProviderElement(super.provider);

  @override
  String get exerciseId => (origin as ExerciseSetsProvider).exerciseId;
}

String _$lastSetInfoHash() => r'f16d21a1de8208875f13f3621a8ab7a530bb678e';

/// 운동별 마지막 세트 정보 Provider
///
/// Copied from [lastSetInfo].
@ProviderFor(lastSetInfo)
const lastSetInfoProvider = LastSetInfoFamily();

/// 운동별 마지막 세트 정보 Provider
///
/// Copied from [lastSetInfo].
class LastSetInfoFamily extends Family<AsyncValue<Map<String, dynamic>?>> {
  /// 운동별 마지막 세트 정보 Provider
  ///
  /// Copied from [lastSetInfo].
  const LastSetInfoFamily();

  /// 운동별 마지막 세트 정보 Provider
  ///
  /// Copied from [lastSetInfo].
  LastSetInfoProvider call(String exerciseId) {
    return LastSetInfoProvider(exerciseId);
  }

  @override
  LastSetInfoProvider getProviderOverride(
    covariant LastSetInfoProvider provider,
  ) {
    return call(provider.exerciseId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'lastSetInfoProvider';
}

/// 운동별 마지막 세트 정보 Provider
///
/// Copied from [lastSetInfo].
class LastSetInfoProvider
    extends AutoDisposeFutureProvider<Map<String, dynamic>?> {
  /// 운동별 마지막 세트 정보 Provider
  ///
  /// Copied from [lastSetInfo].
  LastSetInfoProvider(String exerciseId)
    : this._internal(
        (ref) => lastSetInfo(ref as LastSetInfoRef, exerciseId),
        from: lastSetInfoProvider,
        name: r'lastSetInfoProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$lastSetInfoHash,
        dependencies: LastSetInfoFamily._dependencies,
        allTransitiveDependencies: LastSetInfoFamily._allTransitiveDependencies,
        exerciseId: exerciseId,
      );

  LastSetInfoProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.exerciseId,
  }) : super.internal();

  final String exerciseId;

  @override
  Override overrideWith(
    FutureOr<Map<String, dynamic>?> Function(LastSetInfoRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LastSetInfoProvider._internal(
        (ref) => create(ref as LastSetInfoRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        exerciseId: exerciseId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<String, dynamic>?> createElement() {
    return _LastSetInfoProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LastSetInfoProvider && other.exerciseId == exerciseId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, exerciseId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LastSetInfoRef on AutoDisposeFutureProviderRef<Map<String, dynamic>?> {
  /// The parameter `exerciseId` of this provider.
  String get exerciseId;
}

class _LastSetInfoProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, dynamic>?>
    with LastSetInfoRef {
  _LastSetInfoProviderElement(super.provider);

  @override
  String get exerciseId => (origin as LastSetInfoProvider).exerciseId;
}

String _$currentExercisesHash() => r'a9f6627fd69c0113036069153bdacf2312acec28';

/// 현재 운동 운동 목록 Provider (더미 데이터 사용)
///
/// Copied from [currentExercises].
@ProviderFor(currentExercises)
final currentExercisesProvider =
    AutoDisposeProvider<List<ExerciseModel>>.internal(
      currentExercises,
      name: r'currentExercisesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$currentExercisesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentExercisesRef = AutoDisposeProviderRef<List<ExerciseModel>>;
String _$recentWorkoutsHash() => r'154a4a2748b71f163eb1029d93e01d286110da97';

/// 최근 운동 기록 Provider
///
/// Copied from [recentWorkouts].
@ProviderFor(recentWorkouts)
final recentWorkoutsProvider =
    AutoDisposeFutureProvider<List<WorkoutSessionModel>>.internal(
      recentWorkouts,
      name: r'recentWorkoutsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$recentWorkoutsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RecentWorkoutsRef =
    AutoDisposeFutureProviderRef<List<WorkoutSessionModel>>;
String _$workoutHistoryHash() => r'f8e5ef1d549757825420d3905172c9a77011f336';

/// 운동 기록 히스토리 Provider (월별 그룹화)
///
/// Copied from [workoutHistory].
@ProviderFor(workoutHistory)
const workoutHistoryProvider = WorkoutHistoryFamily();

/// 운동 기록 히스토리 Provider (월별 그룹화)
///
/// Copied from [workoutHistory].
class WorkoutHistoryFamily
    extends Family<AsyncValue<List<WorkoutSessionModel>>> {
  /// 운동 기록 히스토리 Provider (월별 그룹화)
  ///
  /// Copied from [workoutHistory].
  const WorkoutHistoryFamily();

  /// 운동 기록 히스토리 Provider (월별 그룹화)
  ///
  /// Copied from [workoutHistory].
  WorkoutHistoryProvider call({int limit = 20, int offset = 0}) {
    return WorkoutHistoryProvider(limit: limit, offset: offset);
  }

  @override
  WorkoutHistoryProvider getProviderOverride(
    covariant WorkoutHistoryProvider provider,
  ) {
    return call(limit: provider.limit, offset: provider.offset);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'workoutHistoryProvider';
}

/// 운동 기록 히스토리 Provider (월별 그룹화)
///
/// Copied from [workoutHistory].
class WorkoutHistoryProvider
    extends AutoDisposeFutureProvider<List<WorkoutSessionModel>> {
  /// 운동 기록 히스토리 Provider (월별 그룹화)
  ///
  /// Copied from [workoutHistory].
  WorkoutHistoryProvider({int limit = 20, int offset = 0})
    : this._internal(
        (ref) => workoutHistory(
          ref as WorkoutHistoryRef,
          limit: limit,
          offset: offset,
        ),
        from: workoutHistoryProvider,
        name: r'workoutHistoryProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$workoutHistoryHash,
        dependencies: WorkoutHistoryFamily._dependencies,
        allTransitiveDependencies:
            WorkoutHistoryFamily._allTransitiveDependencies,
        limit: limit,
        offset: offset,
      );

  WorkoutHistoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.limit,
    required this.offset,
  }) : super.internal();

  final int limit;
  final int offset;

  @override
  Override overrideWith(
    FutureOr<List<WorkoutSessionModel>> Function(WorkoutHistoryRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WorkoutHistoryProvider._internal(
        (ref) => create(ref as WorkoutHistoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        limit: limit,
        offset: offset,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<WorkoutSessionModel>> createElement() {
    return _WorkoutHistoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WorkoutHistoryProvider &&
        other.limit == limit &&
        other.offset == offset;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);
    hash = _SystemHash.combine(hash, offset.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin WorkoutHistoryRef
    on AutoDisposeFutureProviderRef<List<WorkoutSessionModel>> {
  /// The parameter `limit` of this provider.
  int get limit;

  /// The parameter `offset` of this provider.
  int get offset;
}

class _WorkoutHistoryProviderElement
    extends AutoDisposeFutureProviderElement<List<WorkoutSessionModel>>
    with WorkoutHistoryRef {
  _WorkoutHistoryProviderElement(super.provider);

  @override
  int get limit => (origin as WorkoutHistoryProvider).limit;
  @override
  int get offset => (origin as WorkoutHistoryProvider).offset;
}

String _$workoutSessionDetailHash() =>
    r'20a1e4d8357217404dd411eb7584a4de3eaa9cbc';

/// 특정 세션 상세 조회 Provider
///
/// Copied from [workoutSessionDetail].
@ProviderFor(workoutSessionDetail)
const workoutSessionDetailProvider = WorkoutSessionDetailFamily();

/// 특정 세션 상세 조회 Provider
///
/// Copied from [workoutSessionDetail].
class WorkoutSessionDetailFamily
    extends Family<AsyncValue<WorkoutSessionModel?>> {
  /// 특정 세션 상세 조회 Provider
  ///
  /// Copied from [workoutSessionDetail].
  const WorkoutSessionDetailFamily();

  /// 특정 세션 상세 조회 Provider
  ///
  /// Copied from [workoutSessionDetail].
  WorkoutSessionDetailProvider call(String sessionId) {
    return WorkoutSessionDetailProvider(sessionId);
  }

  @override
  WorkoutSessionDetailProvider getProviderOverride(
    covariant WorkoutSessionDetailProvider provider,
  ) {
    return call(provider.sessionId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'workoutSessionDetailProvider';
}

/// 특정 세션 상세 조회 Provider
///
/// Copied from [workoutSessionDetail].
class WorkoutSessionDetailProvider
    extends AutoDisposeFutureProvider<WorkoutSessionModel?> {
  /// 특정 세션 상세 조회 Provider
  ///
  /// Copied from [workoutSessionDetail].
  WorkoutSessionDetailProvider(String sessionId)
    : this._internal(
        (ref) =>
            workoutSessionDetail(ref as WorkoutSessionDetailRef, sessionId),
        from: workoutSessionDetailProvider,
        name: r'workoutSessionDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$workoutSessionDetailHash,
        dependencies: WorkoutSessionDetailFamily._dependencies,
        allTransitiveDependencies:
            WorkoutSessionDetailFamily._allTransitiveDependencies,
        sessionId: sessionId,
      );

  WorkoutSessionDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.sessionId,
  }) : super.internal();

  final String sessionId;

  @override
  Override overrideWith(
    FutureOr<WorkoutSessionModel?> Function(WorkoutSessionDetailRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WorkoutSessionDetailProvider._internal(
        (ref) => create(ref as WorkoutSessionDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        sessionId: sessionId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<WorkoutSessionModel?> createElement() {
    return _WorkoutSessionDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WorkoutSessionDetailProvider &&
        other.sessionId == sessionId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, sessionId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin WorkoutSessionDetailRef
    on AutoDisposeFutureProviderRef<WorkoutSessionModel?> {
  /// The parameter `sessionId` of this provider.
  String get sessionId;
}

class _WorkoutSessionDetailProviderElement
    extends AutoDisposeFutureProviderElement<WorkoutSessionModel?>
    with WorkoutSessionDetailRef {
  _WorkoutSessionDetailProviderElement(super.provider);

  @override
  String get sessionId => (origin as WorkoutSessionDetailProvider).sessionId;
}

String _$exerciseNamesMapHash() => r'7ae7f27e044aac73f3e9b3bb56e9a4c99259b440';

/// 운동 이름 맵 Provider (exercise_id -> name)
///
/// Copied from [exerciseNamesMap].
@ProviderFor(exerciseNamesMap)
final exerciseNamesMapProvider =
    AutoDisposeFutureProvider<Map<String, String>>.internal(
      exerciseNamesMap,
      name: r'exerciseNamesMapProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$exerciseNamesMapHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ExerciseNamesMapRef = AutoDisposeFutureProviderRef<Map<String, String>>;
String _$activeWorkoutHash() => r'335518839880636c2d35f47dbcb6863018adeda3';

/// 활성 운동 세션 Provider
///
/// Copied from [ActiveWorkout].
@ProviderFor(ActiveWorkout)
final activeWorkoutProvider =
    NotifierProvider<ActiveWorkout, WorkoutSessionModel?>.internal(
      ActiveWorkout.new,
      name: r'activeWorkoutProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$activeWorkoutHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ActiveWorkout = Notifier<WorkoutSessionModel?>;
String _$routineExercisesHash() => r'5b0ff5d5aa50dd4d1af6659283631a760ef8d290';

/// 현재 루틴 운동 목록 Provider (프리셋 루틴 모드일 때)
///
/// Copied from [RoutineExercises].
@ProviderFor(RoutineExercises)
final routineExercisesProvider =
    NotifierProvider<
      RoutineExercises,
      List<PresetRoutineExerciseModel>
    >.internal(
      RoutineExercises.new,
      name: r'routineExercisesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$routineExercisesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$RoutineExercises = Notifier<List<PresetRoutineExerciseModel>>;
String _$currentExerciseIndexHash() =>
    r'5f88e73819f24a3d4eedf94d23ccd07809ccb2a1';

/// 현재 운동 인덱스 Provider
///
/// Copied from [CurrentExerciseIndex].
@ProviderFor(CurrentExerciseIndex)
final currentExerciseIndexProvider =
    NotifierProvider<CurrentExerciseIndex, int>.internal(
      CurrentExerciseIndex.new,
      name: r'currentExerciseIndexProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$currentExerciseIndexHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CurrentExerciseIndex = Notifier<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
