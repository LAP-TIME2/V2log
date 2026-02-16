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

class _CameraOverlayState extends State<CameraOverlay> with WidgetsBindingObserver {
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
  bool _weightIsStable = false;
  int _stabilityHits = 0;
  int _stabilityRequired = 3;

  /// 무게 확정 후 Stage 2 전환 대기 중
  bool _weightConfirmed = false;

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
    // 세트 완료 시 카운터 리셋 + Stage 1로 복귀 (무게 바뀔 수 있으니)
    if (oldWidget.completedSets != widget.completedSets) {
      _repCounter.reset();
      _lastReportedReps = 0;
      if (widget.enableWeightDetection) {
        _weightService.resetStability();
        _weightConfirmed = false;
        _detectedWeight = null;
        _currentStage = CameraStage.weightDetecting;
        print('=== 세트 완료 → Stage 1 복귀 (무게 재감지) ===');
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
            _weightIsStable = weightResult.isStable;
            _stabilityHits = weightResult.stabilityHits;
            _stabilityRequired = weightResult.stabilityRequired;
          });
        }
        // 안정화 → 무게 확정 → Stage 2 자동 전환
        if (weightResult.isStable && !_weightConfirmed) {
          _weightConfirmed = true;
          print('=== 무게 확정: ${weightResult.totalWeight}kg → 2초 후 Stage 2 전환 ===');

          widget.onWeightDetected?.call(
            weightResult.totalWeight,
            weightResult.confidence,
          );

          // 2초 후 Stage 2 전환 (사용자가 확인할 시간)
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted && _weightConfirmed) {
              setState(() {
                _currentStage = CameraStage.repCounting;
              });
              print('=== Stage 2 전환 완료 (Pose 감지 시작) ===');
            }
          });
        }
      }
    } else {
      // === Stage 2: Pose 감지 + 횟수 카운팅만 ===
      final poses = await _poseService.processFrame(image, camera);
      if (poses.isEmpty) return;

      // 가장 가까운(큰) 사람 선택 — 배경 사람 추적 방지
      final rawImageSize = Size(image.width.toDouble(), image.height.toDouble());
      final primaryPose = PoseDetectionService.selectPrimaryPose(poses, rawImageSize);

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
    setState(() {
      _currentStage = CameraStage.repCounting;
      _weightConfirmed = true;
    });
    print('=== 무게 감지 스킵 → Stage 2 전환 ===');
  }

  /// 수동으로 Stage 1로 복귀 (무게 다시 감지)
  void _retryWeightDetection() {
    _weightService.resetStability();
    setState(() {
      _currentStage = CameraStage.weightDetecting;
      _weightConfirmed = false;
      _detectedWeight = null;
      _weightIsStable = false;
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
        height: 200,
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
        height: _currentStage == CameraStage.weightDetecting ? 280 : 200,
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

  /// Stage 1 UI: 무게 감지 모드
  Widget _buildWeightDetectionUI() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // 반투명 오버레이
        Container(
          color: Colors.black.withValues(alpha: 0.3),
        ),

        // 중앙 안내
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_detectedWeight == null) ...[
                // 아직 감지 안 됨
                const Icon(
                  Icons.fitness_center,
                  color: Colors.white,
                  size: 40,
                ),
                const SizedBox(height: AppSpacing.sm),
                const Text(
                  '바벨을 카메라에 보여주세요',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '원판이 보이도록 가까이 가져오세요',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                ),
              ] else if (!_weightIsStable) ...[
                // 감지 중 (안정화 대기)
                const Icon(
                  Icons.pending,
                  color: Colors.orange,
                  size: 36,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '감지 중... ${_detectedWeight!.toStringAsFixed(1)}kg',
                  style: const TextStyle(
                    color: Colors.orange,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '잠시 고정해주세요 ($_stabilityHits/$_stabilityRequired 안정화)',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                ),
              ] else ...[
                // 안정화 완료 → 확정!
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 40,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '${_detectedWeight!.toStringAsFixed(1)}kg 확정!',
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '운동 모드로 전환 중...',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
        ),

        // 스킵 버튼 (우하단)
        Positioned(
          bottom: AppSpacing.sm,
          right: AppSpacing.sm,
          child: GestureDetector(
            onTap: _skipWeightDetection,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
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
        ),

        // Stage 표시 (좌상단)
        Positioned(
          top: AppSpacing.sm,
          left: AppSpacing.sm,
          child: Container(
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
                    const Icon(Icons.check_circle, color: Colors.white, size: 14),
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
