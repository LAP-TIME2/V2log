import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../core/utils/fitness_calculator.dart';
import '../../data/models/exercise_model.dart';
import '../../data/models/workout_session_model.dart';
import '../../data/models/workout_set_model.dart';
import '../../data/services/local_storage_service.dart';
import '../../data/services/supabase_service.dart';
import 'auth_provider.dart';

part 'workout_provider.g.dart';

const _uuid = Uuid();

/// 활성 운동 세션 Provider
@Riverpod(keepAlive: true)
class ActiveWorkout extends _$ActiveWorkout {
  @override
  WorkoutSessionModel? build() {
    // 앱 시작 시 로컬에 저장된 세션 복구 시도
    _restoreSession();
    return null;
  }

  Future<void> _restoreSession() async {
    final localStorage = ref.read(localStorageServiceProvider);
    final savedSession = await localStorage.getWorkoutSession();

    if (savedSession != null) {
      try {
        state = WorkoutSessionModel.fromJson(savedSession);
      } catch (e) {
        await localStorage.clearWorkoutSession();
      }
    }
  }

  /// 운동 시작
  Future<void> startWorkout({
    String? routineId,
    required WorkoutMode mode,
  }) async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) throw Exception('로그인이 필요합니다');

    // 오늘 회차 계산
    final sessionNumber = await _getTodaySessionNumber(userId);

    final session = WorkoutSessionModel(
      id: _uuid.v4(),
      userId: userId,
      routineId: routineId,
      sessionNumber: sessionNumber,
      mode: mode,
      startedAt: DateTime.now(),
      createdAt: DateTime.now(),
    );

    // Supabase에 세션 생성
    final supabase = ref.read(supabaseServiceProvider);
    await supabase.from(SupabaseTables.workoutSessions).insert({
      'id': session.id,
      'user_id': session.userId,
      'routine_id': session.routineId,
      'session_number': session.sessionNumber,
      'mode': session.mode.value,
      'started_at': session.startedAt.toIso8601String(),
    });

    // 로컬 저장소에 백업
    final localStorage = ref.read(localStorageServiceProvider);
    await localStorage.saveWorkoutSession(session.toJson());
    localStorage.lastWorkoutMode = mode.value;

    state = session;
  }

  Future<int> _getTodaySessionNumber(String userId) async {
    final supabase = ref.read(supabaseServiceProvider);
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final response = await supabase
        .from(SupabaseTables.workoutSessions)
        .select('id')
        .eq('user_id', userId)
        .gte('started_at', startOfDay.toIso8601String())
        .lt('started_at', endOfDay.toIso8601String());

    return (response as List).length + 1;
  }

  /// 세트 추가
  Future<void> addSet({
    required String exerciseId,
    required double weight,
    required int reps,
    SetType setType = SetType.working,
    double? rpe,
    String? notes,
  }) async {
    if (state == null) throw Exception('진행 중인 운동이 없습니다');

    final session = state!;
    final exerciseSets =
        session.sets.where((s) => s.exerciseId == exerciseId).toList();
    final setNumber = exerciseSets.length + 1;

    // PR 체크
    final isPr = await _checkPR(session.userId, exerciseId, weight, reps);

    final newSet = WorkoutSetModel(
      id: _uuid.v4(),
      sessionId: session.id,
      exerciseId: exerciseId,
      setNumber: setNumber,
      setType: setType,
      weight: weight,
      reps: reps,
      rpe: rpe,
      isPr: isPr,
      notes: notes,
      completedAt: DateTime.now(),
    );

    // Supabase에 세트 저장
    final supabase = ref.read(supabaseServiceProvider);
    await supabase.from(SupabaseTables.workoutSets).insert({
      'id': newSet.id,
      'session_id': newSet.sessionId,
      'exercise_id': newSet.exerciseId,
      'set_number': newSet.setNumber,
      'set_type': newSet.setType.value,
      'weight': newSet.weight,
      'reps': newSet.reps,
      'rpe': newSet.rpe,
      'is_pr': newSet.isPr,
      'notes': newSet.notes,
      'completed_at': newSet.completedAt.toIso8601String(),
    });

    // 운동 기록 업데이트
    await _updateExerciseRecord(session.userId, exerciseId, weight, reps);

    // 마지막 세트 저장
    final localStorage = ref.read(localStorageServiceProvider);
    await localStorage.saveLastSet(session.userId, exerciseId, weight, reps);

    // 상태 업데이트
    final updatedSession = session.copyWith(
      sets: [...session.sets, newSet],
      totalSets: (session.totalSets ?? 0) + 1,
      totalVolume: (session.totalVolume ?? 0) + newSet.volume,
    );

    state = updatedSession;

    // 로컬 백업
    await localStorage.saveWorkoutSession(updatedSession.toJson());
  }

  Future<bool> _checkPR(
    String userId,
    String exerciseId,
    double weight,
    int reps,
  ) async {
    final supabase = ref.read(supabaseServiceProvider);

    final response = await supabase
        .from(SupabaseTables.exerciseRecords)
        .select('estimated_1rm')
        .eq('user_id', userId)
        .eq('exercise_id', exerciseId)
        .maybeSingle();

    if (response == null) return true; // 첫 기록

    final currentEstimated1rm = response['estimated_1rm'] as double?;
    if (currentEstimated1rm == null) return true;

    final new1rm = FitnessCalculator.calculate1RM(weight, reps);
    return new1rm > currentEstimated1rm;
  }

  Future<void> _updateExerciseRecord(
    String userId,
    String exerciseId,
    double weight,
    int reps,
  ) async {
    final supabase = ref.read(supabaseServiceProvider);
    final new1rm = FitnessCalculator.calculate1RM(weight, reps);
    final volume = weight * reps;
    final now = DateTime.now().toIso8601String();

    // Upsert
    await supabase.from(SupabaseTables.exerciseRecords).upsert({
      'user_id': userId,
      'exercise_id': exerciseId,
      'estimated_1rm': new1rm,
      'max_weight': weight,
      'max_reps': reps,
      'max_volume': volume,
      'last_performed_at': now,
      'updated_at': now,
    }, onConflict: 'user_id,exercise_id');
  }

  /// 세트 수정
  Future<void> updateSet(String setId, {double? weight, int? reps}) async {
    if (state == null) return;

    final session = state!;
    final setIndex = session.sets.indexWhere((s) => s.id == setId);
    if (setIndex == -1) return;

    final oldSet = session.sets[setIndex];
    final updatedSet = oldSet.copyWith(
      weight: weight ?? oldSet.weight,
      reps: reps ?? oldSet.reps,
    );

    final supabase = ref.read(supabaseServiceProvider);
    await supabase.from(SupabaseTables.workoutSets).update({
      'weight': updatedSet.weight,
      'reps': updatedSet.reps,
    }).eq('id', setId);

    final newSets = [...session.sets];
    newSets[setIndex] = updatedSet;

    final volumeDiff = updatedSet.volume - oldSet.volume;

    state = session.copyWith(
      sets: newSets,
      totalVolume: (session.totalVolume ?? 0) + volumeDiff,
    );
  }

  /// 세트 삭제
  Future<void> deleteSet(String setId) async {
    if (state == null) return;

    final session = state!;
    final setToDelete = session.sets.firstWhere((s) => s.id == setId);

    final supabase = ref.read(supabaseServiceProvider);
    await supabase.from(SupabaseTables.workoutSets).delete().eq('id', setId);

    state = session.copyWith(
      sets: session.sets.where((s) => s.id != setId).toList(),
      totalSets: (session.totalSets ?? 1) - 1,
      totalVolume: (session.totalVolume ?? 0) - setToDelete.volume,
    );
  }

  /// 운동 완료
  Future<void> finishWorkout({String? notes, int? moodRating}) async {
    if (state == null) return;

    final session = state!;
    final finishedAt = DateTime.now();
    final durationSeconds = finishedAt.difference(session.startedAt).inSeconds;

    final supabase = ref.read(supabaseServiceProvider);
    await supabase.from(SupabaseTables.workoutSessions).update({
      'finished_at': finishedAt.toIso8601String(),
      'total_volume': session.calculatedVolume,
      'total_sets': session.sets.length,
      'total_duration_seconds': durationSeconds,
      'notes': notes,
      'mood_rating': moodRating,
    }).eq('id', session.id);

    final localStorage = ref.read(localStorageServiceProvider);
    await localStorage.clearWorkoutSession();

    state = null;
  }

  /// 운동 취소
  Future<void> cancelWorkout() async {
    if (state == null) return;

    final session = state!;

    final supabase = ref.read(supabaseServiceProvider);
    await supabase.from(SupabaseTables.workoutSessions).update({
      'is_cancelled': true,
      'finished_at': DateTime.now().toIso8601String(),
    }).eq('id', session.id);

    final localStorage = ref.read(localStorageServiceProvider);
    await localStorage.clearWorkoutSession();

    state = null;
  }
}

/// 운동 진행 상태 Provider
@riverpod
bool isWorkoutInProgress(IsWorkoutInProgressRef ref) {
  final session = ref.watch(activeWorkoutProvider);
  return session != null;
}

/// 현재 운동의 세트 목록 Provider
@riverpod
List<WorkoutSetModel> currentWorkoutSets(CurrentWorkoutSetsRef ref) {
  final session = ref.watch(activeWorkoutProvider);
  return session?.sets ?? [];
}

/// 특정 운동의 세트 목록 Provider
@riverpod
List<WorkoutSetModel> exerciseSets(ExerciseSetsRef ref, String exerciseId) {
  final sets = ref.watch(currentWorkoutSetsProvider);
  return sets.where((s) => s.exerciseId == exerciseId).toList();
}

/// 운동별 마지막 세트 정보 Provider
@riverpod
Future<Map<String, dynamic>?> lastSetInfo(
  LastSetInfoRef ref,
  String exerciseId,
) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return null;

  final localStorage = ref.read(localStorageServiceProvider);
  return await localStorage.getLastSet(userId, exerciseId);
}

/// 현재 운동 운동 목록 Provider
@riverpod
List<ExerciseModel> currentExercises(CurrentExercisesRef ref) {
  // TODO: 루틴에서 운동 목록 가져오기 또는 자유 모드 시 빈 목록
  return [];
}
