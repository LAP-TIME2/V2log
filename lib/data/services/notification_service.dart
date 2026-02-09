import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

/// 요일별 알림 설정
class WeekdaySchedule {
  final int weekday; // 1(월) ~ 7(일)
  final int hour;
  final int minute;

  const WeekdaySchedule({
    required this.weekday,
    required this.hour,
    required this.minute,
  });
}

/// 푸시 알림 서비스
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  /// 알림 서비스 초기화
  Future<void> initialize() async {
    if (_isInitialized) return;

    print('=== NotificationService 초기화 시작 ===');

    // Timezone 초기화 + 한국 시간대 설정
    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
    print('=== Timezone 초기화 완료 (Asia/Seoul) ===');

    // Android 설정
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // iOS 설정
    const iosSettings = DarwinInitializationSettings(
      requestSoundPermission: false,
      requestAlertPermission: true,
      requestBadgePermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // 알림 콜백 설정
    final result = await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    print('=== NotificationService 초기화 완료: $result ===');

    _isInitialized = true;
  }

  /// 알림 권한 요청
  Future<bool> requestPermissions() async {
    print('=== 알림 권한 요청 시작 ===');

    // Android 권한
    bool androidGranted = true;
    if (Platform.isAndroid) {
      androidGranted = await _notifications
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()
              ?.areNotificationsEnabled() ??
          true;
      print('=== Android 알림 권한: $androidGranted ===');

      if (!androidGranted) {
        androidGranted = await _notifications
                .resolvePlatformSpecificImplementation<
                    AndroidFlutterLocalNotificationsPlugin>()
                ?.requestNotificationsPermission() ??
            false;
        print('=== Android 알림 권한 요청 결과: $androidGranted ===');
      }
    }

    // iOS 권한
    bool iosGranted = true;
    if (Platform.isIOS) {
      iosGranted = await _notifications
              .resolvePlatformSpecificImplementation<
                  IOSFlutterLocalNotificationsPlugin>()
              ?.requestPermissions(
                alert: true,
                badge: true,
                sound: true,
              ) ??
          true;
      print('=== iOS 알림 권한: $iosGranted ===');
    }

    return androidGranted && iosGranted;
  }

  /// 요일별 알림 예약 (각 요일마다 다른 시간)
  Future<void> scheduleWeekdayNotifications({
    required String title,
    required String body,
    required List<WeekdaySchedule> schedules,
  }) async {
    if (!_isInitialized) {
      print('=== 알림 서비스 초기화되지 않음 ===');
      await initialize();
    }

    print('=== 요일별 알림 예약 시작: ${schedules.length}개 요일 ===');

    // Android 알림 상세 설정
    const androidDetails = AndroidNotificationDetails(
      'v2log_workout_reminder',
      '운동 리마인더',
      channelDescription: '매일 운동 알림',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    // iOS 알림 상세 설정
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // 기존 알림 모두 취소 (1~7번 ID는 요일별 알림용)
    for (int i = 1; i <= 7; i++) {
      await _notifications.cancel(i);
    }

    // 각 요일별로 알림 예약
    int successCount = 0;
    for (final schedule in schedules) {
      try {
        // 다음 알림 시간 계산
        final nextTime = _getNextScheduledTimeForWeekday(
          schedule.weekday,
          schedule.hour,
          schedule.minute,
        );
        final nextTimeTZ = tz.TZDateTime.from(nextTime, tz.local);

        // 요일별 반복 알림 예약 (ID = 요일번호 1~7)
        await _notifications.zonedSchedule(
          schedule.weekday, // 요일 번호를 ID로 사용
          title,
          body,
          nextTimeTZ,
          details,
          androidScheduleMode: AndroidScheduleMode.inexact,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        );

        successCount++;
        final durationUntilNext = nextTime.difference(DateTime.now());
        print('=== 알림 예약 성공: 요일=${schedule.weekday}, '
            '시간=${schedule.hour.toString().padLeft(2, '0')}:${schedule.minute.toString().padLeft(2, '0')}, '
            '다음 알림=$nextTime (${durationUntilNext.inHours}시간 후) ===');
      } catch (e) {
        print('=== 알림 예약 실패: 요일=${schedule.weekday}, 에러=$e ===');
      }
    }

    print('=== 요일별 알림 예약 완료: $successCount/${schedules.length}개 성공 ===');
  }

  /// 특정 요일의 다음 알림 시간 계산
  DateTime _getNextScheduledTimeForWeekday(int weekday, int hour, int minute) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day, hour, minute);

    // 오늘이 해당 요일이고, 아직 시간이 안 지났으면 오늘로
    if (now.weekday == weekday && today.isAfter(now)) {
      return today;
    }

    // 이번 주 또는 다음 주의 해당 요일 찾기
    int daysUntilWeekday = weekday - now.weekday;
    if (daysUntilWeekday <= 0) {
      daysUntilWeekday += 7; // 다음 주로
    }

    return now.add(Duration(days: daysUntilWeekday)).copyWith(
      hour: hour,
      minute: minute,
      second: 0,
      millisecond: 0,
      microsecond: 0,
    );
  }

  /// 알림 예약 (레거시 호환성 - 단일 시간 모든 요일)
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    required List<int> weekdays,
  }) async {
    if (!_isInitialized) {
      print('=== 알림 서비스 초기화되지 않음 ===');
      await initialize();
    }

    print('=== 레거시 알림 예약 시작: id=$id, ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} 요일=$weekdays ===');

    // Android 알림 상세 설정
    const androidDetails = AndroidNotificationDetails(
      'v2log_workout_reminder',
      '운동 리마인더',
      channelDescription: '매일 운동 알림',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    // iOS 알림 상세 설정
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // 기존 알림 모두 취소
    await cancelAll();

    // 다음 알림 시간 계산 및 예약
    final nextTime = _getNextScheduledTime(hour, minute, weekdays);
    final nextTimeTZ = tz.TZDateTime.from(nextTime, tz.local);

    // zonedSchedule로 매일 반복 알림 예약
    await _notifications.zonedSchedule(
      id,
      title,
      body,
      nextTimeTZ,
      details,
      androidScheduleMode: AndroidScheduleMode.inexact,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    final durationUntilNext = nextTime.difference(DateTime.now());
    print('=== 알림 예약 성공: id=$id, 시간=$nextTime (${durationUntilNext.inMinutes}분 후) ===');
  }

  /// 다음 알림 시간 계산 (레거시)
  DateTime _getNextScheduledTime(int hour, int minute, List<int> weekdays) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day, hour, minute);

    // 오늘 해당 시간이 아직 안 지났고, 오늘이 요일에 포함되면 오늘로
    if (today.isAfter(now) && weekdays.contains(now.weekday)) {
      return today;
    }

    // 이번 주에 남은 요일 중 가장 가까운 시간 찾기
    for (int daysAhead = 1; daysAhead <= 7; daysAhead++) {
      final checkDate = now.add(Duration(days: daysAhead));
      final scheduledTime = DateTime(
        checkDate.year,
        checkDate.month,
        checkDate.day,
        hour,
        minute,
      );

      if (weekdays.contains(checkDate.weekday)) {
        return scheduledTime;
      }
    }

    // 기본값: 내일
    return today.add(const Duration(days: 1));
  }

  /// 알림 취소
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
    print('=== 알림 취소: id=$id ===');
  }

  /// 모든 알림 취소
  Future<void> cancelAll() async {
    await _notifications.cancelAll();
    print('=== 모든 알림 취소 ===');
  }

  /// 테스트 알림 발송 (즉시)
  Future<void> showTestNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'v2log_workout_reminder',
      '운동 리마인더',
      channelDescription: '매일 운동 알림',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      999, // 테스트용 ID
      'V2log',
      '오늘 운동할 시간이에요! 💪',
      details,
      payload: 'test_notification',
    );

    print('=== 테스트 알림 발송 완료 ===');
  }

  /// 알림 탭 처리
  void _onNotificationTap(NotificationResponse response) {
    print('=== 알림 탭: ${response.payload} ===');
    // 앱 실행됨 - GoRouter로 특정 화면으로 이동 가능
  }
}
