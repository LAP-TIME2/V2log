// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preset_routine_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$presetRoutinesHash() => r'81be67bf3452fdefa79aca490e99f2228b77b3c8';

/// 모든 프리셋 루틴 목록 Provider
/// Supabase 실패 시 더미 데이터 반환
///
/// Copied from [presetRoutines].
@ProviderFor(presetRoutines)
final presetRoutinesProvider =
    AutoDisposeFutureProvider<List<PresetRoutineModel>>.internal(
      presetRoutines,
      name: r'presetRoutinesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$presetRoutinesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PresetRoutinesRef =
    AutoDisposeFutureProviderRef<List<PresetRoutineModel>>;
String _$featuredPresetRoutinesHash() =>
    r'c4a28891644d24d294a8e5ce96e15576a327a266';

/// 추천(Featured) 프리셋 루틴 목록 Provider
///
/// Copied from [featuredPresetRoutines].
@ProviderFor(featuredPresetRoutines)
final featuredPresetRoutinesProvider =
    AutoDisposeFutureProvider<List<PresetRoutineModel>>.internal(
      featuredPresetRoutines,
      name: r'featuredPresetRoutinesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$featuredPresetRoutinesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FeaturedPresetRoutinesRef =
    AutoDisposeFutureProviderRef<List<PresetRoutineModel>>;
String _$presetRoutinesByDifficultyHash() =>
    r'd8b683b263d9542add2d5086cf1224979953e0b0';

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

/// 난이도별 프리셋 루틴 Provider
///
/// Copied from [presetRoutinesByDifficulty].
@ProviderFor(presetRoutinesByDifficulty)
const presetRoutinesByDifficultyProvider = PresetRoutinesByDifficultyFamily();

/// 난이도별 프리셋 루틴 Provider
///
/// Copied from [presetRoutinesByDifficulty].
class PresetRoutinesByDifficultyFamily
    extends Family<AsyncValue<List<PresetRoutineModel>>> {
  /// 난이도별 프리셋 루틴 Provider
  ///
  /// Copied from [presetRoutinesByDifficulty].
  const PresetRoutinesByDifficultyFamily();

  /// 난이도별 프리셋 루틴 Provider
  ///
  /// Copied from [presetRoutinesByDifficulty].
  PresetRoutinesByDifficultyProvider call(ExperienceLevel difficulty) {
    return PresetRoutinesByDifficultyProvider(difficulty);
  }

  @override
  PresetRoutinesByDifficultyProvider getProviderOverride(
    covariant PresetRoutinesByDifficultyProvider provider,
  ) {
    return call(provider.difficulty);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'presetRoutinesByDifficultyProvider';
}

/// 난이도별 프리셋 루틴 Provider
///
/// Copied from [presetRoutinesByDifficulty].
class PresetRoutinesByDifficultyProvider
    extends AutoDisposeFutureProvider<List<PresetRoutineModel>> {
  /// 난이도별 프리셋 루틴 Provider
  ///
  /// Copied from [presetRoutinesByDifficulty].
  PresetRoutinesByDifficultyProvider(ExperienceLevel difficulty)
    : this._internal(
        (ref) => presetRoutinesByDifficulty(
          ref as PresetRoutinesByDifficultyRef,
          difficulty,
        ),
        from: presetRoutinesByDifficultyProvider,
        name: r'presetRoutinesByDifficultyProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$presetRoutinesByDifficultyHash,
        dependencies: PresetRoutinesByDifficultyFamily._dependencies,
        allTransitiveDependencies:
            PresetRoutinesByDifficultyFamily._allTransitiveDependencies,
        difficulty: difficulty,
      );

  PresetRoutinesByDifficultyProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.difficulty,
  }) : super.internal();

  final ExperienceLevel difficulty;

  @override
  Override overrideWith(
    FutureOr<List<PresetRoutineModel>> Function(
      PresetRoutinesByDifficultyRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PresetRoutinesByDifficultyProvider._internal(
        (ref) => create(ref as PresetRoutinesByDifficultyRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        difficulty: difficulty,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<PresetRoutineModel>> createElement() {
    return _PresetRoutinesByDifficultyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PresetRoutinesByDifficultyProvider &&
        other.difficulty == difficulty;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, difficulty.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PresetRoutinesByDifficultyRef
    on AutoDisposeFutureProviderRef<List<PresetRoutineModel>> {
  /// The parameter `difficulty` of this provider.
  ExperienceLevel get difficulty;
}

class _PresetRoutinesByDifficultyProviderElement
    extends AutoDisposeFutureProviderElement<List<PresetRoutineModel>>
    with PresetRoutinesByDifficultyRef {
  _PresetRoutinesByDifficultyProviderElement(super.provider);

  @override
  ExperienceLevel get difficulty =>
      (origin as PresetRoutinesByDifficultyProvider).difficulty;
}

String _$presetRoutinesByGoalHash() =>
    r'6ca4076d18fb868d73e1c7b646c6dc931a60acef';

/// 목표별 프리셋 루틴 Provider
///
/// Copied from [presetRoutinesByGoal].
@ProviderFor(presetRoutinesByGoal)
const presetRoutinesByGoalProvider = PresetRoutinesByGoalFamily();

/// 목표별 프리셋 루틴 Provider
///
/// Copied from [presetRoutinesByGoal].
class PresetRoutinesByGoalFamily
    extends Family<AsyncValue<List<PresetRoutineModel>>> {
  /// 목표별 프리셋 루틴 Provider
  ///
  /// Copied from [presetRoutinesByGoal].
  const PresetRoutinesByGoalFamily();

  /// 목표별 프리셋 루틴 Provider
  ///
  /// Copied from [presetRoutinesByGoal].
  PresetRoutinesByGoalProvider call(FitnessGoal targetGoal) {
    return PresetRoutinesByGoalProvider(targetGoal);
  }

  @override
  PresetRoutinesByGoalProvider getProviderOverride(
    covariant PresetRoutinesByGoalProvider provider,
  ) {
    return call(provider.targetGoal);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'presetRoutinesByGoalProvider';
}

/// 목표별 프리셋 루틴 Provider
///
/// Copied from [presetRoutinesByGoal].
class PresetRoutinesByGoalProvider
    extends AutoDisposeFutureProvider<List<PresetRoutineModel>> {
  /// 목표별 프리셋 루틴 Provider
  ///
  /// Copied from [presetRoutinesByGoal].
  PresetRoutinesByGoalProvider(FitnessGoal targetGoal)
    : this._internal(
        (ref) =>
            presetRoutinesByGoal(ref as PresetRoutinesByGoalRef, targetGoal),
        from: presetRoutinesByGoalProvider,
        name: r'presetRoutinesByGoalProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$presetRoutinesByGoalHash,
        dependencies: PresetRoutinesByGoalFamily._dependencies,
        allTransitiveDependencies:
            PresetRoutinesByGoalFamily._allTransitiveDependencies,
        targetGoal: targetGoal,
      );

  PresetRoutinesByGoalProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.targetGoal,
  }) : super.internal();

  final FitnessGoal targetGoal;

  @override
  Override overrideWith(
    FutureOr<List<PresetRoutineModel>> Function(
      PresetRoutinesByGoalRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PresetRoutinesByGoalProvider._internal(
        (ref) => create(ref as PresetRoutinesByGoalRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        targetGoal: targetGoal,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<PresetRoutineModel>> createElement() {
    return _PresetRoutinesByGoalProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PresetRoutinesByGoalProvider &&
        other.targetGoal == targetGoal;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, targetGoal.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PresetRoutinesByGoalRef
    on AutoDisposeFutureProviderRef<List<PresetRoutineModel>> {
  /// The parameter `targetGoal` of this provider.
  FitnessGoal get targetGoal;
}

class _PresetRoutinesByGoalProviderElement
    extends AutoDisposeFutureProviderElement<List<PresetRoutineModel>>
    with PresetRoutinesByGoalRef {
  _PresetRoutinesByGoalProviderElement(super.provider);

  @override
  FitnessGoal get targetGoal =>
      (origin as PresetRoutinesByGoalProvider).targetGoal;
}

String _$filteredPresetRoutinesHash() =>
    r'921d21bf507532d354b457eac59203ac4f72f6ce';

/// 필터링된 프리셋 루틴 목록 Provider
///
/// Copied from [filteredPresetRoutines].
@ProviderFor(filteredPresetRoutines)
final filteredPresetRoutinesProvider =
    AutoDisposeFutureProvider<List<PresetRoutineModel>>.internal(
      filteredPresetRoutines,
      name: r'filteredPresetRoutinesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$filteredPresetRoutinesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FilteredPresetRoutinesRef =
    AutoDisposeFutureProviderRef<List<PresetRoutineModel>>;
String _$presetRoutineDetailHash() =>
    r'7fdd11a34e0ec69b09e98b26904a849db5e49c93';

/// 프리셋 루틴 상세 Provider (운동 포함)
///
/// Copied from [presetRoutineDetail].
@ProviderFor(presetRoutineDetail)
const presetRoutineDetailProvider = PresetRoutineDetailFamily();

/// 프리셋 루틴 상세 Provider (운동 포함)
///
/// Copied from [presetRoutineDetail].
class PresetRoutineDetailFamily extends Family<AsyncValue<PresetRoutineModel>> {
  /// 프리셋 루틴 상세 Provider (운동 포함)
  ///
  /// Copied from [presetRoutineDetail].
  const PresetRoutineDetailFamily();

  /// 프리셋 루틴 상세 Provider (운동 포함)
  ///
  /// Copied from [presetRoutineDetail].
  PresetRoutineDetailProvider call(String routineId) {
    return PresetRoutineDetailProvider(routineId);
  }

  @override
  PresetRoutineDetailProvider getProviderOverride(
    covariant PresetRoutineDetailProvider provider,
  ) {
    return call(provider.routineId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'presetRoutineDetailProvider';
}

/// 프리셋 루틴 상세 Provider (운동 포함)
///
/// Copied from [presetRoutineDetail].
class PresetRoutineDetailProvider
    extends AutoDisposeFutureProvider<PresetRoutineModel> {
  /// 프리셋 루틴 상세 Provider (운동 포함)
  ///
  /// Copied from [presetRoutineDetail].
  PresetRoutineDetailProvider(String routineId)
    : this._internal(
        (ref) => presetRoutineDetail(ref as PresetRoutineDetailRef, routineId),
        from: presetRoutineDetailProvider,
        name: r'presetRoutineDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$presetRoutineDetailHash,
        dependencies: PresetRoutineDetailFamily._dependencies,
        allTransitiveDependencies:
            PresetRoutineDetailFamily._allTransitiveDependencies,
        routineId: routineId,
      );

  PresetRoutineDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.routineId,
  }) : super.internal();

  final String routineId;

  @override
  Override overrideWith(
    FutureOr<PresetRoutineModel> Function(PresetRoutineDetailRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PresetRoutineDetailProvider._internal(
        (ref) => create(ref as PresetRoutineDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        routineId: routineId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<PresetRoutineModel> createElement() {
    return _PresetRoutineDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PresetRoutineDetailProvider && other.routineId == routineId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, routineId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PresetRoutineDetailRef
    on AutoDisposeFutureProviderRef<PresetRoutineModel> {
  /// The parameter `routineId` of this provider.
  String get routineId;
}

class _PresetRoutineDetailProviderElement
    extends AutoDisposeFutureProviderElement<PresetRoutineModel>
    with PresetRoutineDetailRef {
  _PresetRoutineDetailProviderElement(super.provider);

  @override
  String get routineId => (origin as PresetRoutineDetailProvider).routineId;
}

String _$presetRoutineDayExercisesHash() =>
    r'20a705d9214a41417d8d1d1e6ad61fd15f414d52';

/// 프리셋 루틴의 특정 Day 운동 목록 Provider
///
/// Copied from [presetRoutineDayExercises].
@ProviderFor(presetRoutineDayExercises)
const presetRoutineDayExercisesProvider = PresetRoutineDayExercisesFamily();

/// 프리셋 루틴의 특정 Day 운동 목록 Provider
///
/// Copied from [presetRoutineDayExercises].
class PresetRoutineDayExercisesFamily
    extends Family<AsyncValue<List<PresetRoutineExerciseModel>>> {
  /// 프리셋 루틴의 특정 Day 운동 목록 Provider
  ///
  /// Copied from [presetRoutineDayExercises].
  const PresetRoutineDayExercisesFamily();

  /// 프리셋 루틴의 특정 Day 운동 목록 Provider
  ///
  /// Copied from [presetRoutineDayExercises].
  PresetRoutineDayExercisesProvider call(String routineId, int dayNumber) {
    return PresetRoutineDayExercisesProvider(routineId, dayNumber);
  }

  @override
  PresetRoutineDayExercisesProvider getProviderOverride(
    covariant PresetRoutineDayExercisesProvider provider,
  ) {
    return call(provider.routineId, provider.dayNumber);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'presetRoutineDayExercisesProvider';
}

/// 프리셋 루틴의 특정 Day 운동 목록 Provider
///
/// Copied from [presetRoutineDayExercises].
class PresetRoutineDayExercisesProvider
    extends AutoDisposeFutureProvider<List<PresetRoutineExerciseModel>> {
  /// 프리셋 루틴의 특정 Day 운동 목록 Provider
  ///
  /// Copied from [presetRoutineDayExercises].
  PresetRoutineDayExercisesProvider(String routineId, int dayNumber)
    : this._internal(
        (ref) => presetRoutineDayExercises(
          ref as PresetRoutineDayExercisesRef,
          routineId,
          dayNumber,
        ),
        from: presetRoutineDayExercisesProvider,
        name: r'presetRoutineDayExercisesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$presetRoutineDayExercisesHash,
        dependencies: PresetRoutineDayExercisesFamily._dependencies,
        allTransitiveDependencies:
            PresetRoutineDayExercisesFamily._allTransitiveDependencies,
        routineId: routineId,
        dayNumber: dayNumber,
      );

  PresetRoutineDayExercisesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.routineId,
    required this.dayNumber,
  }) : super.internal();

  final String routineId;
  final int dayNumber;

  @override
  Override overrideWith(
    FutureOr<List<PresetRoutineExerciseModel>> Function(
      PresetRoutineDayExercisesRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PresetRoutineDayExercisesProvider._internal(
        (ref) => create(ref as PresetRoutineDayExercisesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        routineId: routineId,
        dayNumber: dayNumber,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<PresetRoutineExerciseModel>>
  createElement() {
    return _PresetRoutineDayExercisesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PresetRoutineDayExercisesProvider &&
        other.routineId == routineId &&
        other.dayNumber == dayNumber;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, routineId.hashCode);
    hash = _SystemHash.combine(hash, dayNumber.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PresetRoutineDayExercisesRef
    on AutoDisposeFutureProviderRef<List<PresetRoutineExerciseModel>> {
  /// The parameter `routineId` of this provider.
  String get routineId;

  /// The parameter `dayNumber` of this provider.
  int get dayNumber;
}

class _PresetRoutineDayExercisesProviderElement
    extends AutoDisposeFutureProviderElement<List<PresetRoutineExerciseModel>>
    with PresetRoutineDayExercisesRef {
  _PresetRoutineDayExercisesProviderElement(super.provider);

  @override
  String get routineId =>
      (origin as PresetRoutineDayExercisesProvider).routineId;
  @override
  int get dayNumber => (origin as PresetRoutineDayExercisesProvider).dayNumber;
}

String _$selectedPresetRoutineDetailHash() =>
    r'60c6982f0ecaf6cd254dbb322be8d84f33aa79c3';

/// 선택된 프리셋 루틴 상세 (선택된 ID 기반)
///
/// Copied from [selectedPresetRoutineDetail].
@ProviderFor(selectedPresetRoutineDetail)
final selectedPresetRoutineDetailProvider =
    AutoDisposeFutureProvider<PresetRoutineModel?>.internal(
      selectedPresetRoutineDetail,
      name: r'selectedPresetRoutineDetailProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$selectedPresetRoutineDetailHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SelectedPresetRoutineDetailRef =
    AutoDisposeFutureProviderRef<PresetRoutineModel?>;
String _$groupedPresetRoutinesHash() =>
    r'1e4f18ea3e93c81ccb06fb0c392d12779762c4cf';

/// 난이도별 그룹화된 프리셋 루틴 Provider
///
/// Copied from [groupedPresetRoutines].
@ProviderFor(groupedPresetRoutines)
final groupedPresetRoutinesProvider =
    AutoDisposeFutureProvider<
      Map<ExperienceLevel, List<PresetRoutineModel>>
    >.internal(
      groupedPresetRoutines,
      name: r'groupedPresetRoutinesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$groupedPresetRoutinesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GroupedPresetRoutinesRef =
    AutoDisposeFutureProviderRef<
      Map<ExperienceLevel, List<PresetRoutineModel>>
    >;
String _$presetRoutineFilterStateHash() =>
    r'f7230cdf5d53d035cfc9dd005068044e4eef7517';

/// 프리셋 루틴 필터 상태 Provider
///
/// Copied from [PresetRoutineFilterState].
@ProviderFor(PresetRoutineFilterState)
final presetRoutineFilterStateProvider =
    AutoDisposeNotifierProvider<
      PresetRoutineFilterState,
      PresetRoutineFilter
    >.internal(
      PresetRoutineFilterState.new,
      name: r'presetRoutineFilterStateProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$presetRoutineFilterStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PresetRoutineFilterState = AutoDisposeNotifier<PresetRoutineFilter>;
String _$selectedPresetRoutineIdHash() =>
    r'f609262b61eb3fd3a13ef8ad9e8df72fc21eb0ff';

/// 선택된 프리셋 루틴 ID Provider
///
/// Copied from [SelectedPresetRoutineId].
@ProviderFor(SelectedPresetRoutineId)
final selectedPresetRoutineIdProvider =
    AutoDisposeNotifierProvider<SelectedPresetRoutineId, String?>.internal(
      SelectedPresetRoutineId.new,
      name: r'selectedPresetRoutineIdProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$selectedPresetRoutineIdHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedPresetRoutineId = AutoDisposeNotifier<String?>;
String _$selectedDayNumberHash() => r'b5053a8963a09edb9469fd00f02c9e98f16119d2';

/// 선택된 Day 번호 Provider
///
/// Copied from [SelectedDayNumber].
@ProviderFor(SelectedDayNumber)
final selectedDayNumberProvider =
    AutoDisposeNotifierProvider<SelectedDayNumber, int>.internal(
      SelectedDayNumber.new,
      name: r'selectedDayNumberProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$selectedDayNumberHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedDayNumber = AutoDisposeNotifier<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
