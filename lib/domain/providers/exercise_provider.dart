import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/dummy/dummy_exercises.dart';
import '../../data/models/exercise_model.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/exercise_repository.dart';

part 'exercise_provider.g.dart';

/// 모든 운동 목록 Provider
@riverpod
Future<List<ExerciseModel>> exercises(ExercisesRef ref) async {
  List<ExerciseModel> results;
  try {
    final repository = ref.watch(exerciseRepositoryProvider);
    results = await repository.getAllExercises();
  } catch (e) {
    print('=== Supabase 연결 실패, 더미 데이터 사용: $e ===');
    results = DummyExercises.exercises;
  }
  return _deduplicateExercises(results);
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
    print('=== Supabase 연결 실패, 더미 데이터 사용: $e ===');
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
    print('=== Supabase 연결 실패, 더미 데이터 사용: $e ===');
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
    print('=== Supabase 연결 실패, 더미 데이터 사용: $e ===');
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
    print('=== Supabase 연결 실패, 더미 데이터 사용: $e ===');
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
    print('=== Supabase 연결 실패, 더미 데이터 사용: $e ===');
    return DummyExercises.search(query);
  }
}

/// 운동 필터 상태 Provider
@riverpod
class ExerciseFilterState extends _$ExerciseFilterState {
  @override
  ExerciseFilter build() => const ExerciseFilter();

  void setMuscle(MuscleGroup? muscle) {
    state = ExerciseFilter(
      primaryMuscle: muscle,
      category: state.category,
      difficulty: state.difficulty,
      searchQuery: state.searchQuery,
    );
  }

  void setCategory(ExerciseCategory? category) {
    state = ExerciseFilter(
      primaryMuscle: state.primaryMuscle,
      category: category,
      difficulty: state.difficulty,
      searchQuery: state.searchQuery,
    );
  }

  void setDifficulty(ExperienceLevel? difficulty) {
    state = ExerciseFilter(
      primaryMuscle: state.primaryMuscle,
      category: state.category,
      difficulty: difficulty,
      searchQuery: state.searchQuery,
    );
  }

  void setSearchQuery(String? query) {
    state = ExerciseFilter(
      primaryMuscle: state.primaryMuscle,
      category: state.category,
      difficulty: state.difficulty,
      searchQuery: query,
    );
  }

  void clearFilters() {
    state = const ExerciseFilter();
  }
}

/// 운동 이름 정규화 (동의어 통합)
String _canonicalName(String name) {
  // "트라이셉" → "트라이셉스" (뒤에 "스"가 없는 경우만)
  return name.replaceAllMapped(
    RegExp(r'트라이셉(?!스)'),
    (m) => '트라이셉스',
  );
}

/// 이름 기반 중복 제거 헬퍼 (정규화 + 정식 이름 우선)
List<ExerciseModel> _deduplicateExercises(List<ExerciseModel> exercises) {
  // 1단계: 정규화 키별로 가장 정식(긴) 이름을 가진 운동 선택
  final bestByKey = <String, ExerciseModel>{};
  for (final e in exercises) {
    final key = _canonicalName(e.name);
    final existing = bestByKey[key];
    if (existing == null || e.name.length > existing.name.length) {
      bestByKey[key] = e;
    }
  }

  // 2단계: 원래 순서 유지하며 중복 제거
  final seen = <String>{};
  final result = <ExerciseModel>[];
  for (final e in exercises) {
    final key = _canonicalName(e.name);
    if (seen.contains(key)) continue;
    seen.add(key);
    result.add(bestByKey[key]!);
  }
  return result;
}

/// 필터링된 운동 목록 Provider
@riverpod
Future<List<ExerciseModel>> filteredExercises(FilteredExercisesRef ref) async {
  final filter = ref.watch(exerciseFilterStateProvider);

  List<ExerciseModel> results;
  try {
    final repository = ref.watch(exerciseRepositoryProvider);

    if (filter.isEmpty) {
      results = await repository.getAllExercises();
    } else {
      results = await repository.getFilteredExercises(
        primaryMuscle: filter.primaryMuscle,
        category: filter.category,
        difficulty: filter.difficulty,
        searchQuery: filter.searchQuery,
      );
    }
  } catch (e) {
    print('=== Supabase 연결 실패, 더미 데이터 사용: $e ===');
    results = DummyExercises.getFiltered(filter);
  }

  // 이름 기반 중복 제거
  return _deduplicateExercises(results);
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
