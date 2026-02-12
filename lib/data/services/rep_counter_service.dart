import 'dart:collection';
import 'dart:math' as math;

import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

import '../../core/utils/exercise_angles.dart';
import 'pose_detection_service.dart';

/// 횟수 카운팅 결과
class RepCountResult {
  final int reps;
  final double currentAngle;
  final double confidence;
  final RepPhase phase;

  const RepCountResult({
    required this.reps,
    required this.currentAngle,
    required this.confidence,
    required this.phase,
  });
}

/// 반복 운동의 위상
enum RepPhase { extending, contracting }

/// 운동 횟수 자동 카운팅 서비스
///
/// **One Euro Filter + Velocity Gate + 방향 전환 감지** (v5)
///
/// 3층 방어 구조:
/// 1. **One Euro Filter**: 적응형 노이즈 제거 (정지 시 95%+, 운동 시 최소 지연)
/// 2. **Velocity Gate**: 속도 ≥ 15°/sec이 2프레임 연속일 때만 카운팅 허용
/// 3. **Amplitude Check**: peak-valley 진폭이 최소 임계값 이상일 때만 카운팅
///
/// 보조 필터:
/// - **몸통 안정성**: 어깨 중간점 이동으로 몸통 회전 감지
/// - **운동 자세 위치 체크**: 오버헤드 운동에서 팔 내리기 동작 필터링
/// - **촬영 방향 자동 감지**: hysteresis + 투표로 정면/측면 안정 판별
class RepCounterService {
  /// 현재 횟수
  int _reps = 0;

  /// 현재 위상
  RepPhase _currentPhase = RepPhase.extending;

  /// 현재 운동 각도 규칙
  ExerciseAngleRule? _currentRule;

  /// 마지막 필터링된 각도
  double _lastSmoothedAngle = 0.0;

  /// 현재 방향의 최댓값/최솟값 추적
  double _currentPeakAngle = 0.0;
  double _currentValleyAngle = 180.0;

  /// 최소 진폭 — 정면 촬영 시 (기본)
  static const double _amplitudeFront = 25.0;

  /// 최소 진폭 — 측면 촬영 시 (원근감으로 각도가 작게 보이므로 낮춤)
  static const double _amplitudeSide = 15.0;

  /// 현재 적용 중인 최소 진폭 (촬영 방향에 따라 동적 변경)
  double _currentMinAmplitude = 25.0;

  /// 마지막 감지 시간 (디바운싱)
  DateTime _lastDetectionTime = DateTime.now();

  /// 디바운싱 간격 (150ms)
  static const Duration _debounceInterval = Duration(milliseconds: 150);

  /// 마지막 카운팅 시간 (최소 반복 간격)
  DateTime _lastRepTime = DateTime.fromMillisecondsSinceEpoch(0);

  /// 최소 반복 간격 (실제 운동 1회 ≥ 1초, 몸통 회전은 0.5초 이내)
  static const Duration _minRepInterval = Duration(milliseconds: 800);

  // ── One Euro Filter (SMA 대체) ──

  /// 각도 스무딩용 One Euro Filter
  final _OneEuroFilter _oneEuroFilter = _OneEuroFilter(
    minCutoff: 1.0, // 정지 시 강한 스무딩
    beta: 0.007, // 운동 시 낮은 지연
    dCutoff: 1.0, // 미분 필터 (표준값)
  );

  // ── Velocity Gate (정지 감지 대체) ──

  /// 이전 필터링된 각도 (속도 계산용)
  double _prevFilteredAngle = 0.0;

  /// 이전 타임스탬프 (초 단위, 속도 계산용)
  double _prevTimestamp = 0.0;

  /// 연속 "움직임" 프레임 카운터
  int _movingFrameCount = 0;

  /// velocity gate 열림 여부
  bool _isMoving = false;

  /// 연속 "정지" 프레임 카운터 (긴 정지 시 peak/valley 리셋용)
  int _stationaryFrameCount = 0;

  /// 긴 정지 판정 프레임 수 (~2초 = 14프레임 × 150ms)
  ///
  /// 방향 전환(0.3초, 2프레임)에서는 리셋 안 함.
  /// 세트 간 휴식(2초+)에서만 리셋 → 다음 세트 깨끗한 시작.
  static const int _stationaryResetFrames = 14;

  /// 최소 각속도 (°/sec) — 이 이상이면 "움직이는 중"
  ///
  /// 근거:
  /// - One Euro 필터 후 정지 노이즈: <5°/sec (보통 <2°/sec)
  /// - 가장 느린 실제 운동 (무거운 스쿼트): ~30°/sec
  /// - 15°/sec = 안전 마진 2배
  static const double _minMovingVelocity = 15.0;

  /// 연속 "움직임" 프레임 필요 수 — 이 이상이면 gate 열림
  ///
  /// 2프레임 × 150ms = 300ms 지속 움직임 필요.
  /// 실제 운동: 500ms-3000ms → 쉽게 통과.
  /// 노이즈 스파이크: 1프레임 → 구조적으로 통과 불가.
  static const int _minMovingFrames = 2;

  // ── 몸통 안정성 체크 ──

  /// 이전 프레임의 어깨 중간점 X좌표
  double? _lastTorsoX;

  /// 이전 프레임의 어깨 간 거리 (너비)
  double _lastShoulderWidth = 0.0;

  /// 몸통 안정성 실패 연속 횟수
  int _torsoUnstableCount = 0;

  /// 몸통 이동 임계값: 어깨 너비의 30% 이상 이동 시 회전으로 판정
  static const double _torsoMovementRatio = 0.30;

  /// 연속 불안정 허용 횟수
  static const int _maxUnstableFrames = 3;

  // ── 촬영 방향 자동 감지 (hysteresis + 투표) ──

  /// 현재 촬영이 측면인지 여부
  bool _isSideView = false;

  /// 이중 임계값 (hysteresis)
  static const double _toSideThreshold = 0.25;
  static const double _toFrontThreshold = 0.35;

  /// 최근 촬영 방향 히스토리 (투표용)
  final Queue<bool> _viewVoteHistory = Queue<bool>();

  /// 투표 윈도우 크기
  static const int _viewVoteWindow = 7;

  /// 최소 신뢰도
  static const double _minConfidence = 0.5;

  // ── 운동 시작 확인 (2회 연속 동작 감지 후 카운팅 시작) ──

  /// 운동이 확인되었는지 (2+ 연속 동작 감지 후)
  ///
  /// 핸드폰 셋팅, 이동, 덤벨 잡기 등 준비 동작에서 발생하는
  /// 1회성 오카운팅을 방지. 2회째 반복이 감지되면 비로소 확인.
  bool _exerciseConfirmed = false;

  /// 확인 대기 중인 내부 카운터
  int _pendingReps = 0;

  /// 첫 번째 미확인 반복 시간 (타임아웃 체크용)
  DateTime? _firstPendingRepTime;

  /// 확인 대기 시간 — 이 안에 2회째가 안 오면 노이즈로 판정
  static const Duration _confirmationWindow = Duration(seconds: 8);

  /// 운동 설정
  void setExercise(ExerciseAngleRule rule) {
    _currentRule = rule;
    reset();
  }

  /// 운동 이름으로 설정 (영어)
  bool setExerciseByNameEn(String nameEn) {
    final rule = ExerciseAngles.findByNameEn(nameEn);
    if (rule != null) {
      setExercise(rule);
      return true;
    }
    return false;
  }

  /// 운동 이름으로 설정 (한국어)
  bool setExerciseByName(String name) {
    final rule = ExerciseAngles.findByName(name);
    if (rule != null) {
      setExercise(rule);
      return true;
    }
    return false;
  }

  /// 포즈 데이터로 횟수 감지
  RepCountResult? processpose(Pose pose) {
    if (_currentRule == null) return null;
    final rule = _currentRule!;

    // 디바운싱
    final now = DateTime.now();
    if (now.difference(_lastDetectionTime) < _debounceInterval) return null;
    _lastDetectionTime = now;

    // ── 미확인 반복 타임아웃 체크 ──
    // 8초 안에 2회째가 안 오면 → 준비 동작 노이즈로 판정 → 대기열 초기화
    if (!_exerciseConfirmed && _firstPendingRepTime != null &&
        now.difference(_firstPendingRepTime!) > _confirmationWindow) {
      _pendingReps = 0;
      _firstPendingRepTime = null;
    }

    // ── 촬영 방향 자동 감지 (정면/측면) ──
    _detectViewAngle(pose);

    // ── 몸통 안정성 체크 (회전 감지) ──
    if (!_isTorsoStable(pose)) {
      _torsoUnstableCount++;
      if (_torsoUnstableCount >= _maxUnstableFrames) {
        _oneEuroFilter.reset();
        _lastSmoothedAngle = 0.0;
        _movingFrameCount = 0;
        _isMoving = false;
        _stationaryFrameCount = 0;
      }
      return RepCountResult(
        reps: _reps,
        currentAngle: _lastSmoothedAngle,
        confidence: 0.0,
        phase: _currentPhase,
      );
    }
    _torsoUnstableCount = 0;

    // ── 운동 자세 위치 체크 (팔 내리기, 이동 중 등 필터링) ──
    if (rule.vertexMustBeAboveFirst && !_isInExercisePosition(pose, rule)) {
      _oneEuroFilter.reset();
      _lastSmoothedAngle = 0.0;
      _currentPhase = RepPhase.extending;
      _currentPeakAngle = 0.0;
      _currentValleyAngle = 180.0;
      _movingFrameCount = 0;
      _isMoving = false;
      _stationaryFrameCount = 0;
      return RepCountResult(
        reps: _reps,
        currentAngle: 0.0,
        confidence: 0.0,
        phase: _currentPhase,
      );
    }

    // 관절 좌표 가져오기 (왼쪽 또는 오른쪽 중 보이는 쪽 사용)
    final angle = _getAngle(pose, rule);
    if (angle == null) return null;

    // ── One Euro Filter 적용 (SMA 대체) ──
    final double currentTime = now.millisecondsSinceEpoch / 1000.0;
    final double filteredAngle =
        _oneEuroFilter.filter(angle.value, currentTime);
    final confidence = angle.confidence;

    // ── Velocity Gate (정지 감지 대체) ──
    double velocity = 0.0;
    if (_prevTimestamp > 0) {
      final double dt = currentTime - _prevTimestamp;
      if (dt > 0) {
        velocity = (filteredAngle - _prevFilteredAngle).abs() / dt;
      }
    }
    _prevFilteredAngle = filteredAngle;
    _prevTimestamp = currentTime;

    // 연속 움직임 프레임 카운트
    if (velocity >= _minMovingVelocity) {
      _movingFrameCount++;
    } else {
      _movingFrameCount = 0;
    }
    _isMoving = _movingFrameCount >= _minMovingFrames;

    // 움직이는 중에만 방향 전환 감지 (카운팅)
    if (_isMoving) {
      _stationaryFrameCount = 0;
      _detectDirectionChange(filteredAngle);
    } else {
      _stationaryFrameCount++;
      // 긴 정지(~2초+): peak/valley 리셋 → 다음 세트 깨끗한 시작
      // 짧은 정지(방향 전환): peak/valley 유지 → 카운팅 보존
      if (_stationaryFrameCount >= _stationaryResetFrames) {
        _currentPeakAngle = filteredAngle;
        _currentValleyAngle = filteredAngle;
        _currentPhase = RepPhase.extending;
      }
    }

    _lastSmoothedAngle = filteredAngle;

    return RepCountResult(
      reps: _reps,
      currentAngle: filteredAngle,
      confidence: confidence,
      phase: _currentPhase,
    );
  }

  /// 촬영 방향 자동 감지 — hysteresis + 투표 방식
  void _detectViewAngle(Pose pose) {
    final leftShoulder =
        pose.landmarks[PoseLandmarkType.values[PoseLandmarkIndex.leftShoulder]];
    final rightShoulder =
        pose.landmarks[PoseLandmarkType.values[PoseLandmarkIndex.rightShoulder]];
    final leftHip =
        pose.landmarks[PoseLandmarkType.values[PoseLandmarkIndex.leftHip]];
    final rightHip =
        pose.landmarks[PoseLandmarkType.values[PoseLandmarkIndex.rightHip]];

    if (leftShoulder == null || rightShoulder == null) return;

    final shoulderWidth = (leftShoulder.x - rightShoulder.x).abs();

    double torsoHeight = 200.0;
    if (leftHip != null) {
      torsoHeight = (leftHip.y - leftShoulder.y).abs();
    } else if (rightHip != null) {
      torsoHeight = (rightHip.y - rightShoulder.y).abs();
    }

    if (torsoHeight <= 0) return;

    final ratio = shoulderWidth / torsoHeight;

    // 1단계: hysteresis — 이중 임계값으로 1차 판정
    bool frameVote = _isSideView;
    if (_isSideView) {
      if (ratio > _toFrontThreshold) frameVote = false;
    } else {
      if (ratio < _toSideThreshold) frameVote = true;
    }

    // 2단계: 투표 — 최근 7프레임 중 과반수
    _viewVoteHistory.addLast(frameVote);
    if (_viewVoteHistory.length > _viewVoteWindow) {
      _viewVoteHistory.removeFirst();
    }

    final sideVotes = _viewVoteHistory.where((v) => v).length;
    final totalVotes = _viewVoteHistory.length;
    _isSideView = sideVotes > totalVotes ~/ 2;

    _currentMinAmplitude = _isSideView ? _amplitudeSide : _amplitudeFront;
  }

  /// 몸통이 안정적인지 확인 (어깨 중간점 이동량 체크)
  bool _isTorsoStable(Pose pose) {
    final leftShoulder =
        pose.landmarks[PoseLandmarkType.values[PoseLandmarkIndex.leftShoulder]];
    final rightShoulder =
        pose.landmarks[PoseLandmarkType.values[PoseLandmarkIndex.rightShoulder]];

    if (leftShoulder == null || rightShoulder == null) return true;

    final shoulderMidX = (leftShoulder.x + rightShoulder.x) / 2.0;
    final shoulderWidth = (leftShoulder.x - rightShoulder.x).abs();

    if (_lastTorsoX == null || _lastShoulderWidth <= 0) {
      _lastTorsoX = shoulderMidX;
      _lastShoulderWidth = shoulderWidth > 0 ? shoulderWidth : 1.0;
      return true;
    }

    final displacement = (shoulderMidX - _lastTorsoX!).abs();
    final ratio = displacement / _lastShoulderWidth;

    _lastTorsoX = shoulderMidX;
    _lastShoulderWidth = shoulderWidth > 0 ? shoulderWidth : _lastShoulderWidth;

    return ratio < _torsoMovementRatio;
  }

  /// 꼭짓점 관절이 기준 관절 위에 있는지 확인 (오버헤드 운동용)
  bool _isInExercisePosition(Pose pose, ExerciseAngleRule rule) {
    final leftHip =
        pose.landmarks[PoseLandmarkType.values[PoseLandmarkIndex.leftHip]];
    final rightHip =
        pose.landmarks[PoseLandmarkType.values[PoseLandmarkIndex.rightHip]];
    final leftShoulder =
        pose.landmarks[PoseLandmarkType.values[PoseLandmarkIndex.leftShoulder]];
    final rightShoulder =
        pose.landmarks[PoseLandmarkType.values[PoseLandmarkIndex.rightShoulder]];

    double torsoHeight = 200.0;
    if (leftShoulder != null && leftHip != null) {
      torsoHeight = (leftHip.y - leftShoulder.y).abs();
    } else if (rightShoulder != null && rightHip != null) {
      torsoHeight = (rightHip.y - rightShoulder.y).abs();
    }
    final toleranceRatio = _isSideView ? 0.55 : 0.30;
    final tolerance = torsoHeight * toleranceRatio;

    final leftFirst =
        pose.landmarks[PoseLandmarkType.values[rule.leftJoints.first]];
    final leftMiddle =
        pose.landmarks[PoseLandmarkType.values[rule.leftJoints.middle]];
    bool leftInPosition = true;
    if (leftFirst != null && leftMiddle != null) {
      leftInPosition = leftMiddle.y <= leftFirst.y + tolerance;
    }

    final rightFirst =
        pose.landmarks[PoseLandmarkType.values[rule.rightJoints.first]];
    final rightMiddle =
        pose.landmarks[PoseLandmarkType.values[rule.rightJoints.middle]];
    bool rightInPosition = true;
    if (rightFirst != null && rightMiddle != null) {
      rightInPosition = rightMiddle.y <= rightFirst.y + tolerance;
    }

    return leftInPosition || rightInPosition;
  }

  /// 왼쪽/오른쪽 중 신뢰도 높은 쪽의 각도 계산
  _AngleResult? _getAngle(Pose pose, ExerciseAngleRule rule) {
    final leftFirst = pose.landmarks[PoseLandmarkType.values[rule.leftJoints.first]];
    final leftMiddle = pose.landmarks[PoseLandmarkType.values[rule.leftJoints.middle]];
    final leftLast = pose.landmarks[PoseLandmarkType.values[rule.leftJoints.last]];

    final rightFirst = pose.landmarks[PoseLandmarkType.values[rule.rightJoints.first]];
    final rightMiddle = pose.landmarks[PoseLandmarkType.values[rule.rightJoints.middle]];
    final rightLast = pose.landmarks[PoseLandmarkType.values[rule.rightJoints.last]];

    double? leftAngle;
    double leftConf = 0.0;
    if (leftFirst != null && leftMiddle != null && leftLast != null) {
      leftConf = (leftFirst.likelihood + leftMiddle.likelihood + leftLast.likelihood) / 3.0;
      if (leftConf >= _minConfidence) {
        leftAngle = PoseDetectionService.calculateAngle(leftFirst, leftMiddle, leftLast);
      }
    }

    double? rightAngle;
    double rightConf = 0.0;
    if (rightFirst != null && rightMiddle != null && rightLast != null) {
      rightConf = (rightFirst.likelihood + rightMiddle.likelihood + rightLast.likelihood) / 3.0;
      if (rightConf >= _minConfidence) {
        rightAngle = PoseDetectionService.calculateAngle(rightFirst, rightMiddle, rightLast);
      }
    }

    if (leftAngle != null && rightAngle != null) {
      if (_isSideView) {
        return leftConf >= rightConf
            ? _AngleResult(value: leftAngle, confidence: leftConf)
            : _AngleResult(value: rightAngle, confidence: rightConf);
      }
      return _AngleResult(
        value: (leftAngle + rightAngle) / 2.0,
        confidence: (leftConf + rightConf) / 2.0,
      );
    } else if (leftAngle != null) {
      return _AngleResult(value: leftAngle, confidence: leftConf);
    } else if (rightAngle != null) {
      return _AngleResult(value: rightAngle, confidence: rightConf);
    }
    return null;
  }

  /// 방향 전환 감지 → 횟수 카운팅
  void _detectDirectionChange(double currentAngle) {
    if (_currentPhase == RepPhase.extending) {
      if (currentAngle > _currentPeakAngle) {
        _currentPeakAngle = currentAngle;
      }

      if (_currentPeakAngle - currentAngle > _currentMinAmplitude * 0.4) {
        _currentPhase = RepPhase.contracting;
        _currentValleyAngle = currentAngle;
      }
    } else {
      if (currentAngle < _currentValleyAngle) {
        _currentValleyAngle = currentAngle;
      }

      if (currentAngle - _currentValleyAngle > _currentMinAmplitude * 0.4) {
        final amplitude = _currentPeakAngle - _currentValleyAngle;
        final now = DateTime.now();
        if (amplitude >= _currentMinAmplitude &&
            now.difference(_lastRepTime) >= _minRepInterval) {
          _lastRepTime = now;
          _onRepDetected();
        }

        _currentPhase = RepPhase.extending;
        _currentPeakAngle = currentAngle;
      }
    }
  }

  /// 반복 감지 시 호출 — 확인 시스템 적용
  ///
  /// 2회 연속 감지 전: 대기열에 쌓임 (UI에 안 보임)
  /// 2회 연속 감지 후: 즉시 카운팅 (대기열 포함 전부 반영)
  void _onRepDetected() {
    if (_exerciseConfirmed) {
      _reps++;
      return;
    }

    // 아직 확인 안 됨 — 대기열에 추가
    _pendingReps++;
    _firstPendingRepTime ??= DateTime.now();

    // 2회 이상 → 확인! 대기열 전부 반영
    if (_pendingReps >= 2) {
      _exerciseConfirmed = true;
      _reps = _pendingReps;
    }
  }

  /// 현재 횟수
  int get reps => _reps;

  /// 현재 각도
  double get currentAngle => _lastSmoothedAngle;

  /// 횟수 초기화 (새 세트 시작)
  void reset() {
    _reps = 0;
    _currentPhase = RepPhase.extending;
    _lastSmoothedAngle = 0.0;
    _currentPeakAngle = 0.0;
    _currentValleyAngle = 180.0;
    _oneEuroFilter.reset();
    _lastDetectionTime = DateTime.now();
    _lastRepTime = DateTime.fromMillisecondsSinceEpoch(0);
    _lastTorsoX = null;
    _lastShoulderWidth = 0.0;
    _torsoUnstableCount = 0;
    _isSideView = false;
    _currentMinAmplitude = _amplitudeFront;
    _viewVoteHistory.clear();
    _prevFilteredAngle = 0.0;
    _prevTimestamp = 0.0;
    _movingFrameCount = 0;
    _isMoving = false;
    _stationaryFrameCount = 0;
    _exerciseConfirmed = false;
    _pendingReps = 0;
    _firstPendingRepTime = null;
  }

  /// 현재 측면 촬영 감지 여부
  bool get isSideView => _isSideView;

  /// 현재 설정된 운동 규칙
  ExerciseAngleRule? get currentRule => _currentRule;
}

/// 내부용 각도 계산 결과
class _AngleResult {
  final double value;
  final double confidence;
  const _AngleResult({required this.value, required this.confidence});
}

/// One Euro Filter — 적응형 저주파 통과 필터 (Casiez et al. 2012)
///
/// Google/MediaPipe 공식 권장 스무딩 기법.
/// - 정지 시: 강한 스무딩 → 노이즈 ±3-5° → <1° (95%+ 제거)
/// - 운동 시: 약한 스무딩 → 지연 1프레임 이내 (체감 불가)
///
/// 파라미터:
/// - [minCutoff]: 최소 차단 주파수 (Hz). 낮을수록 정지 시 스무딩 강함. 기본 1.0
/// - [beta]: 속도 계수. 높을수록 빠른 움직임 추적 좋음. 기본 0.007
/// - [dCutoff]: 미분 필터 차단 주파수 (Hz). 기본 1.0
class _OneEuroFilter {
  final double minCutoff;
  final double beta;
  final double dCutoff;

  double? _prevRawValue;
  double? _prevFilteredValue;
  double _prevDerivative = 0.0;
  double? _prevTimestamp;

  _OneEuroFilter({
    this.minCutoff = 1.0,
    this.beta = 0.007,
    this.dCutoff = 1.0,
  });

  /// 원시 값을 필터링하여 스무딩된 값 반환
  ///
  /// [rawValue]: 원시 각도 값
  /// [timestamp]: 현재 시간 (초 단위)
  double filter(double rawValue, double timestamp) {
    if (_prevTimestamp == null || _prevFilteredValue == null) {
      _prevRawValue = rawValue;
      _prevFilteredValue = rawValue;
      _prevTimestamp = timestamp;
      _prevDerivative = 0.0;
      return rawValue;
    }

    final double dt = timestamp - _prevTimestamp!;
    if (dt <= 0) return _prevFilteredValue!;

    // 1) 미분 추정 (변화 속도)
    final double rawDerivative = (rawValue - _prevRawValue!) / dt;

    // 2) 미분에 고정 저주파 필터 적용
    final double alphaDeriv = _smoothingFactor(dt, dCutoff);
    final double derivative =
        alphaDeriv * rawDerivative + (1.0 - alphaDeriv) * _prevDerivative;

    // 3) 적응형 차단 주파수: 속도 높을수록 → 차단 주파수 높음 → 스무딩 약함
    final double cutoff = minCutoff + beta * derivative.abs();

    // 4) 적응형 저주파 필터로 원시 값 스무딩
    final double alpha = _smoothingFactor(dt, cutoff);
    final double filtered =
        alpha * rawValue + (1.0 - alpha) * _prevFilteredValue!;

    // 상태 업데이트
    _prevRawValue = rawValue;
    _prevFilteredValue = filtered;
    _prevDerivative = derivative;
    _prevTimestamp = timestamp;

    return filtered;
  }

  /// 차단 주파수에서 스무딩 계수(alpha) 계산
  static double _smoothingFactor(double dt, double cutoff) {
    final double tau = 1.0 / (2.0 * math.pi * cutoff);
    return 1.0 / (1.0 + tau / dt);
  }

  /// 필터 상태 초기화
  void reset() {
    _prevRawValue = null;
    _prevFilteredValue = null;
    _prevDerivative = 0.0;
    _prevTimestamp = null;
  }
}
