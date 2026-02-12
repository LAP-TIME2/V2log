import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cv_provider.g.dart';

/// CV 입력 모드
enum CvInputMode {
  /// 기존 수동 입력만
  manual,

  /// CV 자동 감지만
  cv,

  /// 자동 감지 + 수동 수정 가능 (권장)
  hybrid,
}

/// CV 감지 결과
class CvDetectionResult {
  final int reps;
  final double currentAngle;
  final double confidence;
  final bool isActive;

  const CvDetectionResult({
    this.reps = 0,
    this.currentAngle = 0.0,
    this.confidence = 0.0,
    this.isActive = false,
  });

  CvDetectionResult copyWith({
    int? reps,
    double? currentAngle,
    double? confidence,
    bool? isActive,
  }) {
    return CvDetectionResult(
      reps: reps ?? this.reps,
      currentAngle: currentAngle ?? this.currentAngle,
      confidence: confidence ?? this.confidence,
      isActive: isActive ?? this.isActive,
    );
  }
}

/// CV 상태 관리 Provider
///
/// - CV 모드 ON/OFF
/// - 감지 결과 (횟수, 각도, 신뢰도)
/// - 입력 모드 (manual/cv/hybrid)
@Riverpod(keepAlive: true)
class CvState extends _$CvState {
  @override
  CvDetectionResult build() {
    return const CvDetectionResult();
  }

  /// CV 모드 활성화/비활성화
  void toggleActive() {
    state = state.copyWith(isActive: !state.isActive);
  }

  /// CV 모드 켜기
  void activate() {
    state = state.copyWith(isActive: true);
  }

  /// CV 모드 끄기
  void deactivate() {
    state = state.copyWith(isActive: false, reps: 0, confidence: 0.0);
  }

  /// 감지 결과 업데이트
  void updateDetection({
    required int reps,
    required double currentAngle,
    required double confidence,
  }) {
    state = state.copyWith(
      reps: reps,
      currentAngle: currentAngle,
      confidence: confidence,
    );
  }

  /// 횟수 초기화 (새 세트 시작)
  void resetReps() {
    state = state.copyWith(reps: 0, currentAngle: 0.0, confidence: 0.0);
  }
}

/// CV 입력 모드 Provider
@Riverpod(keepAlive: true)
class CvInputModeState extends _$CvInputModeState {
  @override
  CvInputMode build() {
    return CvInputMode.manual;
  }

  void setMode(CvInputMode mode) {
    state = mode;
  }

  void toggleCv() {
    state = state == CvInputMode.manual ? CvInputMode.hybrid : CvInputMode.manual;
  }
}
