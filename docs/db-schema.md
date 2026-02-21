# V2log 데이터베이스 스키마 (Supabase)

> 이 파일은 CLAUDE.md에서 추출됨. DB INSERT/UPDATE 작업 시 반드시 참조.

## 테이블 관계도
```
auth.users ← users (1:1)
users ← routines ← routine_exercises → exercises
users ← workout_sessions ← workout_sets → exercises
users ← exercise_records → exercises
users ← body_records
preset_routines ← preset_routine_exercises → exercises
preset_routines ← routines (source_type='PRESET')
```

## 테이블 DDL

```sql
-- 사용자
CREATE TABLE users (
  id UUID PRIMARY KEY REFERENCES auth.users(id),
  email TEXT UNIQUE NOT NULL,
  nickname TEXT NOT NULL,
  profile_image_url TEXT,
  gender TEXT CHECK (gender IN ('MALE', 'FEMALE', 'OTHER')),
  birth_date DATE,
  height DECIMAL(5,2),
  weight DECIMAL(5,2),
  experience_level TEXT DEFAULT 'BEGINNER'
    CHECK (experience_level IN ('BEGINNER', 'INTERMEDIATE', 'ADVANCED')),
  fitness_goal TEXT DEFAULT 'HYPERTROPHY'
    CHECK (fitness_goal IN ('STRENGTH', 'HYPERTROPHY', 'ENDURANCE', 'WEIGHT_LOSS')),
  preferred_mode TEXT DEFAULT 'HYBRID'
    CHECK (preferred_mode IN ('PRESET', 'FREE', 'HYBRID')),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 운동 라이브러리
CREATE TABLE exercises (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  name_en TEXT,
  category TEXT CHECK (category IN ('STRENGTH', 'CARDIO', 'FLEXIBILITY')),
  primary_muscle TEXT NOT NULL,
  secondary_muscles TEXT[],
  equipment_required TEXT[],
  difficulty TEXT CHECK (difficulty IN ('BEGINNER', 'INTERMEDIATE', 'ADVANCED')),
  instructions TEXT[],
  tips TEXT[],
  animation_url TEXT,
  video_url TEXT,
  thumbnail_url TEXT,
  calories_per_minute DECIMAL(5,2),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 프리셋 루틴 (전문가 큐레이션)
CREATE TABLE preset_routines (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  name_en TEXT,
  description TEXT,
  difficulty TEXT CHECK (difficulty IN ('BEGINNER', 'INTERMEDIATE', 'ADVANCED')),
  target_goal TEXT CHECK (target_goal IN ('STRENGTH', 'HYPERTROPHY', 'ENDURANCE', 'WEIGHT_LOSS')),
  days_per_week INTEGER NOT NULL,
  estimated_duration_minutes INTEGER,
  target_muscles TEXT[],
  equipment_required TEXT[],
  thumbnail_url TEXT,
  popularity_score INTEGER DEFAULT 0,
  is_featured BOOLEAN DEFAULT FALSE,
  created_by TEXT DEFAULT 'V2log Team',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 프리셋 루틴 ↔ 운동 연결
CREATE TABLE preset_routine_exercises (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  preset_routine_id UUID REFERENCES preset_routines(id) ON DELETE CASCADE,
  exercise_id UUID REFERENCES exercises(id),
  day_number INTEGER NOT NULL,
  day_name TEXT,
  order_index INTEGER NOT NULL,
  target_sets INTEGER DEFAULT 3,
  target_reps TEXT DEFAULT '10-12',
  rest_seconds INTEGER DEFAULT 90,
  notes TEXT
);

-- 사용자 루틴
CREATE TABLE routines (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  source_type TEXT DEFAULT 'CUSTOM'
    CHECK (source_type IN ('PRESET', 'CUSTOM', 'TEMPLATE')),
  is_ai_generated BOOLEAN DEFAULT FALSE,
  preset_routine_id UUID REFERENCES preset_routines(id),
  target_muscles TEXT[],
  estimated_duration INTEGER,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 루틴 ↔ 운동 연결
CREATE TABLE routine_exercises (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  routine_id UUID REFERENCES routines(id) ON DELETE CASCADE,
  exercise_id UUID REFERENCES exercises(id),
  order_index INTEGER NOT NULL,
  target_sets INTEGER DEFAULT 3,
  target_reps TEXT DEFAULT '10-12',
  target_weight DECIMAL(6,2),
  rest_seconds INTEGER DEFAULT 90,
  notes TEXT
);

-- 운동 세션
CREATE TABLE workout_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  routine_id UUID REFERENCES routines(id),
  session_number INTEGER DEFAULT 1,
  mode TEXT CHECK (mode IN ('PRESET', 'FREE')),
  started_at TIMESTAMPTZ DEFAULT NOW(),
  finished_at TIMESTAMPTZ,
  is_cancelled BOOLEAN DEFAULT FALSE,
  total_volume DECIMAL(10,2),
  total_sets INTEGER,
  total_duration_seconds INTEGER,
  calories_burned INTEGER,
  notes TEXT,
  mood_rating INTEGER CHECK (mood_rating >= 1 AND mood_rating <= 5),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 세트 기록
CREATE TABLE workout_sets (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id UUID REFERENCES workout_sessions(id) ON DELETE CASCADE,
  exercise_id UUID REFERENCES exercises(id),
  set_number INTEGER NOT NULL,
  set_type TEXT DEFAULT 'WORKING'
    CHECK (set_type IN ('WARMUP', 'WORKING', 'DROP', 'FAILURE', 'SUPERSET')),
  weight DECIMAL(6,2),
  reps INTEGER,
  target_weight DECIMAL(6,2),
  target_reps INTEGER,
  rpe DECIMAL(3,1) CHECK (rpe >= 1 AND rpe <= 10),
  rest_seconds INTEGER,
  is_pr BOOLEAN DEFAULT FALSE,
  notes TEXT,
  completed_at TIMESTAMPTZ DEFAULT NOW()
);

-- 운동별 기록 집계 (1RM 추적)
CREATE TABLE exercise_records (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  exercise_id UUID REFERENCES exercises(id),
  estimated_1rm DECIMAL(6,2),
  max_weight DECIMAL(6,2),
  max_reps INTEGER,
  max_volume DECIMAL(10,2),
  total_volume DECIMAL(12,2) DEFAULT 0,
  total_sets INTEGER DEFAULT 0,
  last_performed_at TIMESTAMPTZ,
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, exercise_id)
);

-- 신체 기록
CREATE TABLE body_records (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  weight DECIMAL(5,2),
  body_fat_percentage DECIMAL(4,2),
  muscle_mass DECIMAL(5,2),
  skeletal_muscle_mass DECIMAL(5,2),
  bmi DECIMAL(4,2),
  chest DECIMAL(5,2),
  waist DECIMAL(5,2),
  hip DECIMAL(5,2),
  thigh DECIMAL(5,2),
  arm DECIMAL(5,2),
  notes TEXT,
  photo_url TEXT,
  recorded_at DATE DEFAULT CURRENT_DATE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

## FK 구조 요약
| FK 컬럼 | 참조 | NOT NULL |
|---------|------|----------|
| `workout_sessions.user_id` | `users.id` | YES |
| `workout_sessions.routine_id` | `routines.id` | NO |
| `workout_sets.session_id` | `workout_sessions.id` | YES |
| `workout_sets.exercise_id` | `exercises.id` | YES |
| `routines.user_id` | `users.id` | YES |
| `routine_exercises.routine_id` | `routines.id` | YES |
| `routine_exercises.exercise_id` | `exercises.id` | YES |

## CHECK 제약조건
| 테이블 | 컬럼 | 허용값 |
|--------|------|--------|
| users | fitness_goal | STRENGTH, HYPERTROPHY, ENDURANCE, WEIGHT_LOSS |
| users | preferred_mode | PRESET, FREE, HYBRID |
| users | experience_level | BEGINNER, INTERMEDIATE, ADVANCED |
| users | gender | MALE, FEMALE, OTHER |
| exercises | category | STRENGTH, CARDIO, FLEXIBILITY |
| exercises | difficulty | BEGINNER, INTERMEDIATE, ADVANCED |
| preset_routines | difficulty | BEGINNER, INTERMEDIATE, ADVANCED |
| preset_routines | target_goal | STRENGTH, HYPERTROPHY, ENDURANCE, WEIGHT_LOSS |
| routines | source_type | PRESET, CUSTOM, TEMPLATE |
| workout_sessions | mode | PRESET, FREE |
| workout_sets | set_type | WARMUP, WORKING, DROP, FAILURE, SUPERSET |
