-- ========================================
-- 1RM 추이 그래프용 더미 데이터
-- 기간: 2025년 9월, 10월, 11월
-- 사용자: bb44adfa-ec20-45fd-acc5-6f411a16fcc9
-- ========================================

WITH exercise_ids AS (
  SELECT
    id,
    name
  FROM exercises
  WHERE name IN ('벤치프레스', '스쿼트', '데드리프트', '오버헤드프레스', '바벨로우')
),
user_data AS (
  SELECT 'bb44adfa-ec20-45fd-acc5-6f411a16fcc9'::uuid AS user_id
),
-- 세션 ID 생성 (UUID는 실행 시 자동 생성됨)
session_sept AS (
  SELECT gen_random_uuid() AS session_id, '2025-09-15 10:00:00'::timestamp AS started_at FROM user_data
),
session_oct AS (
  SELECT gen_random_uuid() AS session_id, '2025-10-15 10:00:00'::timestamp AS started_at FROM user_data
),
session_nov AS (
  SELECT gen_random_uuid() AS session_id, '2025-11-15 10:00:00'::timestamp AS started_at FROM user_data
)

-- ========================================
-- 1. workout_sessions 추가 (3개월)
-- ========================================
INSERT INTO workout_sessions (id, user_id, started_at, finished_at, mode, is_cancelled, total_volume, total_sets, total_duration_seconds)
SELECT
  session_sept.session_id,
  user_data.user_id,
  session_sept.started_at,
  session_sept.started_at + INTERVAL '1 hour',
  'FREE',
  false,
  0.0,  -- 계산 후 업데이트 필요
  15,    -- 5 운동 x 3 세트
  3600   -- 1시간
FROM session_sept, user_data;

INSERT INTO workout_sessions (id, user_id, started_at, finished_at, mode, is_cancelled, total_volume, total_sets, total_duration_seconds)
SELECT
  session_oct.session_id,
  user_data.user_id,
  session_oct.started_at,
  session_oct.started_at + INTERVAL '1 hour',
  'FREE',
  false,
  0.0,
  15,
  3600
FROM session_oct, user_data;

INSERT INTO workout_sessions (id, user_id, started_at, finished_at, mode, is_cancelled, total_volume, total_sets, total_duration_seconds)
SELECT
  session_nov.session_id,
  user_data.user_id,
  session_nov.started_at,
  session_nov.started_at + INTERVAL '1 hour',
  'FREE',
  false,
  0.0,
  15,
  3600
FROM session_nov, user_data;

-- ========================================
-- 2. workout_sets 추가 (각 월별 5 운동 x 3 세트)
-- ========================================

-- 벤치프레스: 9월 (60kg x 8reps → 1RM ≈ 76kg)
INSERT INTO workout_sets (session_id, exercise_id, set_number, set_type, weight, reps)
SELECT
  (SELECT session_id FROM session_sept),
  (SELECT id FROM exercise_ids WHERE name = '벤치프레스'),
  unnest(ARRAY[1, 2, 3]),
  'WORKING',
  60.0,
  8;

-- 벤치프레스: 10월 (65kg x 8reps → 1RM ≈ 82kg)
INSERT INTO workout_sets (session_id, exercise_id, set_number, set_type, weight, reps)
SELECT
  (SELECT session_id FROM session_oct),
  (SELECT id FROM exercise_ids WHERE name = '벤치프레스'),
  unnest(ARRAY[1, 2, 3]),
  'WORKING',
  65.0,
  8;

-- 벤치프레스: 11월 (70kg x 8reps → 1RM ≈ 89kg)
INSERT INTO workout_sets (session_id, exercise_id, set_number, set_type, weight, reps)
SELECT
  (SELECT session_id FROM session_nov),
  (SELECT id FROM exercise_ids WHERE name = '벤치프레스'),
  unnest(ARRAY[1, 2, 3]),
  'WORKING',
  70.0,
  8;

-- 스쿼트: 9월 (80kg x 8reps → 1RM ≈ 101kg)
INSERT INTO workout_sets (session_id, exercise_id, set_number, set_type, weight, reps)
SELECT
  (SELECT session_id FROM session_sept),
  (SELECT id FROM exercise_ids WHERE name = '스쿼트'),
  unnest(ARRAY[1, 2, 3]),
  'WORKING',
  80.0,
  8;

-- 스쿼트: 10월 (85kg x 8reps → 1RM ≈ 108kg)
INSERT INTO workout_sets (session_id, exercise_id, set_number, set_type, weight, reps)
SELECT
  (SELECT session_id FROM session_oct),
  (SELECT id FROM exercise_ids WHERE name = '스쿼트'),
  unnest(ARRAY[1, 2, 3]),
  'WORKING',
  85.0,
  8;

-- 스쿼트: 11월 (90kg x 8reps → 1RM ≈ 114kg)
INSERT INTO workout_sets (session_id, exercise_id, set_number, set_type, weight, reps)
SELECT
  (SELECT session_id FROM session_nov),
  (SELECT id FROM exercise_ids WHERE name = '스쿼트'),
  unnest(ARRAY[1, 2, 3]),
  'WORKING',
  90.0,
  8;

-- 데드리프트: 9월 (100kg x 6reps → 1RM ≈ 120kg)
INSERT INTO workout_sets (session_id, exercise_id, set_number, set_type, weight, reps)
SELECT
  (SELECT session_id FROM session_sept),
  (SELECT id FROM exercise_ids WHERE name = '데드리프트'),
  unnest(ARRAY[1, 2, 3]),
  'WORKING',
  100.0,
  6;

-- 데드리프트: 10월 (110kg x 6reps → 1RM ≈ 132kg)
INSERT INTO workout_sets (session_id, exercise_id, set_number, set_type, weight, reps)
SELECT
  (SELECT session_id FROM session_oct),
  (SELECT id FROM exercise_ids WHERE name = '데드리프트'),
  unnest(ARRAY[1, 2, 3]),
  'WORKING',
  110.0,
  6;

-- 데드리프트: 11월 (115kg x 6reps → 1RM ≈ 138kg)
INSERT INTO workout_sets (session_id, exercise_id, set_number, set_type, weight, reps)
SELECT
  (SELECT session_id FROM session_nov),
  (SELECT id FROM exercise_ids WHERE name = '데드리프트'),
  unnest(ARRAY[1, 2, 3]),
  'WORKING',
  115.0,
  6;

-- 오버헤드프레스: 9월 (30kg x 10reps → 1RM ≈ 40kg)
INSERT INTO workout_sets (session_id, exercise_id, set_number, set_type, weight, reps)
SELECT
  (SELECT session_id FROM session_sept),
  (SELECT id FROM exercise_ids WHERE name = '오버헤드프레스'),
  unnest(ARRAY[1, 2, 3]),
  'WORKING',
  30.0,
  10;

-- 오버헤드프레스: 10월 (32.5kg x 10reps → 1RM ≈ 43kg)
INSERT INTO workout_sets (session_id, exercise_id, set_number, set_type, weight, reps)
SELECT
  (SELECT session_id FROM session_oct),
  (SELECT id FROM exercise_ids WHERE name = '오버헤드프레스'),
  unnest(ARRAY[1, 2, 3]),
  'WORKING',
  32.5,
  10;

-- 오버헤드프레스: 11월 (35kg x 10reps → 1RM ≈ 47kg)
INSERT INTO workout_sets (session_id, exercise_id, set_number, set_type, weight, reps)
SELECT
  (SELECT session_id FROM session_nov),
  (SELECT id FROM exercise_ids WHERE name = '오버헤드프레스'),
  unnest(ARRAY[1, 2, 3]),
  'WORKING',
  35.0,
  10;

-- 바벨로우: 9월 (50kg x 8reps → 1RM ≈ 63kg)
INSERT INTO workout_sets (session_id, exercise_id, set_number, set_type, weight, reps)
SELECT
  (SELECT session_id FROM session_sept),
  (SELECT id FROM exercise_ids WHERE name = '바벨로우'),
  unnest(ARRAY[1, 2, 3]),
  'WORKING',
  50.0,
  8;

-- 바벨로우: 10월 (55kg x 8reps → 1RM ≈ 70kg)
INSERT INTO workout_sets (session_id, exercise_id, set_number, set_type, weight, reps)
SELECT
  (SELECT session_id FROM session_oct),
  (SELECT id FROM exercise_ids WHERE name = '바벨로우'),
  unnest(ARRAY[1, 2, 3]),
  'WORKING',
  55.0,
  8;

-- 바벨로우: 11월 (60kg x 8reps → 1RM ≈ 76kg)
INSERT INTO workout_sets (session_id, exercise_id, set_number, set_type, weight, reps)
SELECT
  (SELECT session_id FROM session_nov),
  (SELECT id FROM exercise_ids WHERE name = '바벨로우'),
  unnest(ARRAY[1, 2, 3]),
  'WORKING',
  60.0,
  8;

-- ========================================
-- 3. total_volume 업데이트 (각 세션의 총 볼륨 계산)
-- ========================================
UPDATE workout_sessions ws
SET total_volume = (
  SELECT COALESCE(SUM(weight * reps), 0)
  FROM workout_sets
  WHERE session_id = ws.id
);

-- ========================================
-- 4. 결과 확인 쿼리
-- ========================================
-- 각 월별 1RM 추이 확인
SELECT
  e.name,
  DATE_TRUNC('month', ws.started_at) AS month,
  MAX((s.weight * (1 + s.reps::float / 30)))::decimal(6,1) AS max_1rm,
  MAX(s.weight) AS max_weight,
  MAX(s.reps) AS max_reps
FROM workout_sessions ws
JOIN workout_sets s ON s.session_id = ws.id
JOIN exercises e ON e.id = s.exercise_id
WHERE ws.user_id = 'bb44adfa-ec20-45fd-acc5-6f411a16fcc9'::uuid
  AND ws.started_at BETWEEN '2025-09-01' AND '2025-11-30'
  AND e.name IN ('벤치프레스', '스쿼트', '데드리프트', '오버헤드프레스', '바벨로우')
GROUP BY e.name, DATE_TRUNC('month', ws.started_at)
ORDER BY e.name, month;
