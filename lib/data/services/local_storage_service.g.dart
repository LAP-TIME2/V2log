// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_storage_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$localStorageServiceHash() =>
    r'6525ccaf39abf6ac2b1ef94fb09e75db9480f7d1';

/// Local Storage 서비스 Provider
///
/// Copied from [localStorageService].
@ProviderFor(localStorageService)
final localStorageServiceProvider = Provider<LocalStorageService>.internal(
  localStorageService,
  name: r'localStorageServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$localStorageServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LocalStorageServiceRef = ProviderRef<LocalStorageService>;
String _$sharedPreferencesHash() => r'87f7c0811db991852c74d72376df550977c6d6db';

/// SharedPreferences Provider
///
/// Copied from [sharedPreferences].
@ProviderFor(sharedPreferences)
final sharedPreferencesProvider = FutureProvider<SharedPreferences>.internal(
  sharedPreferences,
  name: r'sharedPreferencesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sharedPreferencesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SharedPreferencesRef = FutureProviderRef<SharedPreferences>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
