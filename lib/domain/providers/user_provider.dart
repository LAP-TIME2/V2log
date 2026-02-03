import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/user_model.dart';
import '../../data/services/supabase_service.dart';
import 'auth_provider.dart';

part 'user_provider.g.dart';

/// 현재 사용자 Provider (Auth에서 파생)
@riverpod
UserModel? currentUser(CurrentUserRef ref) {
  return ref.watch(authProvider).valueOrNull;
}

/// 사용자 프로필 업데이트 Provider
@riverpod
class UserProfile extends _$UserProfile {
  @override
  FutureOr<void> build() {}

  /// 프로필 업데이트
  Future<void> updateProfile({
    String? nickname,
    String? profileImageUrl,
    Gender? gender,
    DateTime? birthDate,
    double? height,
    double? weight,
    ExperienceLevel? experienceLevel,
    FitnessGoal? fitnessGoal,
    PreferredMode? preferredMode,
  }) async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) throw Exception('로그인이 필요합니다');

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final supabase = ref.read(supabaseServiceProvider);
      final updates = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (nickname != null) updates['nickname'] = nickname;
      if (profileImageUrl != null) {
        updates['profile_image_url'] = profileImageUrl;
      }
      if (gender != null) updates['gender'] = gender.value;
      if (birthDate != null) {
        updates['birth_date'] = birthDate.toIso8601String().split('T')[0];
      }
      if (height != null) updates['height'] = height;
      if (weight != null) updates['weight'] = weight;
      if (experienceLevel != null) {
        updates['experience_level'] = experienceLevel.value;
      }
      if (fitnessGoal != null) updates['fitness_goal'] = fitnessGoal.value;
      if (preferredMode != null) {
        updates['preferred_mode'] = preferredMode.value;
      }

      await supabase
          .from(SupabaseTables.users)
          .update(updates)
          .eq('id', userId);

      // Auth Provider 새로고침
      await ref.read(authProvider.notifier).refresh();
    });
  }

  /// 프로필 이미지 업로드
  Future<String> uploadProfileImage(Uint8List imageBytes) async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) throw Exception('로그인이 필요합니다');

    final supabase = ref.read(supabaseServiceProvider);
    final path = '$userId/profile.jpg';

    final url = await supabase.uploadFile(
      bucket: SupabaseBuckets.avatars,
      path: path,
      fileBytes: imageBytes,
      contentType: 'image/jpeg',
    );

    await updateProfile(profileImageUrl: url);

    return url;
  }

  /// 온보딩 정보 저장
  Future<void> completeOnboarding({
    required Gender gender,
    required DateTime birthDate,
    required double height,
    required double weight,
    required ExperienceLevel experienceLevel,
    required FitnessGoal fitnessGoal,
  }) async {
    await updateProfile(
      gender: gender,
      birthDate: birthDate,
      height: height,
      weight: weight,
      experienceLevel: experienceLevel,
      fitnessGoal: fitnessGoal,
    );
  }
}

/// 사용자 통계 Provider
@riverpod
Future<UserStats> userStats(UserStatsRef ref) async {
  final userId = ref.watch(currentUserIdProvider);

  // 로그인하지 않은 경우 빈 통계 반환
  if (userId == null) {
    return const UserStats(
      totalWorkouts: 0,
      totalVolume: 0,
      totalDuration: Duration.zero,
      currentStreak: 0,
      longestStreak: 0,
    );
  }

  try {
    final supabase = ref.read(supabaseServiceProvider);

    // 총 운동 횟수
    final sessionsResponse = await supabase
        .from(SupabaseTables.workoutSessions)
        .select('id, total_volume, total_duration_seconds')
        .eq('user_id', userId)
        .eq('is_cancelled', false)
        .not('finished_at', 'is', null);

    final sessions = sessionsResponse as List;

    final totalWorkouts = sessions.length;
    final totalVolume = sessions.fold<double>(
      0,
      (sum, s) => sum + (s['total_volume'] as num? ?? 0).toDouble(),
    );
    final totalDurationSeconds = sessions.fold<int>(
      0,
      (sum, s) => sum + (s['total_duration_seconds'] as int? ?? 0),
    );

    // TODO: 연속 운동 일수 계산 (스트릭)

    return UserStats(
      totalWorkouts: totalWorkouts,
      totalVolume: totalVolume,
      totalDuration: Duration(seconds: totalDurationSeconds),
      currentStreak: 0,
      longestStreak: 0,
    );
  } catch (e) {
    // Supabase 연결 실패 시 빈 통계 반환
    return const UserStats(
      totalWorkouts: 0,
      totalVolume: 0,
      totalDuration: Duration.zero,
      currentStreak: 0,
      longestStreak: 0,
    );
  }
}

/// 사용자 통계 모델
class UserStats {
  final int totalWorkouts;
  final double totalVolume;
  final Duration totalDuration;
  final int currentStreak;
  final int longestStreak;

  const UserStats({
    required this.totalWorkouts,
    required this.totalVolume,
    required this.totalDuration,
    required this.currentStreak,
    required this.longestStreak,
  });
}

/// 이번 주 통계 Provider
@riverpod
Future<WeeklyStats> weeklyStats(WeeklyStatsRef ref) async {
  final userId = ref.watch(currentUserIdProvider);

  // 로그인하지 않은 경우 빈 통계 반환
  if (userId == null) {
    return const WeeklyStats(
      workoutCount: 0,
      totalVolume: 0,
      totalDuration: Duration.zero,
      workoutDates: [],
    );
  }

  try {
    final supabase = ref.read(supabaseServiceProvider);

    // 이번 주 시작일 (월요일)
    final now = DateTime.now();
    final weekday = now.weekday;
    final startOfWeek = DateTime(now.year, now.month, now.day - (weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 7));

    final response = await supabase
        .from(SupabaseTables.workoutSessions)
        .select('id, total_volume, total_duration_seconds, started_at')
        .eq('user_id', userId)
        .eq('is_cancelled', false)
        .not('finished_at', 'is', null)
        .gte('started_at', startOfWeek.toIso8601String())
        .lt('started_at', endOfWeek.toIso8601String());

    final sessions = response as List;

    final workoutCount = sessions.length;
    final totalVolume = sessions.fold<double>(
      0,
      (sum, s) => sum + (s['total_volume'] as num? ?? 0).toDouble(),
    );
    final totalDurationSeconds = sessions.fold<int>(
      0,
      (sum, s) => sum + (s['total_duration_seconds'] as int? ?? 0),
    );

    final workoutDates = sessions
        .map((s) => DateTime.parse(s['started_at'] as String))
        .map((d) => DateTime(d.year, d.month, d.day))
        .toSet()
        .toList();

    return WeeklyStats(
      workoutCount: workoutCount,
      totalVolume: totalVolume,
      totalDuration: Duration(seconds: totalDurationSeconds),
      workoutDates: workoutDates,
    );
  } catch (e) {
    // Supabase 연결 실패 시 빈 통계 반환
    debugPrint('weeklyStats 조회 실패: $e');
    return const WeeklyStats(
      workoutCount: 0,
      totalVolume: 0,
      totalDuration: Duration.zero,
      workoutDates: [],
    );
  }
}

/// 이번 주 통계 모델
class WeeklyStats {
  final int workoutCount;
  final double totalVolume;
  final Duration totalDuration;
  final List<DateTime> workoutDates;

  const WeeklyStats({
    required this.workoutCount,
    required this.totalVolume,
    required this.totalDuration,
    required this.workoutDates,
  });
}
