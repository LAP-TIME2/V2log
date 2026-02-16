import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

/// YOLO26-N 무게 플레이트 감지 서비스 (성능 최적화 v3)
///
/// v3 최적화 내역:
/// - IsolateInterpreter로 추론 백그라운드 분리 (UI 블로킹 200ms → 0ms)
/// - 최빈값(MODE) 기반 안정화 (3연속 → 5개 중 3개 최빈값)
/// - 신뢰도 필터 (평균 confidence ≥ 0.7만 안정화 기록)
/// - 안정화 진행률 표시 (UI에 "2/3" 형태)
///
/// v2 유지:
/// - YUV→RGB→resize→normalize 1패스 Float32List 직접 변환
/// - 입력 버퍼 사전 할당 (zero-alloc)
/// - CPU 4스레드 (GPU Delegate는 네이티브 크래시 위험으로 제외)
class WeightDetectionService {
  static final WeightDetectionService _instance =
      WeightDetectionService._internal();
  factory WeightDetectionService() => _instance;
  WeightDetectionService._internal();

  Interpreter? _interpreter;
  IsolateInterpreter? _isolateInterpreter;
  bool _isProcessing = false;
  bool _isInitialized = false;
  int _frameSkipCounter = 0;

  /// 매 프레임 시도 (_isProcessing 가드가 자연 속도 제한)
  static const int _frameSkipInterval = 1;

  /// YOLO 입력 크기
  static const int _inputSize = 640;

  /// 감지 신뢰도 임계값
  /// 0.7: 720p 카메라에서 진짜 원판은 0.8+ 나옴. 0.5였을 때 얼굴/배경 오인식 발생
  static const double _confidenceThreshold = 0.7;

  /// 안정화 기록 신뢰도 임계값 (이 이상만 _recentWeights에 기록)
  /// 0.7: 720p 카메라 기준. 640×480 시절 0.55였으나, 해상도 상승으로 진짜 원판은 충분히 높음
  static const double _stabilityConfidenceThreshold = 0.7;

  /// 최소 바운딩 박스 면적 (정규화 좌표 기준, 0~1)
  /// 진짜 원판은 프레임의 0.5%+ 차지. 노이즈성 미세 감지 필터링
  static const double _minBboxArea = 0.005;

  /// YOLO26 최대 감지 수
  static const int _maxDetections = 300;

  /// 표준 올림픽 바벨 무게 (kg)
  static const double _standardBarbellWeight = 20.0;

  /// 안정화 윈도우 크기 (최근 N개)
  static const int _stabilityWindow = 5;

  /// 안정화 최소 횟수 (최빈값이 이 이상이면 안정화)
  static const int _stabilityRequired = 3;

  /// 클래스 이름 (Roboflow v2 학습 데이터 알파벳순, 5개)
  static const List<String> _classNames = [
    'plate_10kg', // 0
    'plate_15kg', // 1
    'plate_2.5kg', // 2
    'plate_20kg', // 3
    'plate_5kg', // 4
  ];

  /// 클래스 → 무게 매핑 (kg)
  static const Map<String, double> _classWeights = {
    'plate_10kg': 10.0,
    'plate_15kg': 15.0,
    'plate_2.5kg': 2.5,
    'plate_20kg': 20.0,
    'plate_5kg': 5.0,
  };

  /// 무게 안정성 체크용 (최근 N회 감지 결과)
  final List<double> _recentWeights = [];

  /// 사전 할당 입력 버퍼 — 매 프레임 덮어쓰기 (zero-alloc)
  final Float32List _inputBuffer =
      Float32List(1 * _inputSize * _inputSize * 3);

  bool get isInitialized => _isInitialized;

  /// 모델 초기화 (CPU 4스레드 + IsolateInterpreter)
  ///
  /// GPU Delegate / XNNPack은 네이티브 크래시 위험이 있어 제외.
  /// IsolateInterpreter: 상주 Isolate — 추론을 백그라운드에서 실행.
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final options = InterpreterOptions()..threads = 4;

      _interpreter = await Interpreter.fromAsset(
        'assets/models/weight_plate.tflite',
        options: options,
      );

      // IsolateInterpreter 생성 (상주 Isolate, 1회 생성 → 계속 재사용)
      _isolateInterpreter = await IsolateInterpreter.create(
        address: _interpreter!.address,
      );

      _isInitialized = true;
      _isProcessing = false;
      _frameSkipCounter = 0;
      _recentWeights.clear();
      print('=== WeightDetectionService v3 초기화 완료 '
          '(CPU 4 threads + IsolateInterpreter) ===');

      // 모델 입출력 텐서 정보 확인
      final inputTensors = _interpreter!.getInputTensors();
      final outputTensors = _interpreter!.getOutputTensors();
      print(
          '=== 입력 텐서: ${inputTensors.map((t) => '${t.name}: ${t.shape}')} ===');
      print(
          '=== 출력 텐서: ${outputTensors.map((t) => '${t.name}: ${t.shape}')} ===');
    } catch (e) {
      print('=== WeightDetectionService 초기화 실패: $e ===');
      _isInitialized = false;
    }
  }

  /// 카메라 프레임에서 무게 플레이트 감지
  ///
  /// 프레임 스킵 적용: 5번째 프레임만 처리
  /// 이미 처리 중이면 스킵
  /// IsolateInterpreter가 busy면 자연 스킵 (UI 블로킹 0ms)
  /// 반환: WeightDetectionResult (null = 스킵됨)
  Future<WeightDetectionResult?> processFrame(CameraImage image) async {
    if (!_isInitialized || _isolateInterpreter == null) return null;

    // 프레임 스킵
    _frameSkipCounter++;
    if (_frameSkipCounter % _frameSkipInterval != 0) return null;

    // 이전 프레임 처리 중이면 스킵
    if (_isProcessing) return null;
    _isProcessing = true;

    try {
      final sw = Stopwatch()..start();

      // 디버그 로그 (최초 1회)
      if (_frameSkipCounter == _frameSkipInterval) {
        print('=== CameraImage: ${image.width}x${image.height}, '
            'planes=${image.planes.length}, '
            'format=${image.format.group} ===');
        for (int i = 0; i < image.planes.length; i++) {
          print('  Plane $i: bytes=${image.planes[i].bytes.length}, '
              'rowStride=${image.planes[i].bytesPerRow}, '
              'pixelStride=${image.planes[i].bytesPerPixel}');
        }
      }

      // 1. YUV→Float32 전처리 (UI 스레드에서 직접 — 30-50ms)
      final preprocessOk = _preprocessDirect(image);
      final preprocessMs = sw.elapsedMilliseconds;
      sw.reset();

      if (!preprocessOk) {
        if (_frameSkipCounter <= _frameSkipInterval * 5) {
          print(
              '=== WeightDetection: 전처리 실패 (frame #$_frameSkipCounter) ===');
        }
        return null;
      }

      // 2. TFLite 추론 (IsolateInterpreter — 백그라운드, UI 블로킹 0ms)
      final output = List.generate(
          1, (_) => List.generate(_maxDetections, (_) => List.filled(6, 0.0)));

      // 방어: await 복귀 사이에 dispose 되었을 수 있음 (Use-After-Free 방지)
      if (_isolateInterpreter == null || !_isInitialized) return null;
      await _isolateInterpreter!.run(_inputBuffer.buffer.asUint8List(), output);
      final inferenceMs = sw.elapsedMilliseconds;

      // 3. 출력 파싱
      final plates = _parseOutput(output);

      // 4. 무게 계산
      final totalWeight = _calculateTotalWeight(plates);
      final avgConfidence = plates.isEmpty
          ? 0.0
          : plates.map((p) => p.confidence).reduce((a, b) => a + b) /
              plates.length;

      // 5. 안정성 기록 (감지 성공 + 신뢰도 0.7 이상만)
      if (plates.isNotEmpty && avgConfidence >= _stabilityConfidenceThreshold) {
        _recentWeights.add(totalWeight);
        if (_recentWeights.length > _stabilityWindow * 2) {
          // 윈도우의 2배까지만 보관 (메모리 관리)
          _recentWeights.removeRange(
              0, _recentWeights.length - _stabilityWindow * 2);
        }
      }

      // 6. 안정화 체크 (최빈값 기반)
      final stabilityInfo = _getStabilityInfo();

      final result = WeightDetectionResult(
        totalWeight: stabilityInfo.modeWeight ?? totalWeight,
        confidence: avgConfidence,
        plates: plates,
        barbellDetected: plates.isNotEmpty,
        isStable: stabilityInfo.isStable,
        stabilityHits: stabilityInfo.hits,
        stabilityRequired: _stabilityRequired,
        stableWeight: stabilityInfo.modeWeight,
      );

      if (plates.isNotEmpty) {
        print('=== 무게 감지: ${totalWeight}kg '
            '(${plates.length}개, conf: ${avgConfidence.toStringAsFixed(2)}, '
            '안정화: ${stabilityInfo.hits}/$_stabilityRequired, '
            '전처리: ${preprocessMs}ms, 추론: ${inferenceMs}ms) ===');
      }

      return result;
    } catch (e) {
      print('=== WeightDetection 에러: $e ===');
      return null;
    } finally {
      _isProcessing = false;
    }
  }

  /// CameraImage → _inputBuffer에 직접 YUV→RGB→normalize 변환
  ///
  /// UI 스레드에서 실행 (30-50ms).
  /// _isProcessing 플래그로 4/5 프레임은 즉시 스킵 → 카메라 프리뷰 부드러움 유지.
  /// nearest neighbor 리사이즈 포함.
  bool _preprocessDirect(CameraImage image) {
    try {
      final int width = image.width;
      final int height = image.height;
      final int planeCount = image.planes.length;
      if (planeCount == 0) return false;

      final Uint8List yBytes = image.planes[0].bytes;
      final int yRowStride = image.planes[0].bytesPerRow;

      // UV 플레인 참조 (플레인 수에 따라)
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
            // YUV_420_888 (Android 표준)
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
            // NV21 single buffer
            final yIndex = sy * width + sx;
            yVal = yIndex < yBytes.length ? yBytes[yIndex] : 0;

            final ySize = width * height;
            final uvBase = ySize + (sy >> 1) * width + (sx >> 1) * 2;
            vVal = uvBase < yBytes.length ? yBytes[uvBase] : 128;
            uVal = uvBase + 1 < yBytes.length ? yBytes[uvBase + 1] : 128;
          } else {
            // NV21 split (2 planes)
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

          // YUV → RGB → 0~1 정규화
          final double r =
              (yVal + 1.370705 * (vVal - 128)).clamp(0.0, 255.0);
          final double g =
              (yVal - 0.337633 * (uVal - 128) - 0.698001 * (vVal - 128))
                  .clamp(0.0, 255.0);
          final double b =
              (yVal + 1.732446 * (uVal - 128)).clamp(0.0, 255.0);

          _inputBuffer[bufIdx++] = r / 255.0;
          _inputBuffer[bufIdx++] = g / 255.0;
          _inputBuffer[bufIdx++] = b / 255.0;
        }
      }

      return true;
    } catch (e) {
      print('=== 전처리 에러: $e ===');
      return false;
    }
  }

  /// 출력 텐서 파싱 [1][300][6] → DetectedPlate 리스트
  List<DetectedPlate> _parseOutput(List<List<List<double>>> output) {
    final plates = <DetectedPlate>[];

    for (int i = 0; i < _maxDetections; i++) {
      final detection = output[0][i];
      final confidence = detection[4];

      if (confidence < _confidenceThreshold) continue;

      // 최소 크기 필터: 너무 작은 감지는 노이즈 (얼굴/배경 오인식 방지)
      final bboxArea = detection[2] * detection[3];
      if (bboxArea < _minBboxArea) continue;

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
  /// 좌/우 그룹핑 → 더 많이 감지된 쪽(가까운 쪽) × 2
  ///
  /// 왜 "가까운 쪽 × 2"인가:
  /// - 바벨 측면에서 보면 가까운 쪽 원판은 전부 보이지만,
  ///   먼 쪽은 바와 가까운 쪽에 가려서 일부만 보임
  /// - 양쪽 합산 → 먼 쪽 과소 감지 → 오히려 부정확
  /// - 가까운 쪽만 × 2 → 항상 정확 (바벨은 대칭)
  double _calculateTotalWeight(List<DetectedPlate> plates) {
    if (plates.isEmpty) return 0.0;

    // 좌/우 그룹핑 (xCenter 기준)
    double leftSum = 0.0;
    double rightSum = 0.0;
    double centerSum = 0.0; // 중앙(0.4~0.6)에 있는 것

    for (final plate in plates) {
      if (plate.xCenter < 0.4) {
        leftSum += plate.weightKg;
      } else if (plate.xCenter > 0.6) {
        rightSum += plate.weightKg;
      } else {
        centerSum += plate.weightKg;
      }
    }

    // 가까운 쪽 = 더 많이 감지된 쪽 (무게 합이 높은 쪽)
    // 중앙 원판은 가까운 쪽에 합산
    final double oneSide;
    if (leftSum >= rightSum) {
      oneSide = leftSum + centerSum;
    } else {
      oneSide = rightSum + centerSum;
    }

    // 항상 × 2 (바벨은 대칭)
    final totalWeight = _standardBarbellWeight + (oneSide * 2);

    print('=== 무게 계산: L=${leftSum}kg, R=${rightSum}kg, C=${centerSum}kg, '
        'oneSide=${oneSide}kg, total=${totalWeight}kg ===');

    // 2.5kg 단위 반올림
    return (totalWeight / 2.5).round() * 2.5;
  }

  /// 안정화 정보 (최빈값 기반)
  ///
  /// 최근 _stabilityWindow개 무게를 2.5kg 단위로 그룹핑 → 최빈값(MODE) 찾기
  /// 최빈값이 _stabilityRequired 이상이면 안정화 완료
  ({bool isStable, int hits, double? modeWeight}) _getStabilityInfo() {
    if (_recentWeights.length < _stabilityRequired) {
      return (
        isStable: false,
        hits: _recentWeights.length,
        modeWeight: null,
      );
    }

    // 윈도우 크기만큼만 사용
    final windowSize =
        _recentWeights.length < _stabilityWindow
            ? _recentWeights.length
            : _stabilityWindow;
    final recent =
        _recentWeights.sublist(_recentWeights.length - windowSize);

    // 2.5kg 단위로 그룹핑 → 최빈값 찾기
    final counts = <double, int>{};
    for (final w in recent) {
      final rounded = (w / 2.5).round() * 2.5;
      counts[rounded] = (counts[rounded] ?? 0) + 1;
    }

    // 최빈값과 카운트
    double modeWeight = counts.entries.first.key;
    int maxCount = counts.entries.first.value;
    for (final entry in counts.entries) {
      if (entry.value > maxCount) {
        maxCount = entry.value;
        modeWeight = entry.key;
      }
    }

    return (
      isStable: maxCount >= _stabilityRequired,
      hits: maxCount,
      modeWeight: modeWeight,
    );
  }

  /// 안정성 기록 초기화 (새 세트 시작 시)
  void resetStability() {
    _recentWeights.clear();
  }

  /// 리소스 해제
  void dispose() {
    _isolateInterpreter?.close(); // fire-and-forget (내부: cancel + kill)
    _isolateInterpreter = null;
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
  /// 현재 감지 무게 (최빈값 또는 최신 감지)
  final double totalWeight;

  /// 평균 신뢰도 (0~1)
  final double confidence;

  /// 감지된 플레이트 목록
  final List<DetectedPlate> plates;

  /// 플레이트 감지 여부
  final bool barbellDetected;

  /// 안정화 완료 여부 (최빈값 ≥ stabilityRequired)
  final bool isStable;

  /// 현재 최빈값 카운트 (UI 진행률 표시: hits/required)
  final int stabilityHits;

  /// 안정화 필요 횟수
  final int stabilityRequired;

  /// 안정화된 무게 (최빈값, null = 아직 데이터 부족)
  final double? stableWeight;

  const WeightDetectionResult({
    required this.totalWeight,
    required this.confidence,
    required this.plates,
    required this.barbellDetected,
    required this.isStable,
    required this.stabilityHits,
    required this.stabilityRequired,
    this.stableWeight,
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
