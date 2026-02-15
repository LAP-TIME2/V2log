-- V2log 운동 라이브러리 확장 시드 스크립트 (v2)
-- 49개 신규 운동 추가 (기존 41개 건드리지 않음)
-- 실행: Supabase SQL Editor에서 복사+붙여넣기
--
-- ON CONFLICT DO NOTHING: 이미 같은 ID가 있으면 무시
-- UUID 패턴: 10000000-0001-4000-8000-000000000XXX

-- ==================== 가슴 (+5) ====================
INSERT INTO exercises (id, name, name_en, category, primary_muscle, secondary_muscles, equipment_required, difficulty, instructions, tips, calories_per_minute)
VALUES
  ('10000000-0001-4000-8000-000000000008', '디클라인 벤치프레스', 'Decline Bench Press', 'STRENGTH', 'CHEST', ARRAY['TRICEPS','SHOULDERS'], ARRAY['바벨','디클라인 벤치'], 'INTERMEDIATE',
    ARRAY['벤치를 15-30도 디클라인으로 설정합니다.','발을 패드에 고정하고 바벨을 어깨 너비로 잡습니다.','바벨을 하부 가슴으로 천천히 내립니다.','가슴 하부의 힘으로 밀어 올립니다.'],
    ARRAY['하부 가슴에 집중하세요.','너무 과도한 각도는 피하세요.'], 6.0),
  ('10000000-0001-4000-8000-000000000009', '인클라인 덤벨 플라이', 'Incline Dumbbell Fly', 'STRENGTH', 'CHEST', ARRAY['SHOULDERS'], ARRAY['덤벨','인클라인 벤치'], 'INTERMEDIATE',
    ARRAY['인클라인 벤치에 누워 덤벨을 위로 들어올립니다.','팔꿈치를 약간 구부린 채로 양팔을 옆으로 벌립니다.','가슴 상부의 스트레칭을 느끼며 내립니다.','가슴을 수축시키며 덤벨을 다시 모읍니다.'],
    ARRAY['팔꿈치 각도를 일정하게 유지하세요.','어깨가 아닌 가슴으로 모으세요.'], 4.5),
  ('10000000-0001-4000-8000-000000000100', '체스트프레스 머신', 'Chest Press Machine', 'STRENGTH', 'CHEST', ARRAY['TRICEPS','SHOULDERS'], ARRAY['체스트프레스 머신'], 'BEGINNER',
    ARRAY['머신에 앉아 등을 패드에 붙입니다.','손잡이를 잡고 가슴 높이에 맞춥니다.','가슴의 힘으로 앞으로 밀어냅니다.','천천히 시작 위치로 돌아옵니다.'],
    ARRAY['초보자에게 안전한 머신 운동입니다.','가슴 수축에 집중하세요.'], 5.0),
  ('10000000-0001-4000-8000-000000000101', '푸시업', 'Push-up', 'STRENGTH', 'CHEST', ARRAY['TRICEPS','SHOULDERS','CORE'], ARRAY[]::text[], 'BEGINNER',
    ARRAY['양손을 어깨 너비로 바닥에 짚습니다.','몸을 일직선으로 유지합니다.','팔꿈치를 구부려 가슴이 바닥 가까이 오도록 내려갑니다.','팔을 펴며 시작 자세로 돌아옵니다.'],
    ARRAY['코어에 힘을 주세요.','엉덩이가 올라가거나 내려가지 않게 하세요.'], 6.0),
  ('10000000-0001-4000-8000-000000000102', '덤벨 플라이', 'Dumbbell Fly', 'STRENGTH', 'CHEST', ARRAY['SHOULDERS'], ARRAY['덤벨','벤치'], 'INTERMEDIATE',
    ARRAY['벤치에 누워 덤벨을 위로 들어올립니다.','팔꿈치를 약간 구부린 채로 양팔을 옆으로 벌립니다.','가슴의 스트레칭을 느끼며 내립니다.','가슴을 수축시키며 덤벨을 다시 모읍니다.'],
    ARRAY['팔꿈치 각도를 일정하게 유지하세요.','너무 무거운 무게는 어깨 부상 위험이 있습니다.'], 4.5)
ON CONFLICT (id) DO NOTHING;

-- ==================== 등 (+6) ====================
INSERT INTO exercises (id, name, name_en, category, primary_muscle, secondary_muscles, equipment_required, difficulty, instructions, tips, calories_per_minute)
VALUES
  ('10000000-0001-4000-8000-000000000016', '펜들레이 로우', 'Pendlay Row', 'STRENGTH', 'BACK', ARRAY['BICEPS','LATS'], ARRAY['바벨'], 'INTERMEDIATE',
    ARRAY['바벨을 바닥에 놓고 상체를 90도로 숙입니다.','바벨을 어깨 너비로 잡습니다.','폭발적으로 바벨을 가슴 쪽으로 당깁니다.','바벨을 바닥에 완전히 내려놓습니다.'],
    ARRAY['매 반복마다 바벨이 바닥에 닿아야 합니다.','등을 곧게 유지하세요.'], 6.5),
  ('10000000-0001-4000-8000-000000000017', '친업', 'Chin-up', 'STRENGTH', 'LATS', ARRAY['BICEPS','BACK'], ARRAY['풀업 바'], 'INTERMEDIATE',
    ARRAY['풀업 바를 어깨 너비로 언더그립으로 잡습니다.','이두근과 등의 힘으로 턱이 바 위로 올라올 때까지 당깁니다.','천천히 내려옵니다.'],
    ARRAY['풀업보다 이두근 자극이 큽니다.','반동을 사용하지 마세요.'], 7.0),
  ('10000000-0001-4000-8000-000000000018', '티바 로우', 'T-bar Row', 'STRENGTH', 'BACK', ARRAY['BICEPS','LATS'], ARRAY['티바 로우 머신'], 'INTERMEDIATE',
    ARRAY['티바 로우 머신에 서서 핸들을 잡습니다.','상체를 45도로 숙이고 등을 곧게 폅니다.','핸들을 가슴 쪽으로 당깁니다.','천천히 내립니다.'],
    ARRAY['등 근육의 수축에 집중하세요.','허리를 굽히지 마세요.'], 6.0),
  ('10000000-0001-4000-8000-000000000019', '하이퍼 익스텐션', 'Hyperextension', 'STRENGTH', 'LOWER_BACK', ARRAY['GLUTES','HAMSTRINGS'], ARRAY['하이퍼 익스텐션 벤치'], 'BEGINNER',
    ARRAY['하이퍼 익스텐션 벤치에 엎드려 허벅지를 패드에 고정합니다.','상체를 아래로 숙입니다.','하부 등과 둔근의 힘으로 상체를 들어올립니다.','몸이 일직선이 될 때까지 올린 후 천천히 내립니다.'],
    ARRAY['과도하게 젖히지 마세요.','하부 등 강화에 좋은 운동입니다.'], 4.5),
  ('10000000-0001-4000-8000-000000000110', '케이블 스트레이트 암 풀다운', 'Cable Straight Arm Pulldown', 'STRENGTH', 'LATS', ARRAY['BACK'], ARRAY['케이블 머신'], 'INTERMEDIATE',
    ARRAY['케이블을 높은 위치에 설정하고 바를 잡습니다.','팔을 곧게 편 채로 바를 허벅지까지 당깁니다.','광배근의 수축을 느끼며 내립니다.','천천히 시작 위치로 돌아옵니다.'],
    ARRAY['팔꿈치를 구부리지 마세요.','광배근에 집중하세요.'], 4.0),
  ('10000000-0001-4000-8000-000000000111', '덤벨 풀오버', 'Dumbbell Pullover', 'STRENGTH', 'LATS', ARRAY['CHEST'], ARRAY['덤벨','벤치'], 'INTERMEDIATE',
    ARRAY['벤치에 등 상부만 대고 눕습니다.','덤벨을 양손으로 잡고 가슴 위로 들어올립니다.','팔을 곧게 편 채로 머리 뒤로 내립니다.','광배근과 가슴의 힘으로 다시 들어올립니다.'],
    ARRAY['깊이 내릴수록 스트레칭이 커집니다.','코어에 힘을 주세요.'], 4.5)
ON CONFLICT (id) DO NOTHING;

-- ==================== 어깨 (+6) ====================
INSERT INTO exercises (id, name, name_en, category, primary_muscle, secondary_muscles, equipment_required, difficulty, instructions, tips, calories_per_minute)
VALUES
  ('10000000-0001-4000-8000-000000000026', '아놀드 프레스', 'Arnold Press', 'STRENGTH', 'SHOULDERS', ARRAY['TRICEPS'], ARRAY['덤벨'], 'INTERMEDIATE',
    ARRAY['덤벨을 어깨 높이에서 손바닥이 나를 향하게 잡습니다.','밀어 올리면서 손목을 바깥으로 회전시킵니다.','팔이 완전히 펴지면 손바닥이 앞을 향합니다.','역순으로 천천히 내립니다.'],
    ARRAY['회전 동작을 부드럽게 하세요.','삼각근 전체에 자극이 갑니다.'], 5.5),
  ('10000000-0001-4000-8000-000000000027', '숄더프레스 머신', 'Shoulder Press Machine', 'STRENGTH', 'SHOULDERS', ARRAY['TRICEPS'], ARRAY['숄더프레스 머신'], 'BEGINNER',
    ARRAY['머신에 앉아 등을 패드에 붙입니다.','손잡이를 어깨 높이에서 잡습니다.','머리 위로 밀어 올립니다.','천천히 시작 위치로 돌아옵니다.'],
    ARRAY['초보자에게 안전한 머신 운동입니다.','어깨에 집중하세요.'], 5.0),
  ('10000000-0001-4000-8000-000000000028', '케이블 레터럴 레이즈', 'Cable Lateral Raise', 'STRENGTH', 'SHOULDERS', ARRAY[]::text[], ARRAY['케이블 머신'], 'INTERMEDIATE',
    ARRAY['케이블을 낮은 위치에 설정합니다.','반대쪽 손으로 핸들을 잡습니다.','팔을 옆으로 어깨 높이까지 들어올립니다.','천천히 내립니다.'],
    ARRAY['케이블이 일정한 장력을 제공해 효과적입니다.','반동을 사용하지 마세요.'], 3.5),
  ('10000000-0001-4000-8000-000000000029', '레터럴 레이즈 머신', 'Lateral Raise Machine', 'STRENGTH', 'SHOULDERS', ARRAY[]::text[], ARRAY['레터럴 레이즈 머신'], 'BEGINNER',
    ARRAY['머신에 앉아 팔을 패드에 대세요.','어깨의 힘으로 팔을 옆으로 들어올립니다.','어깨 높이까지 올린 후 천천히 내립니다.'],
    ARRAY['머신이 궤도를 잡아줘서 초보자에게 좋습니다.','어깨 측면에 집중하세요.'], 3.5),
  ('10000000-0001-4000-8000-000000000120', '업라이트 로우', 'Upright Row', 'STRENGTH', 'SHOULDERS', ARRAY['TRAPS'], ARRAY['바벨'], 'INTERMEDIATE',
    ARRAY['바벨을 어깨 너비보다 좁게 잡고 서세요.','팔꿈치를 높이 올리며 바벨을 턱 아래까지 당깁니다.','천천히 내립니다.'],
    ARRAY['팔꿈치가 손보다 높아야 합니다.','어깨에 통증이 있으면 중단하세요.'], 5.0),
  ('10000000-0001-4000-8000-000000000121', '바벨 슈러그', 'Barbell Shrug', 'STRENGTH', 'TRAPS', ARRAY[]::text[], ARRAY['바벨'], 'BEGINNER',
    ARRAY['바벨을 어깨 너비로 잡고 서세요.','어깨를 귀 쪽으로 으쓱 올립니다.','승모근을 수축시킨 후 천천히 내립니다.'],
    ARRAY['어깨를 돌리지 말고 수직으로 올리세요.','무거운 무게로 하면 효과적입니다.'], 4.0)
ON CONFLICT (id) DO NOTHING;

-- ==================== 이두 (+5) ====================
INSERT INTO exercises (id, name, name_en, category, primary_muscle, secondary_muscles, equipment_required, difficulty, instructions, tips, calories_per_minute)
VALUES
  ('10000000-0001-4000-8000-000000000036', '이지바 컬', 'EZ Bar Curl', 'STRENGTH', 'BICEPS', ARRAY['FOREARMS'], ARRAY['이지바'], 'BEGINNER',
    ARRAY['이지바의 곡선 부분을 잡고 서세요.','팔꿈치를 고정하고 바를 어깨 쪽으로 들어올립니다.','이두근을 수축시킨 후 천천히 내립니다.'],
    ARRAY['이지바는 손목 부담이 적습니다.','팔꿈치를 움직이지 않게 고정하세요.'], 4.0),
  ('10000000-0001-4000-8000-000000000037', '프리쳐 컬', 'Preacher Curl', 'STRENGTH', 'BICEPS', ARRAY['FOREARMS'], ARRAY['이지바','프리쳐 벤치'], 'BEGINNER',
    ARRAY['프리쳐 벤치에 팔뚝을 올려놓습니다.','이지바를 잡고 이두근의 힘으로 들어올립니다.','천천히 내립니다.'],
    ARRAY['팔이 패드에서 떨어지지 않게 하세요.','이두근 하부에 집중하세요.'], 3.5),
  ('10000000-0001-4000-8000-000000000038', '인클라인 덤벨 컬', 'Incline Dumbbell Curl', 'STRENGTH', 'BICEPS', ARRAY['FOREARMS'], ARRAY['덤벨','인클라인 벤치'], 'INTERMEDIATE',
    ARRAY['인클라인 벤치에 앉아 덤벨을 양 옆으로 늘어뜨립니다.','팔꿈치를 고정하고 덤벨을 들어올립니다.','이두근을 수축시킨 후 천천히 내립니다.'],
    ARRAY['인클라인으로 이두근 스트레칭이 극대화됩니다.','상체를 흔들지 마세요.'], 3.5),
  ('10000000-0001-4000-8000-000000000039', '케이블 컬', 'Cable Curl', 'STRENGTH', 'BICEPS', ARRAY['FOREARMS'], ARRAY['케이블 머신'], 'BEGINNER',
    ARRAY['케이블을 낮은 위치에 설정하고 바를 잡습니다.','팔꿈치를 고정하고 바를 어깨 쪽으로 당깁니다.','이두근을 수축시킨 후 천천히 내립니다.'],
    ARRAY['케이블이 일정한 장력을 유지해줍니다.','팔꿈치 위치를 고정하세요.'], 3.5),
  ('10000000-0001-4000-8000-000000000140', '컨센트레이션 컬', 'Concentration Curl', 'STRENGTH', 'BICEPS', ARRAY[]::text[], ARRAY['덤벨'], 'BEGINNER',
    ARRAY['벤치에 앉아 팔꿈치를 허벅지 안쪽에 고정합니다.','덤벨을 한 손으로 잡고 이두근의 힘으로 들어올립니다.','이두근을 최대한 수축시킨 후 천천히 내립니다.'],
    ARRAY['고립 운동의 대표입니다.','이두근 피크에 집중하세요.'], 3.0)
ON CONFLICT (id) DO NOTHING;

-- ==================== 삼두 (+5) ====================
INSERT INTO exercises (id, name, name_en, category, primary_muscle, secondary_muscles, equipment_required, difficulty, instructions, tips, calories_per_minute)
VALUES
  ('10000000-0001-4000-8000-000000000150', '스컬 크러셔', 'Skull Crusher', 'STRENGTH', 'TRICEPS', ARRAY[]::text[], ARRAY['이지바','벤치'], 'INTERMEDIATE',
    ARRAY['벤치에 눕고 이지바를 좁게 잡아 위로 들어올립니다.','팔꿈치를 고정하고 바를 이마 쪽으로 내립니다.','삼두근의 힘으로 다시 밀어 올립니다.'],
    ARRAY['팔꿈치가 벌어지지 않게 하세요.','이마가 아닌 이마 뒤로 내리면 더 안전합니다.'], 4.5),
  ('10000000-0001-4000-8000-000000000151', '덤벨 킥백', 'Dumbbell Kickback', 'STRENGTH', 'TRICEPS', ARRAY[]::text[], ARRAY['덤벨'], 'BEGINNER',
    ARRAY['상체를 앞으로 숙이고 팔꿈치를 몸에 붙입니다.','팔꿈치를 고정하고 덤벨을 뒤로 밀어냅니다.','팔이 완전히 펴지면 삼두근을 수축시킵니다.','천천히 내립니다.'],
    ARRAY['팔꿈치 위치를 고정하세요.','가벼운 무게로 수축에 집중하세요.'], 3.5),
  ('10000000-0001-4000-8000-000000000152', '오버헤드 케이블 익스텐션', 'Overhead Cable Triceps Extension', 'STRENGTH', 'TRICEPS', ARRAY[]::text[], ARRAY['케이블 머신','로프'], 'INTERMEDIATE',
    ARRAY['케이블을 낮은 위치에 설정하고 로프를 잡습니다.','등을 케이블 머신 쪽으로 하고 로프를 머리 위로 잡습니다.','팔꿈치를 고정하고 로프를 앞으로 밀어냅니다.','삼두근을 수축시킨 후 천천히 돌아옵니다.'],
    ARRAY['케이블이 일정한 장력을 유지해줍니다.','삼두근 장두에 효과적입니다.'], 4.0),
  ('10000000-0001-4000-8000-000000000153', '삼두 딥스', 'Tricep Dips', 'STRENGTH', 'TRICEPS', ARRAY['CHEST','SHOULDERS'], ARRAY['딥스 바'], 'INTERMEDIATE',
    ARRAY['딥스 바를 잡고 몸을 들어올립니다.','상체를 곧게 세운 채로 팔꿈치를 구부립니다.','팔꿈치가 90도가 될 때까지 내려갑니다.','삼두근의 힘으로 밀어 올립니다.'],
    ARRAY['상체를 세울수록 삼두에 더 많은 자극이 갑니다.','가슴 딥스와 반대로 몸을 세우세요.'], 6.5),
  ('10000000-0001-4000-8000-000000000154', '벤치 딥스', 'Bench Dips', 'STRENGTH', 'TRICEPS', ARRAY['SHOULDERS'], ARRAY['벤치'], 'BEGINNER',
    ARRAY['벤치에 등을 대고 손을 벤치 끝에 놓습니다.','엉덩이를 벤치에서 들어올립니다.','팔꿈치를 구부려 몸을 내립니다.','삼두근의 힘으로 밀어 올립니다.'],
    ARRAY['초보자도 쉽게 할 수 있습니다.','발을 멀리 놓을수록 강도가 올라갑니다.'], 5.0)
ON CONFLICT (id) DO NOTHING;

-- ==================== 하체 (+8) ====================
INSERT INTO exercises (id, name, name_en, category, primary_muscle, secondary_muscles, equipment_required, difficulty, instructions, tips, calories_per_minute)
VALUES
  ('10000000-0001-4000-8000-000000000048', '프론트 스쿼트', 'Front Squat', 'STRENGTH', 'QUADS', ARRAY['GLUTES','CORE'], ARRAY['바벨','스쿼트 랙'], 'INTERMEDIATE',
    ARRAY['바벨을 쇄골 앞에 올려놓습니다.','팔꿈치를 높이 올려 바벨을 지지합니다.','상체를 곧게 세운 채로 내려갑니다.','대퇴사두근의 힘으로 일어섭니다.'],
    ARRAY['상체가 앞으로 기울지 않게 주의하세요.','대퇴사두근에 더 집중할 수 있습니다.'], 7.5),
  ('10000000-0001-4000-8000-000000000049', '고블릿 스쿼트', 'Goblet Squat', 'STRENGTH', 'QUADS', ARRAY['GLUTES','CORE'], ARRAY['덤벨'], 'BEGINNER',
    ARRAY['덤벨을 양손으로 가슴 앞에서 잡습니다.','발을 어깨 너비로 벌리고 내려갑니다.','허벅지가 바닥과 평행이 될 때까지 내려간 후 일어섭니다.'],
    ARRAY['초보자에게 스쿼트 자세를 배우기 좋습니다.','상체를 곧게 유지하세요.'], 6.0),
  ('10000000-0001-4000-8000-000000000130', '핵 스쿼트', 'Hack Squat', 'STRENGTH', 'QUADS', ARRAY['GLUTES'], ARRAY['핵 스쿼트 머신'], 'INTERMEDIATE',
    ARRAY['머신에 등을 대고 어깨를 패드 아래에 놓습니다.','발을 플레이트에 어깨 너비로 올립니다.','무릎을 구부려 내려갑니다.','대퇴사두근의 힘으로 밀어 올립니다.'],
    ARRAY['발 위치를 높이면 둔근에 자극이 커집니다.','무릎을 완전히 잠그지 마세요.'], 6.5),
  ('10000000-0001-4000-8000-000000000131', '스티프 레그 데드리프트', 'Stiff Leg Deadlift', 'STRENGTH', 'HAMSTRINGS', ARRAY['GLUTES','LOWER_BACK'], ARRAY['바벨'], 'INTERMEDIATE',
    ARRAY['바벨을 어깨 너비로 잡고 서세요.','무릎을 거의 펴고 상체를 숙입니다.','햄스트링의 스트레칭을 느끼며 내립니다.','둔근과 햄스트링의 힘으로 일어섭니다.'],
    ARRAY['루마니안 데드리프트보다 무릎을 더 펴고 합니다.','등을 곧게 유지하세요.'], 7.0),
  ('10000000-0001-4000-8000-000000000132', '불가리안 스플릿 스쿼트', 'Bulgarian Split Squat', 'STRENGTH', 'QUADS', ARRAY['GLUTES','HAMSTRINGS'], ARRAY['덤벨','벤치'], 'INTERMEDIATE',
    ARRAY['한 발을 뒤쪽 벤치 위에 올립니다.','앞발에 체중을 싣고 내려갑니다.','앞쪽 무릎이 90도가 될 때까지 내려갑니다.','앞발로 밀며 일어섭니다.'],
    ARRAY['균형을 잡기 어려우면 처음에 맨몸으로 시작하세요.','앞 무릎이 발끝을 넘지 않게 주의하세요.'], 6.5),
  ('10000000-0001-4000-8000-000000000133', '힙 어브덕션', 'Hip Abduction', 'STRENGTH', 'GLUTES', ARRAY[]::text[], ARRAY['힙 어브덕션 머신'], 'BEGINNER',
    ARRAY['머신에 앉아 무릎 바깥쪽에 패드를 놓습니다.','다리를 바깥으로 벌립니다.','둔근을 수축시킨 후 천천히 모읍니다.'],
    ARRAY['둔근 중둔근에 효과적입니다.','상체를 곧게 유지하세요.'], 3.5),
  ('10000000-0001-4000-8000-000000000134', '글루트 킥백', 'Glute Kickback', 'STRENGTH', 'GLUTES', ARRAY['HAMSTRINGS'], ARRAY['케이블 머신'], 'BEGINNER',
    ARRAY['케이블 머신 앞에 서서 발목에 스트랩을 겁니다.','한 다리를 뒤로 뻗어올립니다.','둔근을 수축시킨 후 천천히 내립니다.'],
    ARRAY['허리를 과도하게 젖히지 마세요.','둔근에 집중하세요.'], 3.5),
  ('10000000-0001-4000-8000-000000000135', '시티드 카프 레이즈', 'Seated Calf Raise', 'STRENGTH', 'CALVES', ARRAY[]::text[], ARRAY['시티드 카프 레이즈 머신'], 'BEGINNER',
    ARRAY['머신에 앉아 무릎에 패드를 놓습니다.','발꿈치를 들어올려 종아리를 수축시킵니다.','최대한 수축 후 천천히 내립니다.'],
    ARRAY['가자미근에 더 효과적입니다.','동작 범위를 최대로 하세요.'], 3.0)
ON CONFLICT (id) DO NOTHING;

-- ==================== 코어 (+7) ====================
INSERT INTO exercises (id, name, name_en, category, primary_muscle, secondary_muscles, equipment_required, difficulty, instructions, tips, calories_per_minute)
VALUES
  ('10000000-0001-4000-8000-000000000055', '리버스 크런치', 'Reverse Crunch', 'STRENGTH', 'CORE', ARRAY[]::text[], ARRAY[]::text[], 'BEGINNER',
    ARRAY['바닥에 누워 무릎을 90도로 구부립니다.','하복부의 힘으로 무릎을 가슴 쪽으로 당깁니다.','엉덩이가 약간 들릴 때까지 올린 후 천천히 내립니다.'],
    ARRAY['하복부에 집중하세요.','반동을 사용하지 마세요.'], 4.0),
  ('10000000-0001-4000-8000-000000000056', '바이시클 크런치', 'Bicycle Crunch', 'STRENGTH', 'CORE', ARRAY['OBLIQUES'], ARRAY[]::text[], 'INTERMEDIATE',
    ARRAY['바닥에 누워 손을 머리 뒤에 댑니다.','한쪽 무릎을 가슴으로 당기면서 반대쪽 팔꿈치를 가져갑니다.','자전거 타듯이 교차로 반복합니다.'],
    ARRAY['복근과 옆구리 동시 자극 운동입니다.','목을 과도하게 당기지 마세요.'], 5.0),
  ('10000000-0001-4000-8000-000000000057', '사이드 플랭크', 'Side Plank', 'STRENGTH', 'OBLIQUES', ARRAY['CORE','SHOULDERS'], ARRAY[]::text[], 'INTERMEDIATE',
    ARRAY['옆으로 누워 팔꿈치를 바닥에 짚습니다.','엉덩이를 들어올려 몸을 일직선으로 만듭니다.','코어에 힘을 주고 자세를 유지합니다.'],
    ARRAY['엉덩이가 내려가지 않게 주의하세요.','시간 기반 운동입니다.'], 4.5),
  ('10000000-0001-4000-8000-000000000058', '케이블 크런치', 'Cable Crunch', 'STRENGTH', 'CORE', ARRAY[]::text[], ARRAY['케이블 머신','로프'], 'INTERMEDIATE',
    ARRAY['케이블을 높은 위치에 설정하고 로프를 잡습니다.','무릎을 꿇고 로프를 머리 뒤에 잡습니다.','복근의 힘으로 상체를 구부려 크런치합니다.','천천히 시작 위치로 돌아옵니다.'],
    ARRAY['팔이 아닌 복근으로 움직이세요.','무게를 추가해 강도를 높일 수 있습니다.'], 4.5),
  ('10000000-0001-4000-8000-000000000059', 'AB 슬라이드', 'Ab Slide', 'STRENGTH', 'CORE', ARRAY['SHOULDERS','LATS'], ARRAY['AB 롤러'], 'ADVANCED',
    ARRAY['무릎을 꿇고 AB 롤러를 잡습니다.','코어에 힘을 주고 롤러를 앞으로 밀어냅니다.','몸이 일직선이 될 때까지 밀어낸 후 당겨옵니다.'],
    ARRAY['허리가 과도하게 꺾이지 않게 주의하세요.','난이도가 높은 운동입니다.'], 6.0),
  ('10000000-0001-4000-8000-000000000160', '브이업', 'V-up', 'STRENGTH', 'CORE', ARRAY[]::text[], ARRAY[]::text[], 'ADVANCED',
    ARRAY['바닥에 누워 팔과 다리를 곧게 폅니다.','동시에 상체와 하체를 들어올려 V자를 만듭니다.','손이 발에 닿도록 한 후 천천히 내립니다.'],
    ARRAY['상복부와 하복부 동시 자극 운동입니다.','반동을 사용하지 마세요.'], 5.5),
  ('10000000-0001-4000-8000-000000000161', '마운틴 클라이머', 'Mountain Climber', 'CARDIO', 'CORE', ARRAY['SHOULDERS','QUADS'], ARRAY[]::text[], 'INTERMEDIATE',
    ARRAY['푸시업 자세를 잡습니다.','한쪽 무릎을 가슴 쪽으로 빠르게 당깁니다.','교대로 반복합니다.'],
    ARRAY['코어에 힘을 유지하세요.','속도를 높이면 유산소 효과가 커집니다.'], 9.0)
ON CONFLICT (id) DO NOTHING;

-- ==================== 유산소 (+7) ====================
INSERT INTO exercises (id, name, name_en, category, primary_muscle, secondary_muscles, equipment_required, difficulty, instructions, tips, calories_per_minute)
VALUES
  ('10000000-0001-4000-8000-000000000063', '인클라인 워킹', 'Incline Walking', 'CARDIO', 'GLUTES', ARRAY['HAMSTRINGS','CALVES'], ARRAY['트레드밀'], 'BEGINNER',
    ARRAY['트레드밀 경사를 10-15%로 설정합니다.','속도를 4-6km/h로 설정합니다.','자연스럽게 걸으며 둔근을 사용합니다.'],
    ARRAY['손잡이를 잡지 않아야 효과가 큽니다.','심폐 지구력과 둔근 강화에 좋습니다.'], 7.0),
  ('10000000-0001-4000-8000-000000000064', '일립티컬', 'Elliptical', 'CARDIO', 'FULL_BODY', ARRAY[]::text[], ARRAY['일립티컬 머신'], 'BEGINNER',
    ARRAY['페달에 발을 올리고 핸들을 잡습니다.','자연스러운 보폭으로 페달을 밟습니다.','저항을 조절하여 강도를 변경합니다.'],
    ARRAY['관절에 부담이 적은 유산소입니다.','팔 핸들도 함께 움직이면 전신 운동이 됩니다.'], 8.0),
  ('10000000-0001-4000-8000-000000000065', '스텝밀', 'Stair Mill', 'CARDIO', 'GLUTES', ARRAY['QUADS','CALVES'], ARRAY['스텝밀'], 'INTERMEDIATE',
    ARRAY['스텝밀에 올라서 적절한 속도를 설정합니다.','한 계단씩 자연스럽게 올라갑니다.','자세를 곧게 유지합니다.'],
    ARRAY['핸드레일에 기대지 마세요.','둔근과 심폐 지구력 강화에 탁월합니다.'], 10.0),
  ('10000000-0001-4000-8000-000000000066', '줄넘기', 'Jump Rope', 'CARDIO', 'FULL_BODY', ARRAY['CALVES','SHOULDERS'], ARRAY['줄넘기'], 'BEGINNER',
    ARRAY['줄을 양손에 잡고 줄이 뒤에서 시작하게 합니다.','손목을 돌려 줄을 넘기며 점프합니다.','가볍게 착지하며 리듬을 유지합니다.'],
    ARRAY['처음에는 느린 속도로 시작하세요.','손목 위주로 줄을 돌리세요.'], 11.0),
  ('10000000-0001-4000-8000-000000000067', '버피', 'Burpee', 'CARDIO', 'FULL_BODY', ARRAY['CHEST','CORE','QUADS'], ARRAY[]::text[], 'INTERMEDIATE',
    ARRAY['서있는 자세에서 스쿼트로 내려갑니다.','손을 짚고 다리를 뒤로 뻗어 푸시업 자세를 취합니다.','푸시업을 하고 다리를 다시 당겨옵니다.','점프하며 일어섭니다.'],
    ARRAY['전신 고강도 운동입니다.','체력이 부족하면 점프를 생략하세요.'], 12.0),
  ('10000000-0001-4000-8000-000000000068', '점핑잭', 'Jumping Jack', 'CARDIO', 'FULL_BODY', ARRAY['SHOULDERS','CALVES'], ARRAY[]::text[], 'BEGINNER',
    ARRAY['발을 모으고 팔을 옆에 붙인 채로 시작합니다.','점프하며 발을 벌리고 팔을 머리 위로 올립니다.','다시 점프하며 시작 자세로 돌아옵니다.'],
    ARRAY['워밍업으로 좋은 운동입니다.','리듬을 일정하게 유지하세요.'], 8.0),
  ('10000000-0001-4000-8000-000000000069', '배틀 로프', 'Battle Rope', 'CARDIO', 'FULL_BODY', ARRAY['SHOULDERS','CORE'], ARRAY['배틀 로프'], 'INTERMEDIATE',
    ARRAY['배틀 로프 양쪽 끝을 잡고 어깨 너비로 서세요.','양팔을 교대로 위아래로 빠르게 흔듭니다.','코어에 힘을 주고 무릎을 약간 구부립니다.'],
    ARRAY['전신 지구력 운동입니다.','파도 모양이 일정하게 유지되도록 하세요.'], 10.0)
ON CONFLICT (id) DO NOTHING;
