import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

/// YOLO26-N 무게 플레이트 감지 서비스
///
/// - 카메라 프레임 → YOLO26-N 추론 → 플레이트 감지
/// - 감지된 플레이트 무게 합산 → 총 무게 계산
/// - 프레임 스킵 + 중복 처리 방지
/// - 3회 연속 안정성 체크 → 확정 무게 반환
class WeightDetectionService {
  static final WeightDetectionService _instance =
      WeightDetectionService._internal();
  factory WeightDetectionService() => _instance;
  WeightDetectionService._internal();

  Interpreter? _interpreter;
  bool _isProcessing = false;
  bool _isInitialized = false;
  int _frameSkipCounter = 0;

  /// 매 5번째 프레임만 처리 (무게는 자주 안 바뀜)
  static const int _frameSkipInterval = 5;

  /// YOLO 입력 크기
  static const int _inputSize = 640;

  /// 감지 신뢰도 임계값
  static const double _confidenceThreshold = 0.5;

  /// YOLO26 최대 감지 수
  static const int _maxDetections = 300;

  /// 표준 올림픽 바벨 무게 (kg)
  static const double _standardBarbellWeight = 20.0;

  /// 클래스 이름 (data.yaml 순서)
  static const List<String> _classNames = [
    'plate_25kg',
    'plate_20kg',
    'plate_15kg',
    'plate_10kg',
    'plate_5kg',
    'plate_2.5kg',
    'plate_1.25kg',
    'barbell',
    'empty_barbell',
  ];

  /// 클래스 → 무게 매핑 (kg)
  static const Map<String, double> _classWeights = {
    'plate_25kg': 25.0,
    'plate_20kg': 20.0,
    'plate_15kg': 15.0,
    'plate_10kg': 10.0,
    'plate_5kg': 5.0,
    'plate_2.5kg': 2.5,
    'plate_1.25kg': 1.25,
    'barbell': 20.0,
    'empty_barbell': 20.0,
  };

  /// 무게 안정성 체크용 (최근 N회 감지 결과)
  final List<double> _recentWeights = [];
  static const int _stabilityCount = 3;
  static const double _stabilityTolerance = 2.5; // kg

  bool get isInitialized => _isInitialized;

  /// 모델 초기화
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _interpreter = await Interpreter.fromAsset('models/weight_plate.tflite');
      _isInitialized = true;
      _isProcessing = false;
      _frameSkipCounter = 0;
      _recentWeights.clear();
      print('=== WeightDetectionService 초기화 완료 ===');

      // 모델 입출력 텐서 정보 확인
      final inputTensors = _interpreter!.getInputTensors();
      final outputTensors = _interpreter!.getOutputTensors();
      print('=== 입력 텐서: ${inputTensors.map((t) => '${t.name}: ${t.shape}')} ===');
      print('=== 출력 텐서: ${outputTensors.map((t) => '${t.name}: ${t.shape}')} ===');
    } catch (e) {
      print('=== WeightDetectionService 초기화 실패: $e ===');
      _isInitialized = false;
    }
  }

  /// 카메라 프레임에서 무게 플레이트 감지
  ///
  /// 프레임 스킵 적용: 5번째 프레임만 처리
  /// 이미 처리 중이면 스킵
  /// 반환: WeightDetectionResult (null = 스킵됨)
  Future<WeightDetectionResult?> processFrame(CameraImage image) async {
    if (!_isInitialized || _interpreter == null) return null;

    // 프레임 스킵
    _frameSkipCounter++;
    if (_frameSkipCounter % _frameSkipInterval != 0) return null;

    // 이전 프레임 처리 중이면 스킵
    if (_isProcessing) return null;
    _isProcessing = true;

    try {
      // 1. CameraImage → RGB Image 변환
      final rgbImage = _convertCameraImage(image);
      if (rgbImage == null) return null;

      // 2. 640×640 리사이즈 + 정규화 → 입력 텐서
      final inputTensor = _preprocess(rgbImage);

      // 3. 추론 실행
      final outputTensor = _runInference(inputTensor);

      // 4. YOLO26 출력 파싱
      final plates = _parseOutput(outputTensor);

      // 5. 무게 계산
      final totalWeight = _calculateTotalWeight(plates);
      final avgConfidence = plates.isEmpty
          ? 0.0
          : plates.map((p) => p.confidence).reduce((a, b) => a + b) /
              plates.length;

      // 6. 안정성 체크
      _recentWeights.add(totalWeight);
      if (_recentWeights.length > _stabilityCount) {
        _recentWeights.removeAt(0);
      }
      final isStable = _checkStability();

      final result = WeightDetectionResult(
        totalWeight: totalWeight,
        confidence: avgConfidence,
        plates: plates,
        barbellDetected:
            plates.any((p) => p.className == 'barbell' || p.className == 'empty_barbell'),
        isStable: isStable,
      );

      if (plates.isNotEmpty) {
        print('=== 무게 감지: ${totalWeight}kg (${plates.length}개 감지, '
            '안정: $isStable, 신뢰도: ${(avgConfidence * 100).toInt()}%) ===');
      }

      return result;
    } catch (e) {
      print('=== WeightDetection 에러: $e ===');
      return null;
    } finally {
      _isProcessing = false;
    }
  }

  /// CameraImage (NV21/YUV) → RGB Image 변환
  img.Image? _convertCameraImage(CameraImage cameraImage) {
    try {
      final width = cameraImage.width;
      final height = cameraImage.height;

      // NV21 포맷 (Android 기본)
      if (cameraImage.planes.length >= 2) {
        final yPlane = cameraImage.planes[0].bytes;
        final uvPlane = cameraImage.planes.length == 2
            ? cameraImage.planes[1].bytes
            : _mergeUVPlanes(cameraImage.planes[1].bytes,
                cameraImage.planes[2].bytes, width, height);

        final image = img.Image(width: width, height: height);

        for (int y = 0; y < height; y++) {
          for (int x = 0; x < width; x++) {
            final yIndex = y * width + x;
            final uvIndex = (y ~/ 2) * (width ~/ 2) * 2 + (x ~/ 2) * 2;

            final yVal = yPlane[yIndex];
            // NV21: V, U 순서
            final vVal = uvIndex < uvPlane.length ? uvPlane[uvIndex] : 128;
            final uVal =
                uvIndex + 1 < uvPlane.length ? uvPlane[uvIndex + 1] : 128;

            // YUV → RGB 변환
            final r = (yVal + 1.370705 * (vVal - 128)).clamp(0, 255).toInt();
            final g = (yVal - 0.337633 * (uVal - 128) - 0.698001 * (vVal - 128))
                .clamp(0, 255)
                .toInt();
            final b = (yVal + 1.732446 * (uVal - 128)).clamp(0, 255).toInt();

            image.setPixelRgb(x, y, r, g, b);
          }
        }
        return image;
      }

      return null;
    } catch (e) {
      print('=== CameraImage 변환 에러: $e ===');
      return null;
    }
  }

  /// YUV_420_888의 U, V 분리 plane을 NV21 interleaved로 병합
  Uint8List _mergeUVPlanes(
      Uint8List uPlane, Uint8List vPlane, int width, int height) {
    final uvSize = (width ~/ 2) * (height ~/ 2) * 2;
    final merged = Uint8List(uvSize);
    final halfWidth = width ~/ 2;
    for (int i = 0; i < (width ~/ 2) * (height ~/ 2); i++) {
      final row = i ~/ halfWidth;
      final col = i % halfWidth;
      final idx = row * halfWidth * 2 + col * 2;
      if (idx + 1 < merged.length && i < vPlane.length && i < uPlane.length) {
        merged[idx] = vPlane[i]; // V first (NV21)
        merged[idx + 1] = uPlane[i]; // U second
      }
    }
    return merged;
  }

  /// RGB Image → 640×640 정규화 텐서 [1, 640, 640, 3]
  List<List<List<List<double>>>> _preprocess(img.Image image) {
    // 리사이즈 (letterbox: 비율 유지 + 패딩)
    final resized = img.copyResize(image,
        width: _inputSize,
        height: _inputSize,
        interpolation: img.Interpolation.linear);

    // float32 정규화 (0~1)
    final input = List.generate(
      1,
      (_) => List.generate(
        _inputSize,
        (y) => List.generate(
          _inputSize,
          (x) {
            final pixel = resized.getPixel(x, y);
            return [
              pixel.r / 255.0,
              pixel.g / 255.0,
              pixel.b / 255.0,
            ];
          },
        ),
      ),
    );

    return input;
  }

  /// TFLite 추론 실행
  List<List<List<double>>> _runInference(
      List<List<List<List<double>>>> input) {
    // 출력 텐서: YOLO26 NMS-free [1, 300, 6]
    final output = List.generate(
      1,
      (_) => List.generate(
        _maxDetections,
        (_) => List.filled(6, 0.0),
      ),
    );

    _interpreter!.run(input, output);
    return output;
  }

  /// YOLO26 출력 파싱 → DetectedPlate 리스트
  List<DetectedPlate> _parseOutput(List<List<List<double>>> output) {
    final plates = <DetectedPlate>[];

    for (int i = 0; i < _maxDetections; i++) {
      final detection = output[0][i];
      final confidence = detection[4];

      if (confidence < _confidenceThreshold) continue;

      final classId = detection[5].round();
      if (classId < 0 || classId >= _classNames.length) continue;

      final className = _classNames[classId];

      plates.add(DetectedPlate(
        className: className,
        weightKg: _classWeights[className] ?? 0.0,
        confidence: confidence,
        classId: classId,
        // bbox는 정규화 좌표 (0~1)
        xCenter: detection[0],
        yCenter: detection[1],
        width: detection[2],
        height: detection[3],
      ));
    }

    return plates;
  }

  /// 감지된 플레이트로 총 무게 계산
  ///
  /// 규칙:
  /// 1. barbell/empty_barbell 감지 → 바벨 20kg
  /// 2. 바벨 감지 안 됨 + 플레이트 있음 → 바벨 20kg 기본 추가
  /// 3. 플레이트 무게 합산 × 2 (한쪽만 보이는 가정)
  /// 4. 2.5kg 단위 반올림
  double _calculateTotalWeight(List<DetectedPlate> plates) {
    if (plates.isEmpty) return 0.0;

    double barbellWeight = 0.0;
    double plateSum = 0.0;
    bool hasBarbellOrPlates = false;

    for (final plate in plates) {
      if (plate.className == 'barbell' || plate.className == 'empty_barbell') {
        barbellWeight = _standardBarbellWeight;
        hasBarbellOrPlates = true;
      } else {
        plateSum += plate.weightKg;
        hasBarbellOrPlates = true;
      }
    }

    // 플레이트만 감지되고 바벨이 안 보이면 → 바벨 기본 추가
    if (barbellWeight == 0.0 && plateSum > 0.0) {
      barbellWeight = _standardBarbellWeight;
    }

    // 한쪽 촬영 가정: 플레이트 × 2
    final totalWeight = barbellWeight + (plateSum * 2);

    // 2.5kg 단위 반올림
    return (totalWeight / 2.5).round() * 2.5;
  }

  /// 최근 N회 감지 결과가 안정적인지 체크
  bool _checkStability() {
    if (_recentWeights.length < _stabilityCount) return false;

    final recent =
        _recentWeights.sublist(_recentWeights.length - _stabilityCount);
    final first = recent.first;

    return recent.every((w) => (w - first).abs() <= _stabilityTolerance);
  }

  /// 안정성 기록 초기화 (새 세트 시작 시)
  void resetStability() {
    _recentWeights.clear();
  }

  /// 리소스 해제
  void dispose() {
    _interpreter?.close();
    _interpreter = null;
    _isInitialized = false;
    _isProcessing = false;
    _frameSkipCounter = 0;
    _recentWeights.clear();
  }
}

/// 무게 감지 결과
class WeightDetectionResult {
  final double totalWeight;
  final double confidence;
  final List<DetectedPlate> plates;
  final bool barbellDetected;
  final bool isStable;

  const WeightDetectionResult({
    required this.totalWeight,
    required this.confidence,
    required this.plates,
    required this.barbellDetected,
    required this.isStable,
  });
}

/// 개별 플레이트 감지 결과
class DetectedPlate {
  final String className;
  final double weightKg;
  final double confidence;
  final int classId;
  final double xCenter;
  final double yCenter;
  final double width;
  final double height;

  const DetectedPlate({
    required this.className,
    required this.weightKg,
    required this.confidence,
    required this.classId,
    required this.xCenter,
    required this.yCenter,
    required this.width,
    required this.height,
  });
}
