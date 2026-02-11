import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gal/gal.dart';
import 'package:share_plus/share_plus.dart';

/// 운동 기록 공유 유틸리티
class WorkoutShareUtils {
  /// 글로벌 키 맵 (세션 ID별 GlobalKey)
  static final Map<String, GlobalKey> _captureKeys = {};

  /// 세션 ID에 대한 캡처 키 가져오기 또는 생성
  static GlobalKey getCaptureKey(String sessionId) {
    _captureKeys.putIfAbsent(
      sessionId,
      () => GlobalKey(),
    );
    return _captureKeys[sessionId]!;
  }

  /// 캡처 키 정리 (메모리 관리)
  static void clearCaptureKey(String sessionId) {
    _captureKeys.remove(sessionId);
  }

  /// RepaintBoundary에서 이미지 캡처
  static Future<Uint8List?> captureFromRenderBox(
    GlobalKey captureKey,
  ) async {
    try {
      final RenderRepaintBoundary? boundary =
          captureKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;

      if (boundary == null) {
        print('=== 경고: RenderRepaintBoundary를 찾을 수 없음 ===');
        return null;
      }

      // 비동기로 toImage 호출
      final ui.Image image = await boundary.toImage(
        pixelRatio: 3.0,
      );

      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData == null) {
        return null;
      }

      return byteData.buffer.asUint8List();
    } catch (e) {
      print('=== 캡처 실패: $e ===');
      return null;
    }
  }

  /// 이미지를 파일로 저장하고 공유
  static Future<void> shareImageFile(
    Uint8List imageBytes,
    String sessionSummary, {
    String? subject,
  }) async {
    try {
      // 임시 파일로 저장
      final tempDir = Directory.systemTemp;
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File('${tempDir.path}/v2log_workout_$timestamp.png');
      await file.writeAsBytes(imageBytes);

      // 공유
      await Share.shareXFiles(
        [XFile(file.path)],
        text: sessionSummary,
        subject: subject,
      );

      // 임시 파일 정리
      try {
        await file.delete();
      } catch (_) {}
    } catch (e) {
      print('=== 공유 실패: $e ===');
      rethrow;
    }
  }

  /// 이미지를 갤러리에 저장
  static Future<bool> saveToGallery(Uint8List imageBytes) async {
    try {
      // 갤러리 접근 권한 확인 및 요청
      final hasAccess = await Gal.hasAccess();
      if (!hasAccess) {
        final granted = await Gal.requestAccess();
        if (!granted) {
          print('=== 갤러리 권한 거부됨 ===');
          return false;
        }
      }

      await Gal.putImageBytes(imageBytes, album: 'V2log');
      return true;
    } on GalException catch (e) {
      print('=== 갤러리 저장 실패: ${e.type} ===');
      return false;
    } catch (e) {
      print('=== 갤러리 저장 에러: $e ===');
      return false;
    }
  }

  /// 공유 텍스트 생성
  static String generateShareSummary({
    required DateTime date,
    required Duration duration,
    required double volume,
    required int sets,
    int? prCount,
  }) {
    final buffer = StringBuffer();

    buffer.writeln('🏋️ V2log 운동 기록');
    buffer.writeln('');
    buffer.writeln('📅 ${_formatDate(date)}');
    buffer.writeln('⏱️ 운동 시간: ${_formatDuration(duration)}');
    buffer.writeln('💪 총 볼륨: ${_formatVolume(volume)}');
    buffer.writeln('📊 총 세트: $sets세트');

    if (prCount != null && prCount > 0) {
      buffer.writeln('🏆 PR: $prCount개');
    }

    buffer.writeln('');
    buffer.writeln('V2log - 전문가 루틴으로 시작하고, 기록은 10초 만에');

    return buffer.toString().trim();
  }

  /// 날짜 포맷
  static String _formatDate(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }

  /// 기간 포맷
  static String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return '${hours}시간 ${minutes}분';
    }
    return '$minutes분';
  }

  /// 볼륨 포맷
  static String _formatVolume(double volume) {
    if (volume >= 10000) {
      return '${(volume / 1000).toStringAsFixed(1)}k kg';
    } else if (volume >= 1000) {
      return '${(volume / 1000).toStringAsFixed(2)}k kg';
    }
    return '${volume.toStringAsFixed(0)} kg';
  }
}
