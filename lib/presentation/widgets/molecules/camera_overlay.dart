import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/utils/exercise_angles.dart';
import '../../../data/services/pose_detection_service.dart';
import '../../../data/services/rep_counter_service.dart';
import 'pose_overlay.dart';

/// CV 카메라 프리뷰 + 포즈 오버레이 + 횟수 카운팅
///
/// 반드시 별도 위젯으로 유지 (카메라 스트림이 이 위젯만 리빌드)
/// WorkoutScreen 전체를 StreamBuilder로 감싸면 30fps 리빌드 → 버벅임
class CameraOverlay extends StatefulWidget {
  /// 횟수 감지 콜백 (reps, confidence)
  final void Function(int reps, double confidence)? onRepsDetected;

  /// 운동 이름 (영어) — 각도 규칙 자동 매칭
  final String? exerciseNameEn;

  /// 운동 이름 (한국어) — 각도 규칙 자동 매칭
  final String? exerciseName;

  /// 세트 완료 횟수 (값이 바뀌면 카운터 자동 리셋)
  final int completedSets;

  const CameraOverlay({
    this.onRepsDetected,
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

  List<Pose> _currentPoses = [];
  int _lastReportedReps = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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
    // 세트 완료 시 카운터 리셋 (같은 운동 내에서)
    if (oldWidget.completedSets != widget.completedSets) {
      _repCounter.reset();
      _lastReportedReps = 0;
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
        ResolutionPreset.low, // 640x480 (성능 최적화)
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.nv21,
      );

      await _cameraController!.initialize();
      _poseService.initialize();

      // 카메라 스트림 시작
      await _cameraController!.startImageStream(_onCameraFrame);

      if (mounted) {
        setState(() => _isInitialized = true);
      }
    } catch (e) {
      print('=== 카메라 초기화 에러: $e ===');
    }
  }

  /// 카메라 프레임 콜백
  ///
  /// PoseDetectionService가 내부적으로 프레임 스킵 처리
  void _onCameraFrame(CameraImage image) async {
    if (_cameraController == null) return;
    final camera = _cameraController!.description;

    final poses = await _poseService.processFrame(image, camera);
    if (poses.isEmpty) return;

    // 포즈 오버레이 업데이트
    if (mounted) {
      setState(() => _currentPoses = poses);
    }

    // 횟수 카운팅
    final result = _repCounter.processpose(poses.first);
    if (result != null && result.reps != _lastReportedReps) {
      _lastReportedReps = result.reps;
      widget.onRepsDetected?.call(result.reps, result.confidence);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 앱이 백그라운드로 가면 카메라 해제
    if (state == AppLifecycleState.inactive) {
      _disposeCamera();
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  void _disposeCamera() {
    _cameraController?.stopImageStream().catchError((_) {});
    _cameraController?.dispose();
    _cameraController = null;
    _poseService.dispose();
    _isInitialized = false;
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

    final imageSize = Size(
      _cameraController!.value.previewSize!.height,
      _cameraController!.value.previewSize!.width,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: SizedBox(
        height: 200,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 카메라 프리뷰
            CameraPreview(_cameraController!),

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
                      // 추천과 실제 촬영 방향이 다른지 확인
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
        ),
      ),
    );
  }
}
