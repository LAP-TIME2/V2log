// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$pendingSyncCountHash() => r'81f76f758a293b808cd13263a10f07e6646d6d73';

/// 대기 중인 작업 수 Provider
///
/// Copied from [pendingSyncCount].
@ProviderFor(pendingSyncCount)
final pendingSyncCountProvider = AutoDisposeFutureProvider<int>.internal(
  pendingSyncCount,
  name: r'pendingSyncCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pendingSyncCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PendingSyncCountRef = AutoDisposeFutureProviderRef<int>;
String _$syncSummaryHash() => r'd68722ea03239716a39693e43d3dc0617027cbe0';

/// 동기화 상태 요약 Provider
///
/// Copied from [syncSummary].
@ProviderFor(syncSummary)
final syncSummaryProvider = AutoDisposeProvider<SyncSummary>.internal(
  syncSummary,
  name: r'syncSummaryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$syncSummaryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SyncSummaryRef = AutoDisposeProviderRef<SyncSummary>;
String _$connectionStateHash() => r'106baff2d375f05f161eeb245cb87002b3ed5db5';

/// 연결 상태 Provider
///
/// Copied from [ConnectionState].
@ProviderFor(ConnectionState)
final connectionStateProvider =
    AutoDisposeNotifierProvider<ConnectionState, ConnectionStatus>.internal(
      ConnectionState.new,
      name: r'connectionStateProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$connectionStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ConnectionState = AutoDisposeNotifier<ConnectionStatus>;
String _$syncStateHash() => r'59ccf6cef473d4951214e9f5e3a3367a4ddb270e';

/// 동기화 상태 Provider
///
/// Copied from [SyncState].
@ProviderFor(SyncState)
final syncStateProvider =
    AutoDisposeNotifierProvider<SyncState, SyncStatus>.internal(
      SyncState.new,
      name: r'syncStateProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$syncStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SyncState = AutoDisposeNotifier<SyncStatus>;
String _$syncControllerHash() => r'216f39ed20085590f50698e14d5a294697455abc';

/// 동기화 컨트롤러 Provider
///
/// Copied from [SyncController].
@ProviderFor(SyncController)
final syncControllerProvider =
    AutoDisposeNotifierProvider<SyncController, void>.internal(
      SyncController.new,
      name: r'syncControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$syncControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SyncController = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
