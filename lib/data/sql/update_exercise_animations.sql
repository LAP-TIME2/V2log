-- =====================================================
-- V2log Exercise Animation URLs Update
-- =====================================================
-- 생성일: 2026-02-10
-- 설명: free-exercise-db (GitHub) 이미지를 exercises 테이블에 연결
-- 소스: https://github.com/yuhonas/free-exercise-db (Unlicense)
-- 이미지: 운동당 2장 (0.jpg = 시작 자세, 1.jpg = 끝 자세)
-- =====================================================
-- 실행 방법:
-- 1. Supabase Dashboard > SQL Editor 이동
-- 2. 이 SQL 내용을 붙여넣고 Run 클릭
-- =====================================================

-- 가슴 운동 (Chest)
UPDATE exercises SET
  animation_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Barbell_Bench_Press_-_Medium_Grip/0.jpg',
  thumbnail_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Barbell_Bench_Press_-_Medium_Grip/1.jpg'
WHERE id = '10000000-0001-4000-8000-000000000001';

UPDATE exercises SET
  animation_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Incline_Dumbbell_Press/0.jpg',
  thumbnail_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Incline_Dumbbell_Press/1.jpg'
WHERE id = '10000000-0001-4000-8000-000000000002';

UPDATE exercises SET
  animation_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Cable_Crossover/0.jpg',
  thumbnail_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Cable_Crossover/1.jpg'
WHERE id = '10000000-0001-4000-8000-000000000003';

UPDATE exercises SET
  animation_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Dips_-_Chest_Version/0.jpg',
  thumbnail_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Dips_-_Chest_Version/1.jpg'
WHERE id = '10000000-0001-4000-8000-000000000004';

UPDATE exercises SET
  animation_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Butterfly/0.jpg',
  thumbnail_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Butterfly/1.jpg'
WHERE id = '10000000-0001-4000-8000-000000000005';

-- 등 운동 (Back)
UPDATE exercises SET
  animation_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Barbell_Deadlift/0.jpg',
  thumbnail_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Barbell_Deadlift/1.jpg'
WHERE id = '10000000-0001-4000-8000-000000000010';

UPDATE exercises SET
  animation_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Wide-Grip_Lat_Pulldown/0.jpg',
  thumbnail_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Wide-Grip_Lat_Pulldown/1.jpg'
WHERE id = '10000000-0001-4000-8000-000000000011';

UPDATE exercises SET
  animation_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Bent_Over_Barbell_Row/0.jpg',
  thumbnail_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Bent_Over_Barbell_Row/1.jpg'
WHERE id = '10000000-0001-4000-8000-000000000012';

UPDATE exercises SET
  animation_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Seated_Cable_Rows/0.jpg',
  thumbnail_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Seated_Cable_Rows/1.jpg'
WHERE id = '10000000-0001-4000-8000-000000000013';

UPDATE exercises SET
  animation_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Pullups/0.jpg',
  thumbnail_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Pullups/1.jpg'
WHERE id = '10000000-0001-4000-8000-000000000014';

-- 어깨 운동 (Shoulders)
UPDATE exercises SET
  animation_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Standing_Military_Press/0.jpg',
  thumbnail_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Standing_Military_Press/1.jpg'
WHERE id = '10000000-0001-4000-8000-000000000020';

UPDATE exercises SET
  animation_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Dumbbell_Shoulder_Press/0.jpg',
  thumbnail_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Dumbbell_Shoulder_Press/1.jpg'
WHERE id = '10000000-0001-4000-8000-000000000021';

UPDATE exercises SET
  animation_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Side_Lateral_Raise/0.jpg',
  thumbnail_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Side_Lateral_Raise/1.jpg'
WHERE id = '10000000-0001-4000-8000-000000000022';

UPDATE exercises SET
  animation_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Cable_Rear_Delt_Fly/0.jpg',
  thumbnail_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Cable_Rear_Delt_Fly/1.jpg'
WHERE id = '10000000-0001-4000-8000-000000000023';

UPDATE exercises SET
  animation_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Face_Pull/0.jpg',
  thumbnail_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Face_Pull/1.jpg'
WHERE id = '10000000-0001-4000-8000-000000000024';

-- 팔 운동 (Arms)
UPDATE exercises SET
  animation_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Barbell_Curl/0.jpg',
  thumbnail_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Barbell_Curl/1.jpg'
WHERE id = '10000000-0001-4000-8000-000000000030';

UPDATE exercises SET
  animation_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Hammer_Curls/0.jpg',
  thumbnail_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Hammer_Curls/1.jpg'
WHERE id = '10000000-0001-4000-8000-000000000031';

UPDATE exercises SET
  animation_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Triceps_Pushdown/0.jpg',
  thumbnail_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Triceps_Pushdown/1.jpg'
WHERE id = '10000000-0001-4000-8000-000000000032';

UPDATE exercises SET
  animation_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Cable_Rope_Overhead_Triceps_Extension/0.jpg',
  thumbnail_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Cable_Rope_Overhead_Triceps_Extension/1.jpg'
WHERE id = '10000000-0001-4000-8000-000000000033';

UPDATE exercises SET
  animation_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Close-Grip_Barbell_Bench_Press/0.jpg',
  thumbnail_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Close-Grip_Barbell_Bench_Press/1.jpg'
WHERE id = '10000000-0001-4000-8000-000000000034';

-- 하체 운동 (Legs)
UPDATE exercises SET
  animation_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Barbell_Squat/0.jpg',
  thumbnail_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Barbell_Squat/1.jpg'
WHERE id = '10000000-0001-4000-8000-000000000040';

UPDATE exercises SET
  animation_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Leg_Press/0.jpg',
  thumbnail_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Leg_Press/1.jpg'
WHERE id = '10000000-0001-4000-8000-000000000041';

UPDATE exercises SET
  animation_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Leg_Extensions/0.jpg',
  thumbnail_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Leg_Extensions/1.jpg'
WHERE id = '10000000-0001-4000-8000-000000000042';

UPDATE exercises SET
  animation_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Lying_Leg_Curls/0.jpg',
  thumbnail_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Lying_Leg_Curls/1.jpg'
WHERE id = '10000000-0001-4000-8000-000000000043';

UPDATE exercises SET
  animation_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Dumbbell_Lunges/0.jpg',
  thumbnail_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Dumbbell_Lunges/1.jpg'
WHERE id = '10000000-0001-4000-8000-000000000044';

UPDATE exercises SET
  animation_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Barbell_Hip_Thrust/0.jpg',
  thumbnail_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Barbell_Hip_Thrust/1.jpg'
WHERE id = '10000000-0001-4000-8000-000000000045';

UPDATE exercises SET
  animation_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Standing_Calf_Raises/0.jpg',
  thumbnail_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Standing_Calf_Raises/1.jpg'
WHERE id = '10000000-0001-4000-8000-000000000046';

-- 복근 운동 (Abs)
UPDATE exercises SET
  animation_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Crunches/0.jpg',
  thumbnail_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Crunches/1.jpg'
WHERE id = '10000000-0001-4000-8000-000000000050';

UPDATE exercises SET
  animation_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Flat_Bench_Lying_Leg_Raise/0.jpg',
  thumbnail_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Flat_Bench_Lying_Leg_Raise/1.jpg'
WHERE id = '10000000-0001-4000-8000-000000000051';

UPDATE exercises SET
  animation_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Plank/0.jpg',
  thumbnail_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Plank/1.jpg'
WHERE id = '10000000-0001-4000-8000-000000000052';

UPDATE exercises SET
  animation_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Russian_Twist/0.jpg',
  thumbnail_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Russian_Twist/1.jpg'
WHERE id = '10000000-0001-4000-8000-000000000053';

UPDATE exercises SET
  animation_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Hanging_Leg_Raise/0.jpg',
  thumbnail_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Hanging_Leg_Raise/1.jpg'
WHERE id = '10000000-0001-4000-8000-000000000054';

-- 유산소 운동 (Cardio)
UPDATE exercises SET
  animation_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Running_Treadmill/0.jpg',
  thumbnail_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Running_Treadmill/1.jpg'
WHERE id = '10000000-0001-4000-8000-000000000060';

UPDATE exercises SET
  animation_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Bicycling_Stationary/0.jpg',
  thumbnail_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Bicycling_Stationary/1.jpg'
WHERE id = '10000000-0001-4000-8000-000000000061';

UPDATE exercises SET
  animation_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Rowing_Stationary/0.jpg',
  thumbnail_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Rowing_Stationary/1.jpg'
WHERE id = '10000000-0001-4000-8000-000000000062';

-- =====================================================
-- 실행 완료 후 확인 쿼리
-- =====================================================
-- SELECT id, name, animation_url, thumbnail_url
-- FROM exercises
-- WHERE animation_url IS NOT NULL
-- ORDER BY name;
-- =====================================================
