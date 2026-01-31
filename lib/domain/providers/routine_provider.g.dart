// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routine_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userRoutinesHash() => r'c187e76016886e1da1f9ca7c75687c34e592ab4d';

/// 사용자의 모든 루틴 목록 Provider
///
/// Copied from [userRoutines].
@ProviderFor(userRoutines)
final userRoutinesProvider =
    AutoDisposeFutureProvider<List<RoutineModel>>.internal(
      userRoutines,
      name: r'userRoutinesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$userRoutinesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserRoutinesRef = AutoDisposeFutureProviderRef<List<RoutineModel>>;
String _$routineDetailHash() => r'dfddae09b213e3728a5457337b4144df67f2d4b2';

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

/// 루틴 상세 Provider
///
/// Copied from [routineDetail].
@ProviderFor(routineDetail)
const routineDetailProvider = RoutineDetailFamily();

/// 루틴 상세 Provider
///
/// Copied from [routineDetail].
class RoutineDetailFamily extends Family<AsyncValue<RoutineModel?>> {
  /// 루틴 상세 Provider
  ///
  /// Copied from [routineDetail].
  const RoutineDetailFamily();

  /// 루틴 상세 Provider
  ///
  /// Copied from [routineDetail].
  RoutineDetailProvider call(String routineId) {
    return RoutineDetailProvider(routineId);
  }

  @override
  RoutineDetailProvider getProviderOverride(
    covariant RoutineDetailProvider provider,
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
  String? get name => r'routineDetailProvider';
}

/// 루틴 상세 Provider
///
/// Copied from [routineDetail].
class RoutineDetailProvider extends AutoDisposeFutureProvider<RoutineModel?> {
  /// 루틴 상세 Provider
  ///
  /// Copied from [routineDetail].
  RoutineDetailProvider(String routineId)
    : this._internal(
        (ref) => routineDetail(ref as RoutineDetailRef, routineId),
        from: routineDetailProvider,
        name: r'routineDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$routineDetailHash,
        dependencies: RoutineDetailFamily._dependencies,
        allTransitiveDependencies:
            RoutineDetailFamily._allTransitiveDependencies,
        routineId: routineId,
      );

  RoutineDetailProvider._internal(
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
    FutureOr<RoutineModel?> Function(RoutineDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RoutineDetailProvider._internal(
        (ref) => create(ref as RoutineDetailRef),
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
  AutoDisposeFutureProviderElement<RoutineModel?> createElement() {
    return _RoutineDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RoutineDetailProvider && other.routineId == routineId;
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
mixin RoutineDetailRef on AutoDisposeFutureProviderRef<RoutineModel?> {
  /// The parameter `routineId` of this provider.
  String get routineId;
}

class _RoutineDetailProviderElement
    extends AutoDisposeFutureProviderElement<RoutineModel?>
    with RoutineDetailRef {
  _RoutineDetailProviderElement(super.provider);

  @override
  String get routineId => (origin as RoutineDetailProvider).routineId;
}

String _$selectedRoutineDetailHash() =>
    r'a463b460d0c2b512a777952239661c79c054080d';

/// 선택된 루틴 상세 Provider
///
/// Copied from [selectedRoutineDetail].
@ProviderFor(selectedRoutineDetail)
final selectedRoutineDetailProvider =
    AutoDisposeFutureProvider<RoutineModel?>.internal(
      selectedRoutineDetail,
      name: r'selectedRoutineDetailProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$selectedRoutineDetailHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SelectedRoutineDetailRef = AutoDisposeFutureProviderRef<RoutineModel?>;
String _$activeRoutinesHash() => r'87c079ff5b3f4ce195778ef20ee91476ebe575c2';

/// 활성 루틴 목록 Provider (is_active = true)
///
/// Copied from [activeRoutines].
@ProviderFor(activeRoutines)
final activeRoutinesProvider =
    AutoDisposeFutureProvider<List<RoutineModel>>.internal(
      activeRoutines,
      name: r'activeRoutinesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$activeRoutinesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActiveRoutinesRef = AutoDisposeFutureProviderRef<List<RoutineModel>>;
String _$recentRoutinesHash() => r'22bad38c00e35ba30a0ad3e14a418cfb998ce14e';

/// 최근 사용 루틴 Provider
///
/// Copied from [recentRoutines].
@ProviderFor(recentRoutines)
final recentRoutinesProvider =
    AutoDisposeFutureProvider<List<RoutineModel>>.internal(
      recentRoutines,
      name: r'recentRoutinesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$recentRoutinesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RecentRoutinesRef = AutoDisposeFutureProviderRef<List<RoutineModel>>;
String _$selectedRoutineIdHash() => r'e4fada47bea4deab26e7e10b29329ad43fddaedd';

/// 선택된 루틴 ID Provider
///
/// Copied from [SelectedRoutineId].
@ProviderFor(SelectedRoutineId)
final selectedRoutineIdProvider =
    AutoDisposeNotifierProvider<SelectedRoutineId, String?>.internal(
      SelectedRoutineId.new,
      name: r'selectedRoutineIdProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$selectedRoutineIdHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedRoutineId = AutoDisposeNotifier<String?>;
String _$routineManagerHash() => r'bc355902ef2d3577f3d6f6963b81f3c27365c863';

/// 루틴 관리 Provider (생성, 수정, 삭제)
///
/// Copied from [RoutineManager].
@ProviderFor(RoutineManager)
final routineManagerProvider =
    AutoDisposeAsyncNotifierProvider<RoutineManager, void>.internal(
      RoutineManager.new,
      name: r'routineManagerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$routineManagerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$RoutineManager = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
