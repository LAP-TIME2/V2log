import 'package:intl/intl.dart';

/// 포맷터 유틸리티
class Formatters {
  Formatters._();

  // 날짜 포맷터
  static final _dateFormat = DateFormat('yyyy.MM.dd');
  static final _dateTimeFormat = DateFormat('yyyy.MM.dd HH:mm');
  static final _timeFormat = DateFormat('HH:mm');
  static final _monthDayFormat = DateFormat('M월 d일');
  static final _yearMonthFormat = DateFormat('yyyy년 M월');
  static final _weekdayFormat = DateFormat('EEEE', 'ko_KR');
  static final _shortWeekdayFormat = DateFormat('E', 'ko_KR');

  /// 날짜 포맷 (yyyy.MM.dd)
  static String date(DateTime date) => _dateFormat.format(date);

  /// 날짜 및 시간 포맷 (yyyy.MM.dd HH:mm)
  static String dateTime(DateTime dateTime) => _dateTimeFormat.format(dateTime);

  /// 시간 포맷 (HH:mm)
  static String time(DateTime dateTime) => _timeFormat.format(dateTime);

  /// 월일 포맷 (M월 d일)
  static String monthDay(DateTime date) => _monthDayFormat.format(date);

  /// 연월 포맷 (yyyy년 M월)
  static String yearMonth(DateTime date) => _yearMonthFormat.format(date);

  /// 요일 포맷 (월요일, 화요일...)
  static String weekday(DateTime date) => _weekdayFormat.format(date);

  /// 짧은 요일 포맷 (월, 화...)
  static String shortWeekday(DateTime date) => _shortWeekdayFormat.format(date);

  /// 상대적 날짜 (오늘, 어제, 그저께, N일 전)
  static String relativeDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(date.year, date.month, date.day);
    final difference = today.difference(targetDate).inDays;

    if (difference == 0) return '오늘';
    if (difference == 1) return '어제';
    if (difference == 2) return '그저께';
    if (difference <= 7) return '$difference일 전';
    return _dateFormat.format(date);
  }

  /// 운동 시간 포맷 (1시간 30분)
  static String duration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0 && minutes > 0) {
      return '$hours시간 $minutes분';
    } else if (hours > 0) {
      return '$hours시간';
    } else {
      return '$minutes분';
    }
  }

  /// 운동 시간 포맷 (컴팩트: 4h 32m)
  static String durationCompact(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0 && minutes > 0) {
      return '${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h';
    } else {
      return '${minutes}m';
    }
  }

  /// 타이머 포맷 (MM:SS)
  static String timer(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  /// 타이머 포맷 (HH:MM:SS)
  static String timerLong(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  /// 무게 포맷 (소수점 이하 불필요한 0 제거)
  static String weight(double weight) {
    if (weight == weight.roundToDouble()) {
      return '${weight.toInt()}kg';
    }
    return '${weight.toStringAsFixed(1)}kg';
  }

  /// 횟수 포맷
  static String reps(int reps) => '$reps회';

  /// 세트 포맷
  static String sets(int sets) => '$sets세트';

  /// 볼륨 포맷 (천 단위 쉼표)
  static String volume(double volume) {
    final formatter = NumberFormat('#,###.#');
    return '${formatter.format(volume)}kg';
  }

  /// 칼로리 포맷
  static String calories(int calories) {
    final formatter = NumberFormat('#,###');
    return '${formatter.format(calories)}kcal';
  }

  /// 퍼센트 포맷
  static String percent(double value, {int decimals = 0}) {
    return '${value.toStringAsFixed(decimals)}%';
  }

  /// 1RM 포맷
  static String oneRepMax(double value) {
    if (value == value.roundToDouble()) {
      return '${value.toInt()}kg';
    }
    return '${value.toStringAsFixed(1)}kg';
  }

  /// 신장 포맷
  static String height(double cm) {
    return '${cm.toStringAsFixed(0)}cm';
  }

  /// 체중 포맷
  static String bodyWeight(double kg) {
    if (kg == kg.roundToDouble()) {
      return '${kg.toInt()}kg';
    }
    return '${kg.toStringAsFixed(1)}kg';
  }

  /// 숫자 포맷 (천 단위 쉼표, 반올림 지원)
  static String number(num value, {int decimals = 0, bool round = false}) {
    final num workingValue = round ? value.round().toDouble() : value;
    final formatter = decimals > 0
        ? NumberFormat('#,###.${'0' * decimals}')
        : NumberFormat('#,###');
    return formatter.format(workingValue);
  }

  /// 운동 회차 포맷 (N회차)
  static String sessionNumber(int number) => '$number회차';
}
