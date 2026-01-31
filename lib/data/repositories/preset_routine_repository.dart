import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/preset_routine_model.dart';
import '../models/user_model.dart';
import '../services/supabase_service.dart';

part 'preset_routine_repository.g.dart';

/// 프리셋 루틴 Repository Provider
@riverpod
PresetRoutineRepository presetRoutineRepository(PresetRoutineRepositoryRef ref) {
  final supabase = ref.watch(supabaseServiceProvider);
  return PresetRoutineRepository(supabase);
}

/// 프리셋 루틴 Repository
class PresetRoutineRepository {
  final SupabaseService _supabase;

  PresetRoutineRepository(this._supabase);

  /// 모든 프리셋 루틴 조회
  Future<List<PresetRoutineModel>> getAllPresetRoutines() async {
    try {
      final response = await _supabase
          .from(SupabaseTables.presetRoutines)
          .select()
          .order('popularity_score', ascending: false)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => PresetRoutineModel.fromJson(json))
          .toList();
    } catch (e) {
      throw PresetRoutineException('프리셋 루틴 목록을 불러오는데 실패했습니다: $e');
    }
  }

  /// 추천(Featured) 프리셋 루틴만 조회
  Future<List<PresetRoutineModel>> getFeaturedPresetRoutines() async {
    try {
      final response = await _supabase
          .from(SupabaseTables.presetRoutines)
          .select()
          .eq('is_featured', true)
          .order('popularity_score', ascending: false);

      return (response as List)
          .map((json) => PresetRoutineModel.fromJson(json))
          .toList();
    } catch (e) {
      throw PresetRoutineException('추천 루틴을 불러오는데 실패했습니다: $e');
    }
  }

  /// 난이도별 프리셋 루틴 조회
  Future<List<PresetRoutineModel>> getPresetRoutinesByDifficulty(
    ExperienceLevel difficulty,
  ) async {
    try {
      final response = await _supabase
          .from(SupabaseTables.presetRoutines)
          .select()
          .eq('difficulty', difficulty.value)
          .order('popularity_score', ascending: false);

      return (response as List)
          .map((json) => PresetRoutineModel.fromJson(json))
          .toList();
    } catch (e) {
      throw PresetRoutineException('난이도별 루틴을 불러오는데 실패했습니다: $e');
    }
  }

  /// 목표별 프리셋 루틴 조회
  Future<List<PresetRoutineModel>> getPresetRoutinesByGoal(
    FitnessGoal targetGoal,
  ) async {
    try {
      final response = await _supabase
          .from(SupabaseTables.presetRoutines)
          .select()
          .eq('target_goal', targetGoal.value)
          .order('popularity_score', ascending: false);

      return (response as List)
          .map((json) => PresetRoutineModel.fromJson(json))
          .toList();
    } catch (e) {
      throw PresetRoutineException('목표별 루틴을 불러오는데 실패했습니다: $e');
    }
  }

  /// 필터 조건으로 프리셋 루틴 조회
  Future<List<PresetRoutineModel>> getFilteredPresetRoutines(
    PresetRoutineFilter filter,
  ) async {
    try {
      var query = _supabase
          .from(SupabaseTables.presetRoutines)
          .select();

      // 난이도 필터
      if (filter.difficulty != null) {
        query = query.eq('difficulty', filter.difficulty!.value);
      }

      // 목표 필터
      if (filter.targetGoal != null) {
        query = query.eq('target_goal', filter.targetGoal!.value);
      }

      // 추천 필터
      if (filter.isFeatured != null && filter.isFeatured!) {
        query = query.eq('is_featured', true);
      }

      // 검색어 필터
      if (filter.searchQuery != null && filter.searchQuery!.isNotEmpty) {
        query = query.or('name.ilike.%${filter.searchQuery}%,description.ilike.%${filter.searchQuery}%');
      }

      final response = await query
          .order('popularity_score', ascending: false)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => PresetRoutineModel.fromJson(json))
          .toList();
    } catch (e) {
      throw PresetRoutineException('필터된 루틴을 불러오는데 실패했습니다: $e');
    }
  }

  /// 프리셋 루틴 상세 조회 (운동 포함)
  Future<PresetRoutineModel> getPresetRoutineWithExercises(String routineId) async {
    try {
      // 1. 프리셋 루틴 기본 정보 조회
      final routineResponse = await _supabase
          .from(SupabaseTables.presetRoutines)
          .select()
          .eq('id', routineId)
          .single();

      // 2. 프리셋 루틴에 연결된 운동들 조회 (exercises 테이블 조인)
      final exercisesResponse = await _supabase
          .from(SupabaseTables.presetRoutineExercises)
          .select('''
            *,
            exercise:exercises(*)
          ''')
          .eq('preset_routine_id', routineId)
          .order('day_number')
          .order('order_index');

      // 3. 운동 데이터 파싱
      final exercises = (exercisesResponse as List).map((json) {
        final exerciseJson = json['exercise'] as Map<String, dynamic>?;
        return PresetRoutineExerciseModel.fromJson({
          ...json,
          'exercise': exerciseJson,
        });
      }).toList();

      // 4. 루틴 모델 생성 (운동 포함)
      return PresetRoutineModel.fromJson({
        ...routineResponse,
        'exercises': exercises.map((e) => e.toJson()).toList(),
      });
    } catch (e) {
      throw PresetRoutineException('프리셋 루틴 상세를 불러오는데 실패했습니다: $e');
    }
  }

  /// 프리셋 루틴의 특정 Day 운동들만 조회
  Future<List<PresetRoutineExerciseModel>> getPresetRoutineExercisesByDay(
    String routineId,
    int dayNumber,
  ) async {
    try {
      final response = await _supabase
          .from(SupabaseTables.presetRoutineExercises)
          .select('''
            *,
            exercise:exercises(*)
          ''')
          .eq('preset_routine_id', routineId)
          .eq('day_number', dayNumber)
          .order('order_index');

      return (response as List).map((json) {
        final exerciseJson = json['exercise'] as Map<String, dynamic>?;
        return PresetRoutineExerciseModel.fromJson({
          ...json,
          'exercise': exerciseJson,
        });
      }).toList();
    } catch (e) {
      throw PresetRoutineException('Day 운동 목록을 불러오는데 실패했습니다: $e');
    }
  }

  /// 인기도 점수 증가
  Future<void> incrementPopularityScore(String routineId) async {
    try {
      await _supabase.rpc(
        'increment_popularity_score',
        params: {'routine_id': routineId},
      );
    } catch (e) {
      // 실패해도 무시 (비필수 기능)
    }
  }
}

/// 프리셋 루틴 예외
class PresetRoutineException implements Exception {
  final String message;

  PresetRoutineException(this.message);

  @override
  String toString() => message;
}
