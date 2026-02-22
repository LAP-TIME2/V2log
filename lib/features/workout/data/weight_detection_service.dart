import 'dart:math';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import 'depth_estimation_service.dart';

/// YOLO26-N 무게 플레이트 감지 서비스 (성능 최적화 v3)
///
/// v3 최적화 내역:
/// - IsolateInterpreter로 추론 백그라운드 분리 (UI 블로킹 200ms → 0ms)
/// - 최빈값(MODE) 기반 안정화 (3연속 → 5개 중 3개 최빈값)
/// - 신뢰도 필터 (평균 confidence ≥ 0.55만 안정화 기록)
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

  /// 다중 원판 감지 모드 ('none', 'modeA', 'modeB', 'modeC')
  String _activeMode = 'none';

  /// Mode B: MiDaS depth estimation 서비스 (lazy init)
  final DepthEstimationService _depthService = DepthEstimationService();

  /// 매 프레임 시도 (_isProcessing 가드가 자연 속도 제한)
  static const int _frameSkipInterval = 1;

  /// YOLO 입력 크기
  static const int _inputSize = 640;

  /// 감지 신뢰도 임계값
  /// 0.55: 5kg 작은 원판이 0.6~0.68 나오므로 0.7에서 하향.
  /// 얼굴 오인식은 종횡비 필터(_maxAspectRatio)로 방지.
  static const double _confidenceThreshold = 0.55;

  /// 안정화 기록 신뢰도 임계값 (이 이상만 _recentWeights에 기록)
  /// _confidenceThreshold와 동일하게 맞춤 (연쇄 점검: v2B-009)
  static const double _stabilityConfidenceThreshold = 0.55;

  /// 최소 바운딩 박스 면적 (정규화 좌표 기준, 0~1)
  /// 0.005 (0.5%): 5kg 작은 원판이 ~1% 근처라 0.01에서 하향.
  /// 배경 랙 원판은 ROI + 중복 필터로 방지.
  static const double _minBboxArea = 0.005;

  /// ROI 공간 필터 — 프레임 중앙 70%×60% 영역만 감지 허용
  /// 배경 랙 원판(프레임 가장자리) 오감지 방지
  static const double _roiXMin = 0.15;
  static const double _roiXMax = 0.85;
  static const double _roiYMin = 0.20;
  static const double _roiYMax = 0.80;

  /// 종횡비 필터 — 세로/가로 비율이 이 값을 넘으면 원판이 아님 (얼굴 등)
  /// 원판: 정사각~약간 세로 (1.0~1.5), 얼굴: 세로로 긴 직사각형 (1.5+)
  /// 확신도 임계값을 0.55로 낮추면서 얼굴 오인식 방지 역할
  static const double _maxAspectRatio = 1.8;

  /// YOLO26 최대 감지 수
  static const int _maxDetections = 300;

  /// 표준 올림픽 바벨 무게 (kg)
  static const double _standardBarbellWeight = 20.0;

  /// 안정화 윈도우 크기 (최근 N개)
  /// 7: 감지 빈도가 낮을 때(5kg) 더 많이 모아서 최빈값 판단
  static const int _stabilityWindow = 7;

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

  /// 현재 다중 원판 감지 모드
  String get activeMode => _activeMode;

  /// MiDaS depth 서비스 초기화 상태
  bool get isDepthServiceInitialized => _depthService.isInitialized;

  /// 감지 모드 변경 (none/modeA/modeB/modeC)
  void setDetectionMode(String mode) {
    _activeMode = mode;
    _recentWeights.clear();
  }

  /// Mode B: MiDaS depth 서비스 초기화 (최초 1회)
  Future<void> initializeDepthService() async {
    if (!_depthService.isInitialized) {
      await _depthService.initialize();
    }
  }

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

      // 모델 입출력 텐서 정보 확인 (초기화 검증용)
      _interpreter!.getInputTensors();
      _interpreter!.getOutputTensors();
    } catch (_) {
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

      // 1. YUV→Float32 전처리 (UI 스레드에서 직접 — 30-50ms)
      final preprocessOk = _preprocessDirect(image);
      sw.reset();

      if (!preprocessOk) {
        return null;
      }

      // 2. TFLite 추론 (IsolateInterpreter — 백그라운드, UI 블로킹 0ms)
      final output = List.generate(
          1, (_) => List.generate(_maxDetections, (_) => List.filled(6, 0.0)));

      // 방어: await 복귀 사이에 dispose 되었을 수 있음 (Use-After-Free 방지)
      if (_isolateInterpreter == null || !_isInitialized) return null;
      await _isolateInterpreter!.run(_inputBuffer.buffer.asUint8List(), output);

      // 3. 출력 파싱
      final rawPlates = _parseOutput(output);

      // 4. 모드별 다중 원판 추정
      List<DetectedPlate> plates;
      if (_activeMode == 'modeA') {
        plates = rawPlates
            .map((p) => p.copyWith(
                  estimatedPlateCount: _estimatePlateCountModeA(p),
                ))
            .toList();
      } else if (_activeMode == 'modeB' && _depthService.isInitialized) {
        final depthMap = await _depthService.estimateDepth(image);
        if (depthMap != null) {
          plates = rawPlates
              .map((p) => p.copyWith(
                    estimatedPlateCount: _estimatePlateCountModeB(p, depthMap),
                  ))
              .toList();
        } else {
          plates = rawPlates;
        }
      } else if (_activeMode == 'modeC') {
        plates = rawPlates
            .map((p) => p.copyWith(
                  estimatedPlateCount: _estimatePlateCountModeC(p, image),
                ))
            .toList();
      } else {
        plates = rawPlates;
      }

      // 5. 무게 계산
      final totalWeight = _calculateTotalWeight(plates);
      final avgConfidence = plates.isEmpty
          ? 0.0
          : plates.map((p) => p.confidence).reduce((a, b) => a + b) /
              plates.length;

      // 6. 안정성 기록 (감지 성공 + 평균 신뢰도 >= _stabilityConfidenceThreshold)
      if (plates.isNotEmpty && avgConfidence >= _stabilityConfidenceThreshold) {
        _recentWeights.add(totalWeight);
        if (_recentWeights.length > _stabilityWindow * 2) {
          // 윈도우의 2배까지만 보관 (메모리 관리)
          _recentWeights.removeRange(
              0, _recentWeights.length - _stabilityWindow * 2);
        }
      }

      // 7. 안정화 체크 (최빈값 기반)
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

      // modeTag removed — was only used for diagnostics

      return result;
    } catch (_) {
      return null;
    } finally {
      _isProcessing = false;
    }
  }

  /// CameraImage → _inputBuffer에 직접 YUV→RGB→normalize 변환 (Stretch)
  ///
  /// UI 스레드에서 실행 (30-50ms).
  /// _isProcessing 플래그로 프레임 스킵 → 카메라 프리뷰 부드러움 유지.
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
    } catch (_) {
      return false;
    }
  }

  /// 출력 텐서 파싱 [1][300][6] → DetectedPlate 리스트
  ///
  /// 필터 파이프라인: 확신도 → 크기 → 종횡비 → ROI → 클래스별 중복 제거
  /// 각 단계에서 탈락/통과를 진단 로그로 기록
  List<DetectedPlate> _parseOutput(List<List<List<double>>> output) {
    final candidates = <DetectedPlate>[];

    for (int i = 0; i < _maxDetections; i++) {
      final detection = output[0][i];
      final confidence = detection[4];

      if (confidence <= 0.0) continue;

      // 필터 1: 확신도
      if (confidence < _confidenceThreshold) {
        continue;
      }

      // 필터 2: 최소 크기
      final bboxW = detection[2];
      final bboxH = detection[3];
      final bboxArea = bboxW * bboxH;
      if (bboxArea < _minBboxArea) {
        continue;
      }

      // 필터 3: 종횡비 (얼굴 방지 — 세로로 긴 건 원판이 아님)
      final aspectRatio =
          bboxW > 0 ? bboxH / bboxW : 999.0;
      if (aspectRatio > _maxAspectRatio) {
        continue;
      }

      // 필터 4: ROI 공간 필터
      final xCenter = detection[0];
      final yCenter = detection[1];
      if (xCenter < _roiXMin || xCenter > _roiXMax ||
          yCenter < _roiYMin || yCenter > _roiYMax) {
        continue;
      }

      final classId = detection[5].round();
      if (classId < 0 || classId >= _classNames.length) continue;

      final className = _classNames[classId];

      final plate = DetectedPlate(
        className: className,
        weightKg: _classWeights[className] ?? 0.0,
        confidence: confidence,
        classId: classId,
        xCenter: xCenter,
        yCenter: yCenter,
        width: bboxW,
        height: bboxH,
      );


      candidates.add(plate);
    }

    // 필터 5: 클래스별 중복 제거 — 같은 클래스가 2개 이상이면 가장 큰 것만 채택
    // 배경 랙의 원판(작게 보임)을 자동 탈락시킴
    final plates = _deduplicateByClass(candidates);

    return plates;
  }

  /// 클래스별 중복 제거: 같은 클래스가 여러 개면 가장 큰(가까운) 것만 채택
  ///
  /// 이유: 바벨 한쪽에 같은 무게 원판이 2장 겹치는 건 드물지만,
  /// 배경 랙의 같은 무게 원판이 추가로 잡히는 건 흔함.
  /// 가까운 원판 = bbox 면적이 더 큼 → 가장 큰 것 = 실제 바벨 원판.
  ///
  /// ⚠️ 새 모델(바깥 원판만 감지) 배포 후 제거 예정
  List<DetectedPlate> _deduplicateByClass(List<DetectedPlate> candidates) {
    if (candidates.length <= 1) return candidates;

    final bestByClass = <int, DetectedPlate>{};
    for (final plate in candidates) {
      final area = plate.width * plate.height;
      final existing = bestByClass[plate.classId];
      if (existing == null) {
        bestByClass[plate.classId] = plate;
      } else {
        final existingArea = existing.width * existing.height;
        if (area > existingArea) {
          bestByClass[plate.classId] = plate;
        } else {
        }
      }
    }

    return bestByClass.values.toList();
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
      final weight = plate.weightKg * plate.estimatedPlateCount;
      if (plate.xCenter < 0.4) {
        leftSum += weight;
      } else if (plate.xCenter > 0.6) {
        rightSum += weight;
      } else {
        centerSum += weight;
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

    // 2.5kg 단위 반올림
    final rounded = (totalWeight / 2.5).round() * 2.5;

    return rounded;
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

  // ============================================================
  // 다중 원판 감지 알고리즘 (A/B/C 테스트용)
  // ============================================================

  /// Mode A: Bbox Aspect Ratio 기반 (ChatGPT 접근법)
  ///
  /// 대각선 각도(20-45°)에서 원판 2장이면 두께가 2배 → bbox가 두꺼운 타원
  /// aspect ratio 초과분 / 두께비율 = 장수
  /// 정면(0-10°)에서는 물리적으로 작동 불가 (두께가 안 보임)
  int _estimatePlateCountModeA(DetectedPlate plate) {
    final geo = _plateGeometry[plate.className];
    if (geo == null) return 1;

    final aspectRatio = plate.width > 0 ? plate.height / plate.width : 1.0;
    if (aspectRatio <= geo.singleAspectMax) return 1;

    final excess = aspectRatio - 1.0;
    final count = (excess / geo.thicknessRatio).round().clamp(1, 4);


    return count;
  }

  /// Mode B: MiDaS Depth 기반 (Gemini 접근법)
  ///
  /// 원판 bbox 영역의 depth 분산 분석
  /// 다중 원판 = depth 변화가 큼 (원판 경계에서 단차)
  /// 한계: relative depth → 절대 mm 변환 불가, threshold 실기기 튜닝 필수
  int _estimatePlateCountModeB(DetectedPlate plate, Float32List depthMap) {
    const int depthSize = 256;

    // YOLO 정규화 좌표(0~1) → depth map 좌표(0~255)
    final int x1 =
        ((plate.xCenter - plate.width / 2) * depthSize).round().clamp(0, depthSize - 1);
    final int y1 =
        ((plate.yCenter - plate.height / 2) * depthSize).round().clamp(0, depthSize - 1);
    final int x2 =
        ((plate.xCenter + plate.width / 2) * depthSize).round().clamp(0, depthSize - 1);
    final int y2 =
        ((plate.yCenter + plate.height / 2) * depthSize).round().clamp(0, depthSize - 1);

    if (x2 <= x1 || y2 <= y1) return 1;

    // 중앙 50% 영역만 사용 (에지 노이즈 제거)
    final int dx = ((x2 - x1) * 0.25).round();
    final int dy = ((y2 - y1) * 0.25).round();
    final int cx1 = x1 + dx;
    final int cx2 = x2 - dx;
    final int cy1 = y1 + dy;
    final int cy2 = y2 - dy;

    // 평균 + 범위 계산
    double sum = 0;
    int count = 0;
    double minDepth = double.infinity;
    double maxDepth = -double.infinity;

    for (int y = cy1; y <= cy2; y++) {
      for (int x = cx1; x <= cx2; x++) {
        final d = depthMap[y * depthSize + x];
        sum += d;
        count++;
        if (d < minDepth) minDepth = d;
        if (d > maxDepth) maxDepth = d;
      }
    }

    if (count == 0) return 1;

    final mean = sum / count;
    final depthRange = maxDepth - minDepth;

    // depth 변동 기반 장수 추정
    // 단일 원판: 낮은 변동 (평평한 표면)
    // 다중 원판: 높은 변동 (경계 단차)
    // threshold는 실기기 테스트로 튜닝 예정
    final normalizedRange = mean > 0 ? depthRange / mean : 0.0;

    int plateCount;
    if (normalizedRange < 0.15) {
      plateCount = 1;
    } else if (normalizedRange < 0.30) {
      plateCount = 2;
    } else if (normalizedRange < 0.45) {
      plateCount = 3;
    } else {
      plateCount = 4;
    }


    return plateCount;
  }

  /// Mode C: Sobel Edge Projection 기반 (Genspark 접근법)
  ///
  /// bbox crop → grayscale → Sobel Y → 수평 projection → 피크 카운팅
  /// 원판 1장 = 피크 2개 (상단+하단 rim), 2장 = 3-4개
  /// 정면 실패, 메탈 반사 교란 가능. 구현비 최소.
  int _estimatePlateCountModeC(DetectedPlate plate, CameraImage image) {
    // bbox → 이미지 좌표
    final imgW = image.width;
    final imgH = image.height;
    final int x1 =
        ((plate.xCenter - plate.width / 2) * imgW).round().clamp(0, imgW - 1);
    final int y1 =
        ((plate.yCenter - plate.height / 2) * imgH).round().clamp(0, imgH - 1);
    final int x2 =
        ((plate.xCenter + plate.width / 2) * imgW).round().clamp(0, imgW - 1);
    final int y2 =
        ((plate.yCenter + plate.height / 2) * imgH).round().clamp(0, imgH - 1);

    final cropW = x2 - x1;
    final cropH = y2 - y1;
    if (cropW < 10 || cropH < 10) return 1;

    // 1. Y채널(grayscale) crop 추출
    final yPlane = image.planes[0].bytes;
    final yRowStride = image.planes[0].bytesPerRow;
    final crop = Uint8List(cropW * cropH);
    for (int y = 0; y < cropH; y++) {
      for (int x = 0; x < cropW; x++) {
        final idx = (y1 + y) * yRowStride + (x1 + x);
        crop[y * cropW + x] = idx < yPlane.length ? yPlane[idx] : 0;
      }
    }

    // 2. Sobel Y 필터 (수평 에지 강조)
    final edges = _sobelY(crop, cropW, cropH);

    // 3. 수평 projection (각 행의 에지 합)
    final projection = _horizontalProjection(edges, cropW, cropH);

    // 4. Gaussian smoothing
    final smoothed = _gaussianSmooth1D(projection, sigma: 2.0);

    // 5. 피크 검출
    final minDist = cropH ~/ 8;
    final peaks =
        _findPeaks(smoothed, minDistance: minDist > 2 ? minDist : 2);

    // 6. 피크 수 → 장수 매핑
    int plateCount;
    if (peaks.length <= 2) {
      plateCount = 1;
    } else if (peaks.length <= 4) {
      plateCount = 2;
    } else if (peaks.length <= 6) {
      plateCount = 3;
    } else {
      // 피크가 너무 많으면 노이즈 → 1장으로 폴백
      plateCount = 1;
    }


    return plateCount;
  }

  // === Mode C 헬퍼 메서드 ===

  /// Sobel Y 커널 적용 (수평 에지 강조)
  /// 커널: [-1,-2,-1; 0,0,0; 1,2,1]
  Float64List _sobelY(Uint8List gray, int w, int h) {
    final result = Float64List(w * h);
    for (int y = 1; y < h - 1; y++) {
      for (int x = 1; x < w - 1; x++) {
        final top = -gray[(y - 1) * w + (x - 1)] -
            2 * gray[(y - 1) * w + x] -
            gray[(y - 1) * w + (x + 1)];
        final bot = gray[(y + 1) * w + (x - 1)] +
            2 * gray[(y + 1) * w + x] +
            gray[(y + 1) * w + (x + 1)];
        result[y * w + x] = (top + bot).abs().toDouble();
      }
    }
    return result;
  }

  /// 수평 projection: 각 행의 에지 값 합산
  List<double> _horizontalProjection(Float64List edges, int w, int h) {
    final projection = List.filled(h, 0.0);
    for (int y = 0; y < h; y++) {
      double sum = 0;
      for (int x = 0; x < w; x++) {
        sum += edges[y * w + x];
      }
      projection[y] = sum;
    }
    return projection;
  }

  /// 1D Gaussian smoothing
  List<double> _gaussianSmooth1D(List<double> data, {double sigma = 2.0}) {
    final kernelSize = (sigma * 3).ceil() * 2 + 1;
    final kernel = List.filled(kernelSize, 0.0);
    final center = kernelSize ~/ 2;
    double kernelSum = 0;

    for (int i = 0; i < kernelSize; i++) {
      final x = (i - center).toDouble();
      kernel[i] = exp(-x * x / (2 * sigma * sigma));
      kernelSum += kernel[i];
    }
    for (int i = 0; i < kernelSize; i++) {
      kernel[i] /= kernelSum;
    }

    final result = List.filled(data.length, 0.0);
    for (int i = 0; i < data.length; i++) {
      double sum = 0;
      for (int k = 0; k < kernelSize; k++) {
        final idx = i + k - center;
        if (idx >= 0 && idx < data.length) {
          sum += data[idx] * kernel[k];
        }
      }
      result[i] = sum;
    }
    return result;
  }

  /// 피크 검출 (local maxima, minimum distance 보장)
  List<int> _findPeaks(List<double> data, {int minDistance = 3}) {
    if (data.length < 3) return [];

    // threshold: 최대값의 30%
    final maxVal = data.reduce((a, b) => a > b ? a : b);
    final threshold = maxVal * 0.3;

    final peaks = <int>[];
    for (int i = 1; i < data.length - 1; i++) {
      if (data[i] > data[i - 1] &&
          data[i] > data[i + 1] &&
          data[i] > threshold) {
        if (peaks.isEmpty || (i - peaks.last) >= minDistance) {
          peaks.add(i);
        } else if (data[i] > data[peaks.last]) {
          peaks[peaks.length - 1] = i;
        }
      }
    }
    return peaks;
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

  /// 다중 원판 추정 장수 (Mode A/B/C에서 설정, 기본 1)
  final int estimatedPlateCount;

  const DetectedPlate({
    required this.className,
    required this.weightKg,
    required this.confidence,
    required this.classId,
    required this.xCenter,
    required this.yCenter,
    required this.width,
    required this.height,
    this.estimatedPlateCount = 1,
  });

  /// copyWith — estimatedPlateCount만 변경 가능 (다른 필드는 YOLO 출력)
  DetectedPlate copyWith({int? estimatedPlateCount}) {
    return DetectedPlate(
      className: className,
      weightKg: weightKg,
      confidence: confidence,
      classId: classId,
      xCenter: xCenter,
      yCenter: yCenter,
      width: width,
      height: height,
      estimatedPlateCount: estimatedPlateCount ?? this.estimatedPlateCount,
    );
  }
}

/// 원판 물리적 치수 (Mode A에서 사용)
class _PlateGeometry {
  final double diameterMm;
  final double thicknessMm;
  final double singleAspectMax;
  final double thicknessRatio;

  const _PlateGeometry({
    required this.diameterMm,
    required this.thicknessMm,
    required this.singleAspectMax,
    required this.thicknessRatio,
  });
}

/// 클래스별 원판 치수 (IWF 표준 기준)
const Map<String, _PlateGeometry> _plateGeometry = {
  'plate_20kg': _PlateGeometry(
      diameterMm: 450,
      thicknessMm: 52,
      singleAspectMax: 1.15,
      thicknessRatio: 0.116),
  'plate_15kg': _PlateGeometry(
      diameterMm: 375,
      thicknessMm: 45,
      singleAspectMax: 1.15,
      thicknessRatio: 0.120),
  'plate_10kg': _PlateGeometry(
      diameterMm: 290,
      thicknessMm: 39,
      singleAspectMax: 1.15,
      thicknessRatio: 0.134),
  'plate_5kg': _PlateGeometry(
      diameterMm: 248,
      thicknessMm: 27,
      singleAspectMax: 1.12,
      thicknessRatio: 0.109),
  'plate_2.5kg': _PlateGeometry(
      diameterMm: 213,
      thicknessMm: 19,
      singleAspectMax: 1.10,
      thicknessRatio: 0.089),
};
