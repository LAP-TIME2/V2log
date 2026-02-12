import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

/// 33개 관절 점 + 연결선을 카메라 위에 그리는 오버레이
///
/// CustomPainter로 구현 — CameraOverlay 위에 Stack으로 겹침
class PoseOverlay extends StatelessWidget {
  final List<Pose> poses;
  final Size imageSize;
  final Size widgetSize;
  final bool isFrontCamera;

  const PoseOverlay({
    required this.poses,
    required this.imageSize,
    required this.widgetSize,
    this.isFrontCamera = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: widgetSize,
      painter: _PosePainter(
        poses: poses,
        imageSize: imageSize,
        widgetSize: widgetSize,
        isFrontCamera: isFrontCamera,
      ),
    );
  }
}

class _PosePainter extends CustomPainter {
  final List<Pose> poses;
  final Size imageSize;
  final Size widgetSize;
  final bool isFrontCamera;

  _PosePainter({
    required this.poses,
    required this.imageSize,
    required this.widgetSize,
    required this.isFrontCamera,
  });

  /// 관절 연결선 (뼈대)
  static const List<(PoseLandmarkType, PoseLandmarkType)> _connections = [
    // 얼굴
    (PoseLandmarkType.leftEar, PoseLandmarkType.leftEyeOuter),
    (PoseLandmarkType.rightEar, PoseLandmarkType.rightEyeOuter),
    // 몸통
    (PoseLandmarkType.leftShoulder, PoseLandmarkType.rightShoulder),
    (PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip),
    (PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip),
    (PoseLandmarkType.leftHip, PoseLandmarkType.rightHip),
    // 왼팔
    (PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow),
    (PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist),
    // 오른팔
    (PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow),
    (PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist),
    // 왼다리
    (PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee),
    (PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle),
    // 오른다리
    (PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee),
    (PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final jointPaint = Paint()
      ..color = const Color(0xFF00FF88)
      ..style = PaintingStyle.fill;

    final bonePaint = Paint()
      ..color = const Color(0xFF00FF88).withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final lowConfidencePaint = Paint()
      ..color = Colors.red.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    for (final pose in poses) {
      // 연결선 (뼈대) 먼저 그리기
      for (final connection in _connections) {
        final from = pose.landmarks[connection.$1];
        final to = pose.landmarks[connection.$2];
        if (from == null || to == null) continue;
        if (from.likelihood < 0.5 || to.likelihood < 0.5) continue;

        canvas.drawLine(
          _scaledPoint(from),
          _scaledPoint(to),
          bonePaint,
        );
      }

      // 관절 점 그리기
      for (final landmark in pose.landmarks.values) {
        if (landmark.likelihood < 0.5) continue;
        final point = _scaledPoint(landmark);
        final paint = landmark.likelihood >= 0.7 ? jointPaint : lowConfidencePaint;
        canvas.drawCircle(point, 5.0, paint);
      }
    }
  }

  /// 이미지 좌표 → 위젯 좌표 변환
  Offset _scaledPoint(PoseLandmark landmark) {
    final scaleX = widgetSize.width / imageSize.width;
    final scaleY = widgetSize.height / imageSize.height;

    var x = landmark.x * scaleX;
    final y = landmark.y * scaleY;

    // 전면 카메라: 좌우 반전
    if (isFrontCamera) {
      x = widgetSize.width - x;
    }

    return Offset(x, y);
  }

  @override
  bool shouldRepaint(_PosePainter oldDelegate) {
    return oldDelegate.poses != poses;
  }
}
