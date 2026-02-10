import '../models/exercise_model.dart';
import '../models/user_model.dart';
import '../../domain/providers/exercise_provider.dart';

/// 더미 운동 데이터
class DummyExercises {
  DummyExercises._();

  static final List<ExerciseModel> exercises = [
    // ==================== 가슴 운동 ====================
    const ExerciseModel(
      id: '10000000-0001-4000-8000-000000000001',
      name: '벤치프레스',
      nameEn: 'Bench Press',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.chest,
      secondaryMuscles: [MuscleGroup.triceps, MuscleGroup.shoulders],
      equipmentRequired: ['바벨', '벤치'],
      difficulty: ExperienceLevel.beginner,
      instructions: [
        '벤치에 등을 대고 눕니다.',
        '바벨을 어깨 너비보다 약간 넓게 잡습니다.',
        '가슴 중앙으로 바벨을 내립니다.',
        '팔꿈치가 45도 각도를 유지하며 밀어 올립니다.',
      ],
      tips: [
        '어깨 뼈를 모으고 가슴을 펴세요.',
        '발을 바닥에 단단히 고정하세요.',
        '손목이 꺾이지 않도록 주의하세요.',
      ],
      caloriesPerMinute: 6.5,
    ),
    const ExerciseModel(
      id: '10000000-0001-4000-8000-000000000002',
      name: '인클라인 덤벨 프레스',
      nameEn: 'Incline Dumbbell Press',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.chest,
      secondaryMuscles: [MuscleGroup.triceps, MuscleGroup.shoulders],
      equipmentRequired: ['덤벨', '인클라인 벤치'],
      difficulty: ExperienceLevel.beginner,
      instructions: [
        '벤치를 30-45도로 설정합니다.',
        '덤벨을 어깨 옆에 위치시킵니다.',
        '가슴 상부에 힘을 주며 밀어 올립니다.',
        '천천히 내리며 가슴 근육의 스트레칭을 느낍니다.',
      ],
      tips: [
        '상부 가슴에 집중하세요.',
        '덤벨을 서로 부딪히지 않게 주의하세요.',
      ],
      caloriesPerMinute: 5.5,
    ),
    const ExerciseModel(
      id: '10000000-0001-4000-8000-000000000003',
      name: '케이블 크로스오버',
      nameEn: 'Cable Crossover',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.chest,
      secondaryMuscles: [MuscleGroup.shoulders],
      equipmentRequired: ['케이블 머신'],
      difficulty: ExperienceLevel.intermediate,
      instructions: [
        '케이블을 높은 위치에 설정합니다.',
        '한 발을 앞으로 내딛고 상체를 약간 기울입니다.',
        '팔을 아래로 모으며 가슴을 수축합니다.',
        '천천히 시작 위치로 돌아갑니다.',
      ],
      tips: [
        '가슴 근육의 수축을 느끼세요.',
        '팔꿈치를 약간 구부린 채로 유지하세요.',
      ],
      caloriesPerMinute: 4.5,
    ),
    const ExerciseModel(
      id: '10000000-0001-4000-8000-000000000004',
      name: '딥스',
      nameEn: 'Dips',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.chest,
      secondaryMuscles: [MuscleGroup.triceps, MuscleGroup.shoulders],
      equipmentRequired: ['딥스 바'],
      difficulty: ExperienceLevel.intermediate,
      instructions: [
        '딥스 바를 잡고 몸을 들어올립니다.',
        '상체를 앞으로 기울입니다.',
        '팔꿈치가 90도가 될 때까지 내려갑니다.',
        '가슴에 힘을 주며 밀어 올립니다.',
      ],
      tips: [
        '상체를 기울일수록 가슴에 더 많은 자극이 갑니다.',
        '어깨가 귀보다 아래로 내려가지 않게 주의하세요.',
      ],
      caloriesPerMinute: 7.0,
    ),
    const ExerciseModel(
      id: '10000000-0001-4000-8000-000000000006',
      name: '인클라인 벤치프레스',
      nameEn: 'Incline Bench Press',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.chest,
      secondaryMuscles: [MuscleGroup.triceps, MuscleGroup.shoulders],
      equipmentRequired: ['바벨', '인클라인 벤치'],
      difficulty: ExperienceLevel.intermediate,
      instructions: [
        '벤치를 30-45도로 설정합니다.',
        '바벨을 어깨 너비보다 약간 넓게 잡습니다.',
        '가슴 상부로 바벨을 천천히 내립니다.',
        '가슴 상부의 힘으로 밀어 올립니다.',
      ],
      tips: [
        '상부 가슴에 집중하세요.',
        '어깨가 올라가지 않게 주의하세요.',
      ],
      caloriesPerMinute: 6.0,
    ),
    const ExerciseModel(
      id: '10000000-0001-4000-8000-000000000007',
      name: '덤벨 벤치프레스',
      nameEn: 'Dumbbell Bench Press',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.chest,
      secondaryMuscles: [MuscleGroup.triceps, MuscleGroup.shoulders],
      equipmentRequired: ['덤벨', '벤치'],
      difficulty: ExperienceLevel.beginner,
      instructions: [
        '벤치에 등을 대고 눕습니다.',
        '덤벨을 어깨 옆에 위치시킵니다.',
        '가슴 근육을 사용해 덤벨을 밀어 올립니다.',
        '천천히 내리며 가슴의 스트레칭을 느낍니다.',
      ],
      tips: [
        '바벨보다 가동 범위가 넓어 스트레칭에 유리합니다.',
        '좌우 균형에 집중하세요.',
      ],
      caloriesPerMinute: 5.5,
    ),
    const ExerciseModel(
      id: '10000000-0001-4000-8000-000000000005',
      name: '펙덱 플라이',
      nameEn: 'Pec Deck Fly',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.chest,
      secondaryMuscles: [],
      equipmentRequired: ['펙덱 머신'],
      difficulty: ExperienceLevel.beginner,
      instructions: [
        '머신에 앉아 등을 패드에 붙입니다.',
        '팔을 패드에 대고 가슴 앞에서 모읍니다.',
        '가슴을 수축시키며 팔을 모읍니다.',
        '천천히 시작 위치로 돌아갑니다.',
      ],
      tips: [
        '가슴 근육의 수축에 집중하세요.',
        '팔꿈치 높이를 유지하세요.',
      ],
      caloriesPerMinute: 4.0,
    ),

    // ==================== 등 운동 ====================
    const ExerciseModel(
      id: '10000000-0001-4000-8000-000000000010',
      name: '데드리프트',
      nameEn: 'Deadlift',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.back,
      secondaryMuscles: [MuscleGroup.hamstrings, MuscleGroup.glutes, MuscleGroup.traps],
      equipmentRequired: ['바벨'],
      difficulty: ExperienceLevel.intermediate,
      instructions: [
        '바벨 앞에 발을 어깨 너비로 벌리고 섭니다.',
        '바벨을 어깨 너비로 잡습니다.',
        '등을 곧게 펴고 엉덩이를 뒤로 뺍니다.',
        '다리와 등의 힘으로 일어섭니다.',
      ],
      tips: [
        '허리가 굽지 않도록 주의하세요.',
        '바벨을 몸에 가깝게 유지하세요.',
        '코어에 힘을 주세요.',
      ],
      caloriesPerMinute: 8.0,
    ),
    const ExerciseModel(
      id: '10000000-0001-4000-8000-000000000011',
      name: '랫풀다운',
      nameEn: 'Lat Pulldown',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.lats,
      secondaryMuscles: [MuscleGroup.biceps, MuscleGroup.traps],
      equipmentRequired: ['랫풀다운 머신'],
      difficulty: ExperienceLevel.beginner,
      instructions: [
        '머신에 앉아 허벅지를 패드 아래에 고정합니다.',
        '바를 어깨 너비보다 넓게 잡습니다.',
        '가슴을 펴고 바를 쇄골 아래로 당깁니다.',
        '천천히 시작 위치로 돌아갑니다.',
      ],
      tips: [
        '등 근육으로 당기는 느낌에 집중하세요.',
        '팔꿈치를 아래로 당기세요.',
      ],
      caloriesPerMinute: 5.0,
    ),
    const ExerciseModel(
      id: '10000000-0001-4000-8000-000000000012',
      name: '바벨 로우',
      nameEn: 'Barbell Row',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.back,
      secondaryMuscles: [MuscleGroup.biceps, MuscleGroup.lats],
      equipmentRequired: ['바벨'],
      difficulty: ExperienceLevel.intermediate,
      instructions: [
        '바벨을 어깨 너비로 잡고 상체를 45도로 숙입니다.',
        '등을 곧게 펴고 코어에 힘을 줍니다.',
        '바벨을 배꼽 쪽으로 당깁니다.',
        '천천히 내립니다.',
      ],
      tips: [
        '허리가 굽지 않도록 주의하세요.',
        '팔꿈치를 몸에 가깝게 유지하세요.',
      ],
      caloriesPerMinute: 6.0,
    ),
    const ExerciseModel(
      id: '10000000-0001-4000-8000-000000000013',
      name: '시티드 케이블 로우',
      nameEn: 'Seated Cable Row',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.back,
      secondaryMuscles: [MuscleGroup.biceps, MuscleGroup.lats],
      equipmentRequired: ['케이블 머신'],
      difficulty: ExperienceLevel.beginner,
      instructions: [
        '케이블 머신에 앉아 발을 패드에 고정합니다.',
        '핸들을 잡고 등을 곧게 폅니다.',
        '핸들을 배꼽 쪽으로 당깁니다.',
        '견갑골을 모으며 수축합니다.',
      ],
      tips: [
        '상체를 앞뒤로 흔들지 마세요.',
        '등 근육의 수축에 집중하세요.',
      ],
      caloriesPerMinute: 5.0,
    ),
    const ExerciseModel(
      id: '10000000-0001-4000-8000-000000000015',
      name: '원암 덤벨 로우',
      nameEn: 'One Arm Dumbbell Row',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.back,
      secondaryMuscles: [MuscleGroup.biceps, MuscleGroup.lats],
      equipmentRequired: ['덤벨', '벤치'],
      difficulty: ExperienceLevel.beginner,
      instructions: [
        '벤치에 한 손과 한 무릎을 올려놓습니다.',
        '반대 손으로 덤벨을 잡고 아래로 늘어뜨립니다.',
        '등 근육으로 덤벨을 배꼽 쪽으로 당깁니다.',
        '천천히 내립니다.',
      ],
      tips: [
        '등 근육의 수축에 집중하세요.',
        '팔꿈치를 몸에 가깝게 유지하세요.',
      ],
      caloriesPerMinute: 5.0,
    ),
    const ExerciseModel(
      id: '10000000-0001-4000-8000-000000000014',
      name: '풀업',
      nameEn: 'Pull-up',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.lats,
      secondaryMuscles: [MuscleGroup.biceps, MuscleGroup.back],
      equipmentRequired: ['풀업 바'],
      difficulty: ExperienceLevel.intermediate,
      instructions: [
        '풀업 바를 어깨 너비보다 넓게 잡습니다.',
        '가슴을 바 쪽으로 당기며 올라갑니다.',
        '턱이 바 위로 올라올 때까지 당깁니다.',
        '천천히 내려옵니다.',
      ],
      tips: [
        '반동을 사용하지 마세요.',
        '등 근육으로 당기는 느낌에 집중하세요.',
      ],
      caloriesPerMinute: 7.0,
    ),

    // ==================== 어깨 운동 ====================
    const ExerciseModel(
      id: '10000000-0001-4000-8000-000000000020',
      name: '오버헤드 프레스',
      nameEn: 'Overhead Press',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.shoulders,
      secondaryMuscles: [MuscleGroup.triceps, MuscleGroup.traps],
      equipmentRequired: ['바벨'],
      difficulty: ExperienceLevel.intermediate,
      instructions: [
        '바벨을 쇄골 위에 위치시킵니다.',
        '코어에 힘을 주고 바벨을 머리 위로 밀어 올립니다.',
        '팔이 완전히 펴지면 천천히 내립니다.',
      ],
      tips: [
        '허리가 과도하게 젖혀지지 않게 주의하세요.',
        '바벨 경로가 직선이 되도록 하세요.',
      ],
      caloriesPerMinute: 6.0,
    ),
    const ExerciseModel(
      id: '10000000-0001-4000-8000-000000000021',
      name: '덤벨 숄더 프레스',
      nameEn: 'Dumbbell Shoulder Press',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.shoulders,
      secondaryMuscles: [MuscleGroup.triceps],
      equipmentRequired: ['덤벨'],
      difficulty: ExperienceLevel.beginner,
      instructions: [
        '덤벨을 어깨 높이에 위치시킵니다.',
        '덤벨을 머리 위로 밀어 올립니다.',
        '팔이 완전히 펴지면 천천히 내립니다.',
      ],
      tips: [
        '팔꿈치가 몸 옆으로 향하게 하세요.',
        '코어에 힘을 주세요.',
      ],
      caloriesPerMinute: 5.5,
    ),
    const ExerciseModel(
      id: '10000000-0001-4000-8000-000000000022',
      name: '사이드 레터럴 레이즈',
      nameEn: 'Side Lateral Raise',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.shoulders,
      secondaryMuscles: [],
      equipmentRequired: ['덤벨'],
      difficulty: ExperienceLevel.beginner,
      instructions: [
        '덤벨을 양손에 들고 몸 옆에 위치시킵니다.',
        '팔꿈치를 약간 구부린 채로 팔을 옆으로 들어올립니다.',
        '어깨 높이까지 올린 후 천천히 내립니다.',
      ],
      tips: [
        '반동을 사용하지 마세요.',
        '손목이 팔꿈치보다 높아지지 않게 하세요.',
      ],
      caloriesPerMinute: 4.0,
    ),
    const ExerciseModel(
      id: '10000000-0001-4000-8000-000000000023',
      name: '리어 델트 플라이',
      nameEn: 'Rear Delt Fly',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.shoulders,
      secondaryMuscles: [MuscleGroup.traps, MuscleGroup.back],
      equipmentRequired: ['덤벨'],
      difficulty: ExperienceLevel.beginner,
      instructions: [
        '상체를 앞으로 숙이고 덤벨을 아래로 늘어뜨립니다.',
        '팔을 옆으로 들어올립니다.',
        '후면 삼각근을 수축시킨 후 천천히 내립니다.',
      ],
      tips: [
        '등이 굽지 않도록 주의하세요.',
        '후면 삼각근에 집중하세요.',
      ],
      caloriesPerMinute: 4.0,
    ),
    const ExerciseModel(
      id: '10000000-0001-4000-8000-000000000025',
      name: '프론트 레이즈',
      nameEn: 'Front Raise',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.shoulders,
      secondaryMuscles: [],
      equipmentRequired: ['덤벨'],
      difficulty: ExperienceLevel.beginner,
      instructions: [
        '덤벨을 양손에 들고 몸 앞에 위치시킵니다.',
        '팔을 곧게 펴고 앞으로 들어올립니다.',
        '어깨 높이까지 올린 후 천천히 내립니다.',
      ],
      tips: [
        '반동을 사용하지 마세요.',
        '전면 삼각근에 집중하세요.',
      ],
      caloriesPerMinute: 3.5,
    ),
    const ExerciseModel(
      id: '10000000-0001-4000-8000-000000000024',
      name: '페이스 풀',
      nameEn: 'Face Pull',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.shoulders,
      secondaryMuscles: [MuscleGroup.traps, MuscleGroup.back],
      equipmentRequired: ['케이블 머신', '로프'],
      difficulty: ExperienceLevel.beginner,
      instructions: [
        '케이블을 얼굴 높이에 설정합니다.',
        '로프를 잡고 얼굴 쪽으로 당깁니다.',
        '팔꿈치를 높이 유지하며 후면 삼각근을 수축시킵니다.',
      ],
      tips: [
        '팔꿈치가 손목보다 높게 유지하세요.',
        '견갑골을 모으세요.',
      ],
      caloriesPerMinute: 3.5,
    ),

    // ==================== 팔 운동 ====================
    const ExerciseModel(
      id: '10000000-0001-4000-8000-000000000030',
      name: '바벨 컬',
      nameEn: 'Barbell Curl',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.biceps,
      secondaryMuscles: [MuscleGroup.forearms],
      equipmentRequired: ['바벨'],
      difficulty: ExperienceLevel.beginner,
      instructions: [
        '바벨을 어깨 너비로 잡고 서세요.',
        '팔꿈치를 고정하고 바벨을 어깨 쪽으로 들어올립니다.',
        '이두근을 수축시킨 후 천천히 내립니다.',
      ],
      tips: [
        '상체를 흔들지 마세요.',
        '팔꿈치 위치를 고정하세요.',
      ],
      caloriesPerMinute: 4.0,
    ),
    const ExerciseModel(
      id: '10000000-0001-4000-8000-000000000031',
      name: '해머 컬',
      nameEn: 'Hammer Curl',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.biceps,
      secondaryMuscles: [MuscleGroup.forearms],
      equipmentRequired: ['덤벨'],
      difficulty: ExperienceLevel.beginner,
      instructions: [
        '덤벨을 양손에 들고 손바닥이 서로 마주보게 합니다.',
        '팔꿈치를 고정하고 덤벨을 어깨 쪽으로 들어올립니다.',
        '천천히 내립니다.',
      ],
      tips: [
        '손목을 고정하세요.',
        '전완근에도 자극이 갑니다.',
      ],
      caloriesPerMinute: 4.0,
    ),
    const ExerciseModel(
      id: '10000000-0001-4000-8000-000000000032',
      name: '트라이셉스 푸시다운',
      nameEn: 'Triceps Pushdown',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.triceps,
      secondaryMuscles: [],
      equipmentRequired: ['케이블 머신'],
      difficulty: ExperienceLevel.beginner,
      instructions: [
        '케이블 바를 잡고 팔꿈치를 몸에 붙입니다.',
        '팔꿈치를 고정하고 바를 아래로 밀어내립니다.',
        '삼두근을 수축시킨 후 천천히 올립니다.',
      ],
      tips: [
        '팔꿈치가 움직이지 않게 고정하세요.',
        '삼두근의 수축에 집중하세요.',
      ],
      caloriesPerMinute: 3.5,
    ),
    const ExerciseModel(
      id: '10000000-0001-4000-8000-000000000033',
      name: '오버헤드 트라이셉스 익스텐션',
      nameEn: 'Overhead Triceps Extension',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.triceps,
      secondaryMuscles: [],
      equipmentRequired: ['덤벨'],
      difficulty: ExperienceLevel.beginner,
      instructions: [
        '덤벨을 양손으로 잡고 머리 위로 들어올립니다.',
        '팔꿈치를 구부려 덤벨을 머리 뒤로 내립니다.',
        '삼두근의 힘으로 밀어 올립니다.',
      ],
      tips: [
        '팔꿈치가 벌어지지 않게 하세요.',
        '코어에 힘을 주세요.',
      ],
      caloriesPerMinute: 4.0,
    ),
    const ExerciseModel(
      id: '10000000-0001-4000-8000-000000000035',
      name: '덤벨 컬',
      nameEn: 'Dumbbell Curl',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.biceps,
      secondaryMuscles: [MuscleGroup.forearms],
      equipmentRequired: ['덤벨'],
      difficulty: ExperienceLevel.beginner,
      instructions: [
        '덤벨을 양손에 들고 손바닥이 앞을 향하게 합니다.',
        '팔꿈치를 고정하고 덤벨을 어깨 쪽으로 들어올립니다.',
        '이두근을 수축시킨 후 천천히 내립니다.',
      ],
      tips: [
        '좌우 번갈아가며 하면 더 집중할 수 있습니다.',
        '팔꿈치가 움직이지 않게 고정하세요.',
      ],
      caloriesPerMinute: 3.5,
    ),
    const ExerciseModel(
      id: '10000000-0001-4000-8000-000000000034',
      name: '클로즈그립 벤치프레스',
      nameEn: 'Close Grip Bench Press',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.triceps,
      secondaryMuscles: [MuscleGroup.chest, MuscleGroup.shoulders],
      equipmentRequired: ['바벨', '벤치'],
      difficulty: ExperienceLevel.intermediate,
      instructions: [
        '벤치에 눕고 바벨을 어깨 너비보다 좁게 잡습니다.',
        '바벨을 가슴 아래로 내립니다.',
        '삼두근의 힘으로 밀어 올립니다.',
      ],
      tips: [
        '팔꿈치를 몸에 가깝게 유지하세요.',
        '손목이 꺾이지 않게 주의하세요.',
      ],
      caloriesPerMinute: 5.5,
    ),

    // ==================== 하체 운동 ====================
    const ExerciseModel(
      id: '10000000-0001-4000-8000-000000000040',
      name: '스쿼트',
      nameEn: 'Squat',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.quads,
      secondaryMuscles: [MuscleGroup.glutes, MuscleGroup.hamstrings],
      equipmentRequired: ['바벨', '스쿼트 랙'],
      difficulty: ExperienceLevel.intermediate,
      instructions: [
        '바벨을 어깨 뒤에 올려놓습니다.',
        '발을 어깨 너비로 벌리고 발끝은 약간 바깥쪽을 향하게 합니다.',
        '엉덩이를 뒤로 빼며 무릎을 구부립니다.',
        '허벅지가 바닥과 평행이 될 때까지 내려간 후 일어섭니다.',
      ],
      tips: [
        '무릎이 발끝을 넘지 않게 주의하세요.',
        '코어에 힘을 주고 등을 곧게 유지하세요.',
        '발바닥 전체로 바닥을 밀어내세요.',
      ],
      caloriesPerMinute: 8.0,
    ),
    const ExerciseModel(
      id: '10000000-0001-4000-8000-000000000041',
      name: '레그 프레스',
      nameEn: 'Leg Press',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.quads,
      secondaryMuscles: [MuscleGroup.glutes, MuscleGroup.hamstrings],
      equipmentRequired: ['레그 프레스 머신'],
      difficulty: ExperienceLevel.beginner,
      instructions: [
        '머신에 앉아 발을 플레이트에 어깨 너비로 올립니다.',
        '무릎을 가슴 쪽으로 구부립니다.',
        '다리의 힘으로 플레이트를 밀어냅니다.',
        '무릎을 완전히 펴지 않고 멈춥니다.',
      ],
      tips: [
        '허리가 패드에서 떨어지지 않게 하세요.',
        '무릎을 완전히 잠그지 마세요.',
      ],
      caloriesPerMinute: 6.0,
    ),
    const ExerciseModel(
      id: '10000000-0001-4000-8000-000000000042',
      name: '레그 익스텐션',
      nameEn: 'Leg Extension',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.quads,
      secondaryMuscles: [],
      equipmentRequired: ['레그 익스텐션 머신'],
      difficulty: ExperienceLevel.beginner,
      instructions: [
        '머신에 앉아 발목을 패드 아래에 고정합니다.',
        '무릎을 펴며 다리를 들어올립니다.',
        '대퇴사두근을 수축시킨 후 천천히 내립니다.',
      ],
      tips: [
        '동작을 천천히 하세요.',
        '대퇴사두근의 수축에 집중하세요.',
      ],
      caloriesPerMinute: 4.0,
    ),
    const ExerciseModel(
      id: '10000000-0001-4000-8000-000000000043',
      name: '레그 컬',
      nameEn: 'Leg Curl',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.hamstrings,
      secondaryMuscles: [MuscleGroup.calves],
      equipmentRequired: ['레그 컬 머신'],
      difficulty: ExperienceLevel.beginner,
      instructions: [
        '머신에 엎드려 발목을 패드 아래에 고정합니다.',
        '무릎을 구부려 발을 엉덩이 쪽으로 당깁니다.',
        '햄스트링을 수축시킨 후 천천히 내립니다.',
      ],
      tips: [
        '엉덩이가 들리지 않게 하세요.',
        '햄스트링의 수축에 집중하세요.',
      ],
      caloriesPerMinute: 4.0,
    ),
    const ExerciseModel(
      id: '10000000-0001-4000-8000-000000000044',
      name: '런지',
      nameEn: 'Lunge',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.quads,
      secondaryMuscles: [MuscleGroup.glutes, MuscleGroup.hamstrings],
      equipmentRequired: ['덤벨'],
      difficulty: ExperienceLevel.beginner,
      instructions: [
        '덤벨을 양손에 들고 서세요.',
        '한 발을 앞으로 크게 내딛습니다.',
        '뒤쪽 무릎이 바닥에 거의 닿을 때까지 내려갑니다.',
        '앞발로 밀어 원래 위치로 돌아옵니다.',
      ],
      tips: [
        '무릎이 발끝을 넘지 않게 주의하세요.',
        '상체를 곧게 유지하세요.',
      ],
      caloriesPerMinute: 6.0,
    ),
    const ExerciseModel(
      id: '10000000-0001-4000-8000-000000000045',
      name: '힙 쓰러스트',
      nameEn: 'Hip Thrust',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.glutes,
      secondaryMuscles: [MuscleGroup.hamstrings],
      equipmentRequired: ['바벨', '벤치'],
      difficulty: ExperienceLevel.intermediate,
      instructions: [
        '등 상부를 벤치에 기대고 앉습니다.',
        '바벨을 골반 위에 올립니다.',
        '둔근의 힘으로 엉덩이를 들어올립니다.',
        '상체와 허벅지가 일직선이 될 때까지 올린 후 내립니다.',
      ],
      tips: [
        '둔근의 수축에 집중하세요.',
        '허리가 과도하게 젖혀지지 않게 하세요.',
      ],
      caloriesPerMinute: 5.5,
    ),
    const ExerciseModel(
      id: '10000000-0001-4000-8000-000000000047',
      name: '루마니안 데드리프트',
      nameEn: 'Romanian Deadlift',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.hamstrings,
      secondaryMuscles: [MuscleGroup.glutes, MuscleGroup.back],
      equipmentRequired: ['바벨'],
      difficulty: ExperienceLevel.intermediate,
      instructions: [
        '바벨을 어깨 너비로 잡고 섭니다.',
        '무릎을 약간 구부린 상태에서 상체를 앞으로 숙입니다.',
        '바벨을 정강이 아래까지 내립니다.',
        '햄스트링과 둔근의 힘으로 일어섭니다.',
      ],
      tips: [
        '등을 곧게 유지하세요.',
        '햄스트링의 스트레칭을 느끼세요.',
        '바벨을 몸에 가깝게 유지하세요.',
      ],
      caloriesPerMinute: 7.0,
    ),
    const ExerciseModel(
      id: '10000000-0001-4000-8000-000000000046',
      name: '카프 레이즈',
      nameEn: 'Calf Raise',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.calves,
      secondaryMuscles: [],
      equipmentRequired: ['덤벨'],
      difficulty: ExperienceLevel.beginner,
      instructions: [
        '덤벨을 양손에 들고 서세요.',
        '발꿈치를 들어올려 종아리를 수축시킵니다.',
        '천천히 발꿈치를 내립니다.',
      ],
      tips: [
        '종아리의 수축에 집중하세요.',
        '동작 범위를 최대로 하세요.',
      ],
      caloriesPerMinute: 3.0,
    ),

    // ==================== 복근 운동 ====================
    const ExerciseModel(
      id: '10000000-0001-4000-8000-000000000050',
      name: '크런치',
      nameEn: 'Crunch',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.abs,
      secondaryMuscles: [],
      equipmentRequired: [],
      difficulty: ExperienceLevel.beginner,
      instructions: [
        '바닥에 누워 무릎을 구부립니다.',
        '손을 머리 뒤에 가볍게 대세요.',
        '복근의 힘으로 상체를 들어올립니다.',
        '천천히 내립니다.',
      ],
      tips: [
        '목을 당기지 마세요.',
        '복근의 수축에 집중하세요.',
      ],
      caloriesPerMinute: 4.0,
    ),
    const ExerciseModel(
      id: '10000000-0001-4000-8000-000000000051',
      name: '레그 레이즈',
      nameEn: 'Leg Raise',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.abs,
      secondaryMuscles: [],
      equipmentRequired: [],
      difficulty: ExperienceLevel.intermediate,
      instructions: [
        '바닥에 누워 다리를 펴세요.',
        '하복부의 힘으로 다리를 수직으로 들어올립니다.',
        '천천히 내리되 바닥에 닿기 전에 멈춥니다.',
      ],
      tips: [
        '허리가 바닥에서 떨어지지 않게 하세요.',
        '하복부에 집중하세요.',
      ],
      caloriesPerMinute: 4.5,
    ),
    const ExerciseModel(
      id: '10000000-0001-4000-8000-000000000052',
      name: '플랭크',
      nameEn: 'Plank',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.abs,
      secondaryMuscles: [MuscleGroup.shoulders, MuscleGroup.back],
      equipmentRequired: [],
      difficulty: ExperienceLevel.beginner,
      instructions: [
        '팔꿈치를 바닥에 대고 몸을 일직선으로 유지합니다.',
        '코어에 힘을 주고 버팁니다.',
        '엉덩이가 올라가거나 내려가지 않게 합니다.',
      ],
      tips: [
        '몸 전체를 일직선으로 유지하세요.',
        '호흡을 멈추지 마세요.',
      ],
      caloriesPerMinute: 5.0,
    ),
    const ExerciseModel(
      id: '10000000-0001-4000-8000-000000000053',
      name: '러시안 트위스트',
      nameEn: 'Russian Twist',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.obliques,
      secondaryMuscles: [MuscleGroup.abs],
      equipmentRequired: ['덤벨'],
      difficulty: ExperienceLevel.intermediate,
      instructions: [
        '바닥에 앉아 무릎을 구부리고 상체를 뒤로 기울입니다.',
        '덤벨을 양손으로 잡고 좌우로 비틀어줍니다.',
        '옆구리 근육의 수축을 느끼세요.',
      ],
      tips: [
        '발을 바닥에서 떼면 강도가 올라갑니다.',
        '동작을 천천히 하세요.',
      ],
      caloriesPerMinute: 5.0,
    ),
    const ExerciseModel(
      id: '10000000-0001-4000-8000-000000000054',
      name: '행잉 레그 레이즈',
      nameEn: 'Hanging Leg Raise',
      category: ExerciseCategory.strength,
      primaryMuscle: MuscleGroup.abs,
      secondaryMuscles: [],
      equipmentRequired: ['풀업 바'],
      difficulty: ExperienceLevel.advanced,
      instructions: [
        '풀업 바에 매달립니다.',
        '다리를 곧게 펴고 복근의 힘으로 들어올립니다.',
        '다리가 바닥과 평행이 되면 천천히 내립니다.',
      ],
      tips: [
        '반동을 사용하지 마세요.',
        '하복부에 집중하세요.',
      ],
      caloriesPerMinute: 6.0,
    ),

    // ==================== 유산소 운동 ====================
    const ExerciseModel(
      id: '10000000-0001-4000-8000-000000000060',
      name: '트레드밀 러닝',
      nameEn: 'Treadmill Running',
      category: ExerciseCategory.cardio,
      primaryMuscle: MuscleGroup.fullBody,
      secondaryMuscles: [],
      equipmentRequired: ['트레드밀'],
      difficulty: ExperienceLevel.beginner,
      instructions: [
        '트레드밀 속도를 설정합니다.',
        '자연스럽게 팔을 흔들며 뜁니다.',
        '호흡을 규칙적으로 유지합니다.',
      ],
      tips: [
        '처음에는 천천히 시작하세요.',
        '올바른 러닝 자세를 유지하세요.',
      ],
      caloriesPerMinute: 10.0,
    ),
    const ExerciseModel(
      id: '10000000-0001-4000-8000-000000000061',
      name: '사이클',
      nameEn: 'Stationary Bike',
      category: ExerciseCategory.cardio,
      primaryMuscle: MuscleGroup.quads,
      secondaryMuscles: [MuscleGroup.hamstrings, MuscleGroup.calves],
      equipmentRequired: ['실내 자전거'],
      difficulty: ExperienceLevel.beginner,
      instructions: [
        '안장 높이를 조절합니다.',
        '페달을 일정한 리듬으로 밟습니다.',
        '저항을 조절하여 강도를 변경합니다.',
      ],
      tips: [
        '무릎이 완전히 펴지지 않는 높이로 안장을 설정하세요.',
        '상체를 곧게 유지하세요.',
      ],
      caloriesPerMinute: 8.0,
    ),
    const ExerciseModel(
      id: '10000000-0001-4000-8000-000000000062',
      name: '로잉 머신',
      nameEn: 'Rowing Machine',
      category: ExerciseCategory.cardio,
      primaryMuscle: MuscleGroup.back,
      secondaryMuscles: [MuscleGroup.biceps, MuscleGroup.quads],
      equipmentRequired: ['로잉 머신'],
      difficulty: ExperienceLevel.beginner,
      instructions: [
        '발을 스트랩에 고정합니다.',
        '핸들을 잡고 다리로 밀어내며 당깁니다.',
        '팔을 가슴 쪽으로 당긴 후 천천히 돌아갑니다.',
      ],
      tips: [
        '다리 -> 등 -> 팔 순서로 힘을 사용하세요.',
        '등을 곧게 유지하세요.',
      ],
      caloriesPerMinute: 9.0,
    ),
  ];

  /// 근육 부위별 운동 가져오기
  static List<ExerciseModel> getByMuscle(MuscleGroup muscle) {
    return exercises.where((e) => e.primaryMuscle == muscle).toList();
  }

  /// 카테고리별 운동 가져오기
  static List<ExerciseModel> getByCategory(ExerciseCategory category) {
    return exercises.where((e) => e.category == category).toList();
  }

  /// 난이도별 운동 가져오기
  static List<ExerciseModel> getByDifficulty(ExperienceLevel difficulty) {
    return exercises.where((e) => e.difficulty == difficulty).toList();
  }

  /// ID로 운동 가져오기
  static ExerciseModel? getById(String id) {
    try {
      return exercises.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  /// 운동 검색
  static List<ExerciseModel> search(String query) {
    final lowerQuery = query.toLowerCase();
    return exercises.where((e) {
      return e.name.toLowerCase().contains(lowerQuery) ||
          (e.nameEn?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }

  /// 필터링된 운동 가져오기
  static List<ExerciseModel> getFiltered(ExerciseFilter filter) {
    var result = exercises;

    if (filter.primaryMuscle != null) {
      // "하체" 카테고리는 관련 모든 하체 부위 운동을 포함
      if (filter.primaryMuscle == MuscleGroup.legs) {
        const legMuscles = [
          MuscleGroup.legs,
          MuscleGroup.quadriceps,
          MuscleGroup.quads,
          MuscleGroup.hamstrings,
          MuscleGroup.glutes,
          MuscleGroup.calves,
          MuscleGroup.hipFlexors,
        ];
        result = result.where((e) => legMuscles.contains(e.primaryMuscle)).toList();
      } else {
        result = result.where((e) => e.primaryMuscle == filter.primaryMuscle).toList();
      }
    }

    if (filter.category != null) {
      result = result.where((e) => e.category == filter.category).toList();
    }

    if (filter.difficulty != null) {
      result = result.where((e) => e.difficulty == filter.difficulty).toList();
    }

    if (filter.searchQuery != null && filter.searchQuery!.isNotEmpty) {
      final query = filter.searchQuery!.toLowerCase();
      result = result.where((e) {
        return e.name.toLowerCase().contains(query) ||
            (e.nameEn?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    return result;
  }
}
