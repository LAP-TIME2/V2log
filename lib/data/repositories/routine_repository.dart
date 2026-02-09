import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/exercise_model.dart';
import '../models/preset_routine_model.dart';
import '../models/routine_model.dart';
import '../services/supabase_service.dart';

part 'routine_repository.g.dart';

/// Routine Repository Provider
@riverpod
RoutineRepository routineRepository(RoutineRepositoryRef ref) {
  return RoutineRepository(ref);
}

/// 루틴 저장소
class RoutineRepository {
  final RoutineRepositoryRef _ref;

  RoutineRepository(this._ref);

  SupabaseService get _supabase => _ref.read(supabaseServiceProvider);

  /// 사용자의 모든 루틴 가져오기
  Future<List<RoutineModel>> getUserRoutines(String userId) async {
    try {
      final response = await _supabase
          .from(SupabaseTables.routines)
          .select('''
            *,
            routine_exercises (
              *,
              exercises (*)
            )
          ''')
          .eq('user_id', userId)
          .eq('is_active', true)
          .order('updated_at', ascending: false);

      return (response as List).map((e) {
        final exercises = (e['routine_exercises'] as List?)?.map((re) {
          final exercise = re['exercises'] != null
              ? ExerciseModel.fromJson(re['exercises'])
              : null;
          return RoutineExerciseModel.fromJson({
            ...re,
            'exercise': exercise?.toJson(),
          });
        }).toList();

        return RoutineModel.fromJson({
          ...e,
          'exercises': exercises?.map((e) => e.toJson()).toList() ?? [],
        });
      }).toList();
    } catch (e) {
      print('사용자 루틴 목록을 불러오는데 실패했습니다: $e');
      rethrow;
    }
  }

  /// 루틴 ID로 루틴 상세 가져오기
  Future<RoutineModel?> getRoutineById(String routineId) async {
    try {
      final response = await _supabase
          .from(SupabaseTables.routines)
          .select('''
            *,
            routine_exercises (
              *,
              exercises (*)
            )
          ''')
          .eq('id', routineId)
          .single();

      final exercises = (response['routine_exercises'] as List?)?.map((re) {
        final exercise = re['exercises'] != null
            ? ExerciseModel.fromJson(re['exercises'])
            : null;
        return RoutineExerciseModel.fromJson({
          ...re,
          'exercise': exercise?.toJson(),
        });
      }).toList();

      return RoutineModel.fromJson({
        ...response,
        'exercises': exercises?.map((e) => e.toJson()).toList() ?? [],
      });
    } catch (e) {
      print('루틴 정보를 불러오는데 실패했습니다: $e');
      return null;
    }
  }

  /// 새 루틴 생성
  Future<RoutineModel> createRoutine({
    required String userId,
    required String name,
    String? description,
    List<MuscleGroup>? targetMuscles,
    int? estimatedDuration,
  }) async {
    try {
      final response = await _supabase
          .from(SupabaseTables.routines)
          .insert({
            'user_id': userId,
            'name': name,
            'description': description,
            'target_muscles': targetMuscles?.map((m) => m.value).toList(),
            'estimated_duration': estimatedDuration,
            'source_type': RoutineSourceType.custom.value,
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      return RoutineModel.fromJson(response);
    } catch (e) {
      print('루틴 생성에 실패했습니다: $e');
      rethrow;
    }
  }

  /// 루틴 업데이트
  Future<RoutineModel> updateRoutine(RoutineModel routine) async {
    try {
      final response = await _supabase
          .from(SupabaseTables.routines)
          .update({
            'name': routine.name,
            'description': routine.description,
            'target_muscles': routine.targetMuscles.map((m) => m.value).toList(),
            'estimated_duration': routine.estimatedDuration,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', routine.id)
          .select()
          .single();

      return RoutineModel.fromJson(response);
    } catch (e) {
      print('루틴 업데이트에 실패했습니다: $e');
      rethrow;
    }
  }

  /// 루틴 삭제 (soft delete)
  Future<void> deleteRoutine(String routineId) async {
    try {
      await _supabase
          .from(SupabaseTables.routines)
          .update({
            'is_active': false,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', routineId);
    } catch (e) {
      print('루틴 삭제에 실패했습니다: $e');
      rethrow;
    }
  }

  /// 루틴에 운동 추가
  Future<RoutineExerciseModel> addExerciseToRoutine({
    required String routineId,
    required String exerciseId,
    required int orderIndex,
    int targetSets = 3,
    String targetReps = '10-12',
    double? targetWeight,
    int restSeconds = 90,
    String? notes,
  }) async {
    try {
      final response = await _supabase
          .from(SupabaseTables.routineExercises)
          .insert({
            'routine_id': routineId,
            'exercise_id': exerciseId,
            'order_index': orderIndex,
            'target_sets': targetSets,
            'target_reps': targetReps,
            'target_weight': targetWeight,
            'rest_seconds': restSeconds,
            'notes': notes,
          })
          .select('''
            *,
            exercises (*)
          ''')
          .single();

      final exercise = response['exercises'] != null
          ? ExerciseModel.fromJson(response['exercises'])
          : null;

      return RoutineExerciseModel.fromJson({
        ...response,
        'exercise': exercise?.toJson(),
      });
    } catch (e) {
      print('루틴에 운동 추가 실패: $e');
      rethrow;
    }
  }

  /// 루틴에서 운동 제거
  Future<void> removeExerciseFromRoutine(String routineExerciseId) async {
    try {
      await _supabase
          .from(SupabaseTables.routineExercises)
          .delete()
          .eq('id', routineExerciseId);
    } catch (e) {
      print('루틴에서 운동 제거 실패: $e');
      rethrow;
    }
  }

  /// 루틴 운동 순서 변경
  Future<void> reorderRoutineExercises(
    String routineId,
    List<String> exerciseIds,
  ) async {
    try {
      for (int i = 0; i < exerciseIds.length; i++) {
        await _supabase
            .from(SupabaseTables.routineExercises)
            .update({'order_index': i})
            .eq('id', exerciseIds[i]);
      }
    } catch (e) {
      print('운동 순서 변경 실패: $e');
      rethrow;
    }
  }

  /// 프리셋 루틴을 사용자 루틴으로 복사
  Future<RoutineModel> copyPresetRoutine({
    required String userId,
    required PresetRoutineModel presetRoutine,
    int? dayNumber,
  }) async {
    try {
      // 1. 새 루틴 생성
      final routineResponse = await _supabase
          .from(SupabaseTables.routines)
          .insert({
            'user_id': userId,
            'name': presetRoutine.name,
            'description': presetRoutine.description,
            'source_type': RoutineSourceType.template.value,
            'target_muscles': presetRoutine.targetMuscles,
            'estimated_duration': presetRoutine.estimatedDurationMinutes,
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      final newRoutineId = routineResponse['id'] as String;

      // 2. 운동 복사 (특정 day만 또는 전체)
      List<PresetRoutineExerciseModel> exercisesToCopy;
      if (dayNumber != null) {
        exercisesToCopy = presetRoutine.exercisesByDay[dayNumber] ?? [];
      } else {
        exercisesToCopy = presetRoutine.exercises;
      }

      // 3. 루틴 운동 추가
      for (int i = 0; i < exercisesToCopy.length; i++) {
        final exercise = exercisesToCopy[i];
        await _supabase.from(SupabaseTables.routineExercises).insert({
          'routine_id': newRoutineId,
          'exercise_id': exercise.exerciseId,
          'order_index': i,
          'target_sets': exercise.targetSets,
          'target_reps': exercise.targetReps,
          'rest_seconds': exercise.restSeconds,
          'notes': exercise.notes,
        });
      }

      // 4. 완성된 루틴 반환
      return (await getRoutineById(newRoutineId))!;
    } catch (e) {
      print('프리셋 루틴 복사 실패: $e');
      rethrow;
    }
  }
}
