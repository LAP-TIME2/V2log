// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentUserHash() => r'1b6075b65a406d7b2fb6f9d93f8c11c6214a5bb3';

/// 현재 사용자 Provider (Auth에서 파생)
///
/// Copied from [currentUser].
@ProviderFor(currentUser)
final currentUserProvider = AutoDisposeProvider<UserModel?>.internal(
  currentUser,
  name: r'currentUserProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentUserRef = AutoDisposeProviderRef<UserModel?>;
String _$userStatsHash() => r'b157ba20ea2e96745971180640e451a30ffc4bf6';

/// 사용자 통계 Provider
///
/// Copied from [userStats].
@ProviderFor(userStats)
final userStatsProvider = AutoDisposeFutureProvider<UserStats>.internal(
  userStats,
  name: r'userStatsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userStatsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserStatsRef = AutoDisposeFutureProviderRef<UserStats>;
String _$weeklyStatsHash() => r'fb84d8bc3f219669085fce790721217ff42a7f84';

/// 이번 주 통계 Provider
///
/// Copied from [weeklyStats].
@ProviderFor(weeklyStats)
final weeklyStatsProvider = AutoDisposeFutureProvider<WeeklyStats>.internal(
  weeklyStats,
  name: r'weeklyStatsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$weeklyStatsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WeeklyStatsRef = AutoDisposeFutureProviderRef<WeeklyStats>;
String _$dailyVolumesHash() => r'cfc45a3a5ad056e989273334f793e15215383605';

/// 일별 볼륨 Provider (최근 7일)
///
/// Copied from [dailyVolumes].
@ProviderFor(dailyVolumes)
final dailyVolumesProvider =
    AutoDisposeFutureProvider<List<DailyVolume>>.internal(
      dailyVolumes,
      name: r'dailyVolumesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$dailyVolumesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DailyVolumesRef = AutoDisposeFutureProviderRef<List<DailyVolume>>;
String _$monthlyVolumesHash() => r'c3ce0106ea15f4c00e4ad4d830f0ce22071f3f6a';

/// 월간 볼륨 Provider (최근 3개월)
///
/// Copied from [monthlyVolumes].
@ProviderFor(monthlyVolumes)
final monthlyVolumesProvider =
    AutoDisposeFutureProvider<List<MonthlyVolume>>.internal(
      monthlyVolumes,
      name: r'monthlyVolumesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$monthlyVolumesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MonthlyVolumesRef = AutoDisposeFutureProviderRef<List<MonthlyVolume>>;
String _$muscleDailyVolumesHash() =>
    r'94f692086148b22c14c9b45783e0e22049696b6e';

/// 부위별 일별 볼륨 Provider (최근 7일)
/// workout_sets와 exercises를 JOIN해서 primary_muscle로 부위 구분
///
/// Copied from [muscleDailyVolumes].
@ProviderFor(muscleDailyVolumes)
final muscleDailyVolumesProvider =
    AutoDisposeFutureProvider<List<MuscleDailyVolume>>.internal(
      muscleDailyVolumes,
      name: r'muscleDailyVolumesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$muscleDailyVolumesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MuscleDailyVolumesRef =
    AutoDisposeFutureProviderRef<List<MuscleDailyVolume>>;
String _$muscleMonthlyVolumesHash() =>
    r'5e54ee673e21d1b45ee2499e8ed73fcedd7b4aac';

/// 부위별 월간 볼륨 Provider (최근 3개월)
///
/// Copied from [muscleMonthlyVolumes].
@ProviderFor(muscleMonthlyVolumes)
final muscleMonthlyVolumesProvider =
    AutoDisposeFutureProvider<List<MuscleMonthlyVolume>>.internal(
      muscleMonthlyVolumes,
      name: r'muscleMonthlyVolumesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$muscleMonthlyVolumesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MuscleMonthlyVolumesRef =
    AutoDisposeFutureProviderRef<List<MuscleMonthlyVolume>>;
String _$userProfileHash() => r'ec764767cecaaaf97fba916f43ba1b95a7c6fd0d';

/// 사용자 프로필 업데이트 Provider
///
/// Copied from [UserProfile].
@ProviderFor(UserProfile)
final userProfileProvider =
    AutoDisposeAsyncNotifierProvider<UserProfile, void>.internal(
      UserProfile.new,
      name: r'userProfileProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$userProfileHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$UserProfile = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
