import 'dart:math' as math;
import 'dart:typed_data' show Uint8List;
import 'dart:ui' show Size;

import 'package:flutter/foundation.dart' show WriteBuffer;

import 'package:camera/camera.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

/// MediaPipe BlazePose 래퍼 서비스
///
/// - 카메라 프레임 → 포즈 감지 (33개 관절)
/// - 관절 좌표로 각도 계산
/// - 프레임 스킵 + 중복 처리 방지
class PoseDetectionService {
  static final PoseDetectionService _instance = PoseDetectionService._internal();
  factory PoseDetectionService() => _instance;
  PoseDetectionService._internal();

  PoseDetector? _poseDetector;
  bool _isProcessing = false;
  int _frameSkipCounter = 0;

  /// 매 N번째 프레임만 처리 (성능 최적화)
  static const int _frameSkipInterval = 3;

  /// 초기화 (이미 초기화된 경우 기존 것 해제 후 재생성)
  void initialize() {
    // 기존 detector가 있으면 먼저 해제
    _poseDetector?.close();
    _isProcessing = false;
    _frameSkipCounter = 0;

    _poseDetector = PoseDetector(
      options: PoseDetectorOptions(
        mode: PoseDetectionMode.stream,
        model: PoseDetectionModel.base,
      ),
    );
  }

  /// 카메라 프레임에서 포즈 감지
  ///
  /// 프레임 스킵 적용: 3번째 프레임만 처리 (10 FPS로 충분)
  /// 이미 처리 중이면 스킵 (겹침 방지)
  Future<List<Pose>> processFrame(CameraImage image, CameraDescription camera) async {
    // detector가 없으면 무시
    if (_poseDetector == null) return [];

    // 프레임 스킵
    _frameSkipCounter++;
    if (_frameSkipCounter % _frameSkipInterval != 0) return [];

    // 이전 프레임 처리 중이면 스킵
    if (_isProcessing) return [];
    _isProcessing = true;

    try {
      final inputImage = _convertCameraImage(image, camera);
      if (inputImage == null) return [];

      final poses = await _poseDetector?.processImage(inputImage) ?? [];
      return poses;
    } catch (_) {
      return [];
    } finally {
      _isProcessing = false;
    }
  }

  /// CameraImage → InputImage 변환
  ///
  /// Android CameraX: YUV_420_888 또는 NV21 포맷
  /// 포맷 인식 실패 시 NV21로 폴백
  InputImage? _convertCameraImage(CameraImage image, CameraDescription camera) {
    final rotation = _getRotation(camera);
    if (rotation == null) return null;

    // 포맷 변환 (폴백 포함)
    var format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null) {
      // Android에서 포맷 인식 실패 시 NV21로 폴백
      format = InputImageFormat.nv21;
    }

    // 모든 plane의 바이트를 합침 (YUV_420_888 등 다중 plane 대응)
    final Uint8List bytes;
    if (image.planes.length == 1) {
      bytes = image.planes.first.bytes;
    } else {
      final WriteBuffer allBytes = WriteBuffer();
      for (final plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      bytes = allBytes.done().buffer.asUint8List();
    }

    return InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: image.planes.first.bytesPerRow,
      ),
    );
  }

  /// 카메라 센서 회전 → InputImageRotation 변환
  InputImageRotation? _getRotation(CameraDescription camera) {
    switch (camera.sensorOrientation) {
      case 0:
        return InputImageRotation.rotation0deg;
      case 90:
        return InputImageRotation.rotation90deg;
      case 180:
        return InputImageRotation.rotation180deg;
      case 270:
        return InputImageRotation.rotation270deg;
      default:
        return InputImageRotation.rotation0deg;
    }
  }

  /// 여러 포즈 중 사용자(가장 가까운 사람)를 선택
  ///
  /// 기준 1: 포즈의 바운딩 박스 크기 (큰 = 가까운) — 70%
  /// 기준 2: 화면 중앙과의 거리 (가까운 = 사용자) — 30%
  /// 두 기준을 합산해서 점수가 가장 높은 포즈 선택
  static Pose selectPrimaryPose(List<Pose> poses, Size imageSize) {
    if (poses.length == 1) return poses.first;

    Pose bestPose = poses.first;
    double bestScore = -1;

    for (final pose in poses) {
      final landmarks = pose.landmarks.values.toList();
      if (landmarks.isEmpty) continue;

      // 바운딩 박스 계산
      double minX = double.infinity, maxX = -double.infinity;
      double minY = double.infinity, maxY = -double.infinity;
      double sumX = 0, sumY = 0;
      int count = 0;

      for (final lm in landmarks) {
        if (lm.x < minX) minX = lm.x;
        if (lm.x > maxX) maxX = lm.x;
        if (lm.y < minY) minY = lm.y;
        if (lm.y > maxY) maxY = lm.y;
        sumX += lm.x;
        sumY += lm.y;
        count++;
      }

      // 크기 점수 (0~1): 바운딩 박스 면적 / 이미지 면적
      final area = (maxX - minX) * (maxY - minY);
      final imageArea = imageSize.width * imageSize.height;
      final sizeScore = (area / imageArea).clamp(0.0, 1.0);

      // 중앙 근접 점수 (0~1): 1 - (중심점~이미지중심 거리 / 최대거리)
      final cx = sumX / count;
      final cy = sumY / count;
      final dx = (cx - imageSize.width / 2) / (imageSize.width / 2);
      final dy = (cy - imageSize.height / 2) / (imageSize.height / 2);
      final dist = math.sqrt(dx * dx + dy * dy); // 0~1.414
      final centerScore = 1.0 - (dist / 1.414).clamp(0.0, 1.0);

      // 합산 점수 (크기 70% + 중앙 30%)
      // 크기가 더 중요: 가까운 사람이 크게 보이니까
      final score = sizeScore * 0.7 + centerScore * 0.3;

      if (score > bestScore) {
        bestScore = score;
        bestPose = pose;
      }
    }


    return bestPose;
  }

  /// 3개 관절로 각도 계산 (도 단위)
  ///
  /// [first] → [middle] → [last] 에서 middle이 꼭짓점
  static double calculateAngle(
    PoseLandmark first,
    PoseLandmark middle,
    PoseLandmark last,
  ) {
    final radians = math.atan2(
          last.y - middle.y,
          last.x - middle.x,
        ) -
        math.atan2(
          first.y - middle.y,
          first.x - middle.x,
        );

    var angle = radians * 180.0 / math.pi;
    if (angle < 0) angle += 360.0;
    if (angle > 180.0) angle = 360.0 - angle;
    return angle;
  }

  /// 포즈에서 특정 랜드마크의 신뢰도 확인
  static double getLandmarkConfidence(Pose pose, int landmarkIndex) {
    final landmark = pose.landmarks[PoseLandmarkType.values[landmarkIndex]];
    return landmark?.likelihood ?? 0.0;
  }

  /// 리소스 해제
  void dispose() {
    _poseDetector?.close();
    _poseDetector = null;
    _isProcessing = false;
    _frameSkipCounter = 0;
  }
}
