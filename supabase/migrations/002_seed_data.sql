-- ============================================
-- V2log 초기 데이터 (Seed Data)
-- 001_create_tables.sql 실행 후 실행
-- ============================================

-- ============================================
-- EXERCISES (운동 라이브러리) - 주요 운동 50개
-- ============================================

-- 가슴 운동
INSERT INTO exercises (name, name_en, category, primary_muscle, secondary_muscles, equipment_required, difficulty, instructions, tips) VALUES
('벤치프레스', 'Bench Press', 'STRENGTH', 'CHEST', ARRAY['TRICEPS', 'SHOULDERS'], ARRAY['BARBELL', 'BENCH'], 'BEGINNER',
  ARRAY['벤치에 눕고 바벨을 어깨너비보다 약간 넓게 잡습니다', '바벨을 가슴 중앙으로 천천히 내립니다', '가슴 근육을 사용해 바벨을 밀어올립니다'],
  ARRAY['어깨를 벤치에 고정하고 가슴을 살짝 들어올립니다', '팔꿈치 각도는 약 45도를 유지합니다']),

('인클라인 벤치프레스', 'Incline Bench Press', 'STRENGTH', 'CHEST', ARRAY['TRICEPS', 'SHOULDERS'], ARRAY['BARBELL', 'INCLINE_BENCH'], 'INTERMEDIATE',
  ARRAY['인클라인 벤치(30-45도)에 눕습니다', '바벨을 쇄골 방향으로 내립니다', '상부 가슴을 사용해 밀어올립니다'],
  ARRAY['각도가 너무 높으면 어깨에 무리가 갑니다', '30-45도가 최적입니다']),

('덤벨 벤치프레스', 'Dumbbell Bench Press', 'STRENGTH', 'CHEST', ARRAY['TRICEPS', 'SHOULDERS'], ARRAY['DUMBBELL', 'BENCH'], 'BEGINNER',
  ARRAY['덤벨을 양손에 들고 벤치에 눕습니다', '팔꿈치를 굽혀 덤벨을 가슴 옆으로 내립니다', '가슴 근육으로 덤벨을 밀어올립니다'],
  ARRAY['덤벨이 서로 부딪히지 않게 주의합니다', '가동범위를 최대로 활용하세요']),

('딥스', 'Dips', 'STRENGTH', 'CHEST', ARRAY['TRICEPS', 'SHOULDERS'], ARRAY['DIP_STATION'], 'INTERMEDIATE',
  ARRAY['딥스 바를 잡고 몸을 들어올립니다', '상체를 약간 앞으로 기울입니다', '팔꿈치를 굽혀 몸을 내린 후 밀어올립니다'],
  ARRAY['가슴에 집중하려면 상체를 앞으로 기울이세요', '삼두에 집중하려면 상체를 세우세요']),

('케이블 크로스오버', 'Cable Crossover', 'STRENGTH', 'CHEST', ARRAY[]::TEXT[], ARRAY['CABLE_MACHINE'], 'INTERMEDIATE',
  ARRAY['케이블 머신 중앙에 서서 양쪽 핸들을 잡습니다', '팔을 살짝 굽힌 상태로 가슴 앞에서 모읍니다', '천천히 시작 자세로 돌아갑니다'],
  ARRAY['가슴 수축을 느끼며 천천히 진행합니다', '팔꿈치 각도를 일정하게 유지하세요']),

('펙덱 플라이', 'Pec Deck Fly', 'STRENGTH', 'CHEST', ARRAY[]::TEXT[], ARRAY['MACHINE'], 'BEGINNER',
  ARRAY['펙덱 머신에 앉아 패드에 팔을 댑니다', '가슴 근육으로 팔을 모읍니다', '천천히 시작 자세로 돌아갑니다'],
  ARRAY['어깨가 앞으로 나오지 않게 주의합니다', '가슴 수축에 집중하세요']);

-- 등 운동
INSERT INTO exercises (name, name_en, category, primary_muscle, secondary_muscles, equipment_required, difficulty, instructions, tips) VALUES
('데드리프트', 'Deadlift', 'STRENGTH', 'BACK', ARRAY['GLUTES', 'HAMSTRINGS', 'TRAPS'], ARRAY['BARBELL'], 'INTERMEDIATE',
  ARRAY['바벨 앞에 서서 어깨너비로 발을 벌립니다', '엉덩이를 뒤로 빼며 바벨을 잡습니다', '등을 곧게 유지하며 바벨을 들어올립니다'],
  ARRAY['허리를 둥글게 하지 마세요', '바벨이 몸에서 멀어지지 않게 합니다']),

('바벨 로우', 'Barbell Row', 'STRENGTH', 'BACK', ARRAY['BICEPS', 'REAR_DELTS'], ARRAY['BARBELL'], 'INTERMEDIATE',
  ARRAY['바벨을 잡고 상체를 45도 정도 숙입니다', '바벨을 배꼽 방향으로 당깁니다', '등 근육 수축 후 천천히 내립니다'],
  ARRAY['등을 곧게 유지합니다', '팔꿈치를 몸 가까이 유지하세요']),

('랫풀다운', 'Lat Pulldown', 'STRENGTH', 'BACK', ARRAY['BICEPS'], ARRAY['CABLE_MACHINE'], 'BEGINNER',
  ARRAY['넓은 그립으로 바를 잡습니다', '가슴을 펴고 바를 쇄골 방향으로 당깁니다', '광배근 수축 후 천천히 올립니다'],
  ARRAY['상체를 너무 뒤로 젖히지 마세요', '어깨를 내리고 시작하세요']),

('풀업', 'Pull Up', 'STRENGTH', 'BACK', ARRAY['BICEPS', 'FOREARMS'], ARRAY['PULL_UP_BAR'], 'INTERMEDIATE',
  ARRAY['철봉을 어깨너비보다 넓게 잡습니다', '가슴을 철봉에 가까이 당깁니다', '천천히 시작 자세로 내려옵니다'],
  ARRAY['반동을 사용하지 마세요', '턱이 철봉 위로 올라가게 합니다']),

('시티드 로우', 'Seated Row', 'STRENGTH', 'BACK', ARRAY['BICEPS', 'REAR_DELTS'], ARRAY['CABLE_MACHINE'], 'BEGINNER',
  ARRAY['케이블 로우 머신에 앉습니다', '핸들을 배꼽 방향으로 당깁니다', '등 수축 후 천천히 돌아갑니다'],
  ARRAY['상체를 앞뒤로 흔들지 마세요', '어깨를 뒤로 모으며 당기세요']),

('원암 덤벨 로우', 'One Arm Dumbbell Row', 'STRENGTH', 'BACK', ARRAY['BICEPS'], ARRAY['DUMBBELL', 'BENCH'], 'BEGINNER',
  ARRAY['한 손과 무릎을 벤치에 올립니다', '반대 손으로 덤벨을 잡고 당깁니다', '등 수축 후 천천히 내립니다'],
  ARRAY['허리가 회전하지 않게 합니다', '팔꿈치를 몸 가까이 유지하세요']);

-- 어깨 운동
INSERT INTO exercises (name, name_en, category, primary_muscle, secondary_muscles, equipment_required, difficulty, instructions, tips) VALUES
('오버헤드 프레스', 'Overhead Press', 'STRENGTH', 'SHOULDERS', ARRAY['TRICEPS'], ARRAY['BARBELL'], 'INTERMEDIATE',
  ARRAY['바벨을 쇄골 높이에서 잡습니다', '바벨을 머리 위로 밀어올립니다', '천천히 시작 자세로 내립니다'],
  ARRAY['코어에 힘을 주어 허리를 보호하세요', '팔꿈치가 앞으로 나가지 않게 합니다']),

('덤벨 숄더 프레스', 'Dumbbell Shoulder Press', 'STRENGTH', 'SHOULDERS', ARRAY['TRICEPS'], ARRAY['DUMBBELL'], 'BEGINNER',
  ARRAY['덤벨을 어깨 높이에서 잡습니다', '덤벨을 머리 위로 밀어올립니다', '천천히 시작 자세로 내립니다'],
  ARRAY['손목이 꺾이지 않게 합니다', '팔꿈치 각도는 약간 앞쪽으로 합니다']),

('사이드 레터럴 레이즈', 'Side Lateral Raise', 'STRENGTH', 'SHOULDERS', ARRAY[]::TEXT[], ARRAY['DUMBBELL'], 'BEGINNER',
  ARRAY['덤벨을 양옆에 들고 섭니다', '팔을 옆으로 어깨 높이까지 올립니다', '천천히 시작 자세로 내립니다'],
  ARRAY['팔꿈치를 살짝 굽힙니다', '어깨보다 높이 올리지 마세요']),

('프론트 레이즈', 'Front Raise', 'STRENGTH', 'SHOULDERS', ARRAY[]::TEXT[], ARRAY['DUMBBELL'], 'BEGINNER',
  ARRAY['덤벨을 허벅지 앞에 들고 섭니다', '팔을 앞으로 어깨 높이까지 올립니다', '천천히 시작 자세로 내립니다'],
  ARRAY['반동을 사용하지 마세요', '코어에 힘을 줍니다']),

('페이스풀', 'Face Pull', 'STRENGTH', 'SHOULDERS', ARRAY['REAR_DELTS', 'TRAPS'], ARRAY['CABLE_MACHINE'], 'BEGINNER',
  ARRAY['케이블을 얼굴 높이로 설정합니다', '로프를 얼굴 옆으로 당깁니다', '후면 삼각근 수축 후 돌아갑니다'],
  ARRAY['어깨 건강에 좋은 운동입니다', '가볍게 많은 반복을 합니다']),

('리버스 펙덱 플라이', 'Reverse Pec Deck Fly', 'STRENGTH', 'SHOULDERS', ARRAY['REAR_DELTS'], ARRAY['MACHINE'], 'BEGINNER',
  ARRAY['펙덱 머신에 반대로 앉습니다', '팔을 뒤로 벌립니다', '후면 삼각근 수축 후 돌아갑니다'],
  ARRAY['어깨가 올라가지 않게 합니다', '등 상부 수축을 느끼세요']);

-- 이두 운동
INSERT INTO exercises (name, name_en, category, primary_muscle, secondary_muscles, equipment_required, difficulty, instructions, tips) VALUES
('바벨 컬', 'Barbell Curl', 'STRENGTH', 'BICEPS', ARRAY['FOREARMS'], ARRAY['BARBELL'], 'BEGINNER',
  ARRAY['바벨을 어깨너비로 잡습니다', '팔꿈치를 고정하고 바벨을 올립니다', '천천히 시작 자세로 내립니다'],
  ARRAY['상체 반동을 사용하지 마세요', '팔꿈치가 앞으로 나가지 않게 합니다']),

('덤벨 컬', 'Dumbbell Curl', 'STRENGTH', 'BICEPS', ARRAY['FOREARMS'], ARRAY['DUMBBELL'], 'BEGINNER',
  ARRAY['덤벨을 양손에 들고 섭니다', '한 팔씩 또는 동시에 컬을 합니다', '천천히 시작 자세로 내립니다'],
  ARRAY['손목을 회전시키며 컬하면 효과적입니다', '팔꿈치를 고정하세요']),

('해머 컬', 'Hammer Curl', 'STRENGTH', 'BICEPS', ARRAY['BRACHIALIS', 'FOREARMS'], ARRAY['DUMBBELL'], 'BEGINNER',
  ARRAY['덤벨을 중립 그립으로 잡습니다', '그립을 유지하며 컬합니다', '천천히 시작 자세로 내립니다'],
  ARRAY['상완근과 전완근도 자극됩니다', '팔꿈치를 고정하세요']),

('프리처 컬', 'Preacher Curl', 'STRENGTH', 'BICEPS', ARRAY[]::TEXT[], ARRAY['EZ_BAR', 'PREACHER_BENCH'], 'INTERMEDIATE',
  ARRAY['프리처 벤치에 팔을 올립니다', 'EZ바를 컬합니다', '천천히 시작 자세로 내립니다'],
  ARRAY['이두근 하부를 집중 자극합니다', '팔을 완전히 펴지 마세요']),

('케이블 컬', 'Cable Curl', 'STRENGTH', 'BICEPS', ARRAY[]::TEXT[], ARRAY['CABLE_MACHINE'], 'BEGINNER',
  ARRAY['케이블 손잡이를 잡습니다', '팔꿈치를 고정하고 컬합니다', '수축 후 천천히 내립니다'],
  ARRAY['일정한 장력이 유지됩니다', '다양한 핸들로 변형 가능합니다']);

-- 삼두 운동
INSERT INTO exercises (name, name_en, category, primary_muscle, secondary_muscles, equipment_required, difficulty, instructions, tips) VALUES
('트라이셉스 푸쉬다운', 'Triceps Pushdown', 'STRENGTH', 'TRICEPS', ARRAY[]::TEXT[], ARRAY['CABLE_MACHINE'], 'BEGINNER',
  ARRAY['케이블 바를 잡고 팔꿈치를 고정합니다', '팔을 펴며 바를 아래로 밀어냅니다', '천천히 시작 자세로 돌아갑니다'],
  ARRAY['팔꿈치가 움직이지 않게 고정합니다', '손목을 중립으로 유지하세요']),

('오버헤드 트라이셉스 익스텐션', 'Overhead Triceps Extension', 'STRENGTH', 'TRICEPS', ARRAY[]::TEXT[], ARRAY['DUMBBELL'], 'BEGINNER',
  ARRAY['덤벨을 머리 위로 들어올립니다', '팔꿈치를 굽혀 덤벨을 머리 뒤로 내립니다', '삼두근으로 덤벨을 밀어올립니다'],
  ARRAY['삼두근 장두를 자극합니다', '팔꿈치가 벌어지지 않게 합니다']),

('스컬 크러셔', 'Skull Crusher', 'STRENGTH', 'TRICEPS', ARRAY[]::TEXT[], ARRAY['EZ_BAR', 'BENCH'], 'INTERMEDIATE',
  ARRAY['벤치에 누워 EZ바를 머리 위로 듭니다', '팔꿈치만 굽혀 바를 이마 방향으로 내립니다', '삼두근으로 바를 밀어올립니다'],
  ARRAY['팔꿈치가 벌어지지 않게 합니다', '무게는 가볍게 시작하세요']),

('클로즈 그립 벤치프레스', 'Close Grip Bench Press', 'STRENGTH', 'TRICEPS', ARRAY['CHEST'], ARRAY['BARBELL', 'BENCH'], 'INTERMEDIATE',
  ARRAY['바벨을 좁은 그립으로 잡습니다', '팔꿈치를 몸에 붙이고 내립니다', '삼두근으로 밀어올립니다'],
  ARRAY['손목에 무리가 가지 않게 합니다', '가슴보다 삼두에 집중합니다']),

('킥백', 'Kickback', 'STRENGTH', 'TRICEPS', ARRAY[]::TEXT[], ARRAY['DUMBBELL'], 'BEGINNER',
  ARRAY['상체를 숙이고 팔꿈치를 고정합니다', '팔을 뒤로 펴며 덤벨을 올립니다', '수축 후 천천히 내립니다'],
  ARRAY['팔꿈치가 움직이지 않게 합니다', '가벼운 무게로 수축에 집중하세요']);

-- 하체 운동
INSERT INTO exercises (name, name_en, category, primary_muscle, secondary_muscles, equipment_required, difficulty, instructions, tips) VALUES
('스쿼트', 'Squat', 'STRENGTH', 'QUADS', ARRAY['GLUTES', 'HAMSTRINGS'], ARRAY['BARBELL', 'SQUAT_RACK'], 'INTERMEDIATE',
  ARRAY['바벨을 어깨에 올리고 섭니다', '엉덩이를 뒤로 빼며 앉습니다', '허벅지가 평행이 될 때까지 내려갑니다', '발로 땅을 밀며 일어납니다'],
  ARRAY['무릎이 발끝을 넘지 않게 합니다', '허리를 곧게 유지하세요']),

('레그 프레스', 'Leg Press', 'STRENGTH', 'QUADS', ARRAY['GLUTES', 'HAMSTRINGS'], ARRAY['LEG_PRESS_MACHINE'], 'BEGINNER',
  ARRAY['레그프레스 머신에 앉습니다', '발판을 밀어올립니다', '무릎을 굽혀 천천히 내립니다'],
  ARRAY['무릎이 가슴에 너무 가깝게 오지 않게 합니다', '허리를 패드에 붙이세요']),

('런지', 'Lunge', 'STRENGTH', 'QUADS', ARRAY['GLUTES', 'HAMSTRINGS'], ARRAY['DUMBBELL'], 'BEGINNER',
  ARRAY['덤벨을 들고 똑바로 섭니다', '한 발을 앞으로 내딛습니다', '뒷무릎이 바닥에 거의 닿을 때까지 내려갑니다', '앞발로 밀며 일어납니다'],
  ARRAY['상체를 곧게 유지합니다', '앞무릎이 발끝을 넘지 않게 합니다']),

('레그 익스텐션', 'Leg Extension', 'STRENGTH', 'QUADS', ARRAY[]::TEXT[], ARRAY['LEG_EXTENSION_MACHINE'], 'BEGINNER',
  ARRAY['레그 익스텐션 머신에 앉습니다', '대퇴사두근으로 패드를 올립니다', '정점에서 수축 후 천천히 내립니다'],
  ARRAY['무릎에 무리가 가지 않게 적당한 무게를 사용합니다', '전체 가동범위를 사용하세요']),

('레그 컬', 'Leg Curl', 'STRENGTH', 'HAMSTRINGS', ARRAY[]::TEXT[], ARRAY['LEG_CURL_MACHINE'], 'BEGINNER',
  ARRAY['레그 컬 머신에 엎드립니다', '햄스트링으로 패드를 당깁니다', '수축 후 천천히 내립니다'],
  ARRAY['허리가 들리지 않게 합니다', '햄스트링 수축에 집중하세요']),

('루마니안 데드리프트', 'Romanian Deadlift', 'STRENGTH', 'HAMSTRINGS', ARRAY['GLUTES', 'LOWER_BACK'], ARRAY['BARBELL'], 'INTERMEDIATE',
  ARRAY['바벨을 잡고 서서 무릎을 살짝 굽힙니다', '엉덩이를 뒤로 빼며 상체를 숙입니다', '햄스트링 스트레칭 후 일어납니다'],
  ARRAY['등을 곧게 유지합니다', '햄스트링 스트레칭을 느끼세요']),

('힙 쓰러스트', 'Hip Thrust', 'STRENGTH', 'GLUTES', ARRAY['HAMSTRINGS'], ARRAY['BARBELL', 'BENCH'], 'INTERMEDIATE',
  ARRAY['벤치에 등 상부를 기대고 앉습니다', '바벨을 골반에 올립니다', '엉덩이로 바벨을 들어올립니다'],
  ARRAY['정점에서 엉덩이를 강하게 수축합니다', '허리가 과신전되지 않게 합니다']),

('카프 레이즈', 'Calf Raise', 'STRENGTH', 'CALVES', ARRAY[]::TEXT[], ARRAY['MACHINE'], 'BEGINNER',
  ARRAY['카프레이즈 머신에 섭니다', '발가락으로 밀어 올라갑니다', '정점에서 수축 후 천천히 내립니다'],
  ARRAY['전체 가동범위를 사용합니다', '천천히 진행하세요']);

-- 복근 운동
INSERT INTO exercises (name, name_en, category, primary_muscle, secondary_muscles, equipment_required, difficulty, instructions, tips) VALUES
('크런치', 'Crunch', 'STRENGTH', 'ABS', ARRAY[]::TEXT[], ARRAY[]::TEXT[], 'BEGINNER',
  ARRAY['바닥에 누워 무릎을 굽힙니다', '손을 머리 뒤에 가볍게 댑니다', '상복부를 사용해 상체를 들어올립니다'],
  ARRAY['목을 당기지 마세요', '복근 수축에 집중합니다']),

('레그 레이즈', 'Leg Raise', 'STRENGTH', 'ABS', ARRAY['HIP_FLEXORS'], ARRAY[]::TEXT[], 'INTERMEDIATE',
  ARRAY['바닥에 누워 다리를 펴고 있습니다', '하복부를 사용해 다리를 들어올립니다', '천천히 다리를 내립니다'],
  ARRAY['허리가 바닥에서 뜨지 않게 합니다', '하복부에 집중하세요']),

('플랭크', 'Plank', 'STRENGTH', 'ABS', ARRAY['CORE'], ARRAY[]::TEXT[], 'BEGINNER',
  ARRAY['팔꿈치와 발가락으로 몸을 지탱합니다', '몸을 일직선으로 유지합니다', '정해진 시간 동안 자세를 유지합니다'],
  ARRAY['엉덩이가 처지거나 올라가지 않게 합니다', '코어에 힘을 줍니다']),

('러시안 트위스트', 'Russian Twist', 'STRENGTH', 'ABS', ARRAY['OBLIQUES'], ARRAY['DUMBBELL'], 'INTERMEDIATE',
  ARRAY['바닥에 앉아 상체를 뒤로 기울입니다', '덤벨을 들고 좌우로 회전합니다', '복사근 수축을 느끼며 진행합니다'],
  ARRAY['천천히 통제하며 진행합니다', '발이 떠도 좋습니다']),

('행잉 레그 레이즈', 'Hanging Leg Raise', 'STRENGTH', 'ABS', ARRAY['HIP_FLEXORS'], ARRAY['PULL_UP_BAR'], 'ADVANCED',
  ARRAY['철봉에 매달립니다', '복근으로 다리를 들어올립니다', '천천히 다리를 내립니다'],
  ARRAY['반동을 사용하지 마세요', '무릎을 굽혀도 됩니다']),

('케이블 크런치', 'Cable Crunch', 'STRENGTH', 'ABS', ARRAY[]::TEXT[], ARRAY['CABLE_MACHINE'], 'INTERMEDIATE',
  ARRAY['케이블 머신 앞에 무릎을 꿇습니다', '로프를 머리 뒤로 잡습니다', '복근으로 상체를 굽힙니다'],
  ARRAY['엉덩이가 움직이지 않게 합니다', '복근 수축에 집중하세요']);

-- 유산소 운동
INSERT INTO exercises (name, name_en, category, primary_muscle, secondary_muscles, equipment_required, difficulty, instructions, tips, calories_per_minute) VALUES
('러닝머신', 'Treadmill Running', 'CARDIO', 'FULL_BODY', ARRAY[]::TEXT[], ARRAY['TREADMILL'], 'BEGINNER',
  ARRAY['러닝머신에 올라갑니다', '원하는 속도와 경사를 설정합니다', '정해진 시간 동안 달립니다'],
  ARRAY['처음에는 낮은 속도로 시작합니다', '수분 섭취를 잊지 마세요'], 10.5),

('사이클', 'Stationary Bike', 'CARDIO', 'QUADS', ARRAY['HAMSTRINGS', 'CALVES'], ARRAY['STATIONARY_BIKE'], 'BEGINNER',
  ARRAY['사이클 머신에 앉습니다', '안장 높이를 조절합니다', '정해진 시간 동안 페달을 밟습니다'],
  ARRAY['무릎이 약간 굽혀진 상태에서 안장 높이를 맞춥니다', '저항을 조절하며 강도를 변화시킵니다'], 8.0),

('로잉머신', 'Rowing Machine', 'CARDIO', 'BACK', ARRAY['QUADS', 'BICEPS', 'CORE'], ARRAY['ROWING_MACHINE'], 'INTERMEDIATE',
  ARRAY['로잉머신에 앉아 발을 고정합니다', '핸들을 잡고 다리-허리-팔 순으로 당깁니다', '팔-허리-다리 순으로 돌아갑니다'],
  ARRAY['다리의 힘을 먼저 사용합니다', '등을 곧게 유지하세요'], 9.0),

('버피', 'Burpee', 'CARDIO', 'FULL_BODY', ARRAY[]::TEXT[], ARRAY[]::TEXT[], 'ADVANCED',
  ARRAY['서있는 자세에서 시작합니다', '쪼그려 앉아 손을 바닥에 짚습니다', '다리를 뒤로 뻗어 플랭크 자세를 만듭니다', '다리를 다시 당기고 점프합니다'],
  ARRAY['전신 운동으로 매우 효과적입니다', '올바른 자세를 유지하세요'], 12.0),

('점핑잭', 'Jumping Jack', 'CARDIO', 'FULL_BODY', ARRAY[]::TEXT[], ARRAY[]::TEXT[], 'BEGINNER',
  ARRAY['똑바로 서서 팔을 옆에 둡니다', '점프하며 팔과 다리를 벌립니다', '다시 점프하며 시작 자세로 돌아갑니다'],
  ARRAY['워밍업으로 좋습니다', '무릎에 무리가 가지 않게 합니다'], 8.0);


-- ============================================
-- PRESET_ROUTINES (전문가 루틴) - 5개
-- ============================================

-- 1. 초보자 3분할 (주 3회)
INSERT INTO preset_routines (name, name_en, description, difficulty, target_goal, days_per_week, estimated_duration_minutes, target_muscles, equipment_required, is_featured)
VALUES (
  '초보자 3분할 프로그램',
  'Beginner 3-Day Split',
  '헬스 입문자를 위한 기본 루틴입니다. 가슴/등/하체를 나누어 주 3회 진행하며, 기초 근력과 올바른 자세를 만드는 데 집중합니다.',
  'BEGINNER',
  'HYPERTROPHY',
  3,
  60,
  ARRAY['CHEST', 'BACK', 'LEGS', 'SHOULDERS', 'ARMS'],
  ARRAY['BARBELL', 'DUMBBELL', 'MACHINE'],
  TRUE
);

-- 2. 중급자 4분할 (주 4회)
INSERT INTO preset_routines (name, name_en, description, difficulty, target_goal, days_per_week, estimated_duration_minutes, target_muscles, equipment_required, is_featured)
VALUES (
  '중급자 4분할 프로그램',
  'Intermediate 4-Day Split',
  '어느 정도 경험이 있는 분들을 위한 루틴입니다. 상체/하체를 세분화하여 더 집중적인 자극을 줍니다.',
  'INTERMEDIATE',
  'HYPERTROPHY',
  4,
  75,
  ARRAY['CHEST', 'BACK', 'LEGS', 'SHOULDERS', 'ARMS'],
  ARRAY['BARBELL', 'DUMBBELL', 'CABLE_MACHINE', 'MACHINE'],
  TRUE
);

-- 3. 상체 집중 푸시풀 (주 4회)
INSERT INTO preset_routines (name, name_en, description, difficulty, target_goal, days_per_week, estimated_duration_minutes, target_muscles, equipment_required, is_featured)
VALUES (
  '푸시풀 상체 집중',
  'Push Pull Upper Focus',
  '상체 발달에 집중하는 푸시/풀 분할 루틴입니다. 미는 운동과 당기는 운동을 분리하여 효율적으로 훈련합니다.',
  'INTERMEDIATE',
  'HYPERTROPHY',
  4,
  70,
  ARRAY['CHEST', 'BACK', 'SHOULDERS', 'ARMS'],
  ARRAY['BARBELL', 'DUMBBELL', 'CABLE_MACHINE'],
  FALSE
);

-- 4. 하체 집중 프로그램 (주 3회)
INSERT INTO preset_routines (name, name_en, description, difficulty, target_goal, days_per_week, estimated_duration_minutes, target_muscles, equipment_required, is_featured)
VALUES (
  '하체 집중 프로그램',
  'Lower Body Focus Program',
  '하체 근력과 근비대에 집중하는 프로그램입니다. 스쿼트, 데드리프트 등 복합 운동을 중심으로 구성됩니다.',
  'INTERMEDIATE',
  'STRENGTH',
  3,
  70,
  ARRAY['QUADS', 'HAMSTRINGS', 'GLUTES', 'CALVES'],
  ARRAY['BARBELL', 'DUMBBELL', 'LEG_PRESS_MACHINE'],
  FALSE
);

-- 5. 홈트레이닝 덤벨 루틴 (주 3회)
INSERT INTO preset_routines (name, name_en, description, difficulty, target_goal, days_per_week, estimated_duration_minutes, target_muscles, equipment_required, is_featured)
VALUES (
  '홈트레이닝 덤벨 루틴',
  'Home Dumbbell Workout',
  '덤벨만으로 진행할 수 있는 홈트레이닝 루틴입니다. 집에서도 효과적으로 전신을 단련할 수 있습니다.',
  'BEGINNER',
  'HYPERTROPHY',
  3,
  45,
  ARRAY['CHEST', 'BACK', 'LEGS', 'SHOULDERS', 'ARMS'],
  ARRAY['DUMBBELL'],
  TRUE
);


-- ============================================
-- PRESET_ROUTINE_EXERCISES (프리셋 루틴 - 운동 연결)
-- ============================================

-- 초보자 3분할 - Day 1: 가슴/삼두
INSERT INTO preset_routine_exercises (preset_routine_id, exercise_id, day_number, day_name, order_index, target_sets, target_reps, rest_seconds, notes)
SELECT
  (SELECT id FROM preset_routines WHERE name = '초보자 3분할 프로그램'),
  e.id,
  1,
  'Day 1 - 가슴/삼두',
  exercise_order,
  sets,
  reps,
  rest,
  notes
FROM (VALUES
  ('벤치프레스', 1, 4, '8-10', 120, '첫 세트는 워밍업'),
  ('인클라인 벤치프레스', 2, 3, '10-12', 90, NULL),
  ('펙덱 플라이', 3, 3, '12-15', 60, '가슴 수축에 집중'),
  ('트라이셉스 푸쉬다운', 4, 3, '12-15', 60, NULL),
  ('오버헤드 트라이셉스 익스텐션', 5, 3, '10-12', 60, NULL)
) AS v(exercise_name, exercise_order, sets, reps, rest, notes)
JOIN exercises e ON e.name = v.exercise_name;

-- 초보자 3분할 - Day 2: 등/이두
INSERT INTO preset_routine_exercises (preset_routine_id, exercise_id, day_number, day_name, order_index, target_sets, target_reps, rest_seconds, notes)
SELECT
  (SELECT id FROM preset_routines WHERE name = '초보자 3분할 프로그램'),
  e.id,
  2,
  'Day 2 - 등/이두',
  exercise_order,
  sets,
  reps,
  rest,
  notes
FROM (VALUES
  ('랫풀다운', 1, 4, '10-12', 90, '광배근 수축에 집중'),
  ('시티드 로우', 2, 3, '10-12', 90, NULL),
  ('원암 덤벨 로우', 3, 3, '10-12', 60, '각 팔당'),
  ('바벨 컬', 4, 3, '10-12', 60, NULL),
  ('해머 컬', 5, 3, '12-15', 60, NULL)
) AS v(exercise_name, exercise_order, sets, reps, rest, notes)
JOIN exercises e ON e.name = v.exercise_name;

-- 초보자 3분할 - Day 3: 하체/어깨
INSERT INTO preset_routine_exercises (preset_routine_id, exercise_id, day_number, day_name, order_index, target_sets, target_reps, rest_seconds, notes)
SELECT
  (SELECT id FROM preset_routines WHERE name = '초보자 3분할 프로그램'),
  e.id,
  3,
  'Day 3 - 하체/어깨',
  exercise_order,
  sets,
  reps,
  rest,
  notes
FROM (VALUES
  ('레그 프레스', 1, 4, '10-12', 120, '스쿼트 대신 초보자용'),
  ('레그 익스텐션', 2, 3, '12-15', 60, NULL),
  ('레그 컬', 3, 3, '12-15', 60, NULL),
  ('덤벨 숄더 프레스', 4, 3, '10-12', 90, NULL),
  ('사이드 레터럴 레이즈', 5, 3, '15-20', 60, '가볍게 많은 반복')
) AS v(exercise_name, exercise_order, sets, reps, rest, notes)
JOIN exercises e ON e.name = v.exercise_name;


-- 중급자 4분할 - Day 1: 가슴
INSERT INTO preset_routine_exercises (preset_routine_id, exercise_id, day_number, day_name, order_index, target_sets, target_reps, rest_seconds, notes)
SELECT
  (SELECT id FROM preset_routines WHERE name = '중급자 4분할 프로그램'),
  e.id,
  1,
  'Day 1 - 가슴',
  exercise_order,
  sets,
  reps,
  rest,
  notes
FROM (VALUES
  ('벤치프레스', 1, 4, '6-8', 180, '무거운 무게로'),
  ('인클라인 벤치프레스', 2, 4, '8-10', 120, NULL),
  ('덤벨 벤치프레스', 3, 3, '10-12', 90, NULL),
  ('케이블 크로스오버', 4, 3, '12-15', 60, '수축에 집중'),
  ('딥스', 5, 3, '실패까지', 90, '가슴에 집중')
) AS v(exercise_name, exercise_order, sets, reps, rest, notes)
JOIN exercises e ON e.name = v.exercise_name;

-- 중급자 4분할 - Day 2: 등
INSERT INTO preset_routine_exercises (preset_routine_id, exercise_id, day_number, day_name, order_index, target_sets, target_reps, rest_seconds, notes)
SELECT
  (SELECT id FROM preset_routines WHERE name = '중급자 4분할 프로그램'),
  e.id,
  2,
  'Day 2 - 등',
  exercise_order,
  sets,
  reps,
  rest,
  notes
FROM (VALUES
  ('데드리프트', 1, 4, '5-6', 180, '허리 주의'),
  ('바벨 로우', 2, 4, '8-10', 120, NULL),
  ('풀업', 3, 4, '실패까지', 90, '보조 사용 가능'),
  ('시티드 로우', 4, 3, '10-12', 90, NULL),
  ('페이스풀', 5, 3, '15-20', 60, '후면 삼각근')
) AS v(exercise_name, exercise_order, sets, reps, rest, notes)
JOIN exercises e ON e.name = v.exercise_name;

-- 중급자 4분할 - Day 3: 어깨/팔
INSERT INTO preset_routine_exercises (preset_routine_id, exercise_id, day_number, day_name, order_index, target_sets, target_reps, rest_seconds, notes)
SELECT
  (SELECT id FROM preset_routines WHERE name = '중급자 4분할 프로그램'),
  e.id,
  3,
  'Day 3 - 어깨/팔',
  exercise_order,
  sets,
  reps,
  rest,
  notes
FROM (VALUES
  ('오버헤드 프레스', 1, 4, '6-8', 120, NULL),
  ('사이드 레터럴 레이즈', 2, 4, '12-15', 60, NULL),
  ('리버스 펙덱 플라이', 3, 3, '12-15', 60, NULL),
  ('바벨 컬', 4, 3, '10-12', 60, NULL),
  ('트라이셉스 푸쉬다운', 5, 3, '10-12', 60, NULL),
  ('해머 컬', 6, 3, '12-15', 60, NULL)
) AS v(exercise_name, exercise_order, sets, reps, rest, notes)
JOIN exercises e ON e.name = v.exercise_name;

-- 중급자 4분할 - Day 4: 하체
INSERT INTO preset_routine_exercises (preset_routine_id, exercise_id, day_number, day_name, order_index, target_sets, target_reps, rest_seconds, notes)
SELECT
  (SELECT id FROM preset_routines WHERE name = '중급자 4분할 프로그램'),
  e.id,
  4,
  'Day 4 - 하체',
  exercise_order,
  sets,
  reps,
  rest,
  notes
FROM (VALUES
  ('스쿼트', 1, 4, '6-8', 180, '코어 힘 유지'),
  ('레그 프레스', 2, 4, '10-12', 120, NULL),
  ('루마니안 데드리프트', 3, 4, '8-10', 120, '햄스트링 스트레칭'),
  ('레그 익스텐션', 4, 3, '12-15', 60, NULL),
  ('레그 컬', 5, 3, '12-15', 60, NULL),
  ('카프 레이즈', 6, 4, '15-20', 60, NULL)
) AS v(exercise_name, exercise_order, sets, reps, rest, notes)
JOIN exercises e ON e.name = v.exercise_name;


-- 홈트레이닝 덤벨 루틴 - Day 1: 상체 푸시
INSERT INTO preset_routine_exercises (preset_routine_id, exercise_id, day_number, day_name, order_index, target_sets, target_reps, rest_seconds, notes)
SELECT
  (SELECT id FROM preset_routines WHERE name = '홈트레이닝 덤벨 루틴'),
  e.id,
  1,
  'Day 1 - 상체 푸시',
  exercise_order,
  sets,
  reps,
  rest,
  notes
FROM (VALUES
  ('덤벨 벤치프레스', 1, 4, '10-12', 90, '바닥에서 가능'),
  ('덤벨 숄더 프레스', 2, 3, '10-12', 90, NULL),
  ('사이드 레터럴 레이즈', 3, 3, '15-20', 60, NULL),
  ('오버헤드 트라이셉스 익스텐션', 4, 3, '12-15', 60, NULL),
  ('크런치', 5, 3, '15-20', 45, NULL)
) AS v(exercise_name, exercise_order, sets, reps, rest, notes)
JOIN exercises e ON e.name = v.exercise_name;

-- 홈트레이닝 덤벨 루틴 - Day 2: 상체 풀
INSERT INTO preset_routine_exercises (preset_routine_id, exercise_id, day_number, day_name, order_index, target_sets, target_reps, rest_seconds, notes)
SELECT
  (SELECT id FROM preset_routines WHERE name = '홈트레이닝 덤벨 루틴'),
  e.id,
  2,
  'Day 2 - 상체 풀',
  exercise_order,
  sets,
  reps,
  rest,
  notes
FROM (VALUES
  ('원암 덤벨 로우', 1, 4, '10-12', 60, '각 팔당'),
  ('덤벨 컬', 2, 3, '12-15', 60, NULL),
  ('해머 컬', 3, 3, '12-15', 60, NULL),
  ('프론트 레이즈', 4, 3, '12-15', 60, NULL),
  ('플랭크', 5, 3, '30-60초', 45, NULL)
) AS v(exercise_name, exercise_order, sets, reps, rest, notes)
JOIN exercises e ON e.name = v.exercise_name;

-- 홈트레이닝 덤벨 루틴 - Day 3: 하체
INSERT INTO preset_routine_exercises (preset_routine_id, exercise_id, day_number, day_name, order_index, target_sets, target_reps, rest_seconds, notes)
SELECT
  (SELECT id FROM preset_routines WHERE name = '홈트레이닝 덤벨 루틴'),
  e.id,
  3,
  'Day 3 - 하체',
  exercise_order,
  sets,
  reps,
  rest,
  notes
FROM (VALUES
  ('런지', 1, 4, '10-12', 90, '각 다리당'),
  ('루마니안 데드리프트', 2, 4, '10-12', 90, NULL),
  ('러시안 트위스트', 3, 3, '20회', 60, NULL),
  ('레그 레이즈', 4, 3, '15-20', 60, NULL)
) AS v(exercise_name, exercise_order, sets, reps, rest, notes)
JOIN exercises e ON e.name = v.exercise_name;


-- ============================================
-- 완료 메시지
-- ============================================
DO $$
DECLARE
  exercise_count INTEGER;
  routine_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO exercise_count FROM exercises;
  SELECT COUNT(*) INTO routine_count FROM preset_routines;

  RAISE NOTICE '✅ V2log 시드 데이터 입력 완료!';
  RAISE NOTICE '운동 라이브러리: % 개', exercise_count;
  RAISE NOTICE '프리셋 루틴: % 개', routine_count;
END $$;
