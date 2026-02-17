import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/utils/exercise_angles.dart';
import '../../../data/services/pose_detection_service.dart';
import '../../../data/services/rep_counter_service.dart';
import '../../../data/services/weight_detection_service.dart';
import 'pose_overlay.dart';

/// 빌드 변형: AC = Mode A+C (APK 1), B = Mode B (APK 2)
const String kBuildVariant =
    String.fromEnvironment('BUILD_VARIANT', defaultValue: 'AC');

/// Two-Stage 파이프라인 상태
enum CameraStage {
  /// Stage 1: 무게 감지 모드 (YOLO만 실행, Pose 스킵)
  weightDetecting,

  /// Stage 2: 운동 모드 (Pose만 실행, YOLO 스킵)
  repCounting,
}

/// CV 카메라 프리뷰 + Two-Stage 파이프라인
///
/// Stage 1: 전면 카메라로 바벨/원판 감지 → 무게 확정
/// Stage 2: 전면 카메라로 Pose 감지 + 횟수 카운팅
///
/// 반드시 별도 위젯으로 유지 (카메라 스트림이 이 위젯만 리빌드)
class CameraOverlay extends StatefulWidget {
  /// 횟수 감지 콜백 (reps, confidence)
  final void Function(int reps, double confidence)? onRepsDetected;

  /// 무게 감지 콜백 (weight kg, confidence)
  final void Function(double weight, double confidence)? onWeightDetected;

  /// 무게 감지 활성화 여부 (Phase 2B)
  final bool enableWeightDetection;

  /// 운동 이름 (영어) — 각도 규칙 자동 매칭
  final String? exerciseNameEn;

  /// 운동 이름 (한국어) — 각도 규칙 자동 매칭
  final String? exerciseName;

  /// 세트 완료 횟수 (값이 바뀌면 카운터 자동 리셋)
  final int completedSets;

  const CameraOverlay({
    this.onRepsDetected,
    this.onWeightDetected,
    this.enableWeightDetection = false,
    this.exerciseNameEn,
    this.exerciseName,
    this.completedSets = 0,
    super.key,
  });

  @override
  State<CameraOverlay> createState() => _CameraOverlayState();
}

class _CameraOverlayState extends State<CameraOverlay>
    with WidgetsBindingObserver {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isInitialized = false;
  bool _isFrontCamera = true;

  final PoseDetectionService _poseService = PoseDetectionService();
  final RepCounterService _repCounter = RepCounterService();
  final WeightDetectionService _weightService = WeightDetectionService();

  List<Pose> _currentPoses = [];
  int _lastReportedReps = 0;

  /// Two-Stage 파이프라인 상태
  CameraStage _currentStage = CameraStage.weightDetecting;

  /// 무게 감지 결과 (카메라 UI 표시용)
  double? _detectedWeight;
  int _stabilityHits = 0;
  int _stabilityRequired = 3;

  /// 무게 확정 후 Stage 2 전환 대기 중
  bool _weightConfirmed = false;

  /// 현재 다중 원판 감지 모드
  String _currentDetectionMode = 'none';

  /// 모니터링 모드 (2세트+: 이전 무게 기억하며 변경 감시)
  bool _isMonitoring = false;
  double? _monitoringWeight;
  int _monitoringSecondsLeft = 30;
  Timer? _monitoringTimer;

  /// 모니터링 중 무게 변경 감지 임계값 (2.5kg = 최소 원판 단위)
  static const double _monitoringChangeTolerance = 2.5;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // 무게 감지 비활성화면 바로 Stage 2
    if (!widget.enableWeightDetection) {
      _currentStage = CameraStage.repCounting;
    }

    _initCamera();
    _setupExercise();
  }

  @override
  void didUpdateWidget(CameraOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 운동이 바뀌면 카운터 초기화 + 규칙 재설정
    if (oldWidget.exerciseNameEn != widget.exerciseNameEn ||
        oldWidget.exerciseName != widget.exerciseName) {
      _setupExercise();
    }
    // 세트 완료 시 카운터 리셋 + Stage 1 복귀
    if (oldWidget.completedSets != widget.completedSets) {
      _repCounter.reset();
      _lastReportedReps = 0;
      if (widget.enableWeightDetection) {
        _weightService.resetStability();
        _weightConfirmed = false;
        _currentStage = CameraStage.weightDetecting;

        // 이전 무게가 있으면 30초 모니터링 모드 (원판 변경 감시)
        // 첫 세트 후부터 작동, _detectedWeight 유지 (null로 안 지움)
        if (_detectedWeight != null) {
          _startMonitoring(_detectedWeight!);
          print(
              '=== 세트 완료 → Stage 1 + 모니터링 모드 (${_detectedWeight}kg, 30초) ===');
        } else {
          print('=== 세트 완료 → Stage 1 복귀 (첫 감지) ===');
        }
      }
      if (mounted) setState(() {});
    }
  }

  void _setupExercise() {
    _repCounter.reset();
    _lastReportedReps = 0;
    if (widget.exerciseNameEn != null) {
      _repCounter.setExerciseByNameEn(widget.exerciseNameEn!);
    } else if (widget.exerciseName != null) {
      _repCounter.setExerciseByName(widget.exerciseName!);
    }
  }

  /// 30초 모니터링 모드 시작 (2세트+: 원판 변경 감시)
  void _startMonitoring(double weight) {
    _monitoringTimer?.cancel();
    _isMonitoring = true;
    _monitoringWeight = weight;
    _monitoringSecondsLeft = 30;

    _monitoringTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() => _monitoringSecondsLeft--);
      if (_monitoringSecondsLeft <= 0) {
        timer.cancel();
        // 30초간 변화 없음 → 같은 무게로 자동 확정
        _confirmAndSwitchToStage2(_monitoringWeight!);
        print(
            '=== 모니터링 30초 경과 → ${_monitoringWeight}kg 자동 확정 ===');
      }
    });
  }

  /// 무게 확정 → Stage 2 전환 (모니터링/첫세트 공용)
  void _confirmAndSwitchToStage2(double weight) {
    _monitoringTimer?.cancel();
    _isMonitoring = false;
    _weightConfirmed = true;

    widget.onWeightDetected?.call(weight, 0.9);

    if (mounted) {
      setState(() {
        _detectedWeight = weight;
        _currentStage = CameraStage.repCounting;
      });
    }
    print('=== 무게 확정: ${weight}kg → Stage 2 전환 ===');
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) return;

      // 전면 카메라 우선
      final camera = _cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras.first,
      );
      _isFrontCamera = camera.lensDirection == CameraLensDirection.front;

      _cameraController = CameraController(
        camera,
        ResolutionPreset.high, // 1280x720 (정확도 우선, YOLO 640×640에 최적 소스)
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.nv21,
      );

      await _cameraController!.initialize();
      _poseService.initialize();

      // Phase 2B: 무게 감지 모델 초기화
      if (widget.enableWeightDetection) {
        await _weightService.initialize();
        print('=== Two-Stage 파이프라인 시작: Stage 1 (무게 감지) ===');
      }

      // 카메라 스트림 시작
      await _cameraController!.startImageStream(_onCameraFrame);

      if (mounted) {
        setState(() => _isInitialized = true);
      }
    } catch (e) {
      print('=== 카메라 초기화 에러: $e ===');
    }
  }

  /// 카메라 프레임 콜백 — Two-Stage 파이프라인
  ///
  /// Stage 1 (weightDetecting): YOLO만 실행, Pose 스킵
  /// Stage 2 (repCounting): Pose만 실행, YOLO 스킵
  void _onCameraFrame(CameraImage image) async {
    if (_cameraController == null || !_isInitialized) return;
    final camera = _cameraController!.description;

    if (_currentStage == CameraStage.weightDetecting) {
      // === Stage 1: 무게 감지만 ===
      if (!_weightService.isInitialized) return;

      final weightResult = await _weightService.processFrame(image);
      if (weightResult != null && weightResult.plates.isNotEmpty) {
        if (mounted) {
          setState(() {
            _detectedWeight = weightResult.totalWeight;
            _stabilityHits = weightResult.stabilityHits;
            _stabilityRequired = weightResult.stabilityRequired;
          });
        }

        if (_isMonitoring) {
          // === 모니터링 모드 (2세트+): 원판 변경 감시 ===
          if (weightResult.isStable) {
            final diff =
                (weightResult.totalWeight - _monitoringWeight!).abs();
            if (diff >= _monitoringChangeTolerance) {
              // 원판 변경 감지! → 모니터링 종료 → 일반 감지 모드로 전환
              _monitoringTimer?.cancel();
              _isMonitoring = false;
              _weightService.resetStability();
              if (mounted) {
                setState(() {
                  _detectedWeight = null;
                });
              }
              print(
                  '=== 원판 변경 감지! ${_monitoringWeight}kg → ${weightResult.totalWeight}kg ===');
            }
          }
        } else if (weightResult.isStable && !_weightConfirmed) {
          // === 첫 세트 (일반 감지): 안정화 → 즉시 확정 ===
          _confirmAndSwitchToStage2(weightResult.totalWeight);
        }
      }
    } else {
      // === Stage 2: Pose 감지 + 횟수 카운팅만 ===
      final poses = await _poseService.processFrame(image, camera);
      if (poses.isEmpty) return;

      // 가장 가까운(큰) 사람 선택 — 배경 사람 추적 방지
      final rawImageSize =
          Size(image.width.toDouble(), image.height.toDouble());
      final primaryPose =
          PoseDetectionService.selectPrimaryPose(poses, rawImageSize);

      if (mounted) {
        setState(() => _currentPoses = [primaryPose]);
      }

      final result = _repCounter.processpose(primaryPose);
      if (result != null && result.reps != _lastReportedReps) {
        _lastReportedReps = result.reps;
        widget.onRepsDetected?.call(result.reps, result.confidence);
      }
    }
  }

  /// 수동으로 Stage 전환 (무게 스킵 → 바로 운동)
  void _skipWeightDetection() {
    _monitoringTimer?.cancel();
    _isMonitoring = false;
    setState(() {
      _currentStage = CameraStage.repCounting;
      _weightConfirmed = true;
    });
    print('=== 무게 감지 스킵 → Stage 2 전환 ===');
  }

  /// 모드 선택 버튼 UI (BUILD_VARIANT에 따라 다른 버튼)
  Widget _buildModeSelector() {
    // BUILD_VARIANT에 따라 표시할 모드 결정
    final List<_ModeOption> modes;
    if (kBuildVariant == 'B') {
      modes = [
        _ModeOption('none', 'OFF'),
        _ModeOption('modeB', 'B'),
      ];
    } else {
      // 기본: AC
      modes = [
        _ModeOption('none', 'OFF'),
        _ModeOption('modeA', 'A'),
        _ModeOption('modeC', 'C'),
      ];
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: modes.map((m) {
          final isSelected = _currentDetectionMode == m.mode;
          return GestureDetector(
            onTap: () => _changeDetectionMode(m.mode),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.blue.withValues(alpha: 0.9)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Text(
                m.label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white60,
                  fontSize: 11,
                  fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// 다중 원판 감지 모드 변경
  void _changeDetectionMode(String mode) async {
    _weightService.setDetectionMode(mode);
    _weightService.resetStability();
    setState(() {
      _currentDetectionMode = mode;
      _detectedWeight = null;
      _weightConfirmed = false;
    });

    // Mode B: MiDaS 초기화 (최초 1회)
    if (mode == 'modeB' && !_weightService.isDepthServiceInitialized) {
      print('=== MiDaS 모델 로드 시작... ===');
      await _weightService.initializeDepthService();
      if (!_weightService.isDepthServiceInitialized) {
        print('=== MiDaS 모델 로드 실패 → OFF로 복귀 ===');
        _weightService.setDetectionMode('none');
        if (mounted) {
          setState(() => _currentDetectionMode = 'none');
        }
      }
    }
  }

  /// 수동으로 Stage 1로 복귀 (무게 다시 감지, fresh 감지)
  void _retryWeightDetection() {
    _monitoringTimer?.cancel();
    _isMonitoring = false;
    _weightService.resetStability();
    setState(() {
      _currentStage = CameraStage.weightDetecting;
      _weightConfirmed = false;
      _detectedWeight = null;
    });
    print('=== Stage 1 복귀 (무게 재감지) ===');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      _disposeCamera();
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  void _disposeCamera() {
    _isInitialized = false;
    _monitoringTimer?.cancel();
    _isMonitoring = false;
    _cameraController?.stopImageStream().catchError((_) {});
    _cameraController?.dispose();
    _cameraController = null;
    _poseService.dispose();
    // WeightDetectionService는 싱글톤 — dispose 금지
    // (IsolateInterpreter가 추론 중일 수 있고, resumed 시 재사용됨)
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _disposeCamera();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (!_isInitialized || _cameraController == null) {
      return Container(
        height: 280,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: AppSpacing.sm),
              Text('카메라 준비 중...'),
            ],
          ),
        ),
      );
    }

    // portrait 모드에서 previewSize는 센서 기준(landscape)이므로 스왑
    final previewSize = _cameraController!.value.previewSize!;
    final imageSize = Size(previewSize.height, previewSize.width);

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: SizedBox(
        height: 280, // Stage 1, 2 모두 동일 (전환 시 점프 방지 + 넓은 시야)
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 카메라 프리뷰 — 원본 비율 유지, 초과분 잘라냄 (cover 방식)
            FittedBox(
              fit: BoxFit.cover,
              clipBehavior: Clip.hardEdge,
              child: SizedBox(
                width: previewSize.height, // portrait 기준 width
                height: previewSize.width, // portrait 기준 height
                child: CameraPreview(_cameraController!),
              ),
            ),

            // Stage별 UI
            if (_currentStage == CameraStage.weightDetecting)
              _buildWeightDetectionUI()
            else
              _buildRepCountingUI(imageSize),
          ],
        ),
      ),
    );
  }

  /// Stage 1 UI: 무게 감지 모드 (ROI 가이드 + 하단 compact 바)
  Widget _buildWeightDetectionUI() {
    // 상태 결정
    final bool isDetecting =
        _detectedWeight != null && !_isMonitoring;
    final bool isWaiting = _detectedWeight == null && !_isMonitoring;

    // 모드 태그 (디버그용)
    final modeTag = _currentDetectionMode == 'none'
        ? ''
        : ' [${_currentDetectionMode.replaceFirst('mode', '')}]';

    // 상태 텍스트
    String statusText;
    IconData statusIcon;
    Color statusColor;

    if (_isMonitoring) {
      statusText =
          '${_monitoringWeight!.toStringAsFixed(1)}kg · $_monitoringSecondsLeft초$modeTag';
      statusIcon = Icons.timer;
      statusColor = Colors.blue;
    } else if (isWaiting) {
      statusText = '원판을 가이드 안에 맞추세요$modeTag';
      statusIcon = Icons.fitness_center;
      statusColor = Colors.white;
    } else if (isDetecting) {
      statusText =
          '${_detectedWeight!.toStringAsFixed(1)}kg ($_stabilityHits/$_stabilityRequired)$modeTag';
      statusIcon = Icons.pending;
      statusColor = Colors.orange;
    } else {
      statusText = '${_detectedWeight!.toStringAsFixed(1)}kg 확정!$modeTag';
      statusIcon = Icons.check_circle;
      statusColor = Colors.green;
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        // ROI 가이드 오버레이 (밖 어둡게, 안 투명)
        CustomPaint(
          painter: _RoiOverlayPainter(
            isDetected: _detectedWeight != null,
            isStable: _isMonitoring,
          ),
        ),

        // 상단: Stage 표시 (좌) + 모드 선택 (우)
        Positioned(
          top: AppSpacing.sm,
          left: AppSpacing.sm,
          right: AppSpacing.sm,
          child: Row(
            children: [
              // Stage 표시 (좌상단)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.scale, color: Colors.white, size: 12),
                    SizedBox(width: 4),
                    Text(
                      '무게 감지',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // 모드 선택 버튼 (우상단)
              _buildModeSelector(),
            ],
          ),
        ),

        // 하단: 상태 바 + 버튼들
        Positioned(
          bottom: AppSpacing.sm,
          left: AppSpacing.sm,
          right: AppSpacing.sm,
          child: Row(
            children: [
              // 상태 정보
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, color: statusColor, size: 16),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          statusText,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 모니터링 중 [확정] 버튼
              if (_isMonitoring) ...[
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: () =>
                      _confirmAndSwitchToStage2(_monitoringWeight!),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.8),
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: const Text(
                      '확정',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],

              // 건너뛰기 버튼
              const SizedBox(width: 6),
              GestureDetector(
                onTap: _skipWeightDetection,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: const Text(
                    '건너뛰기',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Stage 2 UI: 운동 모드 (Pose 감지 + 횟수)
  Widget _buildRepCountingUI(Size imageSize) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // 포즈 오버레이
        if (_currentPoses.isNotEmpty)
          LayoutBuilder(
            builder: (context, constraints) => PoseOverlay(
              poses: _currentPoses,
              imageSize: imageSize,
              widgetSize: Size(constraints.maxWidth, constraints.maxHeight),
              isFrontCamera: _isFrontCamera,
            ),
          ),

        // 횟수 표시 (좌상단)
        Positioned(
          top: AppSpacing.sm,
          left: AppSpacing.sm,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Text(
              '${_repCounter.reps}회',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        // 확정된 무게 표시 (좌하단) — Stage 2에서도 유지
        if (_detectedWeight != null && _weightConfirmed)
          Positioned(
            bottom: AppSpacing.sm,
            left: AppSpacing.sm,
            child: GestureDetector(
              onTap: _retryWeightDetection,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle,
                        color: Colors.white, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '${_detectedWeight!.toStringAsFixed(1)}kg',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.refresh,
                      color: Colors.white.withValues(alpha: 0.7),
                      size: 12,
                    ),
                  ],
                ),
              ),
            ),
          ),

        // 운동 매칭 + 추천 촬영 방향 (우상단)
        Positioned(
          top: AppSpacing.sm,
          right: AppSpacing.sm,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: _repCounter.currentRule != null
                      ? Colors.green.withValues(alpha: 0.7)
                      : Colors.orange.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Text(
                  _repCounter.currentRule?.name ?? '매칭 없음',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
              if (_repCounter.currentRule != null) ...[
                const SizedBox(height: 4),
                Builder(builder: (context) {
                  final rule = _repCounter.currentRule!;
                  final isSide = _repCounter.isSideView;
                  final recommended = rule.recommendedView;
                  final isMismatch =
                      (recommended == RecommendedView.front && isSide) ||
                      (recommended == RecommendedView.side && !isSide);
                  final currentLabel = isSide ? '측면' : '정면';
                  final recommendLabel =
                      recommended == RecommendedView.front ? '정면' : '측면';

                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: isMismatch
                          ? Colors.amber.withValues(alpha: 0.8)
                          : Colors.black54,
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: Text(
                      isMismatch
                          ? '$currentLabel 감지 · $recommendLabel 추천'
                          : '$currentLabel 촬영',
                      style: TextStyle(
                        color:
                            isMismatch ? Colors.black87 : Colors.white70,
                        fontSize: 10,
                        fontWeight: isMismatch
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  );
                }),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// 모드 선택 옵션 (UI용)
class _ModeOption {
  final String mode;
  final String label;
  const _ModeOption(this.mode, this.label);
}

/// ROI 가이드 오버레이 — ROI 밖 반투명, 안 투명, 테두리 표시
class _RoiOverlayPainter extends CustomPainter {
  final bool isDetected;
  final bool isStable;

  _RoiOverlayPainter({
    required this.isDetected,
    required this.isStable,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // ROI 영역 (중앙 70% × 60%)
    final roiRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.15,
        size.height * 0.20,
        size.width * 0.70,
        size.height * 0.60,
      ),
      const Radius.circular(12),
    );

    // ROI 밖 반투명 검정
    final outerPath = Path()..addRect(Offset.zero & size);
    final roiPath = Path()..addRRect(roiRect);
    final dimPath =
        Path.combine(PathOperation.difference, outerPath, roiPath);

    canvas.drawPath(
      dimPath,
      Paint()..color = Colors.black.withValues(alpha: 0.4),
    );

    // ROI 테두리
    final borderColor = isStable
        ? Colors.green
        : isDetected
            ? Colors.orange
            : Colors.white.withValues(alpha: 0.6);

    canvas.drawRRect(
      roiRect,
      Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );
  }

  @override
  bool shouldRepaint(_RoiOverlayPainter oldDelegate) =>
      oldDelegate.isDetected != isDetected ||
      oldDelegate.isStable != isStable;
}
