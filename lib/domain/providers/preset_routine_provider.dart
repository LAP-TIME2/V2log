import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/dummy/dummy_preset_routines.dart';
import '../../data/models/preset_routine_model.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/preset_routine_repository.dart';

part 'preset_routine_provider.g.dart';

/// 모든 프리셋 루틴 목록 Provider
/// Supabase 실패 시 더미 데이터 반환
@riverpod
Future<List<PresetRoutineModel>> presetRoutines(PresetRoutinesRef ref) async {
  try {
    final repository = ref.watch(presetRoutineRepositoryProvider);
    return await repository.getAllPresetRoutines();
  } catch (e) {
    print('⚠️ Supabase 연결 실패, 더미 데이터 사용: $e');
    return DummyPresetRoutines.presetRoutines;
  }
}

/// 추천(Featured) 프리셋 루틴 목록 Provider
@riverpod
Future<List<PresetRoutineModel>> featuredPresetRoutines(
  FeaturedPresetRoutinesRef ref,
) async {
  try {
    final repository = ref.watch(presetRoutineRepositoryProvider);
    return await repository.getFeaturedPresetRoutines();
  } catch (e) {
    print('⚠️ Supabase 연결 실패, 더미 데이터 사용: $e');
    return DummyPresetRoutines.getFeatured();
  }
}

/// 난이도별 프리셋 루틴 Provider
@riverpod
Future<List<PresetRoutineModel>> presetRoutinesByDifficulty(
  PresetRoutinesByDifficultyRef ref,
  ExperienceLevel difficulty,
) async {
  try {
    final repository = ref.watch(presetRoutineRepositoryProvider);
    return await repository.getPresetRoutinesByDifficulty(difficulty);
  } catch (e) {
    print('⚠️ Supabase 연결 실패, 더미 데이터 사용: $e');
    return DummyPresetRoutines.getByDifficulty(difficulty);
  }
}

/// 목표별 프리셋 루틴 Provider
@riverpod
Future<List<PresetRoutineModel>> presetRoutinesByGoal(
  PresetRoutinesByGoalRef ref,
  FitnessGoal targetGoal,
) async {
  try {
    final repository = ref.watch(presetRoutineRepositoryProvider);
    return await repository.getPresetRoutinesByGoal(targetGoal);
  } catch (e) {
    print('⚠️ Supabase 연결 실패, 더미 데이터 사용: $e');
    return DummyPresetRoutines.presetRoutines
        .where((r) => r.targetGoal == targetGoal)
        .toList();
  }
}

/// 프리셋 루틴 필터 상태 Provider
@riverpod
class PresetRoutineFilterState extends _$PresetRoutineFilterState {
  @override
  PresetRoutineFilter build() => const PresetRoutineFilter();

  /// 난이도 필터 설정
  void setDifficulty(ExperienceLevel? difficulty) {
    state = state.copyWith(difficulty: difficulty);
  }

  /// 목표 필터 설정
  void setTargetGoal(FitnessGoal? targetGoal) {
    state = state.copyWith(targetGoal: targetGoal);
  }

  /// 추천 필터 설정
  void setFeatured(bool? isFeatured) {
    state = state.copyWith(isFeatured: isFeatured);
  }

  /// 검색어 설정
  void setSearchQuery(String? query) {
    state = state.copyWith(searchQuery: query);
  }

  /// 필터 초기화
  void clearFilters() {
    state = const PresetRoutineFilter();
  }

  /// 전체 필터 설정
  void setFilter(PresetRoutineFilter filter) {
    state = filter;
  }
}

/// 필터링된 프리셋 루틴 목록 Provider
@riverpod
Future<List<PresetRoutineModel>> filteredPresetRoutines(
  FilteredPresetRoutinesRef ref,
) async {
  final filter = ref.watch(presetRoutineFilterStateProvider);

  try {
    final repository = ref.watch(presetRoutineRepositoryProvider);

    // 필터가 모두 비어있으면 전체 목록 반환
    if (filter.difficulty == null &&
        filter.targetGoal == null &&
        filter.isFeatured == null &&
        (filter.searchQuery == null || filter.searchQuery!.isEmpty)) {
      return await repository.getAllPresetRoutines();
    }

    return await repository.getFilteredPresetRoutines(filter);
  } catch (e) {
    print('⚠️ Supabase 연결 실패, 더미 데이터 사용: $e');

    // 더미 데이터에서 필터링
    var routines = DummyPresetRoutines.presetRoutines;

    if (filter.difficulty != null) {
      routines = routines.where((r) => r.difficulty == filter.difficulty).toList();
    }

    if (filter.targetGoal != null) {
      routines = routines.where((r) => r.targetGoal == filter.targetGoal).toList();
    }

    if (filter.isFeatured == true) {
      routines = routines.where((r) => r.isFeatured).toList();
    }

    if (filter.searchQuery != null && filter.searchQuery!.isNotEmpty) {
      final query = filter.searchQuery!.toLowerCase();
      routines = routines.where((r) =>
          r.name.toLowerCase().contains(query) ||
          (r.description?.toLowerCase().contains(query) ?? false)
      ).toList();
    }

    return routines;
  }
}

/// 프리셋 루틴 상세 Provider (운동 포함)
@riverpod
Future<PresetRoutineModel> presetRoutineDetail(
  PresetRoutineDetailRef ref,
  String routineId,
) async {
  try {
    final repository = ref.watch(presetRoutineRepositoryProvider);

    // 인기도 점수 증가 (비동기, 실패해도 무시)
    unawaited(repository.incrementPopularityScore(routineId));

    return await repository.getPresetRoutineWithExercises(routineId);
  } catch (e) {
    print('⚠️ Supabase 연결 실패, 더미 데이터 사용: $e');
    final routine = DummyPresetRoutines.getById(routineId);
    if (routine == null) {
      throw Exception('루틴을 찾을 수 없습니다: $routineId');
    }
    return routine;
  }
}

/// 프리셋 루틴의 특정 Day 운동 목록 Provider
@riverpod
Future<List<PresetRoutineExerciseModel>> presetRoutineDayExercises(
  PresetRoutineDayExercisesRef ref,
  String routineId,
  int dayNumber,
) async {
  try {
    final repository = ref.watch(presetRoutineRepositoryProvider);
    return await repository.getPresetRoutineExercisesByDay(routineId, dayNumber);
  } catch (e) {
    print('⚠️ Supabase 연결 실패, 더미 데이터 사용: $e');
    final routine = DummyPresetRoutines.getById(routineId);
    if (routine == null) return [];
    return routine.exercisesByDay[dayNumber] ?? [];
  }
}

/// 선택된 프리셋 루틴 ID Provider
@riverpod
class SelectedPresetRoutineId extends _$SelectedPresetRoutineId {
  @override
  String? build() => null;

  void select(String routineId) {
    state = routineId;
  }

  void clear() {
    state = null;
  }
}

/// 선택된 Day 번호 Provider
@riverpod
class SelectedDayNumber extends _$SelectedDayNumber {
  @override
  int build() => 1;

  void select(int dayNumber) {
    state = dayNumber;
  }

  void reset() {
    state = 1;
  }
}

/// 선택된 프리셋 루틴 상세 (선택된 ID 기반)
@riverpod
Future<PresetRoutineModel?> selectedPresetRoutineDetail(
  SelectedPresetRoutineDetailRef ref,
) async {
  final routineId = ref.watch(selectedPresetRoutineIdProvider);
  if (routineId == null) return null;

  return await ref.watch(presetRoutineDetailProvider(routineId).future);
}

/// 난이도별 그룹화된 프리셋 루틴 Provider
@riverpod
Future<Map<ExperienceLevel, List<PresetRoutineModel>>> groupedPresetRoutines(
  GroupedPresetRoutinesRef ref,
) async {
  final routines = await ref.watch(presetRoutinesProvider.future);

  final Map<ExperienceLevel, List<PresetRoutineModel>> grouped = {
    ExperienceLevel.beginner: [],
    ExperienceLevel.intermediate: [],
    ExperienceLevel.advanced: [],
  };

  for (final routine in routines) {
    grouped[routine.difficulty]?.add(routine);
  }

  return grouped;
}
