// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cv_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$cvStateHash() => r'17707dcb24ca54cb26dd23f482a7332470176df2';

/// CV 상태 관리 Provider
///
/// - CV 모드 ON/OFF
/// - 감지 결과 (횟수, 각도, 신뢰도)
/// - 입력 모드 (manual/cv/hybrid)
///
/// Copied from [CvState].
@ProviderFor(CvState)
final cvStateProvider = NotifierProvider<CvState, CvDetectionResult>.internal(
  CvState.new,
  name: r'cvStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$cvStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CvState = Notifier<CvDetectionResult>;
String _$cvInputModeStateHash() => r'51f31821be98e287ea3369efa1358eebd7f5dcc8';

/// CV 입력 모드 Provider
///
/// Copied from [CvInputModeState].
@ProviderFor(CvInputModeState)
final cvInputModeStateProvider =
    NotifierProvider<CvInputModeState, CvInputMode>.internal(
      CvInputModeState.new,
      name: r'cvInputModeStateProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$cvInputModeStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CvInputModeState = Notifier<CvInputMode>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
