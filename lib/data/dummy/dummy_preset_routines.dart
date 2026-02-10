import '../models/exercise_model.dart';
import '../models/preset_routine_model.dart';
import '../models/user_model.dart';
import 'dummy_exercises.dart';

/// 테스트용 더미 프리셋 루틴 데이터
class DummyPresetRoutines {
  DummyPresetRoutines._();

  /// 운동 ID로 운동 찾기 (DummyExercises에서 조회)
  static ExerciseModel? getExerciseById(String id) {
    return DummyExercises.getById(id);
  }

  // === DummyExercises ID 상수 (가독성용) ===
  // 가슴
  static const _benchPress = '10000000-0001-4000-8000-000000000001';
  static const _inclineBenchPress = '10000000-0001-4000-8000-000000000006';
  static const _dbBenchPress = '10000000-0001-4000-8000-000000000007';
  static const _pecDeckFly = '10000000-0001-4000-8000-000000000005';
  // 등
  static const _deadlift = '10000000-0001-4000-8000-000000000010';
  static const _latPulldown = '10000000-0001-4000-8000-000000000011';
  static const _seatedCableRow = '10000000-0001-4000-8000-000000000013';
  static const _oneArmDbRow = '10000000-0001-4000-8000-000000000015';
  static const _pullUp = '10000000-0001-4000-8000-000000000014';
  // 어깨
  static const _dbShoulderPress = '10000000-0001-4000-8000-000000000021';
  static const _sideLateralRaise = '10000000-0001-4000-8000-000000000022';
  static const _frontRaise = '10000000-0001-4000-8000-000000000025';
  // 팔
  static const _barbellCurl = '10000000-0001-4000-8000-000000000030';
  static const _hammerCurl = '10000000-0001-4000-8000-000000000031';
  static const _tricepsPushdown = '10000000-0001-4000-8000-000000000032';
  static const _overheadTricepsExt = '10000000-0001-4000-8000-000000000033';
  static const _dbCurl = '10000000-0001-4000-8000-000000000035';
  // 하체
  static const _squat = '10000000-0001-4000-8000-000000000040';
  static const _legPress = '10000000-0001-4000-8000-000000000041';
  static const _legExtension = '10000000-0001-4000-8000-000000000042';
  static const _legCurl = '10000000-0001-4000-8000-000000000043';
  static const _lunge = '10000000-0001-4000-8000-000000000044';
  static const _romanianDL = '10000000-0001-4000-8000-000000000047';
  // 복근
  static const _crunch = '10000000-0001-4000-8000-000000000050';
  static const _legRaise = '10000000-0001-4000-8000-000000000051';
  static const _plank = '10000000-0001-4000-8000-000000000052';
  static const _russianTwist = '10000000-0001-4000-8000-000000000053';

  /// 더미 프리셋 루틴 데이터 (5개)
  static final List<PresetRoutineModel> presetRoutines = [
    // 1. 초보자 3분할 프로그램
    PresetRoutineModel(
      id: 'preset-001',
      name: '초보자 3분할 프로그램',
      nameEn: 'Beginner 3-Day Split',
      description: '헬스 입문자를 위한 기본 루틴입니다. 가슴/등/하체를 나누어 주 3회 진행하며, 기초 근력과 올바른 자세를 만드는 데 집중합니다.',
      difficulty: ExperienceLevel.beginner,
      targetGoal: FitnessGoal.hypertrophy,
      daysPerWeek: 3,
      estimatedDurationMinutes: 60,
      targetMuscles: ['CHEST', 'BACK', 'LEGS', 'SHOULDERS', 'ARMS'],
      equipmentRequired: ['바벨', '덤벨', '머신'],
      isFeatured: true,
      popularityScore: 100,
      createdBy: 'V2log Team',
      exercises: [
        // Day 1: 가슴/삼두
        PresetRoutineExerciseModel(id: 'pre-001-01', presetRoutineId: 'preset-001', exerciseId: _benchPress, dayNumber: 1, dayName: 'Day 1 - 가슴/삼두', orderIndex: 1, targetSets: 4, targetReps: '8-10', restSeconds: 120, notes: '첫 세트는 워밍업', exercise: getExerciseById(_benchPress)),
        PresetRoutineExerciseModel(id: 'pre-001-02', presetRoutineId: 'preset-001', exerciseId: _inclineBenchPress, dayNumber: 1, dayName: 'Day 1 - 가슴/삼두', orderIndex: 2, targetSets: 3, targetReps: '10-12', restSeconds: 90, exercise: getExerciseById(_inclineBenchPress)),
        PresetRoutineExerciseModel(id: 'pre-001-03', presetRoutineId: 'preset-001', exerciseId: _pecDeckFly, dayNumber: 1, dayName: 'Day 1 - 가슴/삼두', orderIndex: 3, targetSets: 3, targetReps: '12-15', restSeconds: 60, notes: '가슴 수축에 집중', exercise: getExerciseById(_pecDeckFly)),
        PresetRoutineExerciseModel(id: 'pre-001-04', presetRoutineId: 'preset-001', exerciseId: _tricepsPushdown, dayNumber: 1, dayName: 'Day 1 - 가슴/삼두', orderIndex: 4, targetSets: 3, targetReps: '12-15', restSeconds: 60, exercise: getExerciseById(_tricepsPushdown)),
        PresetRoutineExerciseModel(id: 'pre-001-05', presetRoutineId: 'preset-001', exerciseId: _overheadTricepsExt, dayNumber: 1, dayName: 'Day 1 - 가슴/삼두', orderIndex: 5, targetSets: 3, targetReps: '10-12', restSeconds: 60, exercise: getExerciseById(_overheadTricepsExt)),
        // Day 2: 등/이두
        PresetRoutineExerciseModel(id: 'pre-001-06', presetRoutineId: 'preset-001', exerciseId: _latPulldown, dayNumber: 2, dayName: 'Day 2 - 등/이두', orderIndex: 1, targetSets: 4, targetReps: '10-12', restSeconds: 90, notes: '광배근 수축에 집중', exercise: getExerciseById(_latPulldown)),
        PresetRoutineExerciseModel(id: 'pre-001-07', presetRoutineId: 'preset-001', exerciseId: _seatedCableRow, dayNumber: 2, dayName: 'Day 2 - 등/이두', orderIndex: 2, targetSets: 3, targetReps: '10-12', restSeconds: 90, exercise: getExerciseById(_seatedCableRow)),
        PresetRoutineExerciseModel(id: 'pre-001-08', presetRoutineId: 'preset-001', exerciseId: _oneArmDbRow, dayNumber: 2, dayName: 'Day 2 - 등/이두', orderIndex: 3, targetSets: 3, targetReps: '10-12', restSeconds: 60, notes: '각 팔당', exercise: getExerciseById(_oneArmDbRow)),
        PresetRoutineExerciseModel(id: 'pre-001-09', presetRoutineId: 'preset-001', exerciseId: _barbellCurl, dayNumber: 2, dayName: 'Day 2 - 등/이두', orderIndex: 4, targetSets: 3, targetReps: '10-12', restSeconds: 60, exercise: getExerciseById(_barbellCurl)),
        PresetRoutineExerciseModel(id: 'pre-001-10', presetRoutineId: 'preset-001', exerciseId: _hammerCurl, dayNumber: 2, dayName: 'Day 2 - 등/이두', orderIndex: 5, targetSets: 3, targetReps: '12-15', restSeconds: 60, exercise: getExerciseById(_hammerCurl)),
        // Day 3: 하체/어깨
        PresetRoutineExerciseModel(id: 'pre-001-11', presetRoutineId: 'preset-001', exerciseId: _legPress, dayNumber: 3, dayName: 'Day 3 - 하체/어깨', orderIndex: 1, targetSets: 4, targetReps: '10-12', restSeconds: 120, notes: '스쿼트 대신 초보자용', exercise: getExerciseById(_legPress)),
        PresetRoutineExerciseModel(id: 'pre-001-12', presetRoutineId: 'preset-001', exerciseId: _legExtension, dayNumber: 3, dayName: 'Day 3 - 하체/어깨', orderIndex: 2, targetSets: 3, targetReps: '12-15', restSeconds: 60, exercise: getExerciseById(_legExtension)),
        PresetRoutineExerciseModel(id: 'pre-001-13', presetRoutineId: 'preset-001', exerciseId: _legCurl, dayNumber: 3, dayName: 'Day 3 - 하체/어깨', orderIndex: 3, targetSets: 3, targetReps: '12-15', restSeconds: 60, exercise: getExerciseById(_legCurl)),
        PresetRoutineExerciseModel(id: 'pre-001-14', presetRoutineId: 'preset-001', exerciseId: _dbShoulderPress, dayNumber: 3, dayName: 'Day 3 - 하체/어깨', orderIndex: 4, targetSets: 3, targetReps: '10-12', restSeconds: 90, exercise: getExerciseById(_dbShoulderPress)),
        PresetRoutineExerciseModel(id: 'pre-001-15', presetRoutineId: 'preset-001', exerciseId: _sideLateralRaise, dayNumber: 3, dayName: 'Day 3 - 하체/어깨', orderIndex: 5, targetSets: 3, targetReps: '15-20', restSeconds: 60, notes: '가볍게 많은 반복', exercise: getExerciseById(_sideLateralRaise)),
      ],
    ),

    // 2. 중급자 4분할 프로그램
    PresetRoutineModel(
      id: 'preset-002',
      name: '중급자 4분할 프로그램',
      nameEn: 'Intermediate 4-Day Split',
      description: '어느 정도 경험이 있는 분들을 위한 루틴입니다. 상체/하체를 세분화하여 더 집중적인 자극을 줍니다.',
      difficulty: ExperienceLevel.intermediate,
      targetGoal: FitnessGoal.hypertrophy,
      daysPerWeek: 4,
      estimatedDurationMinutes: 75,
      targetMuscles: ['CHEST', 'BACK', 'LEGS', 'SHOULDERS', 'ARMS'],
      equipmentRequired: ['바벨', '덤벨', '케이블 머신', '머신'],
      isFeatured: true,
      popularityScore: 85,
      createdBy: 'V2log Team',
      exercises: [
        // Day 1: 가슴
        PresetRoutineExerciseModel(id: 'pre-002-01', presetRoutineId: 'preset-002', exerciseId: _benchPress, dayNumber: 1, dayName: 'Day 1 - 가슴', orderIndex: 1, targetSets: 4, targetReps: '6-8', restSeconds: 180, notes: '무거운 무게로', exercise: getExerciseById(_benchPress)),
        PresetRoutineExerciseModel(id: 'pre-002-02', presetRoutineId: 'preset-002', exerciseId: _inclineBenchPress, dayNumber: 1, dayName: 'Day 1 - 가슴', orderIndex: 2, targetSets: 4, targetReps: '8-10', restSeconds: 120, exercise: getExerciseById(_inclineBenchPress)),
        PresetRoutineExerciseModel(id: 'pre-002-03', presetRoutineId: 'preset-002', exerciseId: _dbBenchPress, dayNumber: 1, dayName: 'Day 1 - 가슴', orderIndex: 3, targetSets: 3, targetReps: '10-12', restSeconds: 90, exercise: getExerciseById(_dbBenchPress)),
        PresetRoutineExerciseModel(id: 'pre-002-04', presetRoutineId: 'preset-002', exerciseId: _pecDeckFly, dayNumber: 1, dayName: 'Day 1 - 가슴', orderIndex: 4, targetSets: 3, targetReps: '12-15', restSeconds: 60, notes: '수축에 집중', exercise: getExerciseById(_pecDeckFly)),
        // Day 2: 등
        PresetRoutineExerciseModel(id: 'pre-002-05', presetRoutineId: 'preset-002', exerciseId: _deadlift, dayNumber: 2, dayName: 'Day 2 - 등', orderIndex: 1, targetSets: 4, targetReps: '5-6', restSeconds: 180, notes: '허리 주의', exercise: getExerciseById(_deadlift)),
        PresetRoutineExerciseModel(id: 'pre-002-06', presetRoutineId: 'preset-002', exerciseId: _pullUp, dayNumber: 2, dayName: 'Day 2 - 등', orderIndex: 2, targetSets: 4, targetReps: '8-10', restSeconds: 90, notes: '보조 사용 가능', exercise: getExerciseById(_pullUp)),
        PresetRoutineExerciseModel(id: 'pre-002-07', presetRoutineId: 'preset-002', exerciseId: _seatedCableRow, dayNumber: 2, dayName: 'Day 2 - 등', orderIndex: 3, targetSets: 3, targetReps: '10-12', restSeconds: 90, exercise: getExerciseById(_seatedCableRow)),
        PresetRoutineExerciseModel(id: 'pre-002-08', presetRoutineId: 'preset-002', exerciseId: _latPulldown, dayNumber: 2, dayName: 'Day 2 - 등', orderIndex: 4, targetSets: 3, targetReps: '10-12', restSeconds: 90, exercise: getExerciseById(_latPulldown)),
        // Day 3: 어깨/팔
        PresetRoutineExerciseModel(id: 'pre-002-09', presetRoutineId: 'preset-002', exerciseId: _dbShoulderPress, dayNumber: 3, dayName: 'Day 3 - 어깨/팔', orderIndex: 1, targetSets: 4, targetReps: '8-10', restSeconds: 120, exercise: getExerciseById(_dbShoulderPress)),
        PresetRoutineExerciseModel(id: 'pre-002-10', presetRoutineId: 'preset-002', exerciseId: _sideLateralRaise, dayNumber: 3, dayName: 'Day 3 - 어깨/팔', orderIndex: 2, targetSets: 4, targetReps: '12-15', restSeconds: 60, exercise: getExerciseById(_sideLateralRaise)),
        PresetRoutineExerciseModel(id: 'pre-002-11', presetRoutineId: 'preset-002', exerciseId: _barbellCurl, dayNumber: 3, dayName: 'Day 3 - 어깨/팔', orderIndex: 3, targetSets: 3, targetReps: '10-12', restSeconds: 60, exercise: getExerciseById(_barbellCurl)),
        PresetRoutineExerciseModel(id: 'pre-002-12', presetRoutineId: 'preset-002', exerciseId: _tricepsPushdown, dayNumber: 3, dayName: 'Day 3 - 어깨/팔', orderIndex: 4, targetSets: 3, targetReps: '10-12', restSeconds: 60, exercise: getExerciseById(_tricepsPushdown)),
        PresetRoutineExerciseModel(id: 'pre-002-13', presetRoutineId: 'preset-002', exerciseId: _hammerCurl, dayNumber: 3, dayName: 'Day 3 - 어깨/팔', orderIndex: 5, targetSets: 3, targetReps: '12-15', restSeconds: 60, exercise: getExerciseById(_hammerCurl)),
        // Day 4: 하체
        PresetRoutineExerciseModel(id: 'pre-002-14', presetRoutineId: 'preset-002', exerciseId: _squat, dayNumber: 4, dayName: 'Day 4 - 하체', orderIndex: 1, targetSets: 4, targetReps: '6-8', restSeconds: 180, notes: '코어 힘 유지', exercise: getExerciseById(_squat)),
        PresetRoutineExerciseModel(id: 'pre-002-15', presetRoutineId: 'preset-002', exerciseId: _legPress, dayNumber: 4, dayName: 'Day 4 - 하체', orderIndex: 2, targetSets: 4, targetReps: '10-12', restSeconds: 120, exercise: getExerciseById(_legPress)),
        PresetRoutineExerciseModel(id: 'pre-002-16', presetRoutineId: 'preset-002', exerciseId: _romanianDL, dayNumber: 4, dayName: 'Day 4 - 하체', orderIndex: 3, targetSets: 4, targetReps: '8-10', restSeconds: 120, notes: '햄스트링 스트레칭', exercise: getExerciseById(_romanianDL)),
        PresetRoutineExerciseModel(id: 'pre-002-17', presetRoutineId: 'preset-002', exerciseId: _legExtension, dayNumber: 4, dayName: 'Day 4 - 하체', orderIndex: 4, targetSets: 3, targetReps: '12-15', restSeconds: 60, exercise: getExerciseById(_legExtension)),
        PresetRoutineExerciseModel(id: 'pre-002-18', presetRoutineId: 'preset-002', exerciseId: _legCurl, dayNumber: 4, dayName: 'Day 4 - 하체', orderIndex: 5, targetSets: 3, targetReps: '12-15', restSeconds: 60, exercise: getExerciseById(_legCurl)),
      ],
    ),

    // 3. 홈트레이닝 덤벨 루틴
    PresetRoutineModel(
      id: 'preset-003',
      name: '홈트레이닝 덤벨 루틴',
      nameEn: 'Home Dumbbell Workout',
      description: '덤벨만으로 진행할 수 있는 홈트레이닝 루틴입니다. 집에서도 효과적으로 전신을 단련할 수 있습니다.',
      difficulty: ExperienceLevel.beginner,
      targetGoal: FitnessGoal.hypertrophy,
      daysPerWeek: 3,
      estimatedDurationMinutes: 45,
      targetMuscles: ['CHEST', 'BACK', 'LEGS', 'SHOULDERS', 'ARMS'],
      equipmentRequired: ['덤벨'],
      isFeatured: true,
      popularityScore: 90,
      createdBy: 'V2log Team',
      exercises: [
        // Day 1: 상체 푸시
        PresetRoutineExerciseModel(id: 'pre-003-01', presetRoutineId: 'preset-003', exerciseId: _dbBenchPress, dayNumber: 1, dayName: 'Day 1 - 상체 푸시', orderIndex: 1, targetSets: 4, targetReps: '10-12', restSeconds: 90, notes: '바닥에서 가능', exercise: getExerciseById(_dbBenchPress)),
        PresetRoutineExerciseModel(id: 'pre-003-02', presetRoutineId: 'preset-003', exerciseId: _dbShoulderPress, dayNumber: 1, dayName: 'Day 1 - 상체 푸시', orderIndex: 2, targetSets: 3, targetReps: '10-12', restSeconds: 90, exercise: getExerciseById(_dbShoulderPress)),
        PresetRoutineExerciseModel(id: 'pre-003-03', presetRoutineId: 'preset-003', exerciseId: _sideLateralRaise, dayNumber: 1, dayName: 'Day 1 - 상체 푸시', orderIndex: 3, targetSets: 3, targetReps: '15-20', restSeconds: 60, exercise: getExerciseById(_sideLateralRaise)),
        PresetRoutineExerciseModel(id: 'pre-003-04', presetRoutineId: 'preset-003', exerciseId: _overheadTricepsExt, dayNumber: 1, dayName: 'Day 1 - 상체 푸시', orderIndex: 4, targetSets: 3, targetReps: '12-15', restSeconds: 60, exercise: getExerciseById(_overheadTricepsExt)),
        PresetRoutineExerciseModel(id: 'pre-003-05', presetRoutineId: 'preset-003', exerciseId: _crunch, dayNumber: 1, dayName: 'Day 1 - 상체 푸시', orderIndex: 5, targetSets: 3, targetReps: '15-20', restSeconds: 45, exercise: getExerciseById(_crunch)),
        // Day 2: 상체 풀
        PresetRoutineExerciseModel(id: 'pre-003-06', presetRoutineId: 'preset-003', exerciseId: _oneArmDbRow, dayNumber: 2, dayName: 'Day 2 - 상체 풀', orderIndex: 1, targetSets: 4, targetReps: '10-12', restSeconds: 60, notes: '각 팔당', exercise: getExerciseById(_oneArmDbRow)),
        PresetRoutineExerciseModel(id: 'pre-003-07', presetRoutineId: 'preset-003', exerciseId: _dbCurl, dayNumber: 2, dayName: 'Day 2 - 상체 풀', orderIndex: 2, targetSets: 3, targetReps: '12-15', restSeconds: 60, exercise: getExerciseById(_dbCurl)),
        PresetRoutineExerciseModel(id: 'pre-003-08', presetRoutineId: 'preset-003', exerciseId: _hammerCurl, dayNumber: 2, dayName: 'Day 2 - 상체 풀', orderIndex: 3, targetSets: 3, targetReps: '12-15', restSeconds: 60, exercise: getExerciseById(_hammerCurl)),
        PresetRoutineExerciseModel(id: 'pre-003-09', presetRoutineId: 'preset-003', exerciseId: _frontRaise, dayNumber: 2, dayName: 'Day 2 - 상체 풀', orderIndex: 4, targetSets: 3, targetReps: '12-15', restSeconds: 60, exercise: getExerciseById(_frontRaise)),
        PresetRoutineExerciseModel(id: 'pre-003-10', presetRoutineId: 'preset-003', exerciseId: _plank, dayNumber: 2, dayName: 'Day 2 - 상체 풀', orderIndex: 5, targetSets: 3, targetReps: '30-60초', restSeconds: 45, exercise: getExerciseById(_plank)),
        // Day 3: 하체
        PresetRoutineExerciseModel(id: 'pre-003-11', presetRoutineId: 'preset-003', exerciseId: _lunge, dayNumber: 3, dayName: 'Day 3 - 하체', orderIndex: 1, targetSets: 4, targetReps: '10-12', restSeconds: 90, notes: '각 다리당', exercise: getExerciseById(_lunge)),
        PresetRoutineExerciseModel(id: 'pre-003-12', presetRoutineId: 'preset-003', exerciseId: _romanianDL, dayNumber: 3, dayName: 'Day 3 - 하체', orderIndex: 2, targetSets: 4, targetReps: '10-12', restSeconds: 90, exercise: getExerciseById(_romanianDL)),
        PresetRoutineExerciseModel(id: 'pre-003-13', presetRoutineId: 'preset-003', exerciseId: _russianTwist, dayNumber: 3, dayName: 'Day 3 - 하체', orderIndex: 3, targetSets: 3, targetReps: '20회', restSeconds: 60, exercise: getExerciseById(_russianTwist)),
        PresetRoutineExerciseModel(id: 'pre-003-14', presetRoutineId: 'preset-003', exerciseId: _legRaise, dayNumber: 3, dayName: 'Day 3 - 하체', orderIndex: 4, targetSets: 3, targetReps: '15-20', restSeconds: 60, exercise: getExerciseById(_legRaise)),
      ],
    ),

    // 4. 하체 집중 프로그램
    PresetRoutineModel(
      id: 'preset-004',
      name: '하체 집중 프로그램',
      nameEn: 'Lower Body Focus Program',
      description: '하체 근력과 근비대에 집중하는 프로그램입니다. 스쿼트, 데드리프트 등 복합 운동을 중심으로 구성됩니다.',
      difficulty: ExperienceLevel.intermediate,
      targetGoal: FitnessGoal.strength,
      daysPerWeek: 3,
      estimatedDurationMinutes: 70,
      targetMuscles: ['QUADS', 'HAMSTRINGS', 'GLUTES', 'CALVES'],
      equipmentRequired: ['바벨', '덤벨', '레그프레스 머신'],
      isFeatured: false,
      popularityScore: 65,
      createdBy: 'V2log Team',
      exercises: [
        // Day 1: 스쿼트 중심
        PresetRoutineExerciseModel(id: 'pre-004-01', presetRoutineId: 'preset-004', exerciseId: _squat, dayNumber: 1, dayName: 'Day 1 - 스쿼트 중심', orderIndex: 1, targetSets: 5, targetReps: '5', restSeconds: 180, notes: '무거운 무게', exercise: getExerciseById(_squat)),
        PresetRoutineExerciseModel(id: 'pre-004-02', presetRoutineId: 'preset-004', exerciseId: _legPress, dayNumber: 1, dayName: 'Day 1 - 스쿼트 중심', orderIndex: 2, targetSets: 4, targetReps: '8-10', restSeconds: 120, exercise: getExerciseById(_legPress)),
        PresetRoutineExerciseModel(id: 'pre-004-03', presetRoutineId: 'preset-004', exerciseId: _legExtension, dayNumber: 1, dayName: 'Day 1 - 스쿼트 중심', orderIndex: 3, targetSets: 3, targetReps: '12-15', restSeconds: 60, exercise: getExerciseById(_legExtension)),
        // Day 2: 데드리프트 중심
        PresetRoutineExerciseModel(id: 'pre-004-04', presetRoutineId: 'preset-004', exerciseId: _deadlift, dayNumber: 2, dayName: 'Day 2 - 데드리프트 중심', orderIndex: 1, targetSets: 5, targetReps: '5', restSeconds: 180, notes: '허리 주의', exercise: getExerciseById(_deadlift)),
        PresetRoutineExerciseModel(id: 'pre-004-05', presetRoutineId: 'preset-004', exerciseId: _romanianDL, dayNumber: 2, dayName: 'Day 2 - 데드리프트 중심', orderIndex: 2, targetSets: 4, targetReps: '8-10', restSeconds: 120, exercise: getExerciseById(_romanianDL)),
        PresetRoutineExerciseModel(id: 'pre-004-06', presetRoutineId: 'preset-004', exerciseId: _legCurl, dayNumber: 2, dayName: 'Day 2 - 데드리프트 중심', orderIndex: 3, targetSets: 3, targetReps: '12-15', restSeconds: 60, exercise: getExerciseById(_legCurl)),
        // Day 3: 볼륨
        PresetRoutineExerciseModel(id: 'pre-004-07', presetRoutineId: 'preset-004', exerciseId: _lunge, dayNumber: 3, dayName: 'Day 3 - 볼륨', orderIndex: 1, targetSets: 4, targetReps: '10-12', restSeconds: 90, notes: '각 다리당', exercise: getExerciseById(_lunge)),
        PresetRoutineExerciseModel(id: 'pre-004-08', presetRoutineId: 'preset-004', exerciseId: _legPress, dayNumber: 3, dayName: 'Day 3 - 볼륨', orderIndex: 2, targetSets: 3, targetReps: '15-20', restSeconds: 90, exercise: getExerciseById(_legPress)),
        PresetRoutineExerciseModel(id: 'pre-004-09', presetRoutineId: 'preset-004', exerciseId: _legExtension, dayNumber: 3, dayName: 'Day 3 - 볼륨', orderIndex: 3, targetSets: 3, targetReps: '15-20', restSeconds: 60, exercise: getExerciseById(_legExtension)),
        PresetRoutineExerciseModel(id: 'pre-004-10', presetRoutineId: 'preset-004', exerciseId: _legCurl, dayNumber: 3, dayName: 'Day 3 - 볼륨', orderIndex: 4, targetSets: 3, targetReps: '15-20', restSeconds: 60, exercise: getExerciseById(_legCurl)),
      ],
    ),

    // 5. 푸시풀 상체 집중
    PresetRoutineModel(
      id: 'preset-005',
      name: '푸시풀 상체 집중',
      nameEn: 'Push Pull Upper Focus',
      description: '상체 발달에 집중하는 푸시/풀 분할 루틴입니다. 미는 운동과 당기는 운동을 분리하여 효율적으로 훈련합니다.',
      difficulty: ExperienceLevel.intermediate,
      targetGoal: FitnessGoal.hypertrophy,
      daysPerWeek: 4,
      estimatedDurationMinutes: 70,
      targetMuscles: ['CHEST', 'BACK', 'SHOULDERS', 'ARMS'],
      equipmentRequired: ['바벨', '덤벨', '케이블 머신'],
      isFeatured: false,
      popularityScore: 70,
      createdBy: 'V2log Team',
      exercises: [
        // Day 1: 푸시
        PresetRoutineExerciseModel(id: 'pre-005-01', presetRoutineId: 'preset-005', exerciseId: _benchPress, dayNumber: 1, dayName: 'Day 1 - 푸시', orderIndex: 1, targetSets: 4, targetReps: '6-8', restSeconds: 150, exercise: getExerciseById(_benchPress)),
        PresetRoutineExerciseModel(id: 'pre-005-02', presetRoutineId: 'preset-005', exerciseId: _dbShoulderPress, dayNumber: 1, dayName: 'Day 1 - 푸시', orderIndex: 2, targetSets: 4, targetReps: '8-10', restSeconds: 90, exercise: getExerciseById(_dbShoulderPress)),
        PresetRoutineExerciseModel(id: 'pre-005-03', presetRoutineId: 'preset-005', exerciseId: _inclineBenchPress, dayNumber: 1, dayName: 'Day 1 - 푸시', orderIndex: 3, targetSets: 3, targetReps: '10-12', restSeconds: 90, exercise: getExerciseById(_inclineBenchPress)),
        PresetRoutineExerciseModel(id: 'pre-005-04', presetRoutineId: 'preset-005', exerciseId: _sideLateralRaise, dayNumber: 1, dayName: 'Day 1 - 푸시', orderIndex: 4, targetSets: 3, targetReps: '12-15', restSeconds: 60, exercise: getExerciseById(_sideLateralRaise)),
        PresetRoutineExerciseModel(id: 'pre-005-05', presetRoutineId: 'preset-005', exerciseId: _tricepsPushdown, dayNumber: 1, dayName: 'Day 1 - 푸시', orderIndex: 5, targetSets: 3, targetReps: '12-15', restSeconds: 60, exercise: getExerciseById(_tricepsPushdown)),
        // Day 2: 풀
        PresetRoutineExerciseModel(id: 'pre-005-06', presetRoutineId: 'preset-005', exerciseId: _pullUp, dayNumber: 2, dayName: 'Day 2 - 풀', orderIndex: 1, targetSets: 4, targetReps: '6-10', restSeconds: 120, exercise: getExerciseById(_pullUp)),
        PresetRoutineExerciseModel(id: 'pre-005-07', presetRoutineId: 'preset-005', exerciseId: _seatedCableRow, dayNumber: 2, dayName: 'Day 2 - 풀', orderIndex: 2, targetSets: 4, targetReps: '8-10', restSeconds: 90, exercise: getExerciseById(_seatedCableRow)),
        PresetRoutineExerciseModel(id: 'pre-005-08', presetRoutineId: 'preset-005', exerciseId: _latPulldown, dayNumber: 2, dayName: 'Day 2 - 풀', orderIndex: 3, targetSets: 3, targetReps: '10-12', restSeconds: 90, exercise: getExerciseById(_latPulldown)),
        PresetRoutineExerciseModel(id: 'pre-005-09', presetRoutineId: 'preset-005', exerciseId: _barbellCurl, dayNumber: 2, dayName: 'Day 2 - 풀', orderIndex: 4, targetSets: 3, targetReps: '10-12', restSeconds: 60, exercise: getExerciseById(_barbellCurl)),
        PresetRoutineExerciseModel(id: 'pre-005-10', presetRoutineId: 'preset-005', exerciseId: _hammerCurl, dayNumber: 2, dayName: 'Day 2 - 풀', orderIndex: 5, targetSets: 3, targetReps: '12-15', restSeconds: 60, exercise: getExerciseById(_hammerCurl)),
        // Day 3: 푸시 (볼륨)
        PresetRoutineExerciseModel(id: 'pre-005-11', presetRoutineId: 'preset-005', exerciseId: _dbBenchPress, dayNumber: 3, dayName: 'Day 3 - 푸시 볼륨', orderIndex: 1, targetSets: 4, targetReps: '10-12', restSeconds: 90, exercise: getExerciseById(_dbBenchPress)),
        PresetRoutineExerciseModel(id: 'pre-005-12', presetRoutineId: 'preset-005', exerciseId: _pecDeckFly, dayNumber: 3, dayName: 'Day 3 - 푸시 볼륨', orderIndex: 2, targetSets: 3, targetReps: '12-15', restSeconds: 60, exercise: getExerciseById(_pecDeckFly)),
        PresetRoutineExerciseModel(id: 'pre-005-13', presetRoutineId: 'preset-005', exerciseId: _dbShoulderPress, dayNumber: 3, dayName: 'Day 3 - 푸시 볼륨', orderIndex: 3, targetSets: 3, targetReps: '10-12', restSeconds: 90, exercise: getExerciseById(_dbShoulderPress)),
        PresetRoutineExerciseModel(id: 'pre-005-14', presetRoutineId: 'preset-005', exerciseId: _overheadTricepsExt, dayNumber: 3, dayName: 'Day 3 - 푸시 볼륨', orderIndex: 4, targetSets: 3, targetReps: '12-15', restSeconds: 60, exercise: getExerciseById(_overheadTricepsExt)),
        // Day 4: 풀 (볼륨)
        PresetRoutineExerciseModel(id: 'pre-005-15', presetRoutineId: 'preset-005', exerciseId: _oneArmDbRow, dayNumber: 4, dayName: 'Day 4 - 풀 볼륨', orderIndex: 1, targetSets: 4, targetReps: '10-12', restSeconds: 60, notes: '각 팔당', exercise: getExerciseById(_oneArmDbRow)),
        PresetRoutineExerciseModel(id: 'pre-005-16', presetRoutineId: 'preset-005', exerciseId: _latPulldown, dayNumber: 4, dayName: 'Day 4 - 풀 볼륨', orderIndex: 2, targetSets: 3, targetReps: '12-15', restSeconds: 90, exercise: getExerciseById(_latPulldown)),
        PresetRoutineExerciseModel(id: 'pre-005-17', presetRoutineId: 'preset-005', exerciseId: _dbCurl, dayNumber: 4, dayName: 'Day 4 - 풀 볼륨', orderIndex: 3, targetSets: 3, targetReps: '12-15', restSeconds: 60, exercise: getExerciseById(_dbCurl)),
        PresetRoutineExerciseModel(id: 'pre-005-18', presetRoutineId: 'preset-005', exerciseId: _hammerCurl, dayNumber: 4, dayName: 'Day 4 - 풀 볼륨', orderIndex: 4, targetSets: 3, targetReps: '15-20', restSeconds: 60, exercise: getExerciseById(_hammerCurl)),
      ],
    ),
  ];

  /// 난이도별 프리셋 루틴 필터링
  static List<PresetRoutineModel> getByDifficulty(ExperienceLevel difficulty) {
    return presetRoutines.where((r) => r.difficulty == difficulty).toList();
  }

  /// 추천 프리셋 루틴 가져오기
  static List<PresetRoutineModel> getFeatured() {
    return presetRoutines.where((r) => r.isFeatured).toList();
  }

  /// ID로 프리셋 루틴 찾기
  static PresetRoutineModel? getById(String id) {
    try {
      return presetRoutines.firstWhere((r) => r.id == id);
    } catch (e) {
      return null;
    }
  }
}
