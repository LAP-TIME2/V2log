import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/constants/app_colors.dart';
import '../../data/models/user_model.dart';
import '../../data/models/exercise_model.dart';
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

    print('=== weeklyStats 조회: userId=$userId, 기간=${startOfWeek.toIso8601String()} ~ ${endOfWeek.toIso8601String()} ===');

    final response = await supabase
        .from(SupabaseTables.workoutSessions)
        .select('id, total_volume, total_duration_seconds, started_at')
        .eq('user_id', userId)
        .eq('is_cancelled', false)
        .not('finished_at', 'is', null)
        .gte('started_at', startOfWeek.toIso8601String())
        .lt('started_at', endOfWeek.toIso8601String());

    final sessions = response as List;
    print('=== weeklyStats 결과: ${sessions.length}건 ===');

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
    print('=== weeklyStats 조회 실패: $e ===');
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

/// 일별 볼륨 데이터 모델
class DailyVolume {
  final DateTime date;
  final double volume;

  const DailyVolume({
    required this.date,
    required this.volume,
  });
}

/// 일별 볼륨 Provider (최근 7일)
@riverpod
Future<List<DailyVolume>> dailyVolumes(DailyVolumesRef ref) async {
  final userId = ref.watch(currentUserIdProvider);

  // 로그인하지 않은 경우 빈 데이터 반환
  if (userId == null) {
    return const [];
  }

  try {
    final supabase = ref.read(supabaseServiceProvider);

    // 최근 7일 시작일 계산
    final now = DateTime.now();
    final sevenDaysAgo = DateTime(now.year, now.month, now.day - 6);

    print('=== dailyVolumes 조회: userId=$userId, 기간=${sevenDaysAgo.toIso8601String()} ~ ${now.toIso8601String()} ===');

    final response = await supabase
        .from(SupabaseTables.workoutSessions)
        .select('id, total_volume, started_at')
        .eq('user_id', userId)
        .eq('is_cancelled', false)
        .not('finished_at', 'is', null)
        .gte('started_at', sevenDaysAgo.toIso8601String());

    final sessions = response as List;
    print('=== dailyVolumes 결과: ${sessions.length}건 ===');

    // 날짜별 볼륨 집계
    final Map<DateTime, double> volumeByDate = {};
    for (int i = 0; i < 7; i++) {
      final date = DateTime(now.year, now.month, now.day - i);
      volumeByDate[date] = 0.0;
    }

    for (final session in sessions) {
      final startedAt = DateTime.parse(session['started_at'] as String);
      final date = DateTime(startedAt.year, startedAt.month, startedAt.day);
      final volume = (session['total_volume'] as num? ?? 0).toDouble();
      volumeByDate[date] = (volumeByDate[date] ?? 0) + volume;
    }

    // 최근 7일 데이터 정렬
    final result = volumeByDate.entries
        .map((e) => DailyVolume(date: e.key, volume: e.value))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    return result;
  } catch (e) {
    print('=== dailyVolumes 조회 실패: $e ===');
    return const [];
  }
}

/// 월별 볼륨 데이터 모델
class MonthlyVolume {
  final String monthLabel; // e.g., "12월", "1월", "2월"
  final double volume;

  const MonthlyVolume({
    required this.monthLabel,
    required this.volume,
  });
}

/// 월간 볼륨 Provider (최근 3개월)
@riverpod
Future<List<MonthlyVolume>> monthlyVolumes(MonthlyVolumesRef ref) async {
  final userId = ref.watch(currentUserIdProvider);

  // 로그인하지 않은 경우 빈 데이터 반환
  if (userId == null) {
    return const [];
  }

  try {
    final supabase = ref.read(supabaseServiceProvider);

    // 최근 3개월 시작일 계산 (현재월 포함)
    final now = DateTime.now();
    final threeMonthsAgo = DateTime(now.year, now.month - 2, 1);

    print('=== monthlyVolumes 조회: userId=$userId, 기간=${threeMonthsAgo.toIso8601String()} ~ ${now.toIso8601String()} ===');

    final response = await supabase
        .from(SupabaseTables.workoutSessions)
        .select('id, total_volume, started_at')
        .eq('user_id', userId)
        .eq('is_cancelled', false)
        .not('finished_at', 'is', null)
        .gte('started_at', threeMonthsAgo.toIso8601String());

    final sessions = response as List;
    print('=== monthlyVolumes 결과: ${sessions.length}건 ===');

    // 월별 볼륨 집계
    final Map<String, double> volumeByMonth = {};

    // 최근 3개월 (이번 달, 지난달, 지난지난달)
    for (int i = 0; i < 3; i++) {
      final month = DateTime(now.year, now.month - i, 1);
      final monthLabel = '${month.month}월';
      volumeByMonth[monthLabel] = 0.0;
    }

    for (final session in sessions) {
      final startedAt = DateTime.parse(session['started_at'] as String);
      final month = DateTime(startedAt.year, startedAt.month, 1);
      final monthLabel = '${month.month}월';
      final volume = (session['total_volume'] as num? ?? 0).toDouble();

      if (volumeByMonth.containsKey(monthLabel)) {
        volumeByMonth[monthLabel] = (volumeByMonth[monthLabel] ?? 0) + volume;
      }
    }

    // 월별 순서 정렬 (오래순: 12월, 1월, 2월)
    final sortedMonths = volumeByMonth.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    final result = sortedMonths
        .map((e) => MonthlyVolume(monthLabel: e.key, volume: e.value))
        .toList();

    return result;
  } catch (e) {
    print('=== monthlyVolumes 조회 실패: $e ===');
    return const [];
  }
}

/// 부위별 일별 볼륨 데이터 모델
class MuscleDailyVolume {
  final DateTime date;
  final Map<MuscleGroup, double> volumeByMuscle;

  const MuscleDailyVolume({
    required this.date,
    required this.volumeByMuscle,
  });
}

/// 부위별 일별 볼륨 Provider (최근 7일)
/// workout_sets와 exercises를 JOIN해서 primary_muscle로 부위 구분
@riverpod
Future<List<MuscleDailyVolume>> muscleDailyVolumes(MuscleDailyVolumesRef ref) async {
  final userId = ref.watch(currentUserIdProvider);

  // 로그인하지 않은 경우 빈 데이터 반환
  if (userId == null) {
    return const [];
  }

  try {
    final supabase = ref.read(supabaseServiceProvider);

    // 최근 7일 시작일 계산
    final now = DateTime.now();
    final sevenDaysAgo = DateTime(now.year, now.month, now.day - 6);

    print('=== muscleDailyVolumes 조회: userId=$userId, 기간=${sevenDaysAgo.toIso8601String()} ~ ${now.toIso8601String()} ===');

    // workout_sessions + workout_sets + exercises JOIN
    final response = await supabase
        .from(SupabaseTables.workoutSessions)
        .select('''
          id,
          started_at,
          workout_sets (
            weight,
            reps,
            exercises (
              primary_muscle
            )
          )
        ''')
        .eq('user_id', userId)
        .eq('is_cancelled', false)
        .not('finished_at', 'is', null)
        .gte('started_at', sevenDaysAgo.toIso8601String())
        .order('started_at');

    final sessions = response as List;
    print('=== muscleDailyVolumes 결과: ${sessions.length}건 ===');

    // 날짜별 부위별 볼륨 집계
    final Map<DateTime, Map<MuscleGroup, double>> volumeByDateAndMuscle = {};

    // 최근 7일 빈 데이터 생성
    for (int i = 0; i < 7; i++) {
      final date = DateTime(now.year, now.month, now.day - i);
      volumeByDateAndMuscle[date] = {
        MuscleGroup.chest: 0.0,
        MuscleGroup.back: 0.0,
        MuscleGroup.shoulders: 0.0,
        MuscleGroup.quadriceps: 0.0,
        MuscleGroup.biceps: 0.0,
        MuscleGroup.triceps: 0.0,
        MuscleGroup.core: 0.0,
      };
    }

    // 세트 데이터 집계
    for (final session in sessions) {
      final startedAt = DateTime.parse(session['started_at'] as String);
      final date = DateTime(startedAt.year, startedAt.month, startedAt.day);
      final sets = session['workout_sets'] as List? ?? [];

      for (final set in sets) {
        final weight = (set['weight'] as num?)?.toDouble() ?? 0.0;
        final reps = (set['reps'] as num?)?.toInt() ?? 0;
        final exercise = set['exercises'] as Map?;
        final primaryMuscleStr = exercise?['primary_muscle'] as String?;

        if (primaryMuscleStr != null) {
          final muscle = MuscleGroup.values.firstWhere(
            (m) => m.value == primaryMuscleStr,
            orElse: () => MuscleGroup.fullBody,
          );

          // 볼륨 계산 (무게 x 반복)
          final volume = weight * reps;
          volumeByDateAndMuscle[date]?[muscle] =
              (volumeByDateAndMuscle[date]?[muscle] ?? 0.0) + volume;
        }
      }
    }

    // 결과 변환 및 정렬
    final result = volumeByDateAndMuscle.entries
        .map((e) => MuscleDailyVolume(
              date: e.key,
              volumeByMuscle: e.value,
            ))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    return result;
  } catch (e) {
    print('=== muscleDailyVolumes 조회 실패: $e ===');
    return const [];
  }
}

/// 부위별 월별 볼륨 데이터 모델
class MuscleMonthlyVolume {
  final String monthLabel;
  final Map<MuscleGroup, double> volumeByMuscle;

  const MuscleMonthlyVolume({
    required this.monthLabel,
    required this.volumeByMuscle,
  });
}

/// 부위별 월간 볼륨 Provider (최근 3개월)
@riverpod
Future<List<MuscleMonthlyVolume>> muscleMonthlyVolumes(MuscleMonthlyVolumesRef ref) async {
  final userId = ref.watch(currentUserIdProvider);

  // 로그인하지 않은 경우 빈 데이터 반환
  if (userId == null) {
    return const [];
  }

  try {
    final supabase = ref.read(supabaseServiceProvider);

    // 최근 3개월 시작일 계산
    final now = DateTime.now();
    final threeMonthsAgo = DateTime(now.year, now.month - 2, 1);

    print('=== muscleMonthlyVolumes 조회: userId=$userId, 기간=${threeMonthsAgo.toIso8601String()} ~ ${now.toIso8601String()} ===');

    // workout_sessions + workout_sets + exercises JOIN
    final response = await supabase
        .from(SupabaseTables.workoutSessions)
        .select('''
          id,
          started_at,
          workout_sets (
            weight,
            reps,
            exercises (
              primary_muscle
            )
          )
        ''')
        .eq('user_id', userId)
        .eq('is_cancelled', false)
        .not('finished_at', 'is', null)
        .gte('started_at', threeMonthsAgo.toIso8601String())
        .order('started_at');

    final sessions = response as List;
    print('=== muscleMonthlyVolumes 결과: ${sessions.length}건 ===');

    // 월별 부위별 볼륨 집계
    final Map<String, Map<MuscleGroup, double>> volumeByMonthAndMuscle = {};

    // 최근 3개월 빈 데이터 생성
    for (int i = 0; i < 3; i++) {
      final month = DateTime(now.year, now.month - i, 1);
      final monthLabel = '${month.month}월';
      volumeByMonthAndMuscle[monthLabel] = {
        MuscleGroup.chest: 0.0,
        MuscleGroup.back: 0.0,
        MuscleGroup.shoulders: 0.0,
        MuscleGroup.quadriceps: 0.0,
        MuscleGroup.biceps: 0.0,
        MuscleGroup.triceps: 0.0,
        MuscleGroup.core: 0.0,
      };
    }

    // 세트 데이터 집계
    for (final session in sessions) {
      final startedAt = DateTime.parse(session['started_at'] as String);
      final month = DateTime(startedAt.year, startedAt.month, 1);
      final monthLabel = '${month.month}월';
      final sets = session['workout_sets'] as List? ?? [];

      for (final set in sets) {
        final weight = (set['weight'] as num?)?.toDouble() ?? 0.0;
        final reps = (set['reps'] as num?)?.toInt() ?? 0;
        final exercise = set['exercises'] as Map?;
        final primaryMuscleStr = exercise?['primary_muscle'] as String?;

        if (primaryMuscleStr != null) {
          final muscle = MuscleGroup.values.firstWhere(
            (m) => m.value == primaryMuscleStr,
            orElse: () => MuscleGroup.fullBody,
          );

          // 볼륨 계산 (무게 x 반복)
          final volume = weight * reps;

          if (volumeByMonthAndMuscle.containsKey(monthLabel)) {
            volumeByMonthAndMuscle[monthLabel]?[muscle] =
                (volumeByMonthAndMuscle[monthLabel]?[muscle] ?? 0.0) + volume;
          }
        }
      }
    }

    // 결과 변환 및 정렬
    final sortedMonths = volumeByMonthAndMuscle.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    final result = sortedMonths
        .map((e) => MuscleMonthlyVolume(
              monthLabel: e.key,
              volumeByMuscle: e.value,
            ))
        .toList();

    return result;
  } catch (e) {
    print('=== muscleMonthlyVolumes 조회 실패: $e ===');
    return const [];
  }
}

/// 1RM 추이 데이터 모델
class Exercise1RMRecord {
  final DateTime date;
  final double estimated1RM;

  const Exercise1RMRecord({
    required this.date,
    required this.estimated1RM,
  });
}

/// 운동별 1RM 추이 Provider (최근 6개월, 월간)
@riverpod
Future<List<Exercise1RMRecord>> exercise1RMHistory(
  Exercise1RMHistoryRef ref,
  String exerciseName,
) async {
  final userId = ref.watch(currentUserIdProvider);

  // 로그인하지 않은 경우 빈 데이터 반환
  if (userId == null) {
    return const [];
  }

  try {
    final supabase = ref.read(supabaseServiceProvider);

    // 최근 6개월 시작일 계산
    final now = DateTime.now();
    final sixMonthsAgo = DateTime(now.year, now.month - 5, 1);

    print('=== exercise1RMHistory 조회: userId=$userId, exercise=$exerciseName, 기간=${sixMonthsAgo.toIso8601String()} ~ ${now.toIso8601String()} ===');

    // workout_sessions + workout_sets + exercises JOIN
    final response = await supabase
        .from(SupabaseTables.workoutSessions)
        .select('''
          id,
          started_at,
          workout_sets (
            weight,
            reps,
            exercises (
              name
            )
          )
        ''')
        .eq('user_id', userId)
        .eq('is_cancelled', false)
        .not('finished_at', 'is', null)
        .gte('started_at', sixMonthsAgo.toIso8601String())
        .order('started_at');

    final sessions = response as List;
    print('=== exercise1RMHistory 결과: ${sessions.length}건 ===');

    // 월별 최대 1RM 추적
    final Map<DateTime, double> max1RMByMonth = {};

    // 최근 6개월 빈 데이터 생성
    for (int i = 0; i < 6; i++) {
      final month = DateTime(now.year, now.month - i, 1);
      max1RMByMonth[month] = 0.0;
    }

    for (final session in sessions) {
      final startedAt = DateTime.parse(session['started_at'] as String);
      final month = DateTime(startedAt.year, startedAt.month, 1);
      final sets = session['workout_sets'] as List? ?? [];

      for (final set in sets) {
        final exercise = set['exercises'] as Map?;
        final name = exercise?['name'] as String?;

        // 운동명 필터링 (부분 일치)
        if (name != null && name.contains(exerciseName)) {
          final weight = (set['weight'] as num?)?.toDouble() ?? 0.0;
          final reps = (set['reps'] as num?)?.toInt() ?? 0;

          if (weight > 0 && reps > 0) {
            // 1RM 계산 (Epley 공식: weight * (1 + reps / 30))
            final estimated1RM = weight * (1 + reps / 30);

            // 해당 월의 최대 1RM 갱신
            if (!max1RMByMonth.containsKey(month) ||
                max1RMByMonth[month]! < estimated1RM) {
              max1RMByMonth[month] = estimated1RM;
            }
          }
        }
      }
    }

    // 결과 변환 및 정렬
    final result = max1RMByMonth.entries
        .map((e) => Exercise1RMRecord(
              date: e.key,
              estimated1RM: e.value,
            ))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    print('=== exercise1RMHistory 최종 결과: ${result.length}건 ===');
    return result;
  } catch (e) {
    print('=== exercise1RMHistory 조회 실패: $e ===');
    return const [];
  }
}

/// 운동 빈도 데이터 모델 (부위별)
class MuscleFrequency {
  final String label; // '가슴', '등', '어깨', '하체', '팔', '코어'
  final int count; // 세트 수
  final Color color;

  const MuscleFrequency({
    required this.label,
    required this.count,
    required this.color,
  });
}

/// 운동별 빈도 데이터 모델
class ExerciseFrequency {
  final String exerciseName;
  final int count; // 세트 수
  final String primaryMuscle; // 주요 부위

  const ExerciseFrequency({
    required this.exerciseName,
    required this.count,
    required this.primaryMuscle,
  });
}

/// 부위별 운동 빈도 Provider (최근 6개월)
@riverpod
Future<List<MuscleFrequency>> muscleFrequency(MuscleFrequencyRef ref) async {
  final userId = ref.watch(currentUserIdProvider);

  // 로그인하지 않은 경우 빈 데이터 반환
  if (userId == null) {
    return const [];
  }

  try {
    final supabase = ref.read(supabaseServiceProvider);

    // 최근 6개월 시작일 계산
    final now = DateTime.now();
    final sixMonthsAgo = DateTime(now.year, now.month - 5, 1);

    print('=== muscleFrequency 조회: userId=$userId, 기간=${sixMonthsAgo.toIso8601String()} ~ ${now.toIso8601String()} ===');

    // workout_sessions + workout_sets + exercises JOIN
    final response = await supabase
        .from(SupabaseTables.workoutSessions)
        .select('''
          id,
          workout_sets (
            exercises (
              primary_muscle
            )
          )
        ''')
        .eq('user_id', userId)
        .eq('is_cancelled', false)
        .not('finished_at', 'is', null)
        .gte('started_at', sixMonthsAgo.toIso8601String());

    final sessions = response as List;
    print('=== muscleFrequency 결과: ${sessions.length}세션 ===');

    // 부위별 세트 수 집계
    final Map<MuscleGroup, int> countByMuscle = {
      MuscleGroup.chest: 0,
      MuscleGroup.back: 0,
      MuscleGroup.shoulders: 0,
      MuscleGroup.quadriceps: 0,
      MuscleGroup.quads: 0,
      MuscleGroup.hamstrings: 0,
      MuscleGroup.glutes: 0,
      MuscleGroup.biceps: 0,
      MuscleGroup.triceps: 0,
      MuscleGroup.abs: 0,
      MuscleGroup.obliques: 0,
      MuscleGroup.core: 0,
    };

    for (final session in sessions) {
      final sets = session['workout_sets'] as List? ?? [];

      for (final set in sets) {
        final exercise = set['exercises'] as Map?;
        final primaryMuscleStr = exercise?['primary_muscle'] as String?;

        if (primaryMuscleStr != null) {
          final muscle = MuscleGroup.values.firstWhere(
            (m) => m.value == primaryMuscleStr,
            orElse: () => MuscleGroup.fullBody,
          );

          if (countByMuscle.containsKey(muscle)) {
            countByMuscle[muscle] = (countByMuscle[muscle] ?? 0) + 1;
          }
        }
      }
    }

    // 부위별 그룹화 (하체: quads + hamstrings + glutes, 팔: biceps + triceps, 코어: abs + obliques + core)
    final chestCount = countByMuscle[MuscleGroup.chest] ?? 0;
    final backCount = (countByMuscle[MuscleGroup.back] ?? 0) + (countByMuscle[MuscleGroup.lats] ?? 0);
    final shouldersCount = countByMuscle[MuscleGroup.shoulders] ?? 0;
    final legsCount = (countByMuscle[MuscleGroup.quadriceps] ?? 0) +
                      (countByMuscle[MuscleGroup.quads] ?? 0) +
                      (countByMuscle[MuscleGroup.hamstrings] ?? 0) +
                      (countByMuscle[MuscleGroup.glutes] ?? 0) +
                      (countByMuscle[MuscleGroup.calves] ?? 0);
    final armsCount = (countByMuscle[MuscleGroup.biceps] ?? 0) + (countByMuscle[MuscleGroup.triceps] ?? 0);
    final coreCount = (countByMuscle[MuscleGroup.abs] ?? 0) +
                      (countByMuscle[MuscleGroup.obliques] ?? 0) +
                      (countByMuscle[MuscleGroup.core] ?? 0);

    final result = [
      MuscleFrequency(label: '가슴', count: chestCount, color: AppColors.muscleChest),
      MuscleFrequency(label: '등', count: backCount, color: AppColors.muscleBack),
      MuscleFrequency(label: '어깨', count: shouldersCount, color: AppColors.warning),
      MuscleFrequency(label: '하체', count: legsCount, color: AppColors.success),
      MuscleFrequency(label: '팔', count: armsCount, color: AppColors.muscleArms),
      MuscleFrequency(label: '코어', count: coreCount, color: AppColors.muscleCore),
    ];

    print('=== muscleFrequency 최종 결과: $result ===');
    return result;
  } catch (e) {
    print('=== muscleFrequency 조회 실패: $e ===');
    return const [];
  }
}

/// 운동별 빈도 TOP 5 Provider (최근 6개월)
@riverpod
Future<List<ExerciseFrequency>> exerciseFrequency(ExerciseFrequencyRef ref) async {
  final userId = ref.watch(currentUserIdProvider);

  // 로그인하지 않은 경우 빈 데이터 반환
  if (userId == null) {
    return const [];
  }

  try {
    final supabase = ref.read(supabaseServiceProvider);

    // 최근 6개월 시작일 계산
    final now = DateTime.now();
    final sixMonthsAgo = DateTime(now.year, now.month - 5, 1);

    print('=== exerciseFrequency 조회: userId=$userId, 기간=${sixMonthsAgo.toIso8601String()} ~ ${now.toIso8601String()} ===');

    // workout_sessions + workout_sets + exercises JOIN
    final response = await supabase
        .from(SupabaseTables.workoutSessions)
        .select('''
          id,
          workout_sets (
            exercises (
              name,
              primary_muscle
            )
          )
        ''')
        .eq('user_id', userId)
        .eq('is_cancelled', false)
        .not('finished_at', 'is', null)
        .gte('started_at', sixMonthsAgo.toIso8601String());

    final sessions = response as List;
    print('=== exerciseFrequency 결과: ${sessions.length}세션 ===');

    // 운동별 세트 수 집계
    final Map<String, int> countByExercise = {};
    final Map<String, String> muscleByExercise = {};

    for (final session in sessions) {
      final sets = session['workout_sets'] as List? ?? [];

      for (final set in sets) {
        final exercise = set['exercises'] as Map?;
        final name = exercise?['name'] as String?;
        final primaryMuscleStr = exercise?['primary_muscle'] as String?;

        if (name != null && primaryMuscleStr != null) {
          countByExercise[name] = (countByExercise[name] ?? 0) + 1;
          muscleByExercise[name] = primaryMuscleStr;
        }
      }
    }

    // 세트 수 기준 내림차순 정렬 후 TOP 5
    final sortedEntries = countByExercise.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final top5 = sortedEntries.take(5).map((entry) {
      final muscle = MuscleGroup.values.firstWhere(
        (m) => m.value == muscleByExercise[entry.key],
        orElse: () => MuscleGroup.fullBody,
      );

      return ExerciseFrequency(
        exerciseName: entry.key,
        count: entry.value,
        primaryMuscle: muscle.label,
      );
    }).toList();

    print('=== exerciseFrequency 최종 결과: ${top5.length}건 ===');
    return top5;
  } catch (e) {
    print('=== exerciseFrequency 조회 실패: $e ===');
    return const [];
  }
}
