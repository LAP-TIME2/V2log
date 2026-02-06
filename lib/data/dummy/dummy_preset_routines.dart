import '../models/exercise_model.dart';
import '../models/preset_routine_model.dart';
import '../models/user_model.dart';

/// 테스트용 더미 프리셋 루틴 데이터
class DummyPresetRoutines {
  DummyPresetRoutines._();

  /// 더미 운동 데이터
  static final List<ExerciseModel> exercises = [
    // 가슴 운동
    ExerciseModel(
      id: '10000000-0001-4000-8000-000000000001',
      name: '벤치프레스',
      nameEn: 'Bench Press',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.chest,
      secondaryMuscles: [MuscleGroup.triceps, MuscleGroup.shoulders],
      equipmentRequired: ['바벨', '벤치'],
      difficulty: ExperienceLevel.beginner,
      instructions: ['벤치에 눕고 바벨을 어깨너비보다 약간 넓게 잡습니다', '바벨을 가슴 중앙으로 천천히 내립니다', '가슴 근육을 사용해 바벨을 밀어올립니다'],
      tips: ['어깨를 벤치에 고정하고 가슴을 살짝 들어올립니다', '팔꿈치 각도는 약 45도를 유지합니다'],
    ),
    ExerciseModel(
      id: '10000000-0001-4000-8000-000000000002',
      name: '인클라인 벤치프레스',
      nameEn: 'Incline Bench Press',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.chest,
      secondaryMuscles: [MuscleGroup.triceps, MuscleGroup.shoulders],
      equipmentRequired: ['바벨', '인클라인 벤치'],
      difficulty: ExperienceLevel.intermediate,
    ),
    ExerciseModel(
      id: '10000000-0001-4000-8000-000000000003',
      name: '펙덱 플라이',
      nameEn: 'Pec Deck Fly',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.chest,
      equipmentRequired: ['머신'],
      difficulty: ExperienceLevel.beginner,
    ),

    // 삼두 운동
    ExerciseModel(
      id: '10000000-0001-4000-8000-000000000004',
      name: '트라이셉스 푸쉬다운',
      nameEn: 'Triceps Pushdown',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.triceps,
      equipmentRequired: ['케이블 머신'],
      difficulty: ExperienceLevel.beginner,
    ),
    ExerciseModel(
      id: '10000000-0001-4000-8000-000000000005',
      name: '오버헤드 트라이셉스 익스텐션',
      nameEn: 'Overhead Triceps Extension',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.triceps,
      equipmentRequired: ['덤벨'],
      difficulty: ExperienceLevel.beginner,
    ),

    // 등 운동
    ExerciseModel(
      id: '10000000-0001-4000-8000-000000000006',
      name: '랫풀다운',
      nameEn: 'Lat Pulldown',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.back,
      secondaryMuscles: [MuscleGroup.biceps],
      equipmentRequired: ['케이블 머신'],
      difficulty: ExperienceLevel.beginner,
    ),
    ExerciseModel(
      id: '10000000-0001-4000-8000-000000000007',
      name: '시티드 로우',
      nameEn: 'Seated Row',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.back,
      secondaryMuscles: [MuscleGroup.biceps],
      equipmentRequired: ['케이블 머신'],
      difficulty: ExperienceLevel.beginner,
    ),
    ExerciseModel(
      id: '10000000-0001-4000-8000-000000000008',
      name: '원암 덤벨 로우',
      nameEn: 'One Arm Dumbbell Row',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.back,
      secondaryMuscles: [MuscleGroup.biceps],
      equipmentRequired: ['덤벨', '벤치'],
      difficulty: ExperienceLevel.beginner,
    ),

    // 이두 운동
    ExerciseModel(
      id: '10000000-0001-4000-8000-000000000009',
      name: '바벨 컬',
      nameEn: 'Barbell Curl',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.biceps,
      equipmentRequired: ['바벨'],
      difficulty: ExperienceLevel.beginner,
    ),
    ExerciseModel(
      id: '10000000-0001-4000-8000-00000000000a',
      name: '해머 컬',
      nameEn: 'Hammer Curl',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.biceps,
      equipmentRequired: ['덤벨'],
      difficulty: ExperienceLevel.beginner,
    ),

    // 하체 운동
    ExerciseModel(
      id: '10000000-0001-4000-8000-00000000000b',
      name: '레그 프레스',
      nameEn: 'Leg Press',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.quads,
      secondaryMuscles: [MuscleGroup.glutes, MuscleGroup.hamstrings],
      equipmentRequired: ['레그프레스 머신'],
      difficulty: ExperienceLevel.beginner,
    ),
    ExerciseModel(
      id: '10000000-0001-4000-8000-00000000000c',
      name: '레그 익스텐션',
      nameEn: 'Leg Extension',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.quads,
      equipmentRequired: ['레그 익스텐션 머신'],
      difficulty: ExperienceLevel.beginner,
    ),
    ExerciseModel(
      id: '10000000-0001-4000-8000-00000000000d',
      name: '레그 컬',
      nameEn: 'Leg Curl',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.hamstrings,
      equipmentRequired: ['레그 컬 머신'],
      difficulty: ExperienceLevel.beginner,
    ),

    // 어깨 운동
    ExerciseModel(
      id: '10000000-0001-4000-8000-00000000000e',
      name: '덤벨 숄더 프레스',
      nameEn: 'Dumbbell Shoulder Press',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.shoulders,
      secondaryMuscles: [MuscleGroup.triceps],
      equipmentRequired: ['덤벨'],
      difficulty: ExperienceLevel.beginner,
    ),
    ExerciseModel(
      id: '10000000-0001-4000-8000-00000000000f',
      name: '사이드 레터럴 레이즈',
      nameEn: 'Side Lateral Raise',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.shoulders,
      equipmentRequired: ['덤벨'],
      difficulty: ExperienceLevel.beginner,
    ),

    // 추가 운동
    ExerciseModel(
      id: '10000000-0001-4000-8000-000000000010',
      name: '스쿼트',
      nameEn: 'Squat',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.quads,
      secondaryMuscles: [MuscleGroup.glutes, MuscleGroup.hamstrings],
      equipmentRequired: ['바벨', '스쿼트 랙'],
      difficulty: ExperienceLevel.intermediate,
    ),
    ExerciseModel(
      id: '10000000-0001-4000-8000-000000000011',
      name: '데드리프트',
      nameEn: 'Deadlift',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.back,
      secondaryMuscles: [MuscleGroup.glutes, MuscleGroup.hamstrings],
      equipmentRequired: ['바벨'],
      difficulty: ExperienceLevel.intermediate,
    ),
    ExerciseModel(
      id: '10000000-0001-4000-8000-000000000012',
      name: '풀업',
      nameEn: 'Pull Up',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.back,
      secondaryMuscles: [MuscleGroup.biceps],
      equipmentRequired: ['철봉'],
      difficulty: ExperienceLevel.intermediate,
    ),
    ExerciseModel(
      id: '10000000-0001-4000-8000-000000000013',
      name: '덤벨 벤치프레스',
      nameEn: 'Dumbbell Bench Press',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.chest,
      secondaryMuscles: [MuscleGroup.triceps, MuscleGroup.shoulders],
      equipmentRequired: ['덤벨', '벤치'],
      difficulty: ExperienceLevel.beginner,
    ),
    ExerciseModel(
      id: '10000000-0001-4000-8000-000000000014',
      name: '덤벨 컬',
      nameEn: 'Dumbbell Curl',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.biceps,
      equipmentRequired: ['덤벨'],
      difficulty: ExperienceLevel.beginner,
    ),
    ExerciseModel(
      id: '10000000-0001-4000-8000-000000000015',
      name: '런지',
      nameEn: 'Lunge',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.quads,
      secondaryMuscles: [MuscleGroup.glutes, MuscleGroup.hamstrings],
      equipmentRequired: ['덤벨'],
      difficulty: ExperienceLevel.beginner,
    ),
    ExerciseModel(
      id: '10000000-0001-4000-8000-000000000016',
      name: '루마니안 데드리프트',
      nameEn: 'Romanian Deadlift',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.hamstrings,
      secondaryMuscles: [MuscleGroup.glutes],
      equipmentRequired: ['바벨'],
      difficulty: ExperienceLevel.intermediate,
    ),
    ExerciseModel(
      id: '10000000-0001-4000-8000-000000000017',
      name: '크런치',
      nameEn: 'Crunch',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.abs,
      equipmentRequired: [],
      difficulty: ExperienceLevel.beginner,
    ),
    ExerciseModel(
      id: '10000000-0001-4000-8000-000000000018',
      name: '플랭크',
      nameEn: 'Plank',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.abs,
      equipmentRequired: [],
      difficulty: ExperienceLevel.beginner,
    ),
    ExerciseModel(
      id: '10000000-0001-4000-8000-000000000019',
      name: '프론트 레이즈',
      nameEn: 'Front Raise',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.shoulders,
      equipmentRequired: ['덤벨'],
      difficulty: ExperienceLevel.beginner,
    ),
    ExerciseModel(
      id: '10000000-0001-4000-8000-00000000001a',
      name: '러시안 트위스트',
      nameEn: 'Russian Twist',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.abs,
      equipmentRequired: ['덤벨'],
      difficulty: ExperienceLevel.intermediate,
    ),
    ExerciseModel(
      id: '10000000-0001-4000-8000-00000000001b',
      name: '레그 레이즈',
      nameEn: 'Leg Raise',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.abs,
      equipmentRequired: [],
      difficulty: ExperienceLevel.intermediate,
    ),
  ];

  /// 운동 ID로 운동 찾기
  static ExerciseModel? getExerciseById(String id) {
    try {
      return exercises.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }

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
        PresetRoutineExerciseModel(id: 'pre-001-01', presetRoutineId: 'preset-001', exerciseId: '10000000-0001-4000-8000-000000000001', dayNumber: 1, dayName: 'Day 1 - 가슴/삼두', orderIndex: 1, targetSets: 4, targetReps: '8-10', restSeconds: 120, notes: '첫 세트는 워밍업', exercise: getExerciseById('10000000-0001-4000-8000-000000000001')),
        PresetRoutineExerciseModel(id: 'pre-001-02', presetRoutineId: 'preset-001', exerciseId: '10000000-0001-4000-8000-000000000002', dayNumber: 1, dayName: 'Day 1 - 가슴/삼두', orderIndex: 2, targetSets: 3, targetReps: '10-12', restSeconds: 90, exercise: getExerciseById('10000000-0001-4000-8000-000000000002')),
        PresetRoutineExerciseModel(id: 'pre-001-03', presetRoutineId: 'preset-001', exerciseId: '10000000-0001-4000-8000-000000000003', dayNumber: 1, dayName: 'Day 1 - 가슴/삼두', orderIndex: 3, targetSets: 3, targetReps: '12-15', restSeconds: 60, notes: '가슴 수축에 집중', exercise: getExerciseById('10000000-0001-4000-8000-000000000003')),
        PresetRoutineExerciseModel(id: 'pre-001-04', presetRoutineId: 'preset-001', exerciseId: '10000000-0001-4000-8000-000000000004', dayNumber: 1, dayName: 'Day 1 - 가슴/삼두', orderIndex: 4, targetSets: 3, targetReps: '12-15', restSeconds: 60, exercise: getExerciseById('10000000-0001-4000-8000-000000000004')),
        PresetRoutineExerciseModel(id: 'pre-001-05', presetRoutineId: 'preset-001', exerciseId: '10000000-0001-4000-8000-000000000005', dayNumber: 1, dayName: 'Day 1 - 가슴/삼두', orderIndex: 5, targetSets: 3, targetReps: '10-12', restSeconds: 60, exercise: getExerciseById('10000000-0001-4000-8000-000000000005')),
        // Day 2: 등/이두
        PresetRoutineExerciseModel(id: 'pre-001-06', presetRoutineId: 'preset-001', exerciseId: '10000000-0001-4000-8000-000000000006', dayNumber: 2, dayName: 'Day 2 - 등/이두', orderIndex: 1, targetSets: 4, targetReps: '10-12', restSeconds: 90, notes: '광배근 수축에 집중', exercise: getExerciseById('10000000-0001-4000-8000-000000000006')),
        PresetRoutineExerciseModel(id: 'pre-001-07', presetRoutineId: 'preset-001', exerciseId: '10000000-0001-4000-8000-000000000007', dayNumber: 2, dayName: 'Day 2 - 등/이두', orderIndex: 2, targetSets: 3, targetReps: '10-12', restSeconds: 90, exercise: getExerciseById('10000000-0001-4000-8000-000000000007')),
        PresetRoutineExerciseModel(id: 'pre-001-08', presetRoutineId: 'preset-001', exerciseId: '10000000-0001-4000-8000-000000000008', dayNumber: 2, dayName: 'Day 2 - 등/이두', orderIndex: 3, targetSets: 3, targetReps: '10-12', restSeconds: 60, notes: '각 팔당', exercise: getExerciseById('10000000-0001-4000-8000-000000000008')),
        PresetRoutineExerciseModel(id: 'pre-001-09', presetRoutineId: 'preset-001', exerciseId: '10000000-0001-4000-8000-000000000009', dayNumber: 2, dayName: 'Day 2 - 등/이두', orderIndex: 4, targetSets: 3, targetReps: '10-12', restSeconds: 60, exercise: getExerciseById('10000000-0001-4000-8000-000000000009')),
        PresetRoutineExerciseModel(id: 'pre-001-10', presetRoutineId: 'preset-001', exerciseId: '10000000-0001-4000-8000-00000000000a', dayNumber: 2, dayName: 'Day 2 - 등/이두', orderIndex: 5, targetSets: 3, targetReps: '12-15', restSeconds: 60, exercise: getExerciseById('10000000-0001-4000-8000-00000000000a')),
        // Day 3: 하체/어깨
        PresetRoutineExerciseModel(id: 'pre-001-11', presetRoutineId: 'preset-001', exerciseId: '10000000-0001-4000-8000-00000000000b', dayNumber: 3, dayName: 'Day 3 - 하체/어깨', orderIndex: 1, targetSets: 4, targetReps: '10-12', restSeconds: 120, notes: '스쿼트 대신 초보자용', exercise: getExerciseById('10000000-0001-4000-8000-00000000000b')),
        PresetRoutineExerciseModel(id: 'pre-001-12', presetRoutineId: 'preset-001', exerciseId: '10000000-0001-4000-8000-00000000000c', dayNumber: 3, dayName: 'Day 3 - 하체/어깨', orderIndex: 2, targetSets: 3, targetReps: '12-15', restSeconds: 60, exercise: getExerciseById('10000000-0001-4000-8000-00000000000c')),
        PresetRoutineExerciseModel(id: 'pre-001-13', presetRoutineId: 'preset-001', exerciseId: '10000000-0001-4000-8000-00000000000d', dayNumber: 3, dayName: 'Day 3 - 하체/어깨', orderIndex: 3, targetSets: 3, targetReps: '12-15', restSeconds: 60, exercise: getExerciseById('10000000-0001-4000-8000-00000000000d')),
        PresetRoutineExerciseModel(id: 'pre-001-14', presetRoutineId: 'preset-001', exerciseId: '10000000-0001-4000-8000-00000000000e', dayNumber: 3, dayName: 'Day 3 - 하체/어깨', orderIndex: 4, targetSets: 3, targetReps: '10-12', restSeconds: 90, exercise: getExerciseById('10000000-0001-4000-8000-00000000000e')),
        PresetRoutineExerciseModel(id: 'pre-001-15', presetRoutineId: 'preset-001', exerciseId: '10000000-0001-4000-8000-00000000000f', dayNumber: 3, dayName: 'Day 3 - 하체/어깨', orderIndex: 5, targetSets: 3, targetReps: '15-20', restSeconds: 60, notes: '가볍게 많은 반복', exercise: getExerciseById('10000000-0001-4000-8000-00000000000f')),
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
        PresetRoutineExerciseModel(id: 'pre-002-01', presetRoutineId: 'preset-002', exerciseId: '10000000-0001-4000-8000-000000000001', dayNumber: 1, dayName: 'Day 1 - 가슴', orderIndex: 1, targetSets: 4, targetReps: '6-8', restSeconds: 180, notes: '무거운 무게로', exercise: getExerciseById('10000000-0001-4000-8000-000000000001')),
        PresetRoutineExerciseModel(id: 'pre-002-02', presetRoutineId: 'preset-002', exerciseId: '10000000-0001-4000-8000-000000000002', dayNumber: 1, dayName: 'Day 1 - 가슴', orderIndex: 2, targetSets: 4, targetReps: '8-10', restSeconds: 120, exercise: getExerciseById('10000000-0001-4000-8000-000000000002')),
        PresetRoutineExerciseModel(id: 'pre-002-03', presetRoutineId: 'preset-002', exerciseId: '10000000-0001-4000-8000-000000000013', dayNumber: 1, dayName: 'Day 1 - 가슴', orderIndex: 3, targetSets: 3, targetReps: '10-12', restSeconds: 90, exercise: getExerciseById('10000000-0001-4000-8000-000000000013')),
        PresetRoutineExerciseModel(id: 'pre-002-04', presetRoutineId: 'preset-002', exerciseId: '10000000-0001-4000-8000-000000000003', dayNumber: 1, dayName: 'Day 1 - 가슴', orderIndex: 4, targetSets: 3, targetReps: '12-15', restSeconds: 60, notes: '수축에 집중', exercise: getExerciseById('10000000-0001-4000-8000-000000000003')),
        // Day 2: 등
        PresetRoutineExerciseModel(id: 'pre-002-05', presetRoutineId: 'preset-002', exerciseId: '10000000-0001-4000-8000-000000000011', dayNumber: 2, dayName: 'Day 2 - 등', orderIndex: 1, targetSets: 4, targetReps: '5-6', restSeconds: 180, notes: '허리 주의', exercise: getExerciseById('10000000-0001-4000-8000-000000000011')),
        PresetRoutineExerciseModel(id: 'pre-002-06', presetRoutineId: 'preset-002', exerciseId: '10000000-0001-4000-8000-000000000012', dayNumber: 2, dayName: 'Day 2 - 등', orderIndex: 2, targetSets: 4, targetReps: '8-10', restSeconds: 90, notes: '보조 사용 가능', exercise: getExerciseById('10000000-0001-4000-8000-000000000012')),
        PresetRoutineExerciseModel(id: 'pre-002-07', presetRoutineId: 'preset-002', exerciseId: '10000000-0001-4000-8000-000000000007', dayNumber: 2, dayName: 'Day 2 - 등', orderIndex: 3, targetSets: 3, targetReps: '10-12', restSeconds: 90, exercise: getExerciseById('10000000-0001-4000-8000-000000000007')),
        PresetRoutineExerciseModel(id: 'pre-002-08', presetRoutineId: 'preset-002', exerciseId: '10000000-0001-4000-8000-000000000006', dayNumber: 2, dayName: 'Day 2 - 등', orderIndex: 4, targetSets: 3, targetReps: '10-12', restSeconds: 90, exercise: getExerciseById('10000000-0001-4000-8000-000000000006')),
        // Day 3: 어깨/팔
        PresetRoutineExerciseModel(id: 'pre-002-09', presetRoutineId: 'preset-002', exerciseId: '10000000-0001-4000-8000-00000000000e', dayNumber: 3, dayName: 'Day 3 - 어깨/팔', orderIndex: 1, targetSets: 4, targetReps: '8-10', restSeconds: 120, exercise: getExerciseById('10000000-0001-4000-8000-00000000000e')),
        PresetRoutineExerciseModel(id: 'pre-002-10', presetRoutineId: 'preset-002', exerciseId: '10000000-0001-4000-8000-00000000000f', dayNumber: 3, dayName: 'Day 3 - 어깨/팔', orderIndex: 2, targetSets: 4, targetReps: '12-15', restSeconds: 60, exercise: getExerciseById('10000000-0001-4000-8000-00000000000f')),
        PresetRoutineExerciseModel(id: 'pre-002-11', presetRoutineId: 'preset-002', exerciseId: '10000000-0001-4000-8000-000000000009', dayNumber: 3, dayName: 'Day 3 - 어깨/팔', orderIndex: 3, targetSets: 3, targetReps: '10-12', restSeconds: 60, exercise: getExerciseById('10000000-0001-4000-8000-000000000009')),
        PresetRoutineExerciseModel(id: 'pre-002-12', presetRoutineId: 'preset-002', exerciseId: '10000000-0001-4000-8000-000000000004', dayNumber: 3, dayName: 'Day 3 - 어깨/팔', orderIndex: 4, targetSets: 3, targetReps: '10-12', restSeconds: 60, exercise: getExerciseById('10000000-0001-4000-8000-000000000004')),
        PresetRoutineExerciseModel(id: 'pre-002-13', presetRoutineId: 'preset-002', exerciseId: '10000000-0001-4000-8000-00000000000a', dayNumber: 3, dayName: 'Day 3 - 어깨/팔', orderIndex: 5, targetSets: 3, targetReps: '12-15', restSeconds: 60, exercise: getExerciseById('10000000-0001-4000-8000-00000000000a')),
        // Day 4: 하체
        PresetRoutineExerciseModel(id: 'pre-002-14', presetRoutineId: 'preset-002', exerciseId: '10000000-0001-4000-8000-000000000010', dayNumber: 4, dayName: 'Day 4 - 하체', orderIndex: 1, targetSets: 4, targetReps: '6-8', restSeconds: 180, notes: '코어 힘 유지', exercise: getExerciseById('10000000-0001-4000-8000-000000000010')),
        PresetRoutineExerciseModel(id: 'pre-002-15', presetRoutineId: 'preset-002', exerciseId: '10000000-0001-4000-8000-00000000000b', dayNumber: 4, dayName: 'Day 4 - 하체', orderIndex: 2, targetSets: 4, targetReps: '10-12', restSeconds: 120, exercise: getExerciseById('10000000-0001-4000-8000-00000000000b')),
        PresetRoutineExerciseModel(id: 'pre-002-16', presetRoutineId: 'preset-002', exerciseId: '10000000-0001-4000-8000-000000000016', dayNumber: 4, dayName: 'Day 4 - 하체', orderIndex: 3, targetSets: 4, targetReps: '8-10', restSeconds: 120, notes: '햄스트링 스트레칭', exercise: getExerciseById('10000000-0001-4000-8000-000000000016')),
        PresetRoutineExerciseModel(id: 'pre-002-17', presetRoutineId: 'preset-002', exerciseId: '10000000-0001-4000-8000-00000000000c', dayNumber: 4, dayName: 'Day 4 - 하체', orderIndex: 4, targetSets: 3, targetReps: '12-15', restSeconds: 60, exercise: getExerciseById('10000000-0001-4000-8000-00000000000c')),
        PresetRoutineExerciseModel(id: 'pre-002-18', presetRoutineId: 'preset-002', exerciseId: '10000000-0001-4000-8000-00000000000d', dayNumber: 4, dayName: 'Day 4 - 하체', orderIndex: 5, targetSets: 3, targetReps: '12-15', restSeconds: 60, exercise: getExerciseById('10000000-0001-4000-8000-00000000000d')),
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
        PresetRoutineExerciseModel(id: 'pre-003-01', presetRoutineId: 'preset-003', exerciseId: '10000000-0001-4000-8000-000000000013', dayNumber: 1, dayName: 'Day 1 - 상체 푸시', orderIndex: 1, targetSets: 4, targetReps: '10-12', restSeconds: 90, notes: '바닥에서 가능', exercise: getExerciseById('10000000-0001-4000-8000-000000000013')),
        PresetRoutineExerciseModel(id: 'pre-003-02', presetRoutineId: 'preset-003', exerciseId: '10000000-0001-4000-8000-00000000000e', dayNumber: 1, dayName: 'Day 1 - 상체 푸시', orderIndex: 2, targetSets: 3, targetReps: '10-12', restSeconds: 90, exercise: getExerciseById('10000000-0001-4000-8000-00000000000e')),
        PresetRoutineExerciseModel(id: 'pre-003-03', presetRoutineId: 'preset-003', exerciseId: '10000000-0001-4000-8000-00000000000f', dayNumber: 1, dayName: 'Day 1 - 상체 푸시', orderIndex: 3, targetSets: 3, targetReps: '15-20', restSeconds: 60, exercise: getExerciseById('10000000-0001-4000-8000-00000000000f')),
        PresetRoutineExerciseModel(id: 'pre-003-04', presetRoutineId: 'preset-003', exerciseId: '10000000-0001-4000-8000-000000000005', dayNumber: 1, dayName: 'Day 1 - 상체 푸시', orderIndex: 4, targetSets: 3, targetReps: '12-15', restSeconds: 60, exercise: getExerciseById('10000000-0001-4000-8000-000000000005')),
        PresetRoutineExerciseModel(id: 'pre-003-05', presetRoutineId: 'preset-003', exerciseId: '10000000-0001-4000-8000-000000000017', dayNumber: 1, dayName: 'Day 1 - 상체 푸시', orderIndex: 5, targetSets: 3, targetReps: '15-20', restSeconds: 45, exercise: getExerciseById('10000000-0001-4000-8000-000000000017')),
        // Day 2: 상체 풀
        PresetRoutineExerciseModel(id: 'pre-003-06', presetRoutineId: 'preset-003', exerciseId: '10000000-0001-4000-8000-000000000008', dayNumber: 2, dayName: 'Day 2 - 상체 풀', orderIndex: 1, targetSets: 4, targetReps: '10-12', restSeconds: 60, notes: '각 팔당', exercise: getExerciseById('10000000-0001-4000-8000-000000000008')),
        PresetRoutineExerciseModel(id: 'pre-003-07', presetRoutineId: 'preset-003', exerciseId: '10000000-0001-4000-8000-000000000014', dayNumber: 2, dayName: 'Day 2 - 상체 풀', orderIndex: 2, targetSets: 3, targetReps: '12-15', restSeconds: 60, exercise: getExerciseById('10000000-0001-4000-8000-000000000014')),
        PresetRoutineExerciseModel(id: 'pre-003-08', presetRoutineId: 'preset-003', exerciseId: '10000000-0001-4000-8000-00000000000a', dayNumber: 2, dayName: 'Day 2 - 상체 풀', orderIndex: 3, targetSets: 3, targetReps: '12-15', restSeconds: 60, exercise: getExerciseById('10000000-0001-4000-8000-00000000000a')),
        PresetRoutineExerciseModel(id: 'pre-003-09', presetRoutineId: 'preset-003', exerciseId: '10000000-0001-4000-8000-000000000019', dayNumber: 2, dayName: 'Day 2 - 상체 풀', orderIndex: 4, targetSets: 3, targetReps: '12-15', restSeconds: 60, exercise: getExerciseById('10000000-0001-4000-8000-000000000019')),
        PresetRoutineExerciseModel(id: 'pre-003-10', presetRoutineId: 'preset-003', exerciseId: '10000000-0001-4000-8000-000000000018', dayNumber: 2, dayName: 'Day 2 - 상체 풀', orderIndex: 5, targetSets: 3, targetReps: '30-60초', restSeconds: 45, exercise: getExerciseById('10000000-0001-4000-8000-000000000018')),
        // Day 3: 하체
        PresetRoutineExerciseModel(id: 'pre-003-11', presetRoutineId: 'preset-003', exerciseId: '10000000-0001-4000-8000-000000000015', dayNumber: 3, dayName: 'Day 3 - 하체', orderIndex: 1, targetSets: 4, targetReps: '10-12', restSeconds: 90, notes: '각 다리당', exercise: getExerciseById('10000000-0001-4000-8000-000000000015')),
        PresetRoutineExerciseModel(id: 'pre-003-12', presetRoutineId: 'preset-003', exerciseId: '10000000-0001-4000-8000-000000000016', dayNumber: 3, dayName: 'Day 3 - 하체', orderIndex: 2, targetSets: 4, targetReps: '10-12', restSeconds: 90, exercise: getExerciseById('10000000-0001-4000-8000-000000000016')),
        PresetRoutineExerciseModel(id: 'pre-003-13', presetRoutineId: 'preset-003', exerciseId: '10000000-0001-4000-8000-00000000001a', dayNumber: 3, dayName: 'Day 3 - 하체', orderIndex: 3, targetSets: 3, targetReps: '20회', restSeconds: 60, exercise: getExerciseById('10000000-0001-4000-8000-00000000001a')),
        PresetRoutineExerciseModel(id: 'pre-003-14', presetRoutineId: 'preset-003', exerciseId: '10000000-0001-4000-8000-00000000001b', dayNumber: 3, dayName: 'Day 3 - 하체', orderIndex: 4, targetSets: 3, targetReps: '15-20', restSeconds: 60, exercise: getExerciseById('10000000-0001-4000-8000-00000000001b')),
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
        PresetRoutineExerciseModel(id: 'pre-004-01', presetRoutineId: 'preset-004', exerciseId: '10000000-0001-4000-8000-000000000010', dayNumber: 1, dayName: 'Day 1 - 스쿼트 중심', orderIndex: 1, targetSets: 5, targetReps: '5', restSeconds: 180, notes: '무거운 무게', exercise: getExerciseById('10000000-0001-4000-8000-000000000010')),
        PresetRoutineExerciseModel(id: 'pre-004-02', presetRoutineId: 'preset-004', exerciseId: '10000000-0001-4000-8000-00000000000b', dayNumber: 1, dayName: 'Day 1 - 스쿼트 중심', orderIndex: 2, targetSets: 4, targetReps: '8-10', restSeconds: 120, exercise: getExerciseById('10000000-0001-4000-8000-00000000000b')),
        PresetRoutineExerciseModel(id: 'pre-004-03', presetRoutineId: 'preset-004', exerciseId: '10000000-0001-4000-8000-00000000000c', dayNumber: 1, dayName: 'Day 1 - 스쿼트 중심', orderIndex: 3, targetSets: 3, targetReps: '12-15', restSeconds: 60, exercise: getExerciseById('10000000-0001-4000-8000-00000000000c')),
        // Day 2: 데드리프트 중심
        PresetRoutineExerciseModel(id: 'pre-004-04', presetRoutineId: 'preset-004', exerciseId: '10000000-0001-4000-8000-000000000011', dayNumber: 2, dayName: 'Day 2 - 데드리프트 중심', orderIndex: 1, targetSets: 5, targetReps: '5', restSeconds: 180, notes: '허리 주의', exercise: getExerciseById('10000000-0001-4000-8000-000000000011')),
        PresetRoutineExerciseModel(id: 'pre-004-05', presetRoutineId: 'preset-004', exerciseId: '10000000-0001-4000-8000-000000000016', dayNumber: 2, dayName: 'Day 2 - 데드리프트 중심', orderIndex: 2, targetSets: 4, targetReps: '8-10', restSeconds: 120, exercise: getExerciseById('10000000-0001-4000-8000-000000000016')),
        PresetRoutineExerciseModel(id: 'pre-004-06', presetRoutineId: 'preset-004', exerciseId: '10000000-0001-4000-8000-00000000000d', dayNumber: 2, dayName: 'Day 2 - 데드리프트 중심', orderIndex: 3, targetSets: 3, targetReps: '12-15', restSeconds: 60, exercise: getExerciseById('10000000-0001-4000-8000-00000000000d')),
        // Day 3: 볼륨
        PresetRoutineExerciseModel(id: 'pre-004-07', presetRoutineId: 'preset-004', exerciseId: '10000000-0001-4000-8000-000000000015', dayNumber: 3, dayName: 'Day 3 - 볼륨', orderIndex: 1, targetSets: 4, targetReps: '10-12', restSeconds: 90, notes: '각 다리당', exercise: getExerciseById('10000000-0001-4000-8000-000000000015')),
        PresetRoutineExerciseModel(id: 'pre-004-08', presetRoutineId: 'preset-004', exerciseId: '10000000-0001-4000-8000-00000000000b', dayNumber: 3, dayName: 'Day 3 - 볼륨', orderIndex: 2, targetSets: 3, targetReps: '15-20', restSeconds: 90, exercise: getExerciseById('10000000-0001-4000-8000-00000000000b')),
        PresetRoutineExerciseModel(id: 'pre-004-09', presetRoutineId: 'preset-004', exerciseId: '10000000-0001-4000-8000-00000000000c', dayNumber: 3, dayName: 'Day 3 - 볼륨', orderIndex: 3, targetSets: 3, targetReps: '15-20', restSeconds: 60, exercise: getExerciseById('10000000-0001-4000-8000-00000000000c')),
        PresetRoutineExerciseModel(id: 'pre-004-10', presetRoutineId: 'preset-004', exerciseId: '10000000-0001-4000-8000-00000000000d', dayNumber: 3, dayName: 'Day 3 - 볼륨', orderIndex: 4, targetSets: 3, targetReps: '15-20', restSeconds: 60, exercise: getExerciseById('10000000-0001-4000-8000-00000000000d')),
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
        PresetRoutineExerciseModel(id: 'pre-005-01', presetRoutineId: 'preset-005', exerciseId: '10000000-0001-4000-8000-000000000001', dayNumber: 1, dayName: 'Day 1 - 푸시', orderIndex: 1, targetSets: 4, targetReps: '6-8', restSeconds: 150, exercise: getExerciseById('10000000-0001-4000-8000-000000000001')),
        PresetRoutineExerciseModel(id: 'pre-005-02', presetRoutineId: 'preset-005', exerciseId: '10000000-0001-4000-8000-00000000000e', dayNumber: 1, dayName: 'Day 1 - 푸시', orderIndex: 2, targetSets: 4, targetReps: '8-10', restSeconds: 90, exercise: getExerciseById('10000000-0001-4000-8000-00000000000e')),
        PresetRoutineExerciseModel(id: 'pre-005-03', presetRoutineId: 'preset-005', exerciseId: '10000000-0001-4000-8000-000000000002', dayNumber: 1, dayName: 'Day 1 - 푸시', orderIndex: 3, targetSets: 3, targetReps: '10-12', restSeconds: 90, exercise: getExerciseById('10000000-0001-4000-8000-000000000002')),
        PresetRoutineExerciseModel(id: 'pre-005-04', presetRoutineId: 'preset-005', exerciseId: '10000000-0001-4000-8000-00000000000f', dayNumber: 1, dayName: 'Day 1 - 푸시', orderIndex: 4, targetSets: 3, targetReps: '12-15', restSeconds: 60, exercise: getExerciseById('10000000-0001-4000-8000-00000000000f')),
        PresetRoutineExerciseModel(id: 'pre-005-05', presetRoutineId: 'preset-005', exerciseId: '10000000-0001-4000-8000-000000000004', dayNumber: 1, dayName: 'Day 1 - 푸시', orderIndex: 5, targetSets: 3, targetReps: '12-15', restSeconds: 60, exercise: getExerciseById('10000000-0001-4000-8000-000000000004')),
        // Day 2: 풀
        PresetRoutineExerciseModel(id: 'pre-005-06', presetRoutineId: 'preset-005', exerciseId: '10000000-0001-4000-8000-000000000012', dayNumber: 2, dayName: 'Day 2 - 풀', orderIndex: 1, targetSets: 4, targetReps: '6-10', restSeconds: 120, exercise: getExerciseById('10000000-0001-4000-8000-000000000012')),
        PresetRoutineExerciseModel(id: 'pre-005-07', presetRoutineId: 'preset-005', exerciseId: '10000000-0001-4000-8000-000000000007', dayNumber: 2, dayName: 'Day 2 - 풀', orderIndex: 2, targetSets: 4, targetReps: '8-10', restSeconds: 90, exercise: getExerciseById('10000000-0001-4000-8000-000000000007')),
        PresetRoutineExerciseModel(id: 'pre-005-08', presetRoutineId: 'preset-005', exerciseId: '10000000-0001-4000-8000-000000000006', dayNumber: 2, dayName: 'Day 2 - 풀', orderIndex: 3, targetSets: 3, targetReps: '10-12', restSeconds: 90, exercise: getExerciseById('10000000-0001-4000-8000-000000000006')),
        PresetRoutineExerciseModel(id: 'pre-005-09', presetRoutineId: 'preset-005', exerciseId: '10000000-0001-4000-8000-000000000009', dayNumber: 2, dayName: 'Day 2 - 풀', orderIndex: 4, targetSets: 3, targetReps: '10-12', restSeconds: 60, exercise: getExerciseById('10000000-0001-4000-8000-000000000009')),
        PresetRoutineExerciseModel(id: 'pre-005-10', presetRoutineId: 'preset-005', exerciseId: '10000000-0001-4000-8000-00000000000a', dayNumber: 2, dayName: 'Day 2 - 풀', orderIndex: 5, targetSets: 3, targetReps: '12-15', restSeconds: 60, exercise: getExerciseById('10000000-0001-4000-8000-00000000000a')),
        // Day 3: 푸시 (볼륨)
        PresetRoutineExerciseModel(id: 'pre-005-11', presetRoutineId: 'preset-005', exerciseId: '10000000-0001-4000-8000-000000000013', dayNumber: 3, dayName: 'Day 3 - 푸시 볼륨', orderIndex: 1, targetSets: 4, targetReps: '10-12', restSeconds: 90, exercise: getExerciseById('10000000-0001-4000-8000-000000000013')),
        PresetRoutineExerciseModel(id: 'pre-005-12', presetRoutineId: 'preset-005', exerciseId: '10000000-0001-4000-8000-000000000003', dayNumber: 3, dayName: 'Day 3 - 푸시 볼륨', orderIndex: 2, targetSets: 3, targetReps: '12-15', restSeconds: 60, exercise: getExerciseById('10000000-0001-4000-8000-000000000003')),
        PresetRoutineExerciseModel(id: 'pre-005-13', presetRoutineId: 'preset-005', exerciseId: '10000000-0001-4000-8000-00000000000e', dayNumber: 3, dayName: 'Day 3 - 푸시 볼륨', orderIndex: 3, targetSets: 3, targetReps: '10-12', restSeconds: 90, exercise: getExerciseById('10000000-0001-4000-8000-00000000000e')),
        PresetRoutineExerciseModel(id: 'pre-005-14', presetRoutineId: 'preset-005', exerciseId: '10000000-0001-4000-8000-000000000005', dayNumber: 3, dayName: 'Day 3 - 푸시 볼륨', orderIndex: 4, targetSets: 3, targetReps: '12-15', restSeconds: 60, exercise: getExerciseById('10000000-0001-4000-8000-000000000005')),
        // Day 4: 풀 (볼륨)
        PresetRoutineExerciseModel(id: 'pre-005-15', presetRoutineId: 'preset-005', exerciseId: '10000000-0001-4000-8000-000000000008', dayNumber: 4, dayName: 'Day 4 - 풀 볼륨', orderIndex: 1, targetSets: 4, targetReps: '10-12', restSeconds: 60, notes: '각 팔당', exercise: getExerciseById('10000000-0001-4000-8000-000000000008')),
        PresetRoutineExerciseModel(id: 'pre-005-16', presetRoutineId: 'preset-005', exerciseId: '10000000-0001-4000-8000-000000000006', dayNumber: 4, dayName: 'Day 4 - 풀 볼륨', orderIndex: 2, targetSets: 3, targetReps: '12-15', restSeconds: 90, exercise: getExerciseById('10000000-0001-4000-8000-000000000006')),
        PresetRoutineExerciseModel(id: 'pre-005-17', presetRoutineId: 'preset-005', exerciseId: '10000000-0001-4000-8000-000000000014', dayNumber: 4, dayName: 'Day 4 - 풀 볼륨', orderIndex: 3, targetSets: 3, targetReps: '12-15', restSeconds: 60, exercise: getExerciseById('10000000-0001-4000-8000-000000000014')),
        PresetRoutineExerciseModel(id: 'pre-005-18', presetRoutineId: 'preset-005', exerciseId: '10000000-0001-4000-8000-00000000000a', dayNumber: 4, dayName: 'Day 4 - 풀 볼륨', orderIndex: 4, targetSets: 3, targetReps: '15-20', restSeconds: 60, exercise: getExerciseById('10000000-0001-4000-8000-00000000000a')),
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
