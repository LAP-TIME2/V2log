import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:v2log/core/utils/haptic_feedback.dart';
import 'package:v2log/shared/services/local_storage_service.dart';

part 'timer_provider.g.dart';

/// 휴식 타이머 Provider
@Riverpod(keepAlive: true)
class RestTimer extends _$RestTimer {
  Timer? _timer;
  bool _isPaused = false;

  @override
  RestTimerState build() {
    ref.onDispose(() {
      _timer?.cancel();
    });

    final defaultRestTime =
        ref.watch(localStorageServiceProvider).defaultRestTime;

    return RestTimerState(
      remainingSeconds: 0,
      totalSeconds: defaultRestTime,
      isRunning: false,
      isPaused: false,
    );
  }

  /// 타이머 시작
  void start([int? seconds]) {
    _timer?.cancel();

    final totalSeconds =
        seconds ?? ref.read(localStorageServiceProvider).defaultRestTime;

    state = state.copyWith(
      remainingSeconds: totalSeconds,
      totalSeconds: totalSeconds,
      isRunning: true,
      isPaused: false,
    );
    _isPaused = false;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_isPaused) return;

      if (state.remainingSeconds > 0) {
        state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);

        // 10초 남았을 때 알림
        if (state.remainingSeconds == 10) {
          _onTenSecondsLeft();
        }
      } else {
        _onTimerComplete();
      }
    });
  }

  /// 타이머 일시정지
  void pause() {
    if (!state.isRunning) return;
    _isPaused = true;
    state = state.copyWith(isPaused: true);
  }

  /// 타이머 재개
  void resume() {
    if (!state.isRunning || !state.isPaused) return;
    _isPaused = false;
    state = state.copyWith(isPaused: false);
  }

  /// 타이머 정지
  void stop() {
    _timer?.cancel();
    _timer = null;
    _isPaused = false;

    state = state.copyWith(
      remainingSeconds: 0,
      isRunning: false,
      isPaused: false,
    );
  }

  /// 타이머 건너뛰기
  void skip() {
    stop();
    AppHaptics.lightImpact();
  }

  /// 시간 추가
  void addTime(int seconds) {
    final newRemaining = state.remainingSeconds + seconds;
    if (newRemaining < 0) {
      skip();
      return;
    }

    state = state.copyWith(
      remainingSeconds: newRemaining,
      totalSeconds: state.totalSeconds + seconds,
    );

    AppHaptics.lightImpact();
  }

  /// 시간 설정
  void setTime(int seconds) {
    if (state.isRunning) {
      state = state.copyWith(
        remainingSeconds: seconds,
        totalSeconds: seconds,
      );
    } else {
      start(seconds);
    }
  }

  void _onTenSecondsLeft() {
    // 10초 남았을 때 진동
    if (ref.read(localStorageServiceProvider).vibrationEnabled) {
      AppHaptics.lightImpact();
    }
  }

  void _onTimerComplete() {
    _timer?.cancel();
    _timer = null;

    state = state.copyWith(
      remainingSeconds: 0,
      isRunning: false,
      isPaused: false,
    );

    // 완료 진동
    if (ref.read(localStorageServiceProvider).vibrationEnabled) {
      AppHaptics.warning();
    }

    // TODO: 사운드 알림
  }
}

/// 휴식 타이머 상태
class RestTimerState {
  final int remainingSeconds;
  final int totalSeconds;
  final bool isRunning;
  final bool isPaused;

  const RestTimerState({
    required this.remainingSeconds,
    required this.totalSeconds,
    required this.isRunning,
    required this.isPaused,
  });

  RestTimerState copyWith({
    int? remainingSeconds,
    int? totalSeconds,
    bool? isRunning,
    bool? isPaused,
  }) {
    return RestTimerState(
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      isRunning: isRunning ?? this.isRunning,
      isPaused: isPaused ?? this.isPaused,
    );
  }

  /// 진행률 (0.0 ~ 1.0)
  double get progress {
    if (totalSeconds == 0) return 0;
    return remainingSeconds / totalSeconds;
  }

  /// 포맷된 시간 (MM:SS)
  String get formattedTime {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

/// 운동 세션 타이머 (총 운동 시간)
@Riverpod(keepAlive: true)
class WorkoutTimer extends _$WorkoutTimer {
  Timer? _timer;
  DateTime? _startTime;

  @override
  int build() {
    ref.onDispose(() {
      _timer?.cancel();
    });
    return 0;
  }

  /// 타이머 시작
  void start() {
    _startTime = DateTime.now();
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_startTime != null) {
        state = DateTime.now().difference(_startTime!).inSeconds;
      }
    });
  }

  /// 특정 시간부터 시작 (세션 복구 시)
  void startFrom(DateTime startTime) {
    _startTime = startTime;
    state = DateTime.now().difference(_startTime!).inSeconds;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_startTime != null) {
        state = DateTime.now().difference(_startTime!).inSeconds;
      }
    });
  }

  /// 타이머 정지
  void stop() {
    _timer?.cancel();
    _timer = null;
    _startTime = null;
    state = 0;
  }

  /// 포맷된 시간
  String get formattedTime {
    final hours = state ~/ 3600;
    final minutes = (state % 3600) ~/ 60;
    final seconds = state % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
