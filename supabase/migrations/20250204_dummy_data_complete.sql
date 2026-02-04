-- 완전한 더미 운동 데이터 추가 (workout_sessions + workout_sets)
-- user_id: bb44adfa-ec20-45fd-acc5-6f411a16fcc9
-- 각 세션마다 부위별 2종목씩, 3세트씩 입력

SET timezone = 'Asia/Seoul';

-- 12월 데이터 (8개 세션)

-- 12/5: 가슴 (벤치프레스 3세트 + 인클라인벤치프레스 3세트 = 8,000kg)
WITH chest_exercises AS (
  SELECT id FROM exercises WHERE name IN ('벤치프레스', '인클라인 벤치프레스') ORDER BY name LIMIT 2
)
INSERT INTO workout_sessions (id, user_id, mode, started_at, finished_at, total_volume, total_duration_seconds, total_sets, is_cancelled)
VALUES ('11111111-1111-1111-1111-111111111101', 'bb44adfa-ec20-45fd-acc5-6f411a16fcc9', 'FREE', '2024-12-05 10:00:00', '2024-12-05 11:30:00', 8000.0, 5400, 6, false);

INSERT INTO workout_sets (id, session_id, exercise_id, set_number, set_type, weight, reps, rest_seconds)
SELECT
  gen_random_uuid(),
  '11111111-1111-1111-1111-111111111101',
  (SELECT id FROM exercises WHERE name = '벤치프레스' LIMIT 1),
  1, 'WORKING', 80.0, 8, 90
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111101', (SELECT id FROM exercises WHERE name = '벤치프레스' LIMIT 1), 2, 'WORKING', 80.0, 8, 90
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111101', (SELECT id FROM exercises WHERE name = '벤치프레스' LIMIT 1), 3, 'WORKING', 80.0, 8, 90
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111101', (SELECT id FROM exercises WHERE name = '인클라인 벤치프레스' LIMIT 1), 4, 'WORKING', 60.0, 10, 90
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111101', (SELECT id FROM exercises WHERE name = '인클라인 벤치프레스' LIMIT 1), 5, 'WORKING', 60.0, 10, 90
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111101', (SELECT id FROM exercises WHERE name = '인클라인 벤치프레스' LIMIT 1), 6, 'WORKING', 55.0, 12, 90;

-- 12/8: 등 (랫풀다운 3세트 + 바벨로우 3세트 = 7,500kg)
INSERT INTO workout_sessions (id, user_id, mode, started_at, finished_at, total_volume, total_duration_seconds, total_sets, is_cancelled)
VALUES ('11111111-1111-1111-1111-111111111102', 'bb44adfa-ec20-45fd-acc5-6f411a16fcc9', 'FREE', '2024-12-08 10:00:00', '2024-12-08 11:15:00', 7500.0, 4500, 6, false);

INSERT INTO workout_sets (id, session_id, exercise_id, set_number, set_type, weight, reps, rest_seconds)
SELECT
  gen_random_uuid(),
  '11111111-1111-1111-1111-111111111102',
  (SELECT id FROM exercises WHERE name = '랫풀다운' LIMIT 1),
  1, 'WORKING', 70.0, 10, 90
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111102', (SELECT id FROM exercises WHERE name = '랫풀다운' LIMIT 1), 2, 'WORKING', 70.0, 10, 90
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111102', (SELECT id FROM exercises WHERE name = '랫풀다운' LIMIT 1), 3, 'WORKING', 65.0, 12, 90
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111102', (SELECT id FROM exercises WHERE name = '바벨 로우' LIMIT 1), 4, 'WORKING', 60.0, 10, 90
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111102', (SELECT id FROM exercises WHERE name = '바벨 로우' LIMIT 1), 5, 'WORKING', 60.0, 10, 90
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111102', (SELECT id FROM exercises WHERE name = '바벨 로우' LIMIT 1), 6, 'WORKING', 55.0, 12, 90;

-- 12/12: 하체 (스쿼트 3세트 + 레그프레스 3세트 = 20,000kg)
INSERT INTO workout_sessions (id, user_id, mode, started_at, finished_at, total_volume, total_duration_seconds, total_sets, is_cancelled)
VALUES ('11111111-1111-1111-1111-111111111103', 'bb44adfa-ec20-45fd-acc5-6f411a16fcc9', 'FREE', '2024-12-12 10:00:00', '2024-12-12 12:30:00', 20000.0, 9000, 6, false);

INSERT INTO workout_sets (id, session_id, exercise_id, set_number, set_type, weight, reps, rest_seconds)
SELECT
  gen_random_uuid(),
  '11111111-1111-1111-1111-111111111103',
  (SELECT id FROM exercises WHERE name = '스쿼트' LIMIT 1),
  1, 'WORKING', 100.0, 8, 120
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111103', (SELECT id FROM exercises WHERE name = '스쿼트' LIMIT 1), 2, 'WORKING', 100.0, 8, 120
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111103', (SELECT id FROM exercises WHERE name = '스쿼트' LIMIT 1), 3, 'WORKING', 95.0, 10, 120
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111103', (SELECT id FROM exercises WHERE name = '레그 프레스' LIMIT 1), 4, 'WORKING', 200.0, 12, 120
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111103', (SELECT id FROM exercises WHERE name = '레그 프레스' LIMIT 1), 5, 'WORKING', 200.0, 12, 120
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111103', (SELECT id FROM exercises WHERE name = '레그 프레스' LIMIT 1), 6, 'WORKING', 180.0, 15, 120;

-- 12/15: 어깨 (오버헤드 프레스 3세트 + 사이드 레터럴 레이즈 3세트 = 5,000kg)
INSERT INTO workout_sessions (id, user_id, mode, started_at, finished_at, total_volume, total_duration_seconds, total_sets, is_cancelled)
VALUES ('11111111-1111-1111-1111-111111111104', 'bb44adfa-ec20-45fd-acc5-6f411a16fcc9', 'FREE', '2024-12-15 10:00:00', '2024-12-15 11:00:00', 5000.0, 3600, 6, false);

INSERT INTO workout_sets (id, session_id, exercise_id, set_number, set_type, weight, reps, rest_seconds)
SELECT
  gen_random_uuid(),
  '11111111-1111-1111-1111-111111111104',
  (SELECT id FROM exercises WHERE name = '오버헤드 프레스' LIMIT 1),
  1, 'WORKING', 40.0, 10, 90
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111104', (SELECT id FROM exercises WHERE name = '오버헤드 프레스' LIMIT 1), 2, 'WORKING', 40.0, 10, 90
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111104', (SELECT id FROM exercises WHERE name = '오버헤드 프레스' LIMIT 1), 3, 'WORKING', 35.0, 12, 90
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111104', (SELECT id FROM exercises WHERE name = '사이드 레터럴 레이즈' LIMIT 1), 4, 'WORKING', 12.0, 15, 60
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111104', (SELECT id FROM exercises WHERE name = '사이드 레터럴 레이즈' LIMIT 1), 5, 'WORKING', 10.0, 15, 60
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111104', (SELECT id FROM exercises WHERE name = '사이드 레터럴 레이즈' LIMIT 1), 6, 'WORKING', 10.0, 20, 60;

-- 12/19: 팔 (바벨 컬 3세트 + 트라이셉스 푸쉬다운 3세트 = 3,000kg)
INSERT INTO workout_sessions (id, user_id, mode, started_at, finished_at, total_volume, total_duration_seconds, total_sets, is_cancelled)
VALUES ('11111111-1111-1111-1111-111111111105', 'bb44adfa-ec20-45fd-acc5-6f411a16fcc9', 'FREE', '2024-12-19 10:00:00', '2024-12-19 10:50:00', 3000.0, 3000, 6, false);

INSERT INTO workout_sets (id, session_id, exercise_id, set_number, set_type, weight, reps, rest_seconds)
SELECT
  gen_random_uuid(),
  '11111111-1111-1111-1111-111111111105',
  (SELECT id FROM exercises WHERE name = '바벨 컬' LIMIT 1),
  1, 'WORKING', 30.0, 12, 60
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111105', (SELECT id FROM exercises WHERE name = '바벨 컬' LIMIT 1), 2, 'WORKING', 30.0, 12, 60
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111105', (SELECT id FROM exercises WHERE name = '바벨 컬' LIMIT 1), 3, 'WORKING', 25.0, 15, 60
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111105', (SELECT id FROM exercises WHERE name = '트라이셉스 푸쉬다운' LIMIT 1), 4, 'WORKING', 40.0, 15, 60
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111105', (SELECT id FROM exercises WHERE name = '트라이셉스 푸쉬다운' LIMIT 1), 5, 'WORKING', 35.0, 15, 60
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111105', (SELECT id FROM exercises WHERE name = '트라이셉스 푸쉬다운' LIMIT 1), 6, 'WORKING', 30.0, 20, 60;

-- 12/22: 가슴 (벤치프레스 3세트 + 케이블 크로스오버 3세트 = 9,000kg)
INSERT INTO workout_sessions (id, user_id, mode, started_at, finished_at, total_volume, total_duration_seconds, total_sets, is_cancelled)
VALUES ('11111111-1111-1111-1111-111111111106', 'bb44adfa-ec20-45fd-acc5-6f411a16fcc9', 'FREE', '2024-12-22 10:00:00', '2024-12-22 11:30:00', 9000.0, 5400, 6, false);

INSERT INTO workout_sets (id, session_id, exercise_id, set_number, set_type, weight, reps, rest_seconds)
SELECT
  gen_random_uuid(),
  '11111111-1111-1111-1111-111111111106',
  (SELECT id FROM exercises WHERE name = '벤치프레스' LIMIT 1),
  1, 'WORKING', 85.0, 8, 90
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111106', (SELECT id FROM exercises WHERE name = '벤치프레스' LIMIT 1), 2, 'WORKING', 85.0, 8, 90
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111106', (SELECT id FROM exercises WHERE name = '벤치프레스' LIMIT 1), 3, 'WORKING', 80.0, 10, 90
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111106', (SELECT id FROM exercises WHERE name = '케이블 크로스오버' LIMIT 1), 4, 'WORKING', 50.0, 12, 60
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111106', (SELECT id FROM exercises WHERE name = '케이블 크로스오버' LIMIT 1), 5, 'WORKING', 50.0, 15, 60
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111106', (SELECT id FROM exercises WHERE name = '케이블 크로스오버' LIMIT 1), 6, 'WORKING', 45.0, 15, 60;

-- 12/26: 등 (풀업 3세트 + 시티드 로우 3세트 = 6,500kg)
INSERT INTO workout_sessions (id, user_id, mode, started_at, finished_at, total_volume, total_duration_seconds, total_sets, is_cancelled)
VALUES ('11111111-1111-1111-1111-111111111107', 'bb44adfa-ec20-45fd-acc5-6f411a16fcc9', 'FREE', '2024-12-26 10:00:00', '2024-12-26 11:15:00', 6500.0, 4500, 6, false);

INSERT INTO workout_sets (id, session_id, exercise_id, set_number, set_type, weight, reps, rest_seconds)
SELECT
  gen_random_uuid(),
  '11111111-1111-1111-1111-111111111107',
  (SELECT id FROM exercises WHERE name = '풀업' LIMIT 1),
  1, 'WORKING', 80.0, 8, 90
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111107', (SELECT id FROM exercises WHERE name = '풀업' LIMIT 1), 2, 'WORKING', 80.0, 8, 90
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111107', (SELECT id FROM exercises WHERE name = '풀업' LIMIT 1), 3, 'WORKING', 75.0, 10, 90
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111107', (SELECT id FROM exercises WHERE name = '시티드 로우' LIMIT 1), 4, 'WORKING', 60.0, 12, 90
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111107', (SELECT id FROM exercises WHERE name = '시티드 로우' LIMIT 1), 5, 'WORKING', 55.0, 12, 90
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111107', (SELECT id FROM exercises WHERE name = '시티드 로우' LIMIT 1), 6, 'WORKING', 50.0, 15, 90;

-- 12/29: 하체 (데드리프트 3세트 + 레그 컬 3세트 = 18,000kg)
INSERT INTO workout_sessions (id, user_id, mode, started_at, finished_at, total_volume, total_duration_seconds, total_sets, is_cancelled)
VALUES ('11111111-1111-1111-1111-111111111108', 'bb44adfa-ec20-45fd-acc5-6f411a16fcc9', 'FREE', '2024-12-29 10:00:00', '2024-12-29 12:00:00', 18000.0, 7200, 6, false);

INSERT INTO workout_sets (id, session_id, exercise_id, set_number, set_type, weight, reps, rest_seconds)
SELECT
  gen_random_uuid(),
  '11111111-1111-1111-1111-111111111108',
  (SELECT id FROM exercises WHERE name = '데드리프트' LIMIT 1),
  1, 'WORKING', 120.0, 8, 120
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111108', (SELECT id FROM exercises WHERE name = '데드리프트' LIMIT 1), 2, 'WORKING', 120.0, 8, 120
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111108', (SELECT id FROM exercises WHERE name = '데드리프트' LIMIT 1), 3, 'WORKING', 110.0, 10, 120
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111108', (SELECT id FROM exercises WHERE name = '레그 컬' LIMIT 1), 4, 'WORKING', 80.0, 12, 90
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111108', (SELECT id FROM exercises WHERE name = '레그 컬' LIMIT 1), 5, 'WORKING', 80.0, 12, 90
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111108', (SELECT id FROM exercises WHERE name = '레그 컬' LIMIT 1), 6, 'WORKING', 75.0, 15, 90;

-- 1월 데이터 (9개 세션)

-- 1/2: 어깨 (덤벨 숄더 프레스 3세트 + 페이스풀 3세트 = 5,500kg)
INSERT INTO workout_sessions (id, user_id, mode, started_at, finished_at, total_volume, total_duration_seconds, total_sets, is_cancelled)
VALUES ('11111111-1111-1111-1111-111111111201', 'bb44adfa-ec20-45fd-acc5-6f411a16fcc9', 'FREE', '2025-01-02 10:00:00', '2025-01-02 11:00:00', 5500.0, 3600, 6, false);

INSERT INTO workout_sets (id, session_id, exercise_id, set_number, set_type, weight, reps, rest_seconds)
SELECT
  gen_random_uuid(),
  '11111111-1111-1111-1111-111111111201',
  (SELECT id FROM exercises WHERE name = '덤벨 숄더 프레스' LIMIT 1),
  1, 'WORKING', 25.0, 10, 90
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111201', (SELECT id FROM exercises WHERE name = '덤벨 숄더 프레스' LIMIT 1), 2, 'WORKING', 25.0, 10, 90
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111201', (SELECT id FROM exercises WHERE name = '덤벨 숄더 프레스' LIMIT 1), 3, 'WORKING', 20.0, 12, 90
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111201', (SELECT id FROM exercises WHERE name = '페이스풀' LIMIT 1), 4, 'WORKING', 30.0, 15, 60
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111201', (SELECT id FROM exercises WHERE name = '페이스풀' LIMIT 1), 5, 'WORKING', 25.0, 15, 60
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111201', (SELECT id FROM exercises WHERE name = '페이스풀' LIMIT 1), 6, 'WORKING', 25.0, 20, 60;

-- 1/5: 가슴 (벤치프레스 3세트 + 딥스 3세트 = 10,000kg)
INSERT INTO workout_sessions (id, user_id, mode, started_at, finished_at, total_volume, total_duration_seconds, total_sets, is_cancelled)
VALUES ('11111111-1111-1111-1111-111111111202', 'bb44adfa-ec20-45fd-acc5-6f411a16fcc9', 'FREE', '2025-01-05 10:00:00', '2025-01-05 11:45:00', 10000.0, 6300, 6, false);

INSERT INTO workout_sets (id, session_id, exercise_id, set_number, set_type, weight, reps, rest_seconds)
SELECT
  gen_random_uuid(),
  '11111111-1111-1111-1111-111111111202',
  (SELECT id FROM exercises WHERE name = '벤치프레스' LIMIT 1),
  1, 'WORKING', 90.0, 8, 90
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111202', (SELECT id FROM exercises WHERE name = '벤치프레스' LIMIT 1), 2, 'WORKING', 90.0, 8, 90
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111202', (SELECT id FROM exercises WHERE name = '벤치프레스' LIMIT 1), 3, 'WORKING', 85.0, 10, 90
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111202', (SELECT id FROM exercises WHERE name = '딥스' LIMIT 1), 4, 'WORKING', 80.0, 10, 90
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111202', (SELECT id FROM exercises WHERE name = '딥스' LIMIT 1), 5, 'WORKING', 80.0, 12, 90
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111202', (SELECT id FROM exercises WHERE name = '딥스' LIMIT 1), 6, 'WORKING', 75.0, 15, 90;

-- 1/9: 등 (랫풀다운 3세트 + 티바로우 3세트 = 8,000kg)
INSERT INTO workout_sessions (id, user_id, mode, started_at, finished_at, total_volume, total_duration_seconds, total_sets, is_cancelled)
VALUES ('11111111-1111-1111-1111-111111111203', 'bb44adfa-ec20-45fd-acc5-6f411a16fcc9', 'FREE', '2025-01-09 10:00:00', '2025-01-09 11:30:00', 8000.0, 5400, 6, false);

INSERT INTO workout_sets (id, session_id, exercise_id, set_number, set_type, weight, reps, rest_seconds)
SELECT
  gen_random_uuid(),
  '11111111-1111-1111-1111-111111111203',
  (SELECT id FROM exercises WHERE name = '랫풀다운' LIMIT 1),
  1, 'WORKING', 75.0, 10, 90
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111203', (SELECT id FROM exercises WHERE name = '랫풀다운' LIMIT 1), 2, 'WORKING', 75.0, 10, 90
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111203', (SELECT id FROM exercises WHERE name = '랫풀다운' LIMIT 1), 3, 'WORKING', 70.0, 12, 90
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111203', (SELECT id FROM exercises WHERE name = '티바로우' LIMIT 1), 4, 'WORKING', 60.0, 10, 90
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-1111-111111111203', (SELECT id FROM exercises WHERE name = '티바로우' LIMIT 1), 5, 'WORKING', 60.0, 10, 90
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111203', (SELECT id FROM exercises WHERE name = '티바로우' LIMIT 1), 6, 'WORKING', 55.0, 12, 90;

-- 1/12: 하체 (스쿼트 3세트 + 레그 컬 3세트 = 22,000kg)
INSERT INTO workout_sessions (id, user_id, mode, started_at, finished_at, total_volume, total_duration_seconds, total_sets, is_cancelled)
VALUES ('11111111-1111-1111-1111-111111111204', 'bb44adfa-ec20-45fd-acc5-6f411a16fcc9', 'FREE', '2025-01-12 10:00:00', '2025-01-12 12:40:00', 22000.0, 9600, 6, false);

INSERT INTO workout_sets (id, session_id, exercise_id, set_number, set_type, weight, reps, rest_seconds)
SELECT
  gen_random_uuid(),
  '11111111-1111-1111-1111-111111111204',
  (SELECT id FROM exercises WHERE name = '스쿼트' LIMIT 1),
  1, 'WORKING', 110.0, 8, 120
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111204', (SELECT id FROM exercises WHERE name = '스쿼트' LIMIT 1), 2, 'WORKING', 110.0, 8, 120
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111204', (SELECT id FROM exercises WHERE name = '스쿼트' LIMIT 1), 3, 'WORKING', 105.0, 10, 120
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111204', (SELECT id FROM exercises WHERE name = '레그 컬' LIMIT 1), 4, 'WORKING', 90.0, 12, 90
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111204', (SELECT id FROM exercises WHERE name = '레그 컬' LIMIT 1), 5, 'WORKING', 90.0, 12, 90
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111204', (SELECT id FROM exercises WHERE name = '레그 컬' LIMIT 1), 6, 'WORKING', 85.0, 15, 90;

-- 1/16: 팔 (덤벨 컬 3세트 + 스컬 크러셔 3세트 = 3,500kg)
INSERT INTO workout_sessions (id, user_id, mode, started_at, finished_at, total_volume, total_duration_seconds, total_sets, is_cancelled)
VALUES ('11111111-1111-1111-1111-111111111205', 'bb44adfa-ec20-45fd-acc5-6f411a16fcc9', 'FREE', '2025-01-16 10:00:00', '2025-01-16 10:40:00', 3500.0, 2400, 6, false);

INSERT INTO workout_sets (id, session_id, exercise_id, set_number, set_type, weight, reps, rest_seconds)
SELECT
  gen_random_uuid(),
  '11111111-1111-1111-1111-111111111205',
  (SELECT id FROM exercises WHERE name = '바벨 컬' LIMIT 1),
  1, 'WORKING', 32.0, 12, 60
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111205', (SELECT id FROM exercises WHERE name = '바벨 컬' LIMIT 1), 2, 'WORKING', 30.0, 12, 60
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111205', (SELECT id FROM exercises WHERE name = '바벨 컬' LIMIT 1), 3, 'WORKING', 28.0, 15, 60
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111205', (SELECT id FROM exercises WHERE name = '스컬 크러셔' LIMIT 1), 4, 'WORKING', 25.0, 15, 60
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111205', (SELECT id FROM exercises WHERE name = '스컬 크러셔' LIMIT 1), 5, 'WORKING', 22.0, 15, 60
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111205', (SELECT id FROM exercises WHERE name = '스컬 크러셔' LIMIT 1), 6, 'WORKING', 20.0, 20, 60;

-- 1/19: 가슴 (인클라인 벤치프레스 3세트 + 펙덱 플라이 3세트 = 9,500kg)
INSERT INTO workout_sessions (id, user_id, mode, started_at, finished_at, total_volume, total_duration_seconds, total_sets, is_cancelled)
VALUES ('11111111-1111-1111-1111-111111111206', 'bb44adfa-ec20-45fd-acc5-6f411a16fcc9', 'FREE', '2025-01-19 10:00:00', '2025-01-19 11:30:00', 9500.0, 5400, 6, false);

INSERT INTO workout_sets (id, session_id, exercise_id, set_number, set_type, weight, reps, rest_seconds)
SELECT
  gen_random_uuid(),
  '11111111-1111-1111-1111-111111111206',
  (SELECT id FROM exercises WHERE name = '인클라인 벤치프레스' LIMIT 1),
  1, 'WORKING', 70.0, 10, 90
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111206', (SELECT id FROM exercises WHERE name = '인클라인 벤치프레스' LIMIT 1), 2, 'WORKING', 70.0, 10, 90
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111206', (SELECT id FROM exercises WHERE name = '인클라인 벤치프레스' LIMIT 1), 3, 'WORKING', 65.0, 12, 90
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111206', (SELECT id FROM exercises WHERE name = '펙덱 플라이' LIMIT 1), 4, 'WORKING', 55.0, 15, 60
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111206', (SELECT id FROM exercises WHERE name = '펙덱 플라이' LIMIT 1), 5, 'WORKING', 50.0, 15, 60
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111206', (SELECT id FROM exercises WHERE name = '펙덱 플라이' LIMIT 1), 6, 'WORKING', 45.0, 20, 60;

-- 1/23: 등 (풀업 3세트 + 원암 덤벨 로우 3세트 = 7,000kg)
INSERT INTO workout_sessions (id, user_id, mode, started_at, finished_at, total_volume, total_duration_seconds, total_sets, is_cancelled)
VALUES ('11111111-1111-1111-1111-111111111207', 'bb44adfa-ec20-45fd-acc5-6f411a16fcc9', 'FREE', '2025-01-23 10:00:00', '2025-01-23 11:20:00', 7000.0, 4800, 6, false);

INSERT INTO workout_sets (id, session_id, exercise_id, set_number, set_type, weight, reps, rest_seconds)
SELECT
  gen_random_uuid(),
  '11111111-1111-1111-1111-111111111207',
  (SELECT id FROM exercises WHERE name = '풀업' LIMIT 1),
  1, 'WORKING', 82.0, 8, 90
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111207', (SELECT id FROM exercises WHERE name = '풀업' LIMIT 1), 2, 'WORKING', 82.0, 8, 90
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111207', (SELECT id FROM exercises WHERE name = '풀업' LIMIT 1), 3, 'WORKING', 78.0, 10, 90
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111207', (SELECT id FROM exercises WHERE name = '원암 덤벨 로우' LIMIT 1), 4, 'WORKING', 35.0, 12, 90
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111207', (SELECT id FROM exercises WHERE name = '원암 덤벨 로우' LIMIT 1), 5, 'WORKING', 30.0, 12, 90
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111207', (SELECT id FROM exercises WHERE name = '원암 덤벨 로우' LIMIT 1), 6, 'WORKING', 28.0, 15, 90;

-- 1/25: 가슴 (덤벨 벤치프레스 3세트 + 케이블 크로스오버 3세트 = 5,000kg)
INSERT INTO workout_sessions (id, user_id, mode, started_at, finished_at, total_volume, total_duration_seconds, total_sets, is_cancelled)
VALUES ('11111111-1111-1111-1111-111111111208', 'bb44adfa-ec20-45fd-acc5-6f411a16fcc9', 'FREE', '2025-01-25 10:00:00', '2025-01-25 11:00:00', 5000.0, 3600, 6, false);

INSERT INTO workout_sets (id, session_id, exercise_id, set_number, set_type, weight, reps, rest_seconds)
SELECT
  gen_random_uuid(),
  '11111111-1111-1111-1111-111111111208',
  (SELECT id FROM exercises WHERE name = '덤벨 벤치프레스' LIMIT 1),
  1, 'WORKING', 40.0, 10, 90
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111208', (SELECT id FROM exercises WHERE name = '덤벨 벤치프레스' LIMIT 1), 2, 'WORKING', 40.0, 10, 90
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111208', (SELECT id FROM exercises WHERE name = '덤벨 벤치프레스' LIMIT 1), 3, 'WORKING', 35.0, 12, 90
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111208', (SELECT id FROM exercises WHERE name = '케이블 크로스오버' LIMIT 1), 4, 'WORKING', 50.0, 12, 60
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111208', (SELECT id FROM exercises WHERE name = '케이블 크로스오버' LIMIT 1), 5, 'WORKING', 45.0, 15, 60
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111208', (SELECT id FROM exercises WHERE name = '케이블 크로스오버' LIMIT 1), 6, 'WORKING', 40.0, 15, 60;

-- 1/28: 등 (바벨 로우 3세트 + 시티드 로우 3세트 = 8,000kg)
INSERT INTO workout_sessions (id, user_id, mode, started_at, finished_at, total_volume, total_duration_seconds, total_sets, is_cancelled)
VALUES ('11111111-1111-1111-1111-111111111209', 'bb44adfa-ec20-45fd-acc5-6f411a16fcc9', 'FREE', '2025-01-28 10:00:00', '2025-01-28 11:30:00', 8000.0, 5400, 6, false);

INSERT INTO workout_sets (id, session_id, exercise_id, set_number, set_type, weight, reps, rest_seconds)
SELECT
  gen_random_uuid(),
  '11111111-1111-1111-1111-111111111209',
  (SELECT id FROM exercises WHERE name = '바벨 로우' LIMIT 1),
  1, 'WORKING', 65.0, 10, 90
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-111111111209', (SELECT id FROM exercises WHERE name = '바벨 로우' LIMIT 1), 2, 'WORKING', 65.0, 10, 90
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-111111111209', (SELECT id FROM exercises WHERE name = '바벨 로우' LIMIT 1), 3, 'WORKING', 60.0, 12, 90
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111209', (SELECT id FROM exercises WHERE name = '시티드 로우' LIMIT 1), 4, 'WORKING', 65.0, 12, 90
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111209', (SELECT id FROM exercises WHERE name = '시티드 로우' LIMIT 1), 5, 'WORKING', 60.0, 12, 90
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-111111111209', (SELECT id FROM exercises WHERE name = '시티드 로우' LIMIT 1), 6, 'WORKING', 55.0, 15, 90;

-- 2월 데이터 (2개 세션)

-- 2/3: 하체 (스쿼트 3세트 + 레그 프레스 3세트 = 25,000kg)
INSERT INTO workout_sessions (id, user_id, mode, started_at, finished_at, total_volume, total_duration_seconds, total_sets, is_cancelled)
VALUES ('11111111-1111-1111-1111-111111111301', 'bb44adfa-ec20-45fd-acc5-6f411a16fcc9', 'FREE', '2025-02-03 10:00:00', '2025-02-03 13:00:00', 25000.0, 10800, 6, false);

INSERT INTO workout_sets (id, session_id, exercise_id, set_number, set_type, weight, reps, rest_seconds)
SELECT
  gen_random_uuid(),
  '11111111-1111-1111-1111-111111111301',
  (SELECT id FROM exercises WHERE name = '스쿼트' LIMIT 1),
  1, 'WORKING', 120.0, 8, 120
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111301', (SELECT id FROM exercises WHERE name = '스쿼트' LIMIT 1), 2, 'WORKING', 120.0, 8, 120
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111301', (SELECT id FROM exercises WHERE name = '스쿼트' LIMIT 1), 3, 'WORKING', 115.0, 10, 120
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111301', (SELECT id FROM exercises WHERE name = '레그 프레스' LIMIT 1), 4, 'WORKING', 220.0, 12, 120
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111301', (SELECT id FROM exercises WHERE name = '레그 프레스' LIMIT 1), 5, 'WORKING', 220.0, 12, 120
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111301', (SELECT id FROM exercises WHERE name = '레그 프레스' LIMIT 1), 6, 'WORKING', 200.0, 15, 120;

-- 2/4: 어깨 (오버헤드 프레스 3세트 + 사이드 레터럴 레이즈 3세트 = 6,000kg)
INSERT INTO workout_sessions (id, user_id, mode, started_at, finished_at, total_volume, total_duration_seconds, total_sets, is_cancelled)
VALUES ('11111111-1111-1111-1111-111111111302', 'bb44adfa-ec20-45fd-acc5-6f411a16fcc9', 'FREE', '2025-02-04 10:00:00', '2025-02-04 11:10:00', 6000.0, 4200, 6, false);

INSERT INTO workout_sets (id, session_id, exercise_id, set_number, set_type, weight, reps, rest_seconds)
SELECT
  gen_random_uuid(),
  '11111111-1111-1111-1111-111111111302',
  (SELECT id FROM exercises WHERE name = '오버헤드 프레스' LIMIT 1),
  1, 'WORKING', 45.0, 10, 90
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111302', (SELECT id FROM exercises WHERE name = '오버헤드 프레스' LIMIT 1), 2, 'WORKING', 45.0, 10, 90
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111302', (SELECT id FROM exercises WHERE name = '오버헤드 프레스' LIMIT 1), 3, 'WORKING', 40.0, 12, 90
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111302', (SELECT id FROM exercises WHERE name = '사이드 레터럴 레이즈' LIMIT 1), 4, 'WORKING', 15.0, 15, 60
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111302', (SELECT id FROM exercises WHERE name = '사이드 레터럴 레이즈' LIMIT 1), 5, 'WORKING', 12.0, 15, 60
UNION ALL SELECT gen_random_uuid(), '11111111-1111-1111-1111-111111111302', (SELECT id FROM exercises WHERE name = '사이드 레터럴 레이즈' LIMIT 1), 6, 'WORKING', 10.0, 20, 60;
