import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:v2log/shared/dummy/dummy_routines.dart';
import 'package:v2log/shared/models/exercise_model.dart';
import 'package:v2log/shared/models/preset_routine_model.dart';
import 'package:v2log/shared/models/routine_model.dart';
import 'package:v2log/features/routine/data/routine_repository.dart';
import 'package:v2log/features/auth/domain/auth_provider.dart';

part 'routine_provider.g.dart';

/// 사용자의 모든 루틴 목록 Provider
@riverpod
Future<List<RoutineModel>> userRoutines(UserRoutinesRef ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return [];

  try {
    final repository = ref.watch(routineRepositoryProvider);
    return await repository.getUserRoutines(userId);
  } catch (e) {
    return DummyRoutines.routines;
  }
}

/// 루틴 상세 Provider
@riverpod
Future<RoutineModel?> routineDetail(
  RoutineDetailRef ref,
  String routineId,
) async {
  try {
    final repository = ref.watch(routineRepositoryProvider);
    return await repository.getRoutineById(routineId);
  } catch (_) {
    return DummyRoutines.getById(routineId);
  }
}

/// 선택된 루틴 ID Provider
@riverpod
class SelectedRoutineId extends _$SelectedRoutineId {
  @override
  String? build() => null;

  void select(String routineId) {
    state = routineId;
  }

  void clear() {
    state = null;
  }
}

/// 선택된 루틴 상세 Provider
@riverpod
Future<RoutineModel?> selectedRoutineDetail(SelectedRoutineDetailRef ref) async {
  final routineId = ref.watch(selectedRoutineIdProvider);
  if (routineId == null) return null;

  return await ref.watch(routineDetailProvider(routineId).future);
}

/// 루틴 관리 Provider (생성, 수정, 삭제)
@riverpod
class RoutineManager extends _$RoutineManager {
  @override
  FutureOr<void> build() {}

  /// 새 루틴 생성
  Future<RoutineModel> createRoutine({
    required String name,
    String? description,
    List<MuscleGroup>? targetMuscles,
    int? estimatedDuration,
  }) async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) throw Exception('로그인이 필요합니다');

    state = const AsyncLoading();

    try {
      final repository = ref.read(routineRepositoryProvider);
      final routine = await repository.createRoutine(
        userId: userId,
        name: name,
        description: description,
        targetMuscles: targetMuscles,
        estimatedDuration: estimatedDuration,
      );

      // 루틴 목록 갱신
      ref.invalidate(userRoutinesProvider);

      state = const AsyncData(null);
      return routine;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }

  /// 루틴 수정
  Future<RoutineModel> updateRoutine(RoutineModel routine) async {
    state = const AsyncLoading();

    try {
      final repository = ref.read(routineRepositoryProvider);
      final updated = await repository.updateRoutine(routine);

      // 루틴 목록 및 상세 갱신
      ref.invalidate(userRoutinesProvider);
      ref.invalidate(routineDetailProvider(routine.id));

      state = const AsyncData(null);
      return updated;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }

  /// 루틴 삭제
  Future<void> deleteRoutine(String routineId) async {
    state = const AsyncLoading();

    try {
      final repository = ref.read(routineRepositoryProvider);
      await repository.deleteRoutine(routineId);

      // 루틴 목록 갱신
      ref.invalidate(userRoutinesProvider);

      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }

  /// 루틴에 운동 추가
  Future<void> addExerciseToRoutine({
    required String routineId,
    required String exerciseId,
    required int orderIndex,
    int targetSets = 3,
    String targetReps = '10-12',
    double? targetWeight,
    int restSeconds = 90,
    String? notes,
  }) async {
    state = const AsyncLoading();

    try {
      final repository = ref.read(routineRepositoryProvider);
      await repository.addExerciseToRoutine(
        routineId: routineId,
        exerciseId: exerciseId,
        orderIndex: orderIndex,
        targetSets: targetSets,
        targetReps: targetReps,
        targetWeight: targetWeight,
        restSeconds: restSeconds,
        notes: notes,
      );

      // 루틴 상세 갱신
      ref.invalidate(routineDetailProvider(routineId));

      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }

  /// 루틴에서 운동 제거
  Future<void> removeExerciseFromRoutine({
    required String routineId,
    required String routineExerciseId,
  }) async {
    state = const AsyncLoading();

    try {
      final repository = ref.read(routineRepositoryProvider);
      await repository.removeExerciseFromRoutine(routineExerciseId);

      // 루틴 상세 갱신
      ref.invalidate(routineDetailProvider(routineId));

      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }

  /// 프리셋 루틴을 사용자 루틴으로 복사
  Future<RoutineModel> copyPresetRoutine({
    required PresetRoutineModel presetRoutine,
    int? dayNumber,
  }) async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) throw Exception('로그인이 필요합니다');

    state = const AsyncLoading();

    try {
      final repository = ref.read(routineRepositoryProvider);
      final routine = await repository.copyPresetRoutine(
        userId: userId,
        presetRoutine: presetRoutine,
        dayNumber: dayNumber,
      );

      // 루틴 목록 갱신
      ref.invalidate(userRoutinesProvider);

      state = const AsyncData(null);
      return routine;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }
}

/// 활성 루틴 목록 Provider (is_active = true)
@riverpod
Future<List<RoutineModel>> activeRoutines(ActiveRoutinesRef ref) async {
  final routines = await ref.watch(userRoutinesProvider.future);
  return routines.where((r) => r.isActive).toList();
}

/// 최근 사용 루틴 Provider
@riverpod
Future<List<RoutineModel>> recentRoutines(RecentRoutinesRef ref) async {
  final routines = await ref.watch(userRoutinesProvider.future);

  // 최근 업데이트 순으로 정렬하고 상위 5개 반환
  final sorted = [...routines]..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  return sorted.take(5).toList();
}
