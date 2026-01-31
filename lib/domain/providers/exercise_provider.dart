import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/dummy/dummy_exercises.dart';
import '../../data/models/exercise_model.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/exercise_repository.dart';

part 'exercise_provider.g.dart';

/// 모든 운동 목록 Provider
@riverpod
Future<List<ExerciseModel>> exercises(ExercisesRef ref) async {
  try {
    final repository = ref.watch(exerciseRepositoryProvider);
    return await repository.getAllExercises();
  } catch (e) {
    debugPrint('⚠️ Supabase 연결 실패, 더미 데이터 사용: $e');
    return DummyExercises.exercises;
  }
}

/// 근육 부위별 운동 목록 Provider
@riverpod
Future<List<ExerciseModel>> exercisesByMuscle(
  ExercisesByMuscleRef ref,
  MuscleGroup muscle,
) async {
  try {
    final repository = ref.watch(exerciseRepositoryProvider);
    return await repository.getExercisesByMuscle(muscle);
  } catch (e) {
    debugPrint('⚠️ Supabase 연결 실패, 더미 데이터 사용: $e');
    return DummyExercises.getByMuscle(muscle);
  }
}

/// 카테고리별 운동 목록 Provider
@riverpod
Future<List<ExerciseModel>> exercisesByCategory(
  ExercisesByCategoryRef ref,
  ExerciseCategory category,
) async {
  try {
    final repository = ref.watch(exerciseRepositoryProvider);
    return await repository.getExercisesByCategory(category);
  } catch (e) {
    debugPrint('⚠️ Supabase 연결 실패, 더미 데이터 사용: $e');
    return DummyExercises.getByCategory(category);
  }
}

/// 난이도별 운동 목록 Provider
@riverpod
Future<List<ExerciseModel>> exercisesByDifficulty(
  ExercisesByDifficultyRef ref,
  ExperienceLevel difficulty,
) async {
  try {
    final repository = ref.watch(exerciseRepositoryProvider);
    return await repository.getExercisesByDifficulty(difficulty);
  } catch (e) {
    debugPrint('⚠️ Supabase 연결 실패, 더미 데이터 사용: $e');
    return DummyExercises.getByDifficulty(difficulty);
  }
}

/// 운동 상세 Provider
@riverpod
Future<ExerciseModel?> exerciseDetail(
  ExerciseDetailRef ref,
  String exerciseId,
) async {
  try {
    final repository = ref.watch(exerciseRepositoryProvider);
    return await repository.getExerciseById(exerciseId);
  } catch (e) {
    debugPrint('⚠️ Supabase 연결 실패, 더미 데이터 사용: $e');
    return DummyExercises.getById(exerciseId);
  }
}

/// 운동 검색 Provider
@riverpod
Future<List<ExerciseModel>> searchExercises(
  SearchExercisesRef ref,
  String query,
) async {
  if (query.isEmpty) return [];

  try {
    final repository = ref.watch(exerciseRepositoryProvider);
    return await repository.searchExercises(query);
  } catch (e) {
    debugPrint('⚠️ Supabase 연결 실패, 더미 데이터 사용: $e');
    return DummyExercises.search(query);
  }
}

/// 운동 필터 상태 Provider
@riverpod
class ExerciseFilterState extends _$ExerciseFilterState {
  @override
  ExerciseFilter build() => const ExerciseFilter();

  void setMuscle(MuscleGroup? muscle) {
    state = state.copyWith(primaryMuscle: muscle);
  }

  void setCategory(ExerciseCategory? category) {
    state = state.copyWith(category: category);
  }

  void setDifficulty(ExperienceLevel? difficulty) {
    state = state.copyWith(difficulty: difficulty);
  }

  void setSearchQuery(String? query) {
    state = state.copyWith(searchQuery: query);
  }

  void clearFilters() {
    state = const ExerciseFilter();
  }
}

/// 필터링된 운동 목록 Provider
@riverpod
Future<List<ExerciseModel>> filteredExercises(FilteredExercisesRef ref) async {
  final filter = ref.watch(exerciseFilterStateProvider);

  try {
    final repository = ref.watch(exerciseRepositoryProvider);

    if (filter.isEmpty) {
      return await repository.getAllExercises();
    }

    return await repository.getFilteredExercises(
      primaryMuscle: filter.primaryMuscle,
      category: filter.category,
      difficulty: filter.difficulty,
      searchQuery: filter.searchQuery,
    );
  } catch (e) {
    debugPrint('⚠️ Supabase 연결 실패, 더미 데이터 사용: $e');
    return DummyExercises.getFiltered(filter);
  }
}

/// 근육 그룹별 운동 목록 (그룹화) Provider
@riverpod
Future<Map<MuscleGroup, List<ExerciseModel>>> groupedExercises(
  GroupedExercisesRef ref,
) async {
  final exercises = await ref.watch(exercisesProvider.future);

  final Map<MuscleGroup, List<ExerciseModel>> grouped = {};

  for (final exercise in exercises) {
    grouped.putIfAbsent(exercise.primaryMuscle, () => []).add(exercise);
  }

  return grouped;
}

/// 운동 필터 모델
class ExerciseFilter {
  final MuscleGroup? primaryMuscle;
  final ExerciseCategory? category;
  final ExperienceLevel? difficulty;
  final String? searchQuery;

  const ExerciseFilter({
    this.primaryMuscle,
    this.category,
    this.difficulty,
    this.searchQuery,
  });

  bool get isEmpty =>
      primaryMuscle == null &&
      category == null &&
      difficulty == null &&
      (searchQuery == null || searchQuery!.isEmpty);

  ExerciseFilter copyWith({
    MuscleGroup? primaryMuscle,
    ExerciseCategory? category,
    ExperienceLevel? difficulty,
    String? searchQuery,
  }) {
    return ExerciseFilter(
      primaryMuscle: primaryMuscle ?? this.primaryMuscle,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
