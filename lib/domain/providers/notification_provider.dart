import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/notification_settings_model.dart';
import '../../data/services/notification_service.dart';

/// 알림 설정 StateNotifier
class NotificationSettingsNotifier extends StateNotifier<NotificationSettingsModel> {
  final NotificationService _notificationService;

  NotificationSettingsNotifier({
    NotificationService? notificationService,
  })  : _notificationService = notificationService ?? NotificationService(),
        super(NotificationSettingsModel()) {
    _loadSettings();
  }

  /// 저장된 설정 로드 + 알림 재예약
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString('notification_settings');
      if (settingsJson != null) {
        final settings = NotificationSettingsModel.fromJson(
          json.decode(settingsJson) as Map<String, dynamic>,
        );
        state = settings;
        print('=== 알림 설정 로드 완료: ${settings.enabled} ===');

        // 앱 재시작 시 저장된 설정으로 알림 재예약
        if (settings.enabled) {
          await _scheduleWeekdayNotifications(settings);
          print('=== 앱 시작 시 알림 재예약 완료 ===');
        }
      }
    } catch (e) {
      print('=== 알림 설정 로드 실패: $e ===');
    }
  }

  /// 설정 저장
  Future<void> _saveSettings(NotificationSettingsModel settings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = json.encode(settings.toJson());
      await prefs.setString('notification_settings', jsonString);
      print('=== 알림 설정 저장 완료 ===');
    } catch (e) {
      print('=== 알림 설정 저장 실패: $e ===');
    }
  }

  /// 전체 알림 ON/OFF 토글
  Future<void> toggleAll(bool enabled) async {
    final updated = state.toggleAll(enabled);
    state = updated;

    await _saveSettings(updated);

    if (enabled) {
      // 알림 ON: 요일별 알림 예약 시작
      await _scheduleWeekdayNotifications(updated);
    } else {
      // 알림 OFF: 모든 알림 취소
      await _notificationService.cancelAll();
    }
  }

  /// 특정 요일 설정 업데이트
  Future<void> updateWeekdaySetting(
    int weekday,
    WeekdaySetting setting,
  ) async {
    final updated = state.updateWeekdaySetting(weekday, setting);
    state = updated;

    await _saveSettings(updated);

    // 요일별 알림 재예약
    await _scheduleWeekdayNotifications(updated);
  }

  /// 요일별 알림 예약
  Future<void> _scheduleWeekdayNotifications(
    NotificationSettingsModel settings,
  ) async {
    if (!settings.enabled) {
      print('=== 알림 비활성화 상태, 예약 생략 ===');
      return;
    }

    // 알림 서비스 초기화
    await _notificationService.initialize();

    // 권한 확인 및 요청
    final hasPermission = await _notificationService.requestPermissions();
    if (!hasPermission) {
      print('=== 알림 권한 없음 ===');
      return;
    }

    // 활성화된 요일별 스케줄 생성
    final schedules = <WeekdaySchedule>[];
    for (final entry in settings.weekdaySettings.entries) {
      if (entry.value.enabled) {
        schedules.add(WeekdaySchedule(
          weekday: entry.key,
          hour: entry.value.hour,
          minute: entry.value.minute,
        ));
      }
    }

    if (schedules.isEmpty) {
      print('=== 활성화된 요일 없음, 모든 알림 취소 ===');
      await _notificationService.cancelAll();
      return;
    }

    // 요일별 알림 예약
    await _notificationService.scheduleWeekdayNotifications(
      title: 'V2log',
      body: '오늘 운동할 시간이에요! 💪',
      schedules: schedules,
    );

    print('=== 요일별 알림 예약 완료: ${schedules.length}개 요일 ===');
  }

  /// 테스트 알림 발송
  Future<void> showTestNotification() async {
    await _notificationService.initialize();
    await _notificationService.showTestNotification();
  }
}

/// 알림 설정 Provider
final notificationSettingsProvider =
    StateNotifierProvider<NotificationSettingsNotifier, NotificationSettingsModel>(
  (ref) => NotificationSettingsNotifier(),
);
