-- 더미 운동 데이터 추가
-- user_id: bb44adfa-ec20-45fd-acc5-6f411a16fcc9
-- set_type: 'WORKING' (CHECK 제약조건: WARMUP, WORKING, DROP, FAILURE, SUPERSET)

SET timezone = 'Asia/Seoul';

-- 먼저 기존 데이터 삭제 (중복 방지)
DELETE FROM workout_sets WHERE session_id IN (
  SELECT id FROM workout_sessions WHERE user_id = 'bb44adfa-ec20-45fd-acc5-6f411a16fcc9'
);
DELETE FROM workout_sessions WHERE user_id = 'bb44adfa-ec20-45fd-acc5-6f411a16fcc9';

-- ==================== 12월 데이터 (2025-12-xx) ====================

-- 12/5: 가슴 - 벤치프레스, 인클라인벤치프레스 (총 8,000kg)
WITH session AS (
  INSERT INTO workout_sessions (id, user_id, mode, started_at, finished_at, total_volume, total_duration_seconds, total_sets, is_cancelled)
  VALUES (
    gen_random_uuid(),
    'bb44adfa-ec20-45fd-acc5-6f411a16fcc9',
    'FREE',
    '2025-12-05 10:00:00',
    '2025-12-05 11:30:00',
    8000.0,
    5400,
    16,
    false
  )
  RETURNING id, started_at
)
INSERT INTO workout_sets (id, session_id, exercise_id, set_number, set_type, weight, reps, rest_seconds)
SELECT
  gen_random_uuid(),
  s.id,
  (SELECT id FROM exercises WHERE name = '벤치프레스' LIMIT 1),
  1, 'WORKING', 80.0, 8, 90
FROM session s
UNION ALL
SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '벤치프레스' LIMIT 1), 2, 'WORKING', 80.0, 8, 90
FROM session s
UNION ALL
SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '벤치프레스' LIMIT 1), 3, 'WORKING', 80.0, 8, 90
FROM session s
UNION ALL
SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '벤치프레스' LIMIT 1), 4, 'WORKING', 80.0, 7, 90
FROM session s
UNION ALL
SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '인클라인 벤치프레스' LIMIT 1), 1, 'WORKING', 60.0, 10, 90
FROM session s
UNION ALL
SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '인클라인 벤치프레스' LIMIT 1), 2, 'WORKING', 60.0, 10, 90
FROM session s
UNION ALL
SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '인클라인 벤치프레스' LIMIT 1), 3, 'WORKING', 60.0, 8, 90
FROM session s
UNION ALL
SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '인클라인 벤치프레스' LIMIT 1), 4, 'WORKING', 60.0, 8, 90
FROM session s;

-- 12/12: 하체 - 스쿼트, 레그프레스 (총 20,000kg)
WITH session AS (
  INSERT INTO workout_sessions (id, user_id, mode, started_at, finished_at, total_volume, total_duration_seconds, total_sets, is_cancelled)
  VALUES (
    gen_random_uuid(),
    'bb44adfa-ec20-45fd-acc5-6f411a16fcc9',
    'FREE',
    '2025-12-12 10:00:00',
    '2025-12-12 12:30:00',
    20000.0,
    9000,
    24,
    false
  )
  RETURNING id, started_at
)
INSERT INTO workout_sets (id, session_id, exercise_id, set_number, set_type, weight, reps, rest_seconds)
SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '스쿼트' LIMIT 1), 1, 'WORKING', 100.0, 8, 120
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '스쿼트' LIMIT 1), 2, 'WORKING', 100.0, 8, 120
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '스쿼트' LIMIT 1), 3, 'WORKING', 100.0, 8, 120
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '스쿼트' LIMIT 1), 4, 'WORKING', 100.0, 6, 120
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '스쿼트' LIMIT 1), 5, 'WORKING', 100.0, 6, 120
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '스쿼트' LIMIT 1), 6, 'WORKING', 100.0, 6, 120
FROM session s
UNION ALL
SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '레그 프레스' LIMIT 1), 1, 'WORKING', 200.0, 10, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '레그 프레스' LIMIT 1), 2, 'WORKING', 200.0, 10, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '레그 프레스' LIMIT 1), 3, 'WORKING', 200.0, 10, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '레그 프레스' LIMIT 1), 4, 'WORKING', 200.0, 8, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '레그 프레스' LIMIT 1), 5, 'WORKING', 200.0, 8, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '레그 프레스' LIMIT 1), 6, 'WORKING', 200.0, 8, 90
FROM session s;

-- 12/22: 가슴 - 벤치프레스, 케이블크로스오버 (총 9,000kg)
WITH session AS (
  INSERT INTO workout_sessions (id, user_id, mode, started_at, finished_at, total_volume, total_duration_seconds, total_sets, is_cancelled)
  VALUES (
    gen_random_uuid(),
    'bb44adfa-ec20-45fd-acc5-6f411a16fcc9',
    'FREE',
    '2025-12-22 10:00:00',
    '2025-12-22 11:30:00',
    9000.0,
    5400,
    18,
    false
  )
  RETURNING id, started_at
)
INSERT INTO workout_sets (id, session_id, exercise_id, set_number, set_type, weight, reps, rest_seconds)
SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '벤치프레스' LIMIT 1), 1, 'WORKING', 82.5, 8, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '벤치프레스' LIMIT 1), 2, 'WORKING', 82.5, 8, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '벤치프레스' LIMIT 1), 3, 'WORKING', 82.5, 7, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '벤치프레스' LIMIT 1), 4, 'WORKING', 85.0, 6, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '벤치프레스' LIMIT 1), 5, 'WORKING', 85.0, 6, 90
FROM session s
UNION ALL
SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '케이블 크로스오버' LIMIT 1), 1, 'WORKING', 30.0, 12, 60
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '케이블 크로스오버' LIMIT 1), 2, 'WORKING', 30.0, 12, 60
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '케이블 크로스오버' LIMIT 1), 3, 'WORKING', 30.0, 10, 60
FROM session s
UNION ALL
SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '펙덱 플라이' LIMIT 1), 1, 'WORKING', 40.0, 12, 60
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '펙덱 플라이' LIMIT 1), 2, 'WORKING', 40.0, 12, 60
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '펙덱 플라이' LIMIT 1), 3, 'WORKING', 40.0, 10, 60
FROM session s
UNION ALL
SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '덤벨 벤치프레스' LIMIT 1), 1, 'WORKING', 32.5, 10, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '덤벨 벤치프레스' LIMIT 1), 2, 'WORKING', 32.5, 10, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '덤벨 벤치프레스' LIMIT 1), 3, 'WORKING', 32.5, 8, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '덤벨 벤치프레스' LIMIT 1), 4, 'WORKING', 32.5, 8, 90
FROM session s
UNION ALL
SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '딥스' LIMIT 1), 1, 'WORKING', 70.0, 8, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '딥스' LIMIT 1), 2, 'WORKING', 70.0, 8, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '딥스' LIMIT 1), 3, 'WORKING', 70.0, 6, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '딥스' LIMIT 1), 4, 'WORKING', 70.0, 6, 90
FROM session s;

-- 12/29: 하체 - 데드리프트, 런지 (총 18,000kg)
WITH session AS (
  INSERT INTO workout_sessions (id, user_id, mode, started_at, finished_at, total_volume, total_duration_seconds, total_sets, is_cancelled)
  VALUES (
    gen_random_uuid(),
    'bb44adfa-ec20-45fd-acc5-6f411a16fcc9',
    'FREE',
    '2025-12-29 10:00:00',
    '2025-12-29 12:00:00',
    18000.0,
    7200,
    20,
    false
  )
  RETURNING id, started_at
)
INSERT INTO workout_sets (id, session_id, exercise_id, set_number, set_type, weight, reps, rest_seconds)
SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '데드리프트' LIMIT 1), 1, 'WORKING', 120.0, 6, 180
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '데드리프트' LIMIT 1), 2, 'WORKING', 120.0, 6, 180
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '데드리프트' LIMIT 1), 3, 'WORKING', 120.0, 5, 180
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '데드리프트' LIMIT 1), 4, 'WORKING', 120.0, 5, 180
FROM session s
UNION ALL
SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '런지' LIMIT 1), 1, 'WORKING', 40.0, 10, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '런지' LIMIT 1), 2, 'WORKING', 40.0, 10, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '런지' LIMIT 1), 3, 'WORKING', 40.0, 10, 90
FROM session s
UNION ALL
SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '스쿼트' LIMIT 1), 1, 'WORKING', 100.0, 8, 120
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '스쿼트' LIMIT 1), 2, 'WORKING', 100.0, 8, 120
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '스쿼트' LIMIT 1), 3, 'WORKING', 100.0, 8, 120
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '스쿼트' LIMIT 1), 4, 'WORKING', 100.0, 6, 120
FROM session s
UNION ALL
SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '레그 컬' LIMIT 1), 1, 'WORKING', 50.0, 12, 60
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '레그 컬' LIMIT 1), 2, 'WORKING', 50.0, 12, 60
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '레그 컬' LIMIT 1), 3, 'WORKING', 50.0, 12, 60
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '레그 컬' LIMIT 1), 4, 'WORKING', 50.0, 10, 60
FROM session s
UNION ALL
SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '레그 프레스' LIMIT 1), 1, 'WORKING', 180.0, 10, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '레그 프레스' LIMIT 1), 2, 'WORKING', 180.0, 10, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '레그 프레스' LIMIT 1), 3, 'WORKING', 180.0, 8, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '레그 프레스' LIMIT 1), 4, 'WORKING', 180.0, 8, 90
FROM session s;

-- ==================== 1월 데이터 (2026-01-xx) ====================

-- 1/5: 가슴 - 벤치프레스, 딥스 (총 10,000kg)
WITH session AS (
  INSERT INTO workout_sessions (id, user_id, mode, started_at, finished_at, total_volume, total_duration_seconds, total_sets, is_cancelled)
  VALUES (
    gen_random_uuid(),
    'bb44adfa-ec20-45fd-acc5-6f411a16fcc9',
    'FREE',
    '2026-01-05 10:00:00',
    '2026-01-05 11:45:00',
    10000.0,
    6300,
    20,
    false
  )
  RETURNING id, started_at
)
INSERT INTO workout_sets (id, session_id, exercise_id, set_number, set_type, weight, reps, rest_seconds)
SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '벤치프레스' LIMIT 1), 1, 'WORKING', 85.0, 8, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '벤치프레스' LIMIT 1), 2, 'WORKING', 85.0, 8, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '벤치프레스' LIMIT 1), 3, 'WORKING', 85.0, 7, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '벤치프레스' LIMIT 1), 4, 'WORKING', 87.5, 6, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '벤치프레스' LIMIT 1), 5, 'WORKING', 87.5, 5, 90
FROM session s
UNION ALL
SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '딥스' LIMIT 1), 1, 'WORKING', 75.0, 8, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '딥스' LIMIT 1), 2, 'WORKING', 75.0, 8, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '딥스' LIMIT 1), 3, 'WORKING', 75.0, 7, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '딥스' LIMIT 1), 4, 'WORKING', 75.0, 7, 90
FROM session s
UNION ALL
SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '인클라인 벤치프레스' LIMIT 1), 1, 'WORKING', 65.0, 10, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '인클라인 벤치프레스' LIMIT 1), 2, 'WORKING', 65.0, 10, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '인클라인 벤치프레스' LIMIT 1), 3, 'WORKING', 65.0, 8, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '인클라인 벤치프레스' LIMIT 1), 4, 'WORKING', 65.0, 8, 90
FROM session s
UNION ALL
SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '덤벨 벤치프레스' LIMIT 1), 1, 'WORKING', 35.0, 10, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '덤벨 벤치프레스' LIMIT 1), 2, 'WORKING', 35.0, 10, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '덤벨 벤치프레스' LIMIT 1), 3, 'WORKING', 35.0, 8, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '덤벨 벤치프레스' LIMIT 1), 4, 'WORKING', 35.0, 8, 90
FROM session s
UNION ALL
SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '펙덱 플라이' LIMIT 1), 1, 'WORKING', 45.0, 12, 60
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '펙덱 플라이' LIMIT 1), 2, 'WORKING', 45.0, 12, 60
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '펙덱 플라이' LIMIT 1), 3, 'WORKING', 45.0, 10, 60
FROM session s
UNION ALL
SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '케이블 크로스오버' LIMIT 1), 1, 'WORKING', 35.0, 12, 60
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '케이블 크로스오버' LIMIT 1), 2, 'WORKING', 35.0, 12, 60
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '케이블 크로스오버' LIMIT 1), 3, 'WORKING', 35.0, 10, 60
FROM session s;

-- 1/12: 하체 - 스쿼트, 레그컬 (총 22,000kg)
WITH session AS (
  INSERT INTO workout_sessions (id, user_id, mode, started_at, finished_at, total_volume, total_duration_seconds, total_sets, is_cancelled)
  VALUES (
    gen_random_uuid(),
    'bb44adfa-ec20-45fd-acc5-6f411a16fcc9',
    'FREE',
    '2026-01-12 10:00:00',
    '2026-01-12 12:40:00',
    22000.0,
    9600,
    24,
    false
  )
  RETURNING id, started_at
)
INSERT INTO workout_sets (id, session_id, exercise_id, set_number, set_type, weight, reps, rest_seconds)
SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '스쿼트' LIMIT 1), 1, 'WORKING', 105.0, 8, 120
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '스쿼트' LIMIT 1), 2, 'WORKING', 105.0, 8, 120
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '스쿼트' LIMIT 1), 3, 'WORKING', 105.0, 7, 120
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '스쿼트' LIMIT 1), 4, 'WORKING', 105.0, 7, 120
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '스쿼트' LIMIT 1), 5, 'WORKING', 105.0, 6, 120
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '스쿼트' LIMIT 1), 6, 'WORKING', 105.0, 6, 120
FROM session s
UNION ALL
SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '레그 프레스' LIMIT 1), 1, 'WORKING', 210.0, 10, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '레그 프레스' LIMIT 1), 2, 'WORKING', 210.0, 10, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '레그 프레스' LIMIT 1), 3, 'WORKING', 210.0, 10, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '레그 프레스' LIMIT 1), 4, 'WORKING', 210.0, 8, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '레그 프레스' LIMIT 1), 5, 'WORKING', 210.0, 8, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '레그 프레스' LIMIT 1), 6, 'WORKING', 210.0, 8, 90
FROM session s
UNION ALL
SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '레그 컬' LIMIT 1), 1, 'WORKING', 55.0, 12, 60
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '레그 컬' LIMIT 1), 2, 'WORKING', 55.0, 12, 60
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '레그 컬' LIMIT 1), 3, 'WORKING', 55.0, 12, 60
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '레그 컬' LIMIT 1), 4, 'WORKING', 55.0, 10, 60
FROM session s
UNION ALL
SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '데드리프트' LIMIT 1), 1, 'WORKING', 125.0, 6, 180
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '데드리프트' LIMIT 1), 2, 'WORKING', 125.0, 6, 180
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '데드리프트' LIMIT 1), 3, 'WORKING', 125.0, 5, 180
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '데드리프트' LIMIT 1), 4, 'WORKING', 125.0, 5, 180
FROM session s
UNION ALL
SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '런지' LIMIT 1), 1, 'WORKING', 42.5, 10, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '런지' LIMIT 1), 2, 'WORKING', 42.5, 10, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '런지' LIMIT 1), 3, 'WORKING', 42.5, 10, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '런지' LIMIT 1), 4, 'WORKING', 42.5, 8, 90
FROM session s;

-- 1/19: 가슴 - 인클라인벤치프레스, 펙덱플라이 (총 9,500kg)
WITH session AS (
  INSERT INTO workout_sessions (id, user_id, mode, started_at, finished_at, total_volume, total_duration_seconds, total_sets, is_cancelled)
  VALUES (
    gen_random_uuid(),
    'bb44adfa-ec20-45fd-acc5-6f411a16fcc9',
    'FREE',
    '2026-01-19 10:00:00',
    '2026-01-19 11:30:00',
    9500.0,
    5400,
    18,
    false
  )
  RETURNING id, started_at
)
INSERT INTO workout_sets (id, session_id, exercise_id, set_number, set_type, weight, reps, rest_seconds)
SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '인클라인 벤치프레스' LIMIT 1), 1, 'WORKING', 67.5, 8, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '인클라인 벤치프레스' LIMIT 1), 2, 'WORKING', 67.5, 8, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '인클라인 벤치프레스' LIMIT 1), 3, 'WORKING', 67.5, 7, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '인클라인 벤치프레스' LIMIT 1), 4, 'WORKING', 70.0, 6, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '인클라인 벤치프레스' LIMIT 1), 5, 'WORKING', 70.0, 6, 90
FROM session s
UNION ALL
SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '벤치프레스' LIMIT 1), 1, 'WORKING', 90.0, 8, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '벤치프레스' LIMIT 1), 2, 'WORKING', 90.0, 8, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '벤치프레스' LIMIT 1), 3, 'WORKING', 90.0, 7, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '벤치프레스' LIMIT 1), 4, 'WORKING', 90.0, 7, 90
FROM session s
UNION ALL
SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '펙덱 플라이' LIMIT 1), 1, 'WORKING', 50.0, 12, 60
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '펙덱 플라이' LIMIT 1), 2, 'WORKING', 50.0, 12, 60
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '펙덱 플라이' LIMIT 1), 3, 'WORKING', 50.0, 10, 60
FROM session s
UNION ALL
SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '케이블 크로스오버' LIMIT 1), 1, 'WORKING', 40.0, 12, 60
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '케이블 크로스오버' LIMIT 1), 2, 'WORKING', 40.0, 12, 60
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '케이블 크로스오버' LIMIT 1), 3, 'WORKING', 40.0, 10, 60
FROM session s
UNION ALL
SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '덤벨 벤치프레스' LIMIT 1), 1, 'WORKING', 37.5, 10, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '덤벨 벤치프레스' LIMIT 1), 2, 'WORKING', 37.5, 10, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '덤벨 벤치프레스' LIMIT 1), 3, 'WORKING', 37.5, 8, 90
FROM session s
UNION ALL
SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '딥스' LIMIT 1), 1, 'WORKING', 77.5, 8, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '딥스' LIMIT 1), 2, 'WORKING', 77.5, 7, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '딥스' LIMIT 1), 3, 'WORKING', 77.5, 6, 90
FROM session s;

-- 1/28: 등 - 바벨로우 (총 8,000kg)
WITH session AS (
  INSERT INTO workout_sessions (id, user_id, mode, started_at, finished_at, total_volume, total_duration_seconds, total_sets, is_cancelled)
  VALUES (
    gen_random_uuid(),
    'bb44adfa-ec20-45fd-acc5-6f411a16fcc9',
    'FREE',
    '2026-01-28 10:00:00',
    '2026-01-28 11:30:00',
    8000.0,
    5400,
    16,
    false
  )
  RETURNING id, started_at
)
INSERT INTO workout_sets (id, session_id, exercise_id, set_number, set_type, weight, reps, rest_seconds)
SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '바벨 로우' LIMIT 1), 1, 'WORKING', 70.0, 10, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '바벨 로우' LIMIT 1), 2, 'WORKING', 70.0, 10, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '바벨 로우' LIMIT 1), 3, 'WORKING', 70.0, 8, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '바벨 로우' LIMIT 1), 4, 'WORKING', 70.0, 8, 90
FROM session s
UNION ALL
SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '랫풀다운' LIMIT 1), 1, 'WORKING', 60.0, 12, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '랫풀다운' LIMIT 1), 2, 'WORKING', 60.0, 12, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '랫풀다운' LIMIT 1), 3, 'WORKING', 60.0, 10, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '랫풀다운' LIMIT 1), 4, 'WORKING', 60.0, 10, 90
FROM session s
UNION ALL
SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '시티드 로우' LIMIT 1), 1, 'WORKING', 55.0, 12, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '시티드 로우' LIMIT 1), 2, 'WORKING', 55.0, 12, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '시티드 로우' LIMIT 1), 3, 'WORKING', 55.0, 10, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '시티드 로우' LIMIT 1), 4, 'WORKING', 55.0, 10, 90
FROM session s
UNION ALL
SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '원암 덤벨 로우' LIMIT 1), 1, 'WORKING', 30.0, 10, 60
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '원암 덤벨 로우' LIMIT 1), 2, 'WORKING', 30.0, 10, 60
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '원암 덤벨 로우' LIMIT 1), 3, 'WORKING', 30.0, 10, 60
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '원암 덤벨 로우' LIMIT 1), 4, 'WORKING', 30.0, 10, 60
FROM session s
UNION ALL
SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '풀업' LIMIT 1), 1, 'WORKING', 70.0, 8, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '풀업' LIMIT 1), 2, 'WORKING', 70.0, 7, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '풀업' LIMIT 1), 3, 'WORKING', 70.0, 6, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '풀업' LIMIT 1), 4, 'WORKING', 70.0, 6, 90
FROM session s;

-- ==================== 2월 데이터 (2026-02-xx) ====================

-- 2/1: 가슴 운동 (기존 10,800kg 유지)
WITH session AS (
  INSERT INTO workout_sessions (id, user_id, mode, started_at, finished_at, total_volume, total_duration_seconds, total_sets, is_cancelled)
  VALUES (
    gen_random_uuid(),
    'bb44adfa-ec20-45fd-acc5-6f411a16fcc9',
    'FREE',
    '2026-02-01 10:00:00',
    '2026-02-01 12:00:00',
    10800.0,
    7200,
    24,
    false
  )
  RETURNING id, started_at
)
INSERT INTO workout_sets (id, session_id, exercise_id, set_number, set_type, weight, reps, rest_seconds)
SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '벤치프레스' LIMIT 1), 1, 'WORKING', 90.0, 8, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '벤치프레스' LIMIT 1), 2, 'WORKING', 90.0, 8, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '벤치프레스' LIMIT 1), 3, 'WORKING', 90.0, 7, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '벤치프레스' LIMIT 1), 4, 'WORKING', 90.0, 7, 90
FROM session s
UNION ALL
SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '인클라인 벤치프레스' LIMIT 1), 1, 'WORKING', 70.0, 8, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '인클라인 벤치프레스' LIMIT 1), 2, 'WORKING', 70.0, 8, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '인클라인 벤치프레스' LIMIT 1), 3, 'WORKING', 70.0, 7, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '인클라인 벤치프레스' LIMIT 1), 4, 'WORKING', 70.0, 7, 90
FROM session s
UNION ALL
SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '덤벨 벤치프레스' LIMIT 1), 1, 'WORKING', 40.0, 10, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '덤벨 벤치프레스' LIMIT 1), 2, 'WORKING', 40.0, 10, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '덤벨 벤치프레스' LIMIT 1), 3, 'WORKING', 40.0, 8, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '덤벨 벤치프레스' LIMIT 1), 4, 'WORKING', 40.0, 8, 90
FROM session s
UNION ALL
SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '딥스' LIMIT 1), 1, 'WORKING', 80.0, 8, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '딥스' LIMIT 1), 2, 'WORKING', 80.0, 8, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '딥스' LIMIT 1), 3, 'WORKING', 80.0, 7, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '딥스' LIMIT 1), 4, 'WORKING', 80.0, 7, 90
FROM session s
UNION ALL
SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '펙덱 플라이' LIMIT 1), 1, 'WORKING', 55.0, 12, 60
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '펙덱 플라이' LIMIT 1), 2, 'WORKING', 55.0, 12, 60
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '펙덱 플라이' LIMIT 1), 3, 'WORKING', 55.0, 10, 60
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '펙덱 플라이' LIMIT 1), 4, 'WORKING', 55.0, 10, 60
FROM session s
UNION ALL
SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '케이블 크로스오버' LIMIT 1), 1, 'WORKING', 45.0, 12, 60
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '케이블 크로스오버' LIMIT 1), 2, 'WORKING', 45.0, 12, 60
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '케이블 크로스오버' LIMIT 1), 3, 'WORKING', 45.0, 10, 60
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '케이블 크로스오버' LIMIT 1), 4, 'WORKING', 45.0, 10, 60
FROM session s
UNION ALL
SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '바벨 컬' LIMIT 1), 1, 'WORKING', 30.0, 12, 60
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '바벨 컬' LIMIT 1), 2, 'WORKING', 30.0, 12, 60
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '바벨 컬' LIMIT 1), 3, 'WORKING', 30.0, 10, 60
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '바벨 컬' LIMIT 1), 4, 'WORKING', 30.0, 10, 60
FROM session s;

-- 2/3: 하체 - 스쿼트, 레그프레스 (총 25,000kg)
WITH session AS (
  INSERT INTO workout_sessions (id, user_id, mode, started_at, finished_at, total_volume, total_duration_seconds, total_sets, is_cancelled)
  VALUES (
    gen_random_uuid(),
    'bb44adfa-ec20-45fd-acc5-6f411a16fcc9',
    'FREE',
    '2026-02-03 10:00:00',
    '2026-02-03 13:00:00',
    25000.0,
    10800,
    30,
    false
  )
  RETURNING id, started_at
)
INSERT INTO workout_sets (id, session_id, exercise_id, set_number, set_type, weight, reps, rest_seconds)
SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '스쿼트' LIMIT 1), 1, 'WORKING', 110.0, 8, 120
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '스쿼트' LIMIT 1), 2, 'WORKING', 110.0, 8, 120
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '스쿼트' LIMIT 1), 3, 'WORKING', 110.0, 7, 120
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '스쿼트' LIMIT 1), 4, 'WORKING', 110.0, 7, 120
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '스쿼트' LIMIT 1), 5, 'WORKING', 110.0, 6, 120
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '스쿼트' LIMIT 1), 6, 'WORKING', 110.0, 6, 120
FROM session s
UNION ALL
SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '레그 프레스' LIMIT 1), 1, 'WORKING', 220.0, 10, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '레그 프레스' LIMIT 1), 2, 'WORKING', 220.0, 10, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '레그 프레스' LIMIT 1), 3, 'WORKING', 220.0, 10, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '레그 프레스' LIMIT 1), 4, 'WORKING', 220.0, 8, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '레그 프레스' LIMIT 1), 5, 'WORKING', 220.0, 8, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '레그 프레스' LIMIT 1), 6, 'WORKING', 220.0, 8, 90
FROM session s
UNION ALL
SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '데드리프트' LIMIT 1), 1, 'WORKING', 130.0, 6, 180
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '데드리프트' LIMIT 1), 2, 'WORKING', 130.0, 6, 180
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '데드리프트' LIMIT 1), 3, 'WORKING', 130.0, 5, 180
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '데드리프트' LIMIT 1), 4, 'WORKING', 130.0, 5, 180
FROM session s
UNION ALL
SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '런지' LIMIT 1), 1, 'WORKING', 45.0, 10, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '런지' LIMIT 1), 2, 'WORKING', 45.0, 10, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '런지' LIMIT 1), 3, 'WORKING', 45.0, 10, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '런지' LIMIT 1), 4, 'WORKING', 45.0, 8, 90
FROM session s
UNION ALL
SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '레그 컬' LIMIT 1), 1, 'WORKING', 60.0, 12, 60
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '레그 컬' LIMIT 1), 2, 'WORKING', 60.0, 12, 60
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '레그 컬' LIMIT 1), 3, 'WORKING', 60.0, 12, 60
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '레그 컬' LIMIT 1), 4, 'WORKING', 60.0, 10, 60
FROM session s
UNION ALL
SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '레그 익스텐션' LIMIT 1), 1, 'WORKING', 50.0, 15, 60
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '레그 익스텐션' LIMIT 1), 2, 'WORKING', 50.0, 15, 60
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '레그 익스텐션' LIMIT 1), 3, 'WORKING', 50.0, 12, 60
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '레그 익스텐션' LIMIT 1), 4, 'WORKING', 50.0, 12, 60
FROM session s;

-- 2/4: 어깨 - 오버헤드프레스, 사이드레터럴레이즈 (총 6,000kg)
WITH session AS (
  INSERT INTO workout_sessions (id, user_id, mode, started_at, finished_at, total_volume, total_duration_seconds, total_sets, is_cancelled)
  VALUES (
    gen_random_uuid(),
    'bb44adfa-ec20-45fd-acc5-6f411a16fcc9',
    'FREE',
    '2026-02-04 10:00:00',
    '2026-02-04 11:10:00',
    6000.0,
    4200,
    14,
    false
  )
  RETURNING id, started_at
)
INSERT INTO workout_sets (id, session_id, exercise_id, set_number, set_type, weight, reps, rest_seconds)
SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '오버헤드 프레스' LIMIT 1), 1, 'WORKING', 50.0, 10, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '오버헤드 프레스' LIMIT 1), 2, 'WORKING', 50.0, 10, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '오버헤드 프레스' LIMIT 1), 3, 'WORKING', 50.0, 8, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '오버헤드 프레스' LIMIT 1), 4, 'WORKING', 50.0, 8, 90
FROM session s
UNION ALL
SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '덤벨 숄더 프레스' LIMIT 1), 1, 'WORKING', 22.5, 10, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '덤벨 숄더 프레스' LIMIT 1), 2, 'WORKING', 22.5, 10, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '덤벨 숄더 프레스' LIMIT 1), 3, 'WORKING', 22.5, 8, 90
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '덤벨 숄더 프레스' LIMIT 1), 4, 'WORKING', 22.5, 8, 90
FROM session s
UNION ALL
SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '사이드 레터럴 레이즈' LIMIT 1), 1, 'WORKING', 12.5, 15, 60
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '사이드 레터럴 레이즈' LIMIT 1), 2, 'WORKING', 12.5, 15, 60
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '사이드 레터럴 레이즈' LIMIT 1), 3, 'WORKING', 12.5, 12, 60
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '사이드 레터럴 레이즈' LIMIT 1), 4, 'WORKING', 12.5, 12, 60
FROM session s
UNION ALL
SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '페이스풀' LIMIT 1), 1, 'WORKING', 20.0, 15, 60
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '페이스풀' LIMIT 1), 2, 'WORKING', 20.0, 15, 60
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '페이스풀' LIMIT 1), 3, 'WORKING', 20.0, 12, 60
FROM session s
UNION ALL
SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '리버스 펙덱 플라이' LIMIT 1), 1, 'WORKING', 25.0, 15, 60
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '리버스 펙덱 플라이' LIMIT 1), 2, 'WORKING', 25.0, 15, 60
FROM session s
UNION ALL SELECT gen_random_uuid(), s.id, (SELECT id FROM exercises WHERE name = '리버스 펙덱 플라이' LIMIT 1), 3, 'WORKING', 25.0, 12, 60
FROM session s;

-- 데이터 삽입 완료
SELECT 'Dummy data insert completed!' AS status;
