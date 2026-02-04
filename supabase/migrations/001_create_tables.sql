-- ============================================
-- V2log Database Schema
-- Supabase SQL Editor에서 실행
-- ============================================

-- 기존 테이블 삭제 (개발 환경에서만 사용)
-- DROP TABLE IF EXISTS body_records CASCADE;
-- DROP TABLE IF EXISTS exercise_records CASCADE;
-- DROP TABLE IF EXISTS workout_sets CASCADE;
-- DROP TABLE IF EXISTS workout_sessions CASCADE;
-- DROP TABLE IF EXISTS routine_exercises CASCADE;
-- DROP TABLE IF EXISTS routines CASCADE;
-- DROP TABLE IF EXISTS preset_routine_exercises CASCADE;
-- DROP TABLE IF EXISTS preset_routines CASCADE;
-- DROP TABLE IF EXISTS exercises CASCADE;
-- DROP TABLE IF EXISTS users CASCADE;

-- ============================================
-- 1. USERS 테이블
-- ============================================
CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT UNIQUE NOT NULL,
  nickname TEXT NOT NULL,
  profile_image_url TEXT,
  gender TEXT CHECK (gender IN ('MALE', 'FEMALE', 'OTHER')),
  birth_date DATE,
  height DECIMAL(5,2),  -- cm (최대 999.99)
  weight DECIMAL(5,2),  -- kg (최대 999.99)
  experience_level TEXT DEFAULT 'BEGINNER'
    CHECK (experience_level IN ('BEGINNER', 'INTERMEDIATE', 'ADVANCED')),
  fitness_goal TEXT DEFAULT 'HYPERTROPHY'
    CHECK (fitness_goal IN ('STRENGTH', 'HYPERTROPHY', 'ENDURANCE', 'WEIGHT_LOSS')),
  preferred_mode TEXT DEFAULT 'HYBRID'
    CHECK (preferred_mode IN ('PRESET', 'FREE', 'HYBRID')),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Users 인덱스
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_experience_level ON users(experience_level);

-- Users RLS
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own profile" ON users
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON users
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile" ON users
  FOR INSERT WITH CHECK (auth.uid() = id);

-- ============================================
-- 2. EXERCISES 테이블 (운동 라이브러리)
-- ============================================
CREATE TABLE IF NOT EXISTS exercises (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  name_en TEXT,
  category TEXT CHECK (category IN ('STRENGTH', 'CARDIO', 'FLEXIBILITY')),
  primary_muscle TEXT NOT NULL,
  secondary_muscles TEXT[] DEFAULT '{}',
  equipment_required TEXT[] DEFAULT '{}',
  difficulty TEXT CHECK (difficulty IN ('BEGINNER', 'INTERMEDIATE', 'ADVANCED')),
  instructions TEXT[] DEFAULT '{}',
  tips TEXT[] DEFAULT '{}',
  animation_url TEXT,
  video_url TEXT,
  thumbnail_url TEXT,
  calories_per_minute DECIMAL(5,2),
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Exercises 인덱스
CREATE INDEX IF NOT EXISTS idx_exercises_name ON exercises(name);
CREATE INDEX IF NOT EXISTS idx_exercises_primary_muscle ON exercises(primary_muscle);
CREATE INDEX IF NOT EXISTS idx_exercises_category ON exercises(category);
CREATE INDEX IF NOT EXISTS idx_exercises_difficulty ON exercises(difficulty);

-- Exercises RLS (모든 사용자 읽기 가능)
ALTER TABLE exercises ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Exercises are viewable by everyone" ON exercises
  FOR SELECT USING (true);

-- ============================================
-- 3. PRESET_ROUTINES 테이블 (전문가 큐레이션 루틴)
-- ============================================
CREATE TABLE IF NOT EXISTS preset_routines (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  name_en TEXT,
  description TEXT,
  difficulty TEXT CHECK (difficulty IN ('BEGINNER', 'INTERMEDIATE', 'ADVANCED')),
  target_goal TEXT CHECK (target_goal IN ('STRENGTH', 'HYPERTROPHY', 'ENDURANCE', 'WEIGHT_LOSS')),
  days_per_week INTEGER NOT NULL CHECK (days_per_week >= 1 AND days_per_week <= 7),
  estimated_duration_minutes INTEGER,
  target_muscles TEXT[] DEFAULT '{}',
  equipment_required TEXT[] DEFAULT '{}',
  thumbnail_url TEXT,
  popularity_score INTEGER DEFAULT 0,
  is_featured BOOLEAN DEFAULT FALSE,
  is_active BOOLEAN DEFAULT TRUE,
  created_by TEXT DEFAULT 'V2log Team',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Preset Routines 인덱스
CREATE INDEX IF NOT EXISTS idx_preset_routines_difficulty ON preset_routines(difficulty);
CREATE INDEX IF NOT EXISTS idx_preset_routines_target_goal ON preset_routines(target_goal);
CREATE INDEX IF NOT EXISTS idx_preset_routines_is_featured ON preset_routines(is_featured);
CREATE INDEX IF NOT EXISTS idx_preset_routines_popularity ON preset_routines(popularity_score DESC);

-- Preset Routines RLS (모든 사용자 읽기 가능)
ALTER TABLE preset_routines ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Preset routines are viewable by everyone" ON preset_routines
  FOR SELECT USING (true);

-- ============================================
-- 4. PRESET_ROUTINE_EXERCISES 테이블 (프리셋-운동 연결)
-- ============================================
CREATE TABLE IF NOT EXISTS preset_routine_exercises (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  preset_routine_id UUID NOT NULL REFERENCES preset_routines(id) ON DELETE CASCADE,
  exercise_id UUID NOT NULL REFERENCES exercises(id) ON DELETE CASCADE,
  day_number INTEGER NOT NULL CHECK (day_number >= 1 AND day_number <= 7),
  day_name TEXT,
  order_index INTEGER NOT NULL,
  target_sets INTEGER DEFAULT 3,
  target_reps TEXT DEFAULT '10-12',
  rest_seconds INTEGER DEFAULT 90,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Preset Routine Exercises 인덱스
CREATE INDEX IF NOT EXISTS idx_preset_routine_exercises_routine
  ON preset_routine_exercises(preset_routine_id);
CREATE INDEX IF NOT EXISTS idx_preset_routine_exercises_day
  ON preset_routine_exercises(preset_routine_id, day_number);
CREATE INDEX IF NOT EXISTS idx_preset_routine_exercises_order
  ON preset_routine_exercises(preset_routine_id, day_number, order_index);

-- Preset Routine Exercises RLS
ALTER TABLE preset_routine_exercises ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Preset routine exercises are viewable by everyone" ON preset_routine_exercises
  FOR SELECT USING (true);

-- ============================================
-- 5. ROUTINES 테이블 (사용자 루틴)
-- ============================================
CREATE TABLE IF NOT EXISTS routines (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  source_type TEXT DEFAULT 'CUSTOM'
    CHECK (source_type IN ('PRESET', 'CUSTOM')),
  preset_routine_id UUID REFERENCES preset_routines(id) ON DELETE SET NULL,
  target_muscles TEXT[] DEFAULT '{}',
  estimated_duration INTEGER,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Routines 인덱스
CREATE INDEX IF NOT EXISTS idx_routines_user ON routines(user_id);
CREATE INDEX IF NOT EXISTS idx_routines_user_active ON routines(user_id, is_active);
CREATE INDEX IF NOT EXISTS idx_routines_source ON routines(source_type);

-- Routines RLS
ALTER TABLE routines ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own routines" ON routines
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own routines" ON routines
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own routines" ON routines
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own routines" ON routines
  FOR DELETE USING (auth.uid() = user_id);

-- ============================================
-- 6. ROUTINE_EXERCISES 테이블 (루틴-운동 연결)
-- ============================================
CREATE TABLE IF NOT EXISTS routine_exercises (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  routine_id UUID NOT NULL REFERENCES routines(id) ON DELETE CASCADE,
  exercise_id UUID NOT NULL REFERENCES exercises(id) ON DELETE CASCADE,
  order_index INTEGER NOT NULL,
  target_sets INTEGER DEFAULT 3,
  target_reps TEXT DEFAULT '10-12',
  target_weight DECIMAL(6,2),
  rest_seconds INTEGER DEFAULT 90,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Routine Exercises 인덱스
CREATE INDEX IF NOT EXISTS idx_routine_exercises_routine ON routine_exercises(routine_id);
CREATE INDEX IF NOT EXISTS idx_routine_exercises_order ON routine_exercises(routine_id, order_index);

-- Routine Exercises RLS
ALTER TABLE routine_exercises ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own routine exercises" ON routine_exercises
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM routines
      WHERE routines.id = routine_exercises.routine_id
      AND routines.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can insert own routine exercises" ON routine_exercises
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM routines
      WHERE routines.id = routine_exercises.routine_id
      AND routines.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can update own routine exercises" ON routine_exercises
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM routines
      WHERE routines.id = routine_exercises.routine_id
      AND routines.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can delete own routine exercises" ON routine_exercises
  FOR DELETE USING (
    EXISTS (
      SELECT 1 FROM routines
      WHERE routines.id = routine_exercises.routine_id
      AND routines.user_id = auth.uid()
    )
  );

-- ============================================
-- 7. WORKOUT_SESSIONS 테이블 (운동 세션)
-- ============================================
CREATE TABLE IF NOT EXISTS workout_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  routine_id UUID REFERENCES routines(id) ON DELETE SET NULL,
  session_number INTEGER DEFAULT 1,  -- 당일 회차 (하루 3회까지)
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

-- Workout Sessions 인덱스
CREATE INDEX IF NOT EXISTS idx_workout_sessions_user ON workout_sessions(user_id);
CREATE INDEX IF NOT EXISTS idx_workout_sessions_user_date
  ON workout_sessions(user_id, started_at DESC);
CREATE INDEX IF NOT EXISTS idx_workout_sessions_routine ON workout_sessions(routine_id);
CREATE INDEX IF NOT EXISTS idx_workout_sessions_date ON workout_sessions(started_at DESC);

-- Workout Sessions RLS
ALTER TABLE workout_sessions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own workout sessions" ON workout_sessions
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own workout sessions" ON workout_sessions
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own workout sessions" ON workout_sessions
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own workout sessions" ON workout_sessions
  FOR DELETE USING (auth.uid() = user_id);

-- ============================================
-- 8. WORKOUT_SETS 테이블 (세트 기록)
-- ============================================
CREATE TABLE IF NOT EXISTS workout_sets (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id UUID NOT NULL REFERENCES workout_sessions(id) ON DELETE CASCADE,
  exercise_id UUID NOT NULL REFERENCES exercises(id) ON DELETE CASCADE,
  set_number INTEGER NOT NULL,
  set_type TEXT DEFAULT 'WORKING'
    CHECK (set_type IN ('WARMUP', 'WORKING', 'DROP', 'FAILURE', 'SUPERSET')),
  weight DECIMAL(6,2),  -- kg
  reps INTEGER,
  target_weight DECIMAL(6,2),
  target_reps INTEGER,
  rpe DECIMAL(3,1) CHECK (rpe >= 1 AND rpe <= 10),  -- Rate of Perceived Exertion
  rest_seconds INTEGER,
  is_pr BOOLEAN DEFAULT FALSE,  -- Personal Record 여부
  notes TEXT,
  completed_at TIMESTAMPTZ DEFAULT NOW()
);

-- Workout Sets 인덱스
CREATE INDEX IF NOT EXISTS idx_workout_sets_session ON workout_sets(session_id);
CREATE INDEX IF NOT EXISTS idx_workout_sets_exercise ON workout_sets(exercise_id);
CREATE INDEX IF NOT EXISTS idx_workout_sets_session_order ON workout_sets(session_id, set_number);
CREATE INDEX IF NOT EXISTS idx_workout_sets_pr ON workout_sets(exercise_id, is_pr) WHERE is_pr = TRUE;

-- Workout Sets RLS
ALTER TABLE workout_sets ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own workout sets" ON workout_sets
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM workout_sessions
      WHERE workout_sessions.id = workout_sets.session_id
      AND workout_sessions.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can insert own workout sets" ON workout_sets
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM workout_sessions
      WHERE workout_sessions.id = workout_sets.session_id
      AND workout_sessions.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can update own workout sets" ON workout_sets
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM workout_sessions
      WHERE workout_sessions.id = workout_sets.session_id
      AND workout_sessions.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can delete own workout sets" ON workout_sets
  FOR DELETE USING (
    EXISTS (
      SELECT 1 FROM workout_sessions
      WHERE workout_sessions.id = workout_sets.session_id
      AND workout_sessions.user_id = auth.uid()
    )
  );

-- ============================================
-- 9. EXERCISE_RECORDS 테이블 (운동별 기록 집계 - 1RM 추적)
-- ============================================
CREATE TABLE IF NOT EXISTS exercise_records (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  exercise_id UUID NOT NULL REFERENCES exercises(id) ON DELETE CASCADE,
  estimated_1rm DECIMAL(6,2),  -- 추정 1RM
  max_weight DECIMAL(6,2),      -- 최대 중량
  max_reps INTEGER,             -- 최대 반복 횟수
  max_volume DECIMAL(10,2),     -- 최대 볼륨 (단일 세션)
  total_volume DECIMAL(12,2) DEFAULT 0,  -- 누적 총 볼륨
  total_sets INTEGER DEFAULT 0,  -- 누적 총 세트 수
  last_performed_at TIMESTAMPTZ,
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, exercise_id)
);

-- Exercise Records 인덱스
CREATE INDEX IF NOT EXISTS idx_exercise_records_user ON exercise_records(user_id);
CREATE INDEX IF NOT EXISTS idx_exercise_records_user_exercise
  ON exercise_records(user_id, exercise_id);
CREATE INDEX IF NOT EXISTS idx_exercise_records_1rm ON exercise_records(user_id, estimated_1rm DESC);

-- Exercise Records RLS
ALTER TABLE exercise_records ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own exercise records" ON exercise_records
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own exercise records" ON exercise_records
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own exercise records" ON exercise_records
  FOR UPDATE USING (auth.uid() = user_id);

-- ============================================
-- 10. BODY_RECORDS 테이블 (신체 기록)
-- ============================================
CREATE TABLE IF NOT EXISTS body_records (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  weight DECIMAL(5,2),          -- kg
  body_fat_percentage DECIMAL(4,2),  -- %
  muscle_mass DECIMAL(5,2),     -- kg
  chest DECIMAL(5,2),           -- cm (가슴둘레)
  waist DECIMAL(5,2),           -- cm (허리둘레)
  hip DECIMAL(5,2),             -- cm (엉덩이둘레)
  thigh DECIMAL(5,2),           -- cm (허벅지둘레)
  arm DECIMAL(5,2),             -- cm (팔둘레)
  notes TEXT,
  recorded_at DATE DEFAULT CURRENT_DATE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Body Records 인덱스
CREATE INDEX IF NOT EXISTS idx_body_records_user ON body_records(user_id);
CREATE INDEX IF NOT EXISTS idx_body_records_user_date
  ON body_records(user_id, recorded_at DESC);

-- Body Records RLS
ALTER TABLE body_records ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own body records" ON body_records
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own body records" ON body_records
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own body records" ON body_records
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own body records" ON body_records
  FOR DELETE USING (auth.uid() = user_id);

-- ============================================
-- FUNCTIONS & TRIGGERS
-- ============================================

-- updated_at 자동 업데이트 함수
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Users updated_at 트리거
CREATE TRIGGER update_users_updated_at
  BEFORE UPDATE ON users
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Preset Routines updated_at 트리거
CREATE TRIGGER update_preset_routines_updated_at
  BEFORE UPDATE ON preset_routines
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Routines updated_at 트리거
CREATE TRIGGER update_routines_updated_at
  BEFORE UPDATE ON routines
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Exercise Records updated_at 트리거
CREATE TRIGGER update_exercise_records_updated_at
  BEFORE UPDATE ON exercise_records
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- 새 사용자 자동 생성 함수 (Auth와 연동)
-- ============================================
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.users (id, email, nickname)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'nickname', split_part(NEW.email, '@', 1))
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Auth 트리거 (새 사용자 가입 시 users 테이블에 자동 추가)
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();

-- ============================================
-- 완료 메시지
-- ============================================
DO $$
BEGIN
  RAISE NOTICE '✅ V2log 데이터베이스 스키마 생성 완료!';
  RAISE NOTICE '테이블: users, exercises, preset_routines, preset_routine_exercises,';
  RAISE NOTICE '        routines, routine_exercises, workout_sessions, workout_sets,';
  RAISE NOTICE '        exercise_records, body_records';
END $$;
