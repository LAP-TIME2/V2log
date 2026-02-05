import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/body_record_model.dart';
import '../models/sync_queue_model.dart';
import '../models/workout_session_model.dart';
import '../models/workout_set_model.dart';
import '../services/supabase_service.dart';
import '../services/sync_service.dart';

part 'workout_repository.g.dart';

/// Workout Repository Provider
@riverpod
WorkoutRepository workoutRepository(WorkoutRepositoryRef ref) {
  return WorkoutRepository(ref);
}

/// 운동 기록 저장소
class WorkoutRepository {
  final WorkoutRepositoryRef _ref;

  WorkoutRepository(this._ref);

  SupabaseService get _supabase => _ref.read(supabaseServiceProvider);
  SyncService get _sync => _ref.read(syncServiceProvider);

  /// 현재 연결 상태 확인
  Future<bool> get _isOnline async {
    final status = await _sync.checkConnection();
    return status == ConnectionStatus.online;
  }

  // ==================== Workout Sessions ====================

  /// 새 운동 세션 시작
  Future<WorkoutSessionModel> startWorkoutSession({
    required String userId,
    String? routineId,
    required WorkoutMode mode,
  }) async {
    try {
      // 세션 번호 계산
      final countResponse = await _supabase
          .from(SupabaseTables.workoutSessions)
          .select('id')
          .eq('user_id', userId)
          .eq('is_cancelled', false);

      final sessionNumber = (countResponse as List).length + 1;

      final sessionData = {
        'user_id': userId,
        'routine_id': routineId,
        'session_number': sessionNumber,
        'mode': mode.value,
        'started_at': DateTime.now().toIso8601String(),
        'created_at': DateTime.now().toIso8601String(),
      };

      // 오프라인이면 큐에 추가
      if (!await _isOnline) {
        debugPrint('📦 오프라인: 세션 시작을 큐에 추가');
        await _sync.enqueue(
          operation: SyncOperation.insert,
          table: 'workout_sessions',
          data: sessionData,
        );
        // 로컬용 ID 생성
        return WorkoutSessionModel(
          id: sessionData['user_id'] + '_' + DateTime.now().millisecondsSinceEpoch.toString(),
          userId: userId,
          routineId: routineId,
          sessionNumber: sessionNumber,
          mode: mode,
          startedAt: DateTime.now(),
          createdAt: DateTime.now(),
        );
      }

      final response = await _supabase
          .from(SupabaseTables.workoutSessions)
          .insert(sessionData)
          .select()
          .single();

      return WorkoutSessionModel.fromJson(response);
    } catch (e) {
      debugPrint('운동 세션 시작 실패: $e');
      rethrow;
    }
  }

  /// 운동 세션 완료
  Future<WorkoutSessionModel> finishWorkoutSession({
    required String sessionId,
    String? notes,
    int? moodRating,
  }) async {
    try {
      // 세션의 모든 세트 가져오기
      final setsResponse = await _supabase
          .from(SupabaseTables.workoutSets)
          .select()
          .eq('session_id', sessionId);

      final sets = (setsResponse as List)
          .map((e) => WorkoutSetModel.fromJson(e))
          .toList();

      // 총 볼륨 계산
      final totalVolume = sets.fold(0.0, (sum, set) => sum + set.volume);
      final totalSets = sets.length;

      final updateData = {
        'id': sessionId, // update에 필요
        'finished_at': DateTime.now().toIso8601String(),
        'total_volume': totalVolume,
        'total_sets': totalSets,
        'notes': notes,
        'mood_rating': moodRating,
      };

      // 오프라인이면 큐에 추가
      if (!await _isOnline) {
        debugPrint('📦 오프라인: 세션 완료를 큐에 추가');
        await _sync.enqueue(
          operation: SyncOperation.update,
          table: 'workout_sessions',
          data: updateData,
        );
        return WorkoutSessionModel(
          id: sessionId,
          userId: '',
          sessionNumber: 1,
          mode: WorkoutMode.free,
          startedAt: DateTime.now(),
          finishedAt: DateTime.now(),
          totalVolume: totalVolume,
          totalSets: totalSets,
          notes: notes,
          moodRating: moodRating,
          createdAt: DateTime.now(),
          sets: sets,
        );
      }

      final response = await _supabase
          .from(SupabaseTables.workoutSessions)
          .update({
            'finished_at': DateTime.now().toIso8601String(),
            'total_volume': totalVolume,
            'total_sets': totalSets,
            'notes': notes,
            'mood_rating': moodRating,
          })
          .eq('id', sessionId)
          .select()
          .single();

      return WorkoutSessionModel.fromJson({
        ...response,
        'sets': sets.map((s) => s.toJson()).toList(),
      });
    } catch (e) {
      debugPrint('운동 세션 완료 실패: $e');
      rethrow;
    }
  }

  /// 운동 세션 취소
  Future<void> cancelWorkoutSession(String sessionId) async {
    try {
      final updateData = {
        'id': sessionId,
        'is_cancelled': true,
        'finished_at': DateTime.now().toIso8601String(),
      };

      // 오프라인이면 큐에 추가
      if (!await _isOnline) {
        debugPrint('📦 오프라인: 세션 취소를 큐에 추가');
        await _sync.enqueue(
          operation: SyncOperation.update,
          table: 'workout_sessions',
          data: updateData,
        );
        return;
      }

      await _supabase
          .from(SupabaseTables.workoutSessions)
          .update({
            'is_cancelled': true,
            'finished_at': DateTime.now().toIso8601String(),
          })
          .eq('id', sessionId);
    } catch (e) {
      debugPrint('운동 세션 취소 실패: $e');
      rethrow;
    }
  }

  /// 세션 ID로 세션 가져오기 (세트 포함)
  Future<WorkoutSessionModel?> getSessionById(String sessionId) async {
    try {
      final response = await _supabase
          .from(SupabaseTables.workoutSessions)
          .select('''
            *,
            workout_sets (*)
          ''')
          .eq('id', sessionId)
          .single();

      final sets = (response['workout_sets'] as List?)
          ?.map((e) => WorkoutSetModel.fromJson(e))
          .toList() ?? [];

      return WorkoutSessionModel.fromJson({
        ...response,
        'sets': sets.map((s) => s.toJson()).toList(),
      });
    } catch (e) {
      debugPrint('세션 정보를 불러오는데 실패했습니다: $e');
      return null;
    }
  }

  /// 사용자의 운동 기록 가져오기 (페이지네이션)
  Future<List<WorkoutSessionModel>> getUserWorkoutHistory({
    required String userId,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final response = await _supabase
          .from(SupabaseTables.workoutSessions)
          .select('''
            *,
            workout_sets (*)
          ''')
          .eq('user_id', userId)
          .eq('is_cancelled', false)
          .order('started_at', ascending: false)
          .range(offset, offset + limit - 1);

      return (response as List).map((e) {
        final sets = (e['workout_sets'] as List?)
            ?.map((s) => WorkoutSetModel.fromJson(s))
            .toList() ?? [];

        return WorkoutSessionModel.fromJson({
          ...e,
          'sets': sets.map((s) => s.toJson()).toList(),
        });
      }).toList();
    } catch (e) {
      debugPrint('운동 기록을 불러오는데 실패했습니다: $e');
      rethrow;
    }
  }

  /// 특정 날짜의 운동 기록 가져오기
  Future<List<WorkoutSessionModel>> getWorkoutsByDate({
    required String userId,
    required DateTime date,
  }) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final response = await _supabase
          .from(SupabaseTables.workoutSessions)
          .select('''
            *,
            workout_sets (*)
          ''')
          .eq('user_id', userId)
          .eq('is_cancelled', false)
          .gte('started_at', startOfDay.toIso8601String())
          .lt('started_at', endOfDay.toIso8601String())
          .order('started_at');

      return (response as List).map((e) {
        final sets = (e['workout_sets'] as List?)
            ?.map((s) => WorkoutSetModel.fromJson(s))
            .toList() ?? [];

        return WorkoutSessionModel.fromJson({
          ...e,
          'sets': sets.map((s) => s.toJson()).toList(),
        });
      }).toList();
    } catch (e) {
      debugPrint('날짜별 운동 기록을 불러오는데 실패했습니다: $e');
      rethrow;
    }
  }

  /// 특정 기간의 운동 일수 가져오기
  Future<List<DateTime>> getWorkoutDates({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final response = await _supabase
          .from(SupabaseTables.workoutSessions)
          .select('started_at')
          .eq('user_id', userId)
          .eq('is_cancelled', false)
          .gte('started_at', startDate.toIso8601String())
          .lte('started_at', endDate.toIso8601String());

      return (response as List)
          .map((e) => DateTime.parse(e['started_at']))
          .toSet()
          .map((d) => DateTime(d.year, d.month, d.day))
          .toList();
    } catch (e) {
      debugPrint('운동 일수를 불러오는데 실패했습니다: $e');
      rethrow;
    }
  }

  // ==================== Workout Sets ====================

  /// 세트 기록 추가
  Future<WorkoutSetModel> addSet({
    required String sessionId,
    required String exerciseId,
    required int setNumber,
    SetType setType = SetType.working,
    double? weight,
    int? reps,
    double? targetWeight,
    int? targetReps,
    double? rpe,
    int? restSeconds,
    String? notes,
  }) async {
    try {
      // PR 확인
      final isPr = await _checkIfPr(
        exerciseId: exerciseId,
        weight: weight,
        reps: reps,
      );

      final setData = {
        'id': sessionId + '_set_$setNumber',
        'session_id': sessionId,
        'exercise_id': exerciseId,
        'set_number': setNumber,
        'set_type': setType.value,
        'weight': weight,
        'reps': reps,
        'target_weight': targetWeight,
        'target_reps': targetReps,
        'rpe': rpe,
        'rest_seconds': restSeconds,
        'is_pr': isPr,
        'notes': notes,
        'completed_at': DateTime.now().toIso8601String(),
      };

      // 오프라인이면 큐에 추가
      if (!await _isOnline) {
        debugPrint('📦 오프라인: 세트 추가를 큐에 추가');
        await _sync.enqueue(
          operation: SyncOperation.insert,
          table: 'workout_sets',
          data: setData,
        );
        // 운동 기록 업데이트도 큐에 추가
        if (weight != null && reps != null) {
          await _updateExerciseRecord(
            exerciseId: exerciseId,
            weight: weight,
            reps: reps,
          );
        }
        return WorkoutSetModel.fromJson(setData);
      }

      final response = await _supabase
          .from(SupabaseTables.workoutSets)
          .insert(setData)
          .select()
          .single();

      // 운동 기록 업데이트
      if (weight != null && reps != null) {
        await _updateExerciseRecord(
          exerciseId: exerciseId,
          weight: weight,
          reps: reps,
        );
      }

      return WorkoutSetModel.fromJson(response);
    } catch (e) {
      debugPrint('세트 기록 추가 실패: $e');
      rethrow;
    }
  }

  /// 세트 기록 수정
  Future<WorkoutSetModel> updateSet({
    required String setId,
    double? weight,
    int? reps,
    double? rpe,
    String? notes,
  }) async {
    try {
      final updateData = {
        'id': setId,
        if (weight != null) 'weight': weight,
        if (reps != null) 'reps': reps,
        if (rpe != null) 'rpe': rpe,
        if (notes != null) 'notes': notes,
      };

      // 오프라인이면 큐에 추가
      if (!await _isOnline) {
        debugPrint('📦 오프라인: 세트 수정을 큐에 추가');
        await _sync.enqueue(
          operation: SyncOperation.update,
          table: 'workout_sets',
          data: updateData,
        );
        return WorkoutSetModel(
          id: setId,
          sessionId: '',
          exerciseId: '',
          setNumber: 1,
          weight: weight,
          reps: reps,
          rpe: rpe,
          notes: notes,
          completedAt: DateTime.now(),
        );
      }

      final response = await _supabase
          .from(SupabaseTables.workoutSets)
          .update({
            if (weight != null) 'weight': weight,
            if (reps != null) 'reps': reps,
            if (rpe != null) 'rpe': rpe,
            if (notes != null) 'notes': notes,
          })
          .eq('id', setId)
          .select()
          .single();

      return WorkoutSetModel.fromJson(response);
    } catch (e) {
      debugPrint('세트 기록 수정 실패: $e');
      rethrow;
    }
  }

  /// 세트 기록 삭제
  Future<void> deleteSet(String setId) async {
    try {
      final deleteData = {'id': setId};

      // 오프라인이면 큐에 추가
      if (!await _isOnline) {
        debugPrint('📦 오프라인: 세트 삭제를 큐에 추가');
        await _sync.enqueue(
          operation: SyncOperation.delete,
          table: 'workout_sets',
          data: deleteData,
        );
        return;
      }

      await _supabase
          .from(SupabaseTables.workoutSets)
          .delete()
          .eq('id', setId);
    } catch (e) {
      debugPrint('세트 기록 삭제 실패: $e');
      rethrow;
    }
  }

  // ==================== Exercise Records ====================

  /// 운동별 기록 가져오기
  Future<ExerciseRecordModel?> getExerciseRecord({
    required String userId,
    required String exerciseId,
  }) async {
    try {
      final response = await _supabase
          .from(SupabaseTables.exerciseRecords)
          .select()
          .eq('user_id', userId)
          .eq('exercise_id', exerciseId)
          .maybeSingle();

      if (response == null) return null;
      return ExerciseRecordModel.fromJson(response);
    } catch (e) {
      debugPrint('운동 기록을 불러오는데 실패했습니다: $e');
      return null;
    }
  }

  /// 운동별 기록 업데이트 (내부용)
  Future<void> _updateExerciseRecord({
    required String exerciseId,
    required double weight,
    required int reps,
  }) async {
    try {
      final userId = _supabase.currentUser?.id;
      if (userId == null) return;

      // 1RM 계산 (Epley 공식)
      final estimated1rm = weight * (1 + reps / 30);
      final volume = weight * reps;

      // 기존 기록 확인
      final existing = await getExerciseRecord(
        userId: userId,
        exerciseId: exerciseId,
      );

      if (existing == null) {
        // 새 기록 생성
        await _supabase.from(SupabaseTables.exerciseRecords).insert({
          'user_id': userId,
          'exercise_id': exerciseId,
          'estimated_1rm': estimated1rm,
          'max_weight': weight,
          'max_reps': reps,
          'max_volume': volume,
          'total_volume': volume,
          'total_sets': 1,
          'last_performed_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });
      } else {
        // 기존 기록 업데이트
        await _supabase
            .from(SupabaseTables.exerciseRecords)
            .update({
              'estimated_1rm': estimated1rm > (existing.estimated1rm ?? 0)
                  ? estimated1rm
                  : existing.estimated1rm,
              'max_weight': weight > (existing.maxWeight ?? 0)
                  ? weight
                  : existing.maxWeight,
              'max_reps': reps > (existing.maxReps ?? 0)
                  ? reps
                  : existing.maxReps,
              'max_volume': volume > (existing.maxVolume ?? 0)
                  ? volume
                  : existing.maxVolume,
              'total_volume': existing.totalVolume + volume,
              'total_sets': existing.totalSets + 1,
              'last_performed_at': DateTime.now().toIso8601String(),
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('id', existing.id);
      }
    } catch (e) {
      debugPrint('운동 기록 업데이트 실패: $e');
    }
  }

  /// PR 확인 (내부용)
  Future<bool> _checkIfPr({
    required String exerciseId,
    double? weight,
    int? reps,
  }) async {
    if (weight == null || reps == null) return false;

    try {
      final userId = _supabase.currentUser?.id;
      if (userId == null) return false;

      final existing = await getExerciseRecord(
        userId: userId,
        exerciseId: exerciseId,
      );

      if (existing == null) return true;

      // 1RM 기준 PR 확인
      final currentEstimated1rm = weight * (1 + reps / 30);
      return currentEstimated1rm > (existing.estimated1rm ?? 0);
    } catch (e) {
      return false;
    }
  }

  // ==================== Body Records ====================

  /// 신체 기록 추가
  Future<BodyRecordModel> addBodyRecord({
    required String userId,
    double? weight,
    double? bodyFatPercentage,
    double? muscleMass,
    String? notes,
    DateTime? recordedAt,
  }) async {
    try {
      final response = await _supabase
          .from(SupabaseTables.bodyRecords)
          .insert({
            'user_id': userId,
            'weight': weight,
            'body_fat_percentage': bodyFatPercentage,
            'muscle_mass': muscleMass,
            'notes': notes,
            'recorded_at': (recordedAt ?? DateTime.now()).toIso8601String(),
            'created_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      return BodyRecordModel.fromJson(response);
    } catch (e) {
      debugPrint('신체 기록 추가 실패: $e');
      rethrow;
    }
  }

  /// 신체 기록 목록 가져오기
  Future<List<BodyRecordModel>> getBodyRecords({
    required String userId,
    int limit = 30,
  }) async {
    try {
      final response = await _supabase
          .from(SupabaseTables.bodyRecords)
          .select()
          .eq('user_id', userId)
          .order('recorded_at', ascending: false)
          .limit(limit);

      return (response as List)
          .map((e) => BodyRecordModel.fromJson(e))
          .toList();
    } catch (e) {
      debugPrint('신체 기록을 불러오는데 실패했습니다: $e');
      rethrow;
    }
  }

  /// 최근 신체 기록 가져오기
  Future<BodyRecordModel?> getLatestBodyRecord(String userId) async {
    try {
      final response = await _supabase
          .from(SupabaseTables.bodyRecords)
          .select()
          .eq('user_id', userId)
          .order('recorded_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (response == null) return null;
      return BodyRecordModel.fromJson(response);
    } catch (e) {
      debugPrint('최근 신체 기록을 불러오는데 실패했습니다: $e');
      return null;
    }
  }
}
