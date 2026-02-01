// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$isLoggedInHash() => r'1efba52e09a70ea462ab1a40db7edaf8f01f91e1';

/// 로그인 상태 Provider
///
/// Copied from [isLoggedIn].
@ProviderFor(isLoggedIn)
final isLoggedInProvider = AutoDisposeProvider<bool>.internal(
  isLoggedIn,
  name: r'isLoggedInProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isLoggedInHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsLoggedInRef = AutoDisposeProviderRef<bool>;
String _$currentUserIdHash() => r'7bc8e1edf9d3a734c48133543814ab145801278a';

/// 현재 사용자 ID Provider
///
/// Copied from [currentUserId].
@ProviderFor(currentUserId)
final currentUserIdProvider = AutoDisposeProvider<String?>.internal(
  currentUserId,
  name: r'currentUserIdProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentUserIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentUserIdRef = AutoDisposeProviderRef<String?>;
String _$authHash() => r'3088e4657dde3623fb7c39cb53e8c1983e337975';

/// 현재 인증 상태 Provider
///
/// Copied from [Auth].
@ProviderFor(Auth)
final authProvider = AsyncNotifierProvider<Auth, UserModel?>.internal(
  Auth.new,
  name: r'authProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Auth = AsyncNotifier<UserModel?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
