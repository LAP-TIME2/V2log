// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$exercisesHash() => r'12c3dc7f645f92406e1c5f8dd5b752c6c6c4cb26';

/// 모든 운동 목록 Provider
///
/// Copied from [exercises].
@ProviderFor(exercises)
final exercisesProvider =
    AutoDisposeFutureProvider<List<ExerciseModel>>.internal(
      exercises,
      name: r'exercisesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$exercisesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ExercisesRef = AutoDisposeFutureProviderRef<List<ExerciseModel>>;
String _$exercisesByMuscleHash() => r'71d7b11609a0aec8d17d3e04c23e7ea3c76f41d0';

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

/// 근육 부위별 운동 목록 Provider
///
/// Copied from [exercisesByMuscle].
@ProviderFor(exercisesByMuscle)
const exercisesByMuscleProvider = ExercisesByMuscleFamily();

/// 근육 부위별 운동 목록 Provider
///
/// Copied from [exercisesByMuscle].
class ExercisesByMuscleFamily extends Family<AsyncValue<List<ExerciseModel>>> {
  /// 근육 부위별 운동 목록 Provider
  ///
  /// Copied from [exercisesByMuscle].
  const ExercisesByMuscleFamily();

  /// 근육 부위별 운동 목록 Provider
  ///
  /// Copied from [exercisesByMuscle].
  ExercisesByMuscleProvider call(MuscleGroup muscle) {
    return ExercisesByMuscleProvider(muscle);
  }

  @override
  ExercisesByMuscleProvider getProviderOverride(
    covariant ExercisesByMuscleProvider provider,
  ) {
    return call(provider.muscle);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'exercisesByMuscleProvider';
}

/// 근육 부위별 운동 목록 Provider
///
/// Copied from [exercisesByMuscle].
class ExercisesByMuscleProvider
    extends AutoDisposeFutureProvider<List<ExerciseModel>> {
  /// 근육 부위별 운동 목록 Provider
  ///
  /// Copied from [exercisesByMuscle].
  ExercisesByMuscleProvider(MuscleGroup muscle)
    : this._internal(
        (ref) => exercisesByMuscle(ref as ExercisesByMuscleRef, muscle),
        from: exercisesByMuscleProvider,
        name: r'exercisesByMuscleProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$exercisesByMuscleHash,
        dependencies: ExercisesByMuscleFamily._dependencies,
        allTransitiveDependencies:
            ExercisesByMuscleFamily._allTransitiveDependencies,
        muscle: muscle,
      );

  ExercisesByMuscleProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.muscle,
  }) : super.internal();

  final MuscleGroup muscle;

  @override
  Override overrideWith(
    FutureOr<List<ExerciseModel>> Function(ExercisesByMuscleRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ExercisesByMuscleProvider._internal(
        (ref) => create(ref as ExercisesByMuscleRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        muscle: muscle,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ExerciseModel>> createElement() {
    return _ExercisesByMuscleProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ExercisesByMuscleProvider && other.muscle == muscle;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, muscle.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ExercisesByMuscleRef
    on AutoDisposeFutureProviderRef<List<ExerciseModel>> {
  /// The parameter `muscle` of this provider.
  MuscleGroup get muscle;
}

class _ExercisesByMuscleProviderElement
    extends AutoDisposeFutureProviderElement<List<ExerciseModel>>
    with ExercisesByMuscleRef {
  _ExercisesByMuscleProviderElement(super.provider);

  @override
  MuscleGroup get muscle => (origin as ExercisesByMuscleProvider).muscle;
}

String _$exercisesByCategoryHash() =>
    r'9fa09e13fd7037dc964821fd398ed99410ba96eb';

/// 카테고리별 운동 목록 Provider
///
/// Copied from [exercisesByCategory].
@ProviderFor(exercisesByCategory)
const exercisesByCategoryProvider = ExercisesByCategoryFamily();

/// 카테고리별 운동 목록 Provider
///
/// Copied from [exercisesByCategory].
class ExercisesByCategoryFamily
    extends Family<AsyncValue<List<ExerciseModel>>> {
  /// 카테고리별 운동 목록 Provider
  ///
  /// Copied from [exercisesByCategory].
  const ExercisesByCategoryFamily();

  /// 카테고리별 운동 목록 Provider
  ///
  /// Copied from [exercisesByCategory].
  ExercisesByCategoryProvider call(ExerciseCategory category) {
    return ExercisesByCategoryProvider(category);
  }

  @override
  ExercisesByCategoryProvider getProviderOverride(
    covariant ExercisesByCategoryProvider provider,
  ) {
    return call(provider.category);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'exercisesByCategoryProvider';
}

/// 카테고리별 운동 목록 Provider
///
/// Copied from [exercisesByCategory].
class ExercisesByCategoryProvider
    extends AutoDisposeFutureProvider<List<ExerciseModel>> {
  /// 카테고리별 운동 목록 Provider
  ///
  /// Copied from [exercisesByCategory].
  ExercisesByCategoryProvider(ExerciseCategory category)
    : this._internal(
        (ref) => exercisesByCategory(ref as ExercisesByCategoryRef, category),
        from: exercisesByCategoryProvider,
        name: r'exercisesByCategoryProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$exercisesByCategoryHash,
        dependencies: ExercisesByCategoryFamily._dependencies,
        allTransitiveDependencies:
            ExercisesByCategoryFamily._allTransitiveDependencies,
        category: category,
      );

  ExercisesByCategoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.category,
  }) : super.internal();

  final ExerciseCategory category;

  @override
  Override overrideWith(
    FutureOr<List<ExerciseModel>> Function(ExercisesByCategoryRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ExercisesByCategoryProvider._internal(
        (ref) => create(ref as ExercisesByCategoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        category: category,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ExerciseModel>> createElement() {
    return _ExercisesByCategoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ExercisesByCategoryProvider && other.category == category;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, category.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ExercisesByCategoryRef
    on AutoDisposeFutureProviderRef<List<ExerciseModel>> {
  /// The parameter `category` of this provider.
  ExerciseCategory get category;
}

class _ExercisesByCategoryProviderElement
    extends AutoDisposeFutureProviderElement<List<ExerciseModel>>
    with ExercisesByCategoryRef {
  _ExercisesByCategoryProviderElement(super.provider);

  @override
  ExerciseCategory get category =>
      (origin as ExercisesByCategoryProvider).category;
}

String _$exercisesByDifficultyHash() =>
    r'0bfa31e6890ee9d6bc4e77d725b38b37dd2e7e3f';

/// 난이도별 운동 목록 Provider
///
/// Copied from [exercisesByDifficulty].
@ProviderFor(exercisesByDifficulty)
const exercisesByDifficultyProvider = ExercisesByDifficultyFamily();

/// 난이도별 운동 목록 Provider
///
/// Copied from [exercisesByDifficulty].
class ExercisesByDifficultyFamily
    extends Family<AsyncValue<List<ExerciseModel>>> {
  /// 난이도별 운동 목록 Provider
  ///
  /// Copied from [exercisesByDifficulty].
  const ExercisesByDifficultyFamily();

  /// 난이도별 운동 목록 Provider
  ///
  /// Copied from [exercisesByDifficulty].
  ExercisesByDifficultyProvider call(ExperienceLevel difficulty) {
    return ExercisesByDifficultyProvider(difficulty);
  }

  @override
  ExercisesByDifficultyProvider getProviderOverride(
    covariant ExercisesByDifficultyProvider provider,
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
  String? get name => r'exercisesByDifficultyProvider';
}

/// 난이도별 운동 목록 Provider
///
/// Copied from [exercisesByDifficulty].
class ExercisesByDifficultyProvider
    extends AutoDisposeFutureProvider<List<ExerciseModel>> {
  /// 난이도별 운동 목록 Provider
  ///
  /// Copied from [exercisesByDifficulty].
  ExercisesByDifficultyProvider(ExperienceLevel difficulty)
    : this._internal(
        (ref) =>
            exercisesByDifficulty(ref as ExercisesByDifficultyRef, difficulty),
        from: exercisesByDifficultyProvider,
        name: r'exercisesByDifficultyProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$exercisesByDifficultyHash,
        dependencies: ExercisesByDifficultyFamily._dependencies,
        allTransitiveDependencies:
            ExercisesByDifficultyFamily._allTransitiveDependencies,
        difficulty: difficulty,
      );

  ExercisesByDifficultyProvider._internal(
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
    FutureOr<List<ExerciseModel>> Function(ExercisesByDifficultyRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ExercisesByDifficultyProvider._internal(
        (ref) => create(ref as ExercisesByDifficultyRef),
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
  AutoDisposeFutureProviderElement<List<ExerciseModel>> createElement() {
    return _ExercisesByDifficultyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ExercisesByDifficultyProvider &&
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
mixin ExercisesByDifficultyRef
    on AutoDisposeFutureProviderRef<List<ExerciseModel>> {
  /// The parameter `difficulty` of this provider.
  ExperienceLevel get difficulty;
}

class _ExercisesByDifficultyProviderElement
    extends AutoDisposeFutureProviderElement<List<ExerciseModel>>
    with ExercisesByDifficultyRef {
  _ExercisesByDifficultyProviderElement(super.provider);

  @override
  ExperienceLevel get difficulty =>
      (origin as ExercisesByDifficultyProvider).difficulty;
}

String _$exerciseDetailHash() => r'7611c465630a84f44df5d4e763f65280ce6a9827';

/// 운동 상세 Provider
///
/// Copied from [exerciseDetail].
@ProviderFor(exerciseDetail)
const exerciseDetailProvider = ExerciseDetailFamily();

/// 운동 상세 Provider
///
/// Copied from [exerciseDetail].
class ExerciseDetailFamily extends Family<AsyncValue<ExerciseModel?>> {
  /// 운동 상세 Provider
  ///
  /// Copied from [exerciseDetail].
  const ExerciseDetailFamily();

  /// 운동 상세 Provider
  ///
  /// Copied from [exerciseDetail].
  ExerciseDetailProvider call(String exerciseId) {
    return ExerciseDetailProvider(exerciseId);
  }

  @override
  ExerciseDetailProvider getProviderOverride(
    covariant ExerciseDetailProvider provider,
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
  String? get name => r'exerciseDetailProvider';
}

/// 운동 상세 Provider
///
/// Copied from [exerciseDetail].
class ExerciseDetailProvider extends AutoDisposeFutureProvider<ExerciseModel?> {
  /// 운동 상세 Provider
  ///
  /// Copied from [exerciseDetail].
  ExerciseDetailProvider(String exerciseId)
    : this._internal(
        (ref) => exerciseDetail(ref as ExerciseDetailRef, exerciseId),
        from: exerciseDetailProvider,
        name: r'exerciseDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$exerciseDetailHash,
        dependencies: ExerciseDetailFamily._dependencies,
        allTransitiveDependencies:
            ExerciseDetailFamily._allTransitiveDependencies,
        exerciseId: exerciseId,
      );

  ExerciseDetailProvider._internal(
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
    FutureOr<ExerciseModel?> Function(ExerciseDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ExerciseDetailProvider._internal(
        (ref) => create(ref as ExerciseDetailRef),
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
  AutoDisposeFutureProviderElement<ExerciseModel?> createElement() {
    return _ExerciseDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ExerciseDetailProvider && other.exerciseId == exerciseId;
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
mixin ExerciseDetailRef on AutoDisposeFutureProviderRef<ExerciseModel?> {
  /// The parameter `exerciseId` of this provider.
  String get exerciseId;
}

class _ExerciseDetailProviderElement
    extends AutoDisposeFutureProviderElement<ExerciseModel?>
    with ExerciseDetailRef {
  _ExerciseDetailProviderElement(super.provider);

  @override
  String get exerciseId => (origin as ExerciseDetailProvider).exerciseId;
}

String _$searchExercisesHash() => r'ac6c8e6d0fac6e033fccf2e3a57b4c7fe9779d66';

/// 운동 검색 Provider
///
/// Copied from [searchExercises].
@ProviderFor(searchExercises)
const searchExercisesProvider = SearchExercisesFamily();

/// 운동 검색 Provider
///
/// Copied from [searchExercises].
class SearchExercisesFamily extends Family<AsyncValue<List<ExerciseModel>>> {
  /// 운동 검색 Provider
  ///
  /// Copied from [searchExercises].
  const SearchExercisesFamily();

  /// 운동 검색 Provider
  ///
  /// Copied from [searchExercises].
  SearchExercisesProvider call(String query) {
    return SearchExercisesProvider(query);
  }

  @override
  SearchExercisesProvider getProviderOverride(
    covariant SearchExercisesProvider provider,
  ) {
    return call(provider.query);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'searchExercisesProvider';
}

/// 운동 검색 Provider
///
/// Copied from [searchExercises].
class SearchExercisesProvider
    extends AutoDisposeFutureProvider<List<ExerciseModel>> {
  /// 운동 검색 Provider
  ///
  /// Copied from [searchExercises].
  SearchExercisesProvider(String query)
    : this._internal(
        (ref) => searchExercises(ref as SearchExercisesRef, query),
        from: searchExercisesProvider,
        name: r'searchExercisesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$searchExercisesHash,
        dependencies: SearchExercisesFamily._dependencies,
        allTransitiveDependencies:
            SearchExercisesFamily._allTransitiveDependencies,
        query: query,
      );

  SearchExercisesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final String query;

  @override
  Override overrideWith(
    FutureOr<List<ExerciseModel>> Function(SearchExercisesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchExercisesProvider._internal(
        (ref) => create(ref as SearchExercisesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ExerciseModel>> createElement() {
    return _SearchExercisesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchExercisesProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SearchExercisesRef on AutoDisposeFutureProviderRef<List<ExerciseModel>> {
  /// The parameter `query` of this provider.
  String get query;
}

class _SearchExercisesProviderElement
    extends AutoDisposeFutureProviderElement<List<ExerciseModel>>
    with SearchExercisesRef {
  _SearchExercisesProviderElement(super.provider);

  @override
  String get query => (origin as SearchExercisesProvider).query;
}

String _$filteredExercisesHash() => r'543726890372628e5e50c7f67164e0179f995b1e';

/// 필터링된 운동 목록 Provider
///
/// Copied from [filteredExercises].
@ProviderFor(filteredExercises)
final filteredExercisesProvider =
    AutoDisposeFutureProvider<List<ExerciseModel>>.internal(
      filteredExercises,
      name: r'filteredExercisesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$filteredExercisesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FilteredExercisesRef =
    AutoDisposeFutureProviderRef<List<ExerciseModel>>;
String _$groupedExercisesHash() => r'69be26b3e5cb2397152c468f5771058f91416887';

/// 근육 그룹별 운동 목록 (그룹화) Provider
///
/// Copied from [groupedExercises].
@ProviderFor(groupedExercises)
final groupedExercisesProvider =
    AutoDisposeFutureProvider<Map<MuscleGroup, List<ExerciseModel>>>.internal(
      groupedExercises,
      name: r'groupedExercisesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$groupedExercisesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GroupedExercisesRef =
    AutoDisposeFutureProviderRef<Map<MuscleGroup, List<ExerciseModel>>>;
String _$exerciseFilterStateHash() =>
    r'2a2b1a34588ead17405e98ff89e64401057ede92';

/// 운동 필터 상태 Provider
///
/// Copied from [ExerciseFilterState].
@ProviderFor(ExerciseFilterState)
final exerciseFilterStateProvider =
    AutoDisposeNotifierProvider<ExerciseFilterState, ExerciseFilter>.internal(
      ExerciseFilterState.new,
      name: r'exerciseFilterStateProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$exerciseFilterStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ExerciseFilterState = AutoDisposeNotifier<ExerciseFilter>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
