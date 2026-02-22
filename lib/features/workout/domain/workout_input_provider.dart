import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:v2log/shared/models/exercise_model.dart';
import 'package:v2log/shared/models/workout_set_model.dart';

part 'workout_input_provider.g.dart';

/// 운동 입력 상태 (무게, 반복, 세트 타입, 메모 등)
@riverpod
class WorkoutInput extends _$WorkoutInput {
  @override
  WorkoutInputState build() => const WorkoutInputState();

  void setWeight(double weight) {
    state = state.copyWith(currentWeight: weight);
  }

  void setReps(int reps) {
    state = state.copyWith(currentReps: reps);
  }

  void setSetType(SetType setType) {
    state = state.copyWith(currentSetType: setType);
  }

  void setFreeExercise(ExerciseModel? exercise) {
    state = state.copyWith(
      freeExercise: exercise,
      clearFreeExercise: exercise == null,
    );
  }

  void setSupersetPartnerExercise(ExerciseModel? exercise) {
    state = state.copyWith(
      supersetPartnerExercise: exercise,
      clearSupersetPartnerExercise: exercise == null,
    );
  }

  void setSupersetIsOnPartner(bool isOnPartner) {
    state = state.copyWith(supersetIsOnPartner: isOnPartner);
  }

  void setExerciseNote(String exerciseId, String note) {
    final newNotes = Map<String, String>.from(state.exerciseNotes);
    if (note.isEmpty) {
      newNotes.remove(exerciseId);
    } else {
      newNotes[exerciseId] = note;
    }
    state = state.copyWith(exerciseNotes: newNotes);
  }

  String getExerciseNote(String exerciseId) {
    return state.exerciseNotes[exerciseId] ?? '';
  }

  /// 슈퍼세트 운동 A ↔ B 스왑
  void swapSupersetExercises() {
    final temp = state.freeExercise;
    state = state.copyWith(
      freeExercise: state.supersetPartnerExercise,
      supersetPartnerExercise: temp,
      supersetIsOnPartner: !state.supersetIsOnPartner,
      clearFreeExercise: state.supersetPartnerExercise == null,
      clearSupersetPartnerExercise: temp == null,
    );
  }

  /// 운동 변경 시 슈퍼세트 상태 초기화
  void resetSupersetState() {
    state = state.copyWith(
      supersetPartnerExercise: null,
      clearSupersetPartnerExercise: true,
      supersetIsOnPartner: false,
      currentSetType: SetType.working,
    );
  }
}

/// 운동 입력 상태 모델
class WorkoutInputState {
  final double currentWeight;
  final int currentReps;
  final SetType currentSetType;
  final ExerciseModel? freeExercise;
  final ExerciseModel? supersetPartnerExercise;
  final bool supersetIsOnPartner;
  final Map<String, String> exerciseNotes;

  const WorkoutInputState({
    this.currentWeight = 60.0,
    this.currentReps = 10,
    this.currentSetType = SetType.working,
    this.freeExercise,
    this.supersetPartnerExercise,
    this.supersetIsOnPartner = false,
    this.exerciseNotes = const {},
  });

  WorkoutInputState copyWith({
    double? currentWeight,
    int? currentReps,
    SetType? currentSetType,
    ExerciseModel? freeExercise,
    bool clearFreeExercise = false,
    ExerciseModel? supersetPartnerExercise,
    bool clearSupersetPartnerExercise = false,
    bool? supersetIsOnPartner,
    Map<String, String>? exerciseNotes,
  }) {
    return WorkoutInputState(
      currentWeight: currentWeight ?? this.currentWeight,
      currentReps: currentReps ?? this.currentReps,
      currentSetType: currentSetType ?? this.currentSetType,
      freeExercise:
          clearFreeExercise ? null : (freeExercise ?? this.freeExercise),
      supersetPartnerExercise: clearSupersetPartnerExercise
          ? null
          : (supersetPartnerExercise ?? this.supersetPartnerExercise),
      supersetIsOnPartner:
          supersetIsOnPartner ?? this.supersetIsOnPartner,
      exerciseNotes: exerciseNotes ?? this.exerciseNotes,
    );
  }
}
