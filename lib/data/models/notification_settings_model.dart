/// 요일별 알림 설정
class WeekdaySetting {
  final bool enabled;
  final int hour; // 0-23
  final int minute; // 0-59

  const WeekdaySetting({
    this.enabled = false,
    this.hour = 18,
    this.minute = 0,
  });

  /// JSON 변환
  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'hour': hour,
      'minute': minute,
    };
  }

  /// JSON에서 생성
  factory WeekdaySetting.fromJson(Map<String, dynamic> json) {
    return WeekdaySetting(
      enabled: json['enabled'] as bool? ?? false,
      hour: json['hour'] as int? ?? 18,
      minute: json['minute'] as int? ?? 0,
    );
  }

  /// 복사
  WeekdaySetting copyWith({
    bool? enabled,
    int? hour,
    int? minute,
  }) {
    return WeekdaySetting(
      enabled: enabled ?? this.enabled,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
    );
  }

  /// 시간을 "HH:MM" 형식으로 반환
  String get timeString {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  /// 활성화된 요일인지 확인
  bool get isActive => enabled;
}

/// 알림 설정 모델 (요일별 개별 시간 설정)
class NotificationSettingsModel {
  // 요일별 설정 (1=월 ~ 7=일)
  final Map<int, WeekdaySetting> weekdaySettings;

  NotificationSettingsModel({
    Map<int, WeekdaySetting>? weekdaySettings,
  }) : weekdaySettings = weekdaySettings ?? _defaultSettings();

  /// 기본 설정 (팩토리)
  static Map<int, WeekdaySetting> _defaultSettings() {
    return {
      1: const WeekdaySetting(enabled: true, hour: 18, minute: 0), // 월
      2: const WeekdaySetting(enabled: false), // 화
      3: const WeekdaySetting(enabled: true, hour: 18, minute: 0), // 수
      4: const WeekdaySetting(enabled: false), // 목
      5: const WeekdaySetting(enabled: true, hour: 18, minute: 0), // 금
      6: const WeekdaySetting(enabled: false), // 토
      7: const WeekdaySetting(enabled: false), // 일
    };
  }

  /// 전체 알림 활성화 여부 (하나라도 켜져 있으면 true)
  bool get enabled {
    return weekdaySettings.values.any((setting) => setting.enabled);
  }

  /// 활성화된 요일 리스트
  List<int> get activeWeekdays {
    return weekdaySettings.entries
        .where((e) => e.value.enabled)
        .map((e) => e.key)
        .toList()
      ..sort();
  }

  /// JSON 변환
  Map<String, dynamic> toJson() {
    return {
      'weekdaySettings': weekdaySettings.map(
        (key, value) => MapEntry(key.toString(), value.toJson()),
      ),
    };
  }

  /// JSON에서 생성
  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json) {
    final Map<int, WeekdaySetting> settings = {};

    // 기본값 초기화
    for (int i = 1; i <= 7; i++) {
      settings[i] = const WeekdaySetting();
    }

    // JSON 데이터 로드
    if (json.containsKey('weekdaySettings')) {
      final weekdayData = json['weekdaySettings'] as Map<String, dynamic>;
      for (final entry in weekdayData.entries) {
        final weekday = int.parse(entry.key);
        if (weekday >= 1 && weekday <= 7) {
          settings[weekday] = WeekdaySetting.fromJson(
            entry.value as Map<String, dynamic>,
          );
        }
      }
    } else {
      // 레거시 호환성 (이전 형식 지원)
      final bool legacyEnabled = json['enabled'] as bool? ?? false;
      final int legacyHour = json['hour'] as int? ?? 18;
      final int legacyMinute = json['minute'] as int? ?? 0;
      final List<int> legacyWeekdays =
          (json['weekdays'] as List<dynamic>? ?? [1, 3, 5])
              .map((e) => e as int)
              .toList();

      for (final weekday in legacyWeekdays) {
        if (weekday >= 1 && weekday <= 7) {
          settings[weekday] = WeekdaySetting(
            enabled: legacyEnabled,
            hour: legacyHour,
            minute: legacyMinute,
          );
        }
      }
    }

    return NotificationSettingsModel(weekdaySettings: settings);
  }

  /// 복사
  NotificationSettingsModel copyWith({
    Map<int, WeekdaySetting>? weekdaySettings,
  }) {
    return NotificationSettingsModel(
      weekdaySettings: weekdaySettings ?? this.weekdaySettings,
    );
  }

  /// 특정 요일의 설정 가져오기
  WeekdaySetting getWeekdaySetting(int weekday) {
    return weekdaySettings[weekday] ?? const WeekdaySetting();
  }

  /// 특정 요일의 설정 업데이트
  NotificationSettingsModel updateWeekdaySetting(
    int weekday,
    WeekdaySetting setting,
  ) {
    final newSettings = Map<int, WeekdaySetting>.from(weekdaySettings);
    newSettings[weekday] = setting;
    return NotificationSettingsModel(weekdaySettings: newSettings);
  }

  /// 전체 ON/OFF 토글 (모든 요일을 같은 상태로 변경)
  NotificationSettingsModel toggleAll(bool enabled) {
    final newSettings = <int, WeekdaySetting>{};
    for (final entry in weekdaySettings.entries) {
      newSettings[entry.key] = entry.value.copyWith(enabled: enabled);
    }
    return NotificationSettingsModel(weekdaySettings: newSettings);
  }

  /// 요일 이름 리스트
  static const List<String> weekdayNames = ['월', '화', '수', '목', '금', '토', '일'];
}
