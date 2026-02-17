import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

/// MiDaS v2.1 Small 기반 depth estimation (Mode B 전용)
///
/// 256×256 입력 → 256×256 상대 depth map 출력
/// ImageNet 정규화 + IsolateInterpreter (백그라운드 추론)
class DepthEstimationService {
  static final DepthEstimationService _instance =
      DepthEstimationService._internal();
  factory DepthEstimationService() => _instance;
  DepthEstimationService._internal();

  Interpreter? _interpreter;
  IsolateInterpreter? _isolateInterpreter;
  bool _isInitialized = false;

  /// 모델에서 읽어온 실제 입력 크기 (256 또는 384)
  int _inputSize = 256;

  /// ImageNet normalization 상수
  static const List<double> _mean = [0.485, 0.456, 0.406];
  static const List<double> _std = [0.229, 0.224, 0.225];

  /// 입력 버퍼 (initialize에서 실제 크기로 재할당)
  Float32List _inputBuffer = Float32List(1 * 256 * 256 * 3);

  bool get isInitialized => _isInitialized;

  /// MiDaS 모델 초기화 (CPU 2스레드 + IsolateInterpreter)
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final options = InterpreterOptions()..threads = 2;

      _interpreter = await Interpreter.fromAsset(
        'assets/models/midas_v2.tflite',
        options: options,
      );

      _isolateInterpreter = await IsolateInterpreter.create(
        address: _interpreter!.address,
      );

      // 모델 입력 크기 동적 결정 (256 or 384)
      final inputTensors = _interpreter!.getInputTensors();
      final outputTensors = _interpreter!.getOutputTensors();
      if (inputTensors.isNotEmpty && inputTensors[0].shape.length >= 3) {
        _inputSize = inputTensors[0].shape[1]; // [1, H, W, 3]
        _inputBuffer = Float32List(1 * _inputSize * _inputSize * 3);
      }

      _isInitialized = true;
      print('=== DepthEstimationService 초기화 완료 '
          '(입력: ${_inputSize}x$_inputSize) ===');
      print(
          '=== MiDaS 입력: ${inputTensors.map((t) => '${t.name}: ${t.shape}')} ===');
      print(
          '=== MiDaS 출력: ${outputTensors.map((t) => '${t.name}: ${t.shape}')} ===');
    } catch (e) {
      print('=== DepthEstimationService 초기화 실패: $e ===');
      _isInitialized = false;
    }
  }

  /// CameraImage → 256×256 depth map (Float32List, 65536개 float)
  ///
  /// 반환: relative inverse depth (높을수록 가까움)
  /// null = 처리 실패
  Future<Float32List?> estimateDepth(CameraImage image) async {
    if (!_isInitialized || _isolateInterpreter == null) return null;

    try {
      // 1. 전처리: YUV → RGB → 256×256 → ImageNet normalize
      final ok = _preprocessImage(image);
      if (!ok) return null;

      // 2. 추론 — MiDaS 출력: [1][H][W] float32
      final sz = _inputSize;
      final output = List.generate(
        1,
        (_) => List.generate(sz, (_) => List.filled(sz, 0.0)),
      );

      if (_isolateInterpreter == null || !_isInitialized) return null;
      await _isolateInterpreter!.run(_inputBuffer.buffer.asUint8List(), output);

      // 3. Float32List로 flatten (항상 256×256로 반환 — 호출쪽 통일)
      final depthMap = Float32List(256 * 256);
      final scale = sz / 256.0;
      for (int y = 0; y < 256; y++) {
        final sy = (y * scale).toInt().clamp(0, sz - 1);
        for (int x = 0; x < 256; x++) {
          final sx = (x * scale).toInt().clamp(0, sz - 1);
          depthMap[y * 256 + x] = output[0][sy][sx];
        }
      }

      return depthMap;
    } catch (e) {
      print('=== Depth estimation 에러: $e ===');
      return null;
    }
  }

  /// YUV → RGB → 256×256 resize → ImageNet normalize
  bool _preprocessImage(CameraImage image) {
    try {
      final int width = image.width;
      final int height = image.height;
      final int planeCount = image.planes.length;
      if (planeCount == 0) return false;

      final Uint8List yBytes = image.planes[0].bytes;
      final int yRowStride = image.planes[0].bytesPerRow;

      Uint8List? uBytes;
      Uint8List? vBytes;
      Uint8List? vuBytes;
      int uvRowStride = 0;
      int uvPixelStride = 1;

      if (planeCount >= 3) {
        uBytes = image.planes[1].bytes;
        vBytes = image.planes[2].bytes;
        uvRowStride = image.planes[1].bytesPerRow;
        uvPixelStride = image.planes[1].bytesPerPixel ?? 1;
      } else if (planeCount == 2) {
        vuBytes = image.planes[1].bytes;
      }

      final double scaleX = width / _inputSize;
      final double scaleY = height / _inputSize;
      int bufIdx = 0;

      for (int oy = 0; oy < _inputSize; oy++) {
        final int sy = (oy * scaleY).toInt();
        for (int ox = 0; ox < _inputSize; ox++) {
          final int sx = (ox * scaleX).toInt();

          int yVal, uVal, vVal;

          if (planeCount >= 3) {
            final yIndex = sy * yRowStride + sx;
            yVal = yIndex < yBytes.length ? yBytes[yIndex] : 0;

            final uvRow = sy >> 1;
            final uvCol = sx >> 1;
            final uvIndex = uvRow * uvRowStride + uvCol * uvPixelStride;
            uVal = (uBytes != null && uvIndex < uBytes.length)
                ? uBytes[uvIndex]
                : 128;
            vVal = (vBytes != null && uvIndex < vBytes.length)
                ? vBytes[uvIndex]
                : 128;
          } else if (planeCount == 1) {
            final yIndex = sy * width + sx;
            yVal = yIndex < yBytes.length ? yBytes[yIndex] : 0;

            final ySize = width * height;
            final uvBase = ySize + (sy >> 1) * width + (sx >> 1) * 2;
            vVal = uvBase < yBytes.length ? yBytes[uvBase] : 128;
            uVal = uvBase + 1 < yBytes.length ? yBytes[uvBase + 1] : 128;
          } else {
            final yIndex = sy * yRowStride + sx;
            yVal = yIndex < yBytes.length ? yBytes[yIndex] : 0;

            final uvIndex = (sy >> 1) * width + (sx >> 1) * 2;
            vVal = (vuBytes != null && uvIndex < vuBytes.length)
                ? vuBytes[uvIndex]
                : 128;
            uVal = (vuBytes != null && uvIndex + 1 < vuBytes.length)
                ? vuBytes[uvIndex + 1]
                : 128;
          }

          // YUV → RGB → 0~1 → ImageNet normalize
          final double r =
              (yVal + 1.370705 * (vVal - 128)).clamp(0.0, 255.0) / 255.0;
          final double g =
              (yVal - 0.337633 * (uVal - 128) - 0.698001 * (vVal - 128))
                      .clamp(0.0, 255.0) /
                  255.0;
          final double b =
              (yVal + 1.732446 * (uVal - 128)).clamp(0.0, 255.0) / 255.0;

          _inputBuffer[bufIdx++] = (r - _mean[0]) / _std[0];
          _inputBuffer[bufIdx++] = (g - _mean[1]) / _std[1];
          _inputBuffer[bufIdx++] = (b - _mean[2]) / _std[2];
        }
      }

      return true;
    } catch (e) {
      print('=== MiDaS 전처리 에러: $e ===');
      return false;
    }
  }

  /// 리소스 해제
  void dispose() {
    _isolateInterpreter?.close();
    _isolateInterpreter = null;
    _interpreter?.close();
    _interpreter = null;
    _isInitialized = false;
  }
}
