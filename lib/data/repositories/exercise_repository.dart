import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/exercise_model.dart';
import '../models/user_model.dart';
import '../services/supabase_service.dart';

part 'exercise_repository.g.dart';

/// Exercise Repository Provider
@riverpod
ExerciseRepository exerciseRepository(ExerciseRepositoryRef ref) {
  return ExerciseRepository(ref);
}

/// 운동 저장소
class ExerciseRepository {
  final ExerciseRepositoryRef _ref;

  ExerciseRepository(this._ref);

  SupabaseService get _supabase => _ref.read(supabaseServiceProvider);

  /// 모든 운동 목록 가져오기
  Future<List<ExerciseModel>> getAllExercises() async {
    try {
      final response = await _supabase
          .from(SupabaseTables.exercises)
          .select()
          .order('name');

      return (response as List)
          .map((e) => ExerciseModel.fromJson(e))
          .toList();
    } catch (e) {
      print('=== 운동 목록을 불러오는데 실패했습니다: $e ===');
      rethrow;
    }
  }

  /// 운동 ID로 운동 정보 가져오기
  Future<ExerciseModel?> getExerciseById(String exerciseId) async {
    try {
      final response = await _supabase
          .from(SupabaseTables.exercises)
          .select()
          .eq('id', exerciseId)
          .single();

      return ExerciseModel.fromJson(response);
    } catch (e) {
      print('=== 운동 정보를 불러오는데 실패했습니다: $e ===');
      return null;
    }
  }

  /// 근육 부위별 운동 목록 가져오기
  Future<List<ExerciseModel>> getExercisesByMuscle(MuscleGroup muscle) async {
    try {
      final response = await _supabase
          .from(SupabaseTables.exercises)
          .select()
          .eq('primary_muscle', muscle.value)
          .order('name');

      return (response as List)
          .map((e) => ExerciseModel.fromJson(e))
          .toList();
    } catch (e) {
      print('=== 근육 부위별 운동 목록을 불러오는데 실패했습니다: $e ===');
      rethrow;
    }
  }

  /// 카테고리별 운동 목록 가져오기
  Future<List<ExerciseModel>> getExercisesByCategory(ExerciseCategory category) async {
    try {
      final response = await _supabase
          .from(SupabaseTables.exercises)
          .select()
          .eq('category', category.value)
          .order('name');

      return (response as List)
          .map((e) => ExerciseModel.fromJson(e))
          .toList();
    } catch (e) {
      print('=== 카테고리별 운동 목록을 불러오는데 실패했습니다: $e ===');
      rethrow;
    }
  }

  /// 난이도별 운동 목록 가져오기
  Future<List<ExerciseModel>> getExercisesByDifficulty(ExperienceLevel difficulty) async {
    try {
      final response = await _supabase
          .from(SupabaseTables.exercises)
          .select()
          .eq('difficulty', difficulty.value)
          .order('name');

      return (response as List)
          .map((e) => ExerciseModel.fromJson(e))
          .toList();
    } catch (e) {
      print('=== 난이도별 운동 목록을 불러오는데 실패했습니다: $e ===');
      rethrow;
    }
  }

  /// 장비별 운동 목록 가져오기
  Future<List<ExerciseModel>> getExercisesByEquipment(String equipment) async {
    try {
      final response = await _supabase
          .from(SupabaseTables.exercises)
          .select()
          .contains('equipment_required', [equipment])
          .order('name');

      return (response as List)
          .map((e) => ExerciseModel.fromJson(e))
          .toList();
    } catch (e) {
      print('=== 장비별 운동 목록을 불러오는데 실패했습니다: $e ===');
      rethrow;
    }
  }

  /// 운동 검색
  Future<List<ExerciseModel>> searchExercises(String query) async {
    try {
      final response = await _supabase
          .from(SupabaseTables.exercises)
          .select()
          .or('name.ilike.%$query%,name_en.ilike.%$query%')
          .order('name');

      return (response as List)
          .map((e) => ExerciseModel.fromJson(e))
          .toList();
    } catch (e) {
      print('=== 운동 검색에 실패했습니다: $e ===');
      rethrow;
    }
  }

  /// 여러 운동 ID로 운동 목록 가져오기
  Future<List<ExerciseModel>> getExercisesByIds(List<String> exerciseIds) async {
    if (exerciseIds.isEmpty) return [];

    try {
      final response = await _supabase
          .from(SupabaseTables.exercises)
          .select()
          .inFilter('id', exerciseIds);

      return (response as List)
          .map((e) => ExerciseModel.fromJson(e))
          .toList();
    } catch (e) {
      print('=== 운동 목록을 불러오는데 실패했습니다: $e ===');
      rethrow;
    }
  }

  /// 필터링된 운동 목록 가져오기
  Future<List<ExerciseModel>> getFilteredExercises({
    MuscleGroup? primaryMuscle,
    ExerciseCategory? category,
    ExperienceLevel? difficulty,
    String? equipment,
    String? searchQuery,
  }) async {
    try {
      var query = _supabase.from(SupabaseTables.exercises).select();

      if (primaryMuscle != null) {
        // 상위 그룹 선택 시 관련 하위 근육 모두 포함
        final groupMapping = <MuscleGroup, List<String>>{
          MuscleGroup.legs: [
            'LEGS', 'QUADRICEPS', 'QUADS', 'HAMSTRINGS',
            'GLUTES', 'CALVES', 'HIP_FLEXORS',
          ],
          MuscleGroup.core: ['CORE', 'ABS', 'OBLIQUES'],
          MuscleGroup.back: ['BACK', 'LATS', 'TRAPS', 'LOWER_BACK'],
          MuscleGroup.shoulders: ['SHOULDERS', 'REAR_DELTS'],
          MuscleGroup.biceps: ['BICEPS', 'FOREARMS'],
        };

        final muscles = groupMapping[primaryMuscle];
        if (muscles != null) {
          query = query.inFilter('primary_muscle', muscles);
        } else {
          query = query.eq('primary_muscle', primaryMuscle.value);
        }
      }

      if (category != null) {
        query = query.eq('category', category.value);
      }

      if (difficulty != null) {
        query = query.eq('difficulty', difficulty.value);
      }

      if (equipment != null) {
        query = query.contains('equipment_required', [equipment]);
      }

      if (searchQuery != null && searchQuery.isNotEmpty) {
        query = query.or('name.ilike.%$searchQuery%,name_en.ilike.%$searchQuery%');
      }

      final response = await query.order('name');

      return (response as List)
          .map((e) => ExerciseModel.fromJson(e))
          .toList();
    } catch (e) {
      print('=== 필터링된 운동 목록을 불러오는데 실패했습니다: $e ===');
      rethrow;
    }
  }
}
