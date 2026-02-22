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
    r'f564e115ce88cded35ad0cbf0bcd10bf094b4a2e';

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
    r'46ac1730b3ef5fdeebb9b8b4d37957504e571885';

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
String _$exercise1RMHistoryHash() =>
    r'7dce0d8b6bcdad25a30cf757586d11edf5bd29c0';

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

/// 운동별 1RM 추이 Provider (최근 6개월, 월간)
///
/// Copied from [exercise1RMHistory].
@ProviderFor(exercise1RMHistory)
const exercise1RMHistoryProvider = Exercise1RMHistoryFamily();

/// 운동별 1RM 추이 Provider (최근 6개월, 월간)
///
/// Copied from [exercise1RMHistory].
class Exercise1RMHistoryFamily
    extends Family<AsyncValue<List<Exercise1RMRecord>>> {
  /// 운동별 1RM 추이 Provider (최근 6개월, 월간)
  ///
  /// Copied from [exercise1RMHistory].
  const Exercise1RMHistoryFamily();

  /// 운동별 1RM 추이 Provider (최근 6개월, 월간)
  ///
  /// Copied from [exercise1RMHistory].
  Exercise1RMHistoryProvider call(String exerciseName) {
    return Exercise1RMHistoryProvider(exerciseName);
  }

  @override
  Exercise1RMHistoryProvider getProviderOverride(
    covariant Exercise1RMHistoryProvider provider,
  ) {
    return call(provider.exerciseName);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'exercise1RMHistoryProvider';
}

/// 운동별 1RM 추이 Provider (최근 6개월, 월간)
///
/// Copied from [exercise1RMHistory].
class Exercise1RMHistoryProvider
    extends AutoDisposeFutureProvider<List<Exercise1RMRecord>> {
  /// 운동별 1RM 추이 Provider (최근 6개월, 월간)
  ///
  /// Copied from [exercise1RMHistory].
  Exercise1RMHistoryProvider(String exerciseName)
    : this._internal(
        (ref) => exercise1RMHistory(ref as Exercise1RMHistoryRef, exerciseName),
        from: exercise1RMHistoryProvider,
        name: r'exercise1RMHistoryProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$exercise1RMHistoryHash,
        dependencies: Exercise1RMHistoryFamily._dependencies,
        allTransitiveDependencies:
            Exercise1RMHistoryFamily._allTransitiveDependencies,
        exerciseName: exerciseName,
      );

  Exercise1RMHistoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.exerciseName,
  }) : super.internal();

  final String exerciseName;

  @override
  Override overrideWith(
    FutureOr<List<Exercise1RMRecord>> Function(Exercise1RMHistoryRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: Exercise1RMHistoryProvider._internal(
        (ref) => create(ref as Exercise1RMHistoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        exerciseName: exerciseName,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Exercise1RMRecord>> createElement() {
    return _Exercise1RMHistoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is Exercise1RMHistoryProvider &&
        other.exerciseName == exerciseName;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, exerciseName.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin Exercise1RMHistoryRef
    on AutoDisposeFutureProviderRef<List<Exercise1RMRecord>> {
  /// The parameter `exerciseName` of this provider.
  String get exerciseName;
}

class _Exercise1RMHistoryProviderElement
    extends AutoDisposeFutureProviderElement<List<Exercise1RMRecord>>
    with Exercise1RMHistoryRef {
  _Exercise1RMHistoryProviderElement(super.provider);

  @override
  String get exerciseName =>
      (origin as Exercise1RMHistoryProvider).exerciseName;
}

String _$muscleFrequencyHash() => r'8c609edbf66a6491e958fdda11718500206aec50';

/// 부위별 운동 빈도 Provider (최근 6개월)
///
/// Copied from [muscleFrequency].
@ProviderFor(muscleFrequency)
final muscleFrequencyProvider =
    AutoDisposeFutureProvider<List<MuscleFrequency>>.internal(
      muscleFrequency,
      name: r'muscleFrequencyProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$muscleFrequencyHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MuscleFrequencyRef =
    AutoDisposeFutureProviderRef<List<MuscleFrequency>>;
String _$exerciseFrequencyHash() => r'4cbdd0fa6be8741b2d56c96cce54d74c79aa40e5';

/// 운동별 빈도 TOP 5 Provider (최근 6개월)
///
/// Copied from [exerciseFrequency].
@ProviderFor(exerciseFrequency)
final exerciseFrequencyProvider =
    AutoDisposeFutureProvider<List<ExerciseFrequency>>.internal(
      exerciseFrequency,
      name: r'exerciseFrequencyProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$exerciseFrequencyHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ExerciseFrequencyRef =
    AutoDisposeFutureProviderRef<List<ExerciseFrequency>>;
String _$intensityZoneDistributionHash() =>
    r'036886a1192981c07cc0728da55e1589e932f7ad';

/// 강도 존 분포 Provider (최근 30일)
/// 각 세트를 1RM 대비 강도 존으로 분류
///
/// Copied from [intensityZoneDistribution].
@ProviderFor(intensityZoneDistribution)
final intensityZoneDistributionProvider =
    AutoDisposeFutureProvider<IntensityZoneDistribution>.internal(
      intensityZoneDistribution,
      name: r'intensityZoneDistributionProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$intensityZoneDistributionHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IntensityZoneDistributionRef =
    AutoDisposeFutureProviderRef<IntensityZoneDistribution>;
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
