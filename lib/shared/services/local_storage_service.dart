import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'local_storage_service.g.dart';

/// Local Storage 서비스 Provider
@Riverpod(keepAlive: true)
LocalStorageService localStorageService(LocalStorageServiceRef ref) {
  return LocalStorageService();
}

/// SharedPreferences Provider
@Riverpod(keepAlive: true)
Future<SharedPreferences> sharedPreferences(SharedPreferencesRef ref) async {
  return await SharedPreferences.getInstance();
}

/// 로컬 스토리지 서비스
class LocalStorageService {
  // Hive 박스 이름
  static const String _settingsBox = 'settings';
  static const String _cacheBox = 'cache';
  static const String _workoutBox = 'workout';

  // 설정 키
  static const String _keyThemeMode = 'theme_mode';
  static const String _keyOnboardingCompleted = 'onboarding_completed';
  static const String _keyLastUserId = 'last_user_id';
  static const String _keyDefaultRestTime = 'default_rest_time';
  static const String _keyVibrationEnabled = 'vibration_enabled';
  static const String _keySoundEnabled = 'sound_enabled';
  static const String _keyWeightUnit = 'weight_unit';
  static const String _keyLastWorkoutMode = 'last_workout_mode';

  // ==================== Hive ====================

  /// 설정 박스
  Box get _settings => Hive.box(_settingsBox);

  /// 캐시 박스
  Box get _cache => Hive.box(_cacheBox);

  /// 운동 박스 (임시 저장용)
  Future<Box> get _workout async {
    if (!Hive.isBoxOpen(_workoutBox)) {
      return await Hive.openBox(_workoutBox);
    }
    return Hive.box(_workoutBox);
  }

  // ==================== Settings ====================

  /// 테마 모드 (dark, light, system)
  String get themeMode => _settings.get(_keyThemeMode, defaultValue: 'dark');
  set themeMode(String value) => _settings.put(_keyThemeMode, value);

  /// 온보딩 완료 여부
  bool get onboardingCompleted =>
      _settings.get(_keyOnboardingCompleted, defaultValue: false);
  set onboardingCompleted(bool value) =>
      _settings.put(_keyOnboardingCompleted, value);

  /// 마지막 로그인 사용자 ID
  String? get lastUserId => _settings.get(_keyLastUserId);
  set lastUserId(String? value) => _settings.put(_keyLastUserId, value);

  /// 기본 휴식 시간 (초)
  int get defaultRestTime =>
      _settings.get(_keyDefaultRestTime, defaultValue: 90);
  set defaultRestTime(int value) => _settings.put(_keyDefaultRestTime, value);

  /// 진동 활성화
  bool get vibrationEnabled =>
      _settings.get(_keyVibrationEnabled, defaultValue: true);
  set vibrationEnabled(bool value) =>
      _settings.put(_keyVibrationEnabled, value);

  /// 사운드 활성화
  bool get soundEnabled => _settings.get(_keySoundEnabled, defaultValue: true);
  set soundEnabled(bool value) => _settings.put(_keySoundEnabled, value);

  /// 무게 단위 (kg, lb)
  String get weightUnit => _settings.get(_keyWeightUnit, defaultValue: 'kg');
  set weightUnit(String value) => _settings.put(_keyWeightUnit, value);

  /// 마지막 운동 모드
  String get lastWorkoutMode =>
      _settings.get(_keyLastWorkoutMode, defaultValue: 'free');
  set lastWorkoutMode(String value) =>
      _settings.put(_keyLastWorkoutMode, value);

  // ==================== Cache ====================

  /// 캐시 저장
  Future<void> setCache(String key, dynamic value, {Duration? expiry}) async {
    final data = {
      'value': value,
      'expiry': expiry != null
          ? DateTime.now().add(expiry).millisecondsSinceEpoch
          : null,
    };
    await _cache.put(key, data);
  }

  /// 캐시 가져오기
  T? getCache<T>(String key) {
    final data = _cache.get(key);
    if (data == null) return null;

    final expiry = data['expiry'] as int?;
    if (expiry != null && DateTime.now().millisecondsSinceEpoch > expiry) {
      _cache.delete(key);
      return null;
    }

    return data['value'] as T?;
  }

  /// 캐시 삭제
  Future<void> deleteCache(String key) async {
    await _cache.delete(key);
  }

  /// 모든 캐시 삭제
  Future<void> clearCache() async {
    await _cache.clear();
  }

  // ==================== Workout (임시 저장) ====================

  /// 진행 중인 운동 세션 저장
  Future<void> saveWorkoutSession(Map<String, dynamic> session) async {
    final box = await _workout;
    await box.put('current_session', session);
  }

  /// 진행 중인 운동 세션 불러오기
  Future<Map<String, dynamic>?> getWorkoutSession() async {
    final box = await _workout;
    final data = box.get('current_session');
    if (data == null) return null;
    return Map<String, dynamic>.from(data);
  }

  /// 진행 중인 운동 세션 삭제
  Future<void> clearWorkoutSession() async {
    final box = await _workout;
    await box.delete('current_session');
  }

  /// 운동별 마지막 무게/횟수 저장
  Future<void> saveLastSet(
    String userId,
    String exerciseId,
    double weight,
    int reps,
  ) async {
    final box = await _workout;
    final key = 'last_set_${userId}_$exerciseId';
    await box.put(key, {'weight': weight, 'reps': reps});
  }

  /// 운동별 마지막 무게/횟수 불러오기
  Future<Map<String, dynamic>?> getLastSet(
    String userId,
    String exerciseId,
  ) async {
    final box = await _workout;
    final key = 'last_set_${userId}_$exerciseId';
    final data = box.get(key);
    if (data == null) return null;
    return Map<String, dynamic>.from(data);
  }

  // ==================== Utility ====================

  /// 모든 데이터 삭제 (로그아웃 시)
  Future<void> clearAll() async {
    await _settings.clear();
    await _cache.clear();
    final box = await _workout;
    await box.clear();
  }

  /// 사용자 데이터만 삭제
  Future<void> clearUserData() async {
    lastUserId = null;
    await _cache.clear();
    final box = await _workout;
    await box.clear();
  }
}
