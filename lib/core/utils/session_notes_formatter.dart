import '../../../data/dummy/dummy_exercises.dart';
import '../../../data/dummy/dummy_preset_routines.dart';

/// 세션 메모에서 운동별 메모를 추출하고 exercise_id를 운동명으로 변환
String formatSessionNotes(String? notes, Map<String, String> exerciseNames) {
  if (notes == null || notes.isEmpty) {
    return '';
  }

  // exercise_id가 포함된 경우 운동명으로 변환
  final parts = notes.split(' / ');
  final formattedParts = <String>[];

  for (final part in parts) {
    final colonIndex = part.indexOf(':');
    if (colonIndex > 0) {
      var key = part.substring(0, colonIndex).trim();
      final note = part.substring(colonIndex + 1).trim();

      // exercise_id인 경우 운동명으로 변환 (UUID 또는 ex-001 형식)
      if (key.contains('00000000-') || key.length == 36 || RegExp(r'^ex-\d+$').hasMatch(key)) {
        final exerciseName = getExerciseNameFromId(key, exerciseNames);
        if (exerciseName != key) {
          // 운동명을 찾은 경우
          key = exerciseName;
        } else if (RegExp(r'^ex-\d+$').hasMatch(key)) {
          // 찾지 못한 경우 'ex-XXX' prefix 제거 (메모만 표시)
          key = '';
        }
      }
      if (key.isNotEmpty) {
        formattedParts.add('$key: $note');
      } else {
        formattedParts.add(note);
      }
    } else {
      formattedParts.add(part);
    }
  }

  return formattedParts.join(' / ');
}

/// exercise_id로 운동명 찾기
String getExerciseNameFromId(String exerciseId, Map<String, String> exerciseNames) {
  // Supabase에서 가져온 이름 맵에서 찾기
  if (exerciseNames.containsKey(exerciseId)) {
    return exerciseNames[exerciseId]!;
  }

  // DummyExercises에서 찾기
  final exercise = DummyExercises.getById(exerciseId);
  if (exercise != null) {
    return exercise.name;
  }

  // DummyPresetRoutines에서 찾기
  final presetExercise = DummyPresetRoutines.getExerciseById(exerciseId);
  if (presetExercise != null) {
    return presetExercise.name;
  }

  return exerciseId;
}
