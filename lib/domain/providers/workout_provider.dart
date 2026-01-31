import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../core/utils/fitness_calculator.dart';
import '../../data/dummy/dummy_exercises.dart';
import '../../data/dummy/dummy_preset_routines.dart';
import '../../data/models/exercise_model.dart';
import '../../data/models/preset_routine_model.dart';
import '../../data/models/workout_session_model.dart';
import '../../data/models/workout_set_model.dart';
import '../../data/services/local_storage_service.dart';
import '../../data/services/supabase_service.dart';
import 'auth_provider.dart';
import 'preset_routine_provider.dart';

part 'workout_provider.g.dart';

const _uuid = Uuid();

/// 활성 운동 세션 Provider
@Riverpod(keepAlive: true)
class ActiveWorkout extends _$ActiveWorkout {
  // 데모 모드용 로컬 PR 기록
  final Map<String, double> _localPrRecords = {};

  @override
  WorkoutSessionModel? build() {
    // 앱 시작 시 로컬에 저장된 세션 복구 시도
    _restoreSession();
    return null;
  }

  Future<void> _restoreSession() async {
    try {
      final localStorage = ref.read(localStorageServiceProvider);
      final savedSession = await localStorage.getWorkoutSession();

      if (savedSession != null) {
        try {
          state = WorkoutSessionModel.fromJson(savedSession);
        } catch (e) {
          await localStorage.clearWorkoutSession();
        }
      }
    } catch (e) {
      debugPrint('세션 복구 실패: $e');
    }
  }

  /// 운동 시작
  Future<void> startWorkout({
    String? routineId,
    required WorkoutMode mode,
  }) async {
    // 데모 모드에서는 더미 사용자 ID 사용
    var userId = ref.read(currentUserIdProvider);
    userId ??= 'demo-user';

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

    // Supabase에 세션 생성 시도 (실패해도 무시)
    try {
      final supabase = ref.read(supabaseServiceProvider);
      await supabase.from(SupabaseTables.workoutSessions).insert({
        'id': session.id,
        'user_id': session.userId,
        'routine_id': session.routineId,
        'session_number': session.sessionNumber,
        'mode': session.mode.value,
        'started_at': session.startedAt.toIso8601String(),
      });
    } catch (e) {
      debugPrint('⚠️ Supabase 세션 생성 실패 (데모 모드): $e');
    }

    // 로컬 저장소에 백업
    try {
      final localStorage = ref.read(localStorageServiceProvider);
      await localStorage.saveWorkoutSession(session.toJson());
      localStorage.lastWorkoutMode = mode.value;
    } catch (e) {
      debugPrint('로컬 저장 실패: $e');
    }

    state = session;
  }

  Future<int> _getTodaySessionNumber(String userId) async {
    try {
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
    } catch (e) {
      debugPrint('세션 번호 조회 실패 (데모 모드 기본값 1): $e');
      return 1;
    }
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

    // PR 체크 (로컬 기준)
    final isPr = _checkLocalPR(exerciseId, weight, reps);

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

    // Supabase에 세트 저장 시도 (실패해도 무시)
    try {
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
    } catch (e) {
      debugPrint('⚠️ Supabase 세트 저장 실패 (데모 모드): $e');
    }

    // 로컬 PR 업데이트
    _updateLocalPR(exerciseId, weight, reps);

    // 마지막 세트 저장
    try {
      final localStorage = ref.read(localStorageServiceProvider);
      await localStorage.saveLastSet(session.userId, exerciseId, weight, reps);
    } catch (e) {
      debugPrint('마지막 세트 저장 실패: $e');
    }

    // 상태 업데이트
    final updatedSession = session.copyWith(
      sets: [...session.sets, newSet],
      totalSets: (session.totalSets ?? 0) + 1,
      totalVolume: (session.totalVolume ?? 0) + newSet.volume,
    );

    state = updatedSession;

    // 로컬 백업
    try {
      final localStorage = ref.read(localStorageServiceProvider);
      await localStorage.saveWorkoutSession(updatedSession.toJson());
    } catch (e) {
      debugPrint('세션 백업 실패: $e');
    }
  }

  bool _checkLocalPR(String exerciseId, double weight, int reps) {
    final new1rm = FitnessCalculator.calculate1RM(weight, reps);
    final current1rm = _localPrRecords[exerciseId];

    if (current1rm == null) return true;
    return new1rm > current1rm;
  }

  void _updateLocalPR(String exerciseId, double weight, int reps) {
    final new1rm = FitnessCalculator.calculate1RM(weight, reps);
    final current1rm = _localPrRecords[exerciseId];

    if (current1rm == null || new1rm > current1rm) {
      _localPrRecords[exerciseId] = new1rm;
    }
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

    // Supabase 업데이트 시도 (실패해도 무시)
    try {
      final supabase = ref.read(supabaseServiceProvider);
      await supabase.from(SupabaseTables.workoutSets).update({
        'weight': updatedSet.weight,
        'reps': updatedSet.reps,
      }).eq('id', setId);
    } catch (e) {
      debugPrint('⚠️ Supabase 세트 수정 실패 (데모 모드): $e');
    }

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

    // Supabase 삭제 시도 (실패해도 무시)
    try {
      final supabase = ref.read(supabaseServiceProvider);
      await supabase.from(SupabaseTables.workoutSets).delete().eq('id', setId);
    } catch (e) {
      debugPrint('⚠️ Supabase 세트 삭제 실패 (데모 모드): $e');
    }

    state = session.copyWith(
      sets: session.sets.where((s) => s.id != setId).toList(),
      totalSets: (session.totalSets ?? 1) - 1,
      totalVolume: (session.totalVolume ?? 0) - setToDelete.volume,
    );
  }

  /// 운동 완료 - 완료된 세션을 반환
  Future<WorkoutSessionModel?> finishWorkout({String? notes, int? moodRating}) async {
    if (state == null) return null;

    final session = state!;
    final finishedAt = DateTime.now();
    final durationSeconds = finishedAt.difference(session.startedAt).inSeconds;

    // 완료된 세션 생성
    final finishedSession = session.copyWith(
      finishedAt: finishedAt,
      totalVolume: session.calculatedVolume,
      totalSets: session.sets.length,
      totalDurationSeconds: durationSeconds,
      notes: notes,
      moodRating: moodRating,
    );

    // Supabase 업데이트 시도 (실패해도 무시)
    try {
      final supabase = ref.read(supabaseServiceProvider);
      await supabase.from(SupabaseTables.workoutSessions).update({
        'finished_at': finishedAt.toIso8601String(),
        'total_volume': session.calculatedVolume,
        'total_sets': session.sets.length,
        'total_duration_seconds': durationSeconds,
        'notes': notes,
        'mood_rating': moodRating,
      }).eq('id', session.id);
    } catch (e) {
      debugPrint('⚠️ Supabase 세션 완료 실패 (데모 모드): $e');
    }

    // 로컬 저장소 정리
    try {
      final localStorage = ref.read(localStorageServiceProvider);
      await localStorage.clearWorkoutSession();
    } catch (e) {
      debugPrint('로컬 저장소 정리 실패: $e');
    }

    state = null;
    return finishedSession;
  }

  /// 운동 취소
  Future<void> cancelWorkout() async {
    if (state == null) return;

    final session = state!;

    // Supabase 업데이트 시도 (실패해도 무시)
    try {
      final supabase = ref.read(supabaseServiceProvider);
      await supabase.from(SupabaseTables.workoutSessions).update({
        'is_cancelled': true,
        'finished_at': DateTime.now().toIso8601String(),
      }).eq('id', session.id);
    } catch (e) {
      debugPrint('⚠️ Supabase 세션 취소 실패 (데모 모드): $e');
    }

    // 로컬 저장소 정리
    try {
      final localStorage = ref.read(localStorageServiceProvider);
      await localStorage.clearWorkoutSession();
    } catch (e) {
      debugPrint('로컬 저장소 정리 실패: $e');
    }

    state = null;
  }
}

/// 현재 루틴 운동 목록 Provider (프리셋 루틴 모드일 때)
@Riverpod(keepAlive: true)
class RoutineExercises extends _$RoutineExercises {
  @override
  List<PresetRoutineExerciseModel> build() => [];

  /// 루틴 운동 목록 설정
  Future<void> loadFromRoutine(String routineId, {int dayNumber = 1}) async {
    try {
      final exercises = await ref.read(
        presetRoutineDayExercisesProvider(routineId, dayNumber).future,
      );
      state = exercises;
    } catch (e) {
      debugPrint('루틴 운동 로드 실패: $e');
      // 더미 데이터에서 로드
      final routine = DummyPresetRoutines.getById(routineId);
      if (routine != null) {
        state = routine.exercisesByDay[dayNumber] ?? [];
      }
    }
  }

  /// 운동 목록 초기화
  void clear() {
    state = [];
  }
}

/// 현재 운동 인덱스 Provider
@Riverpod(keepAlive: true)
class CurrentExerciseIndex extends _$CurrentExerciseIndex {
  @override
  int build() => 0;

  /// 다음 운동으로 이동
  void next() {
    final exercises = ref.read(routineExercisesProvider);
    if (state < exercises.length - 1) {
      state = state + 1;
    }
  }

  /// 이전 운동으로 이동
  void previous() {
    if (state > 0) {
      state = state - 1;
    }
  }

  /// 특정 운동으로 이동
  void goTo(int index) {
    final exercises = ref.read(routineExercisesProvider);
    if (index >= 0 && index < exercises.length) {
      state = index;
    }
  }

  /// 인덱스 초기화
  void reset() {
    state = 0;
  }
}

/// 현재 운동 (루틴 모드)
@riverpod
PresetRoutineExerciseModel? currentRoutineExercise(CurrentRoutineExerciseRef ref) {
  final exercises = ref.watch(routineExercisesProvider);
  final index = ref.watch(currentExerciseIndexProvider);

  if (exercises.isEmpty || index >= exercises.length) return null;
  return exercises[index];
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

  try {
    final localStorage = ref.read(localStorageServiceProvider);
    return await localStorage.getLastSet(userId, exerciseId);
  } catch (e) {
    return null;
  }
}

/// 현재 운동 운동 목록 Provider (더미 데이터 사용)
@riverpod
List<ExerciseModel> currentExercises(CurrentExercisesRef ref) {
  // 자유 모드 시 인기 운동 목록 반환
  return DummyExercises.exercises.take(10).toList();
}

/// 최근 운동 기록 Provider
@riverpod
Future<List<WorkoutSessionModel>> recentWorkouts(RecentWorkoutsRef ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) {
    // 데모 모드 - 더미 데이터 반환
    return _getDummyRecentWorkouts();
  }

  try {
    final supabase = ref.read(supabaseServiceProvider);
    final response = await supabase
        .from(SupabaseTables.workoutSessions)
        .select('''
          *,
          workout_sets (*)
        ''')
        .eq('user_id', userId)
        .eq('is_cancelled', false)
        .not('finished_at', 'is', null)
        .order('started_at', ascending: false)
        .limit(5);

    return (response as List).map((e) {
      final sets = (e['workout_sets'] as List?)
              ?.map((s) => WorkoutSetModel.fromJson(s))
              .toList() ??
          [];

      return WorkoutSessionModel.fromJson({
        ...e,
        'sets': sets.map((s) => s.toJson()).toList(),
      });
    }).toList();
  } catch (e) {
    debugPrint('최근 운동 기록 로드 실패: $e');
    return _getDummyRecentWorkouts();
  }
}

List<WorkoutSessionModel> _getDummyRecentWorkouts() {
  return [
    WorkoutSessionModel(
      id: 'demo-1',
      userId: 'demo-user',
      sessionNumber: 1,
      mode: WorkoutMode.free,
      startedAt: DateTime.now().subtract(const Duration(days: 1, hours: 10)),
      finishedAt: DateTime.now().subtract(const Duration(days: 1, hours: 9)),
      totalVolume: 8500,
      totalSets: 15,
      totalDurationSeconds: 52 * 60,
      notes: '등 & 이두',
    ),
    WorkoutSessionModel(
      id: 'demo-2',
      userId: 'demo-user',
      sessionNumber: 2,
      mode: WorkoutMode.free,
      startedAt: DateTime.now().subtract(const Duration(days: 2, hours: 14)),
      finishedAt: DateTime.now().subtract(const Duration(days: 2, hours: 13)),
      totalVolume: 7200,
      totalSets: 12,
      totalDurationSeconds: 48 * 60,
      notes: '가슴 & 삼두',
    ),
    WorkoutSessionModel(
      id: 'demo-3',
      userId: 'demo-user',
      sessionNumber: 3,
      mode: WorkoutMode.free,
      startedAt: DateTime.now().subtract(const Duration(days: 4, hours: 18)),
      finishedAt: DateTime.now().subtract(const Duration(days: 4, hours: 17)),
      totalVolume: 12000,
      totalSets: 18,
      totalDurationSeconds: 65 * 60,
      notes: '하체',
    ),
  ];
}

/// 운동 기록 히스토리 Provider (월별 그룹화)
@riverpod
Future<List<WorkoutSessionModel>> workoutHistory(
  WorkoutHistoryRef ref, {
  int limit = 20,
  int offset = 0,
}) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) {
    return _getDummyRecentWorkouts();
  }

  try {
    final supabase = ref.read(supabaseServiceProvider);
    final response = await supabase
        .from(SupabaseTables.workoutSessions)
        .select('''
          *,
          workout_sets (*)
        ''')
        .eq('user_id', userId)
        .eq('is_cancelled', false)
        .not('finished_at', 'is', null)
        .order('started_at', ascending: false)
        .range(offset, offset + limit - 1);

    return (response as List).map((e) {
      final sets = (e['workout_sets'] as List?)
              ?.map((s) => WorkoutSetModel.fromJson(s))
              .toList() ??
          [];

      return WorkoutSessionModel.fromJson({
        ...e,
        'sets': sets.map((s) => s.toJson()).toList(),
      });
    }).toList();
  } catch (e) {
    debugPrint('운동 기록 히스토리 로드 실패: $e');
    return _getDummyRecentWorkouts();
  }
}
