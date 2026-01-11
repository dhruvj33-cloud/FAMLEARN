-- ========================================
-- Migration: Add Grade Column to Users Table
-- ========================================
-- Purpose: Add grade field to support grade-based block system
-- Run this in Supabase SQL Editor ONCE
-- ========================================

-- Add the grade column to the users table
ALTER TABLE users
ADD COLUMN IF NOT EXISTS grade INTEGER;

-- Add comment to document the column
COMMENT ON COLUMN users.grade IS 'Student grade/class (5-12). Determines subject options and quiz blocks.';

-- Add check constraint to ensure valid grade values
ALTER TABLE users
ADD CONSTRAINT users_grade_check
CHECK (grade IS NULL OR (grade >= 5 AND grade <= 12));

-- ========================================
-- VERIFICATION QUERIES
-- ========================================
-- Run these queries to verify the migration was successful

-- 1. Check if column was added
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'users'
  AND column_name = 'grade';

-- Expected output:
-- grade | integer | YES

-- 2. Check constraints
SELECT conname, pg_get_constraintdef(oid) as constraint_def
FROM pg_constraint
WHERE conrelid = 'users'::regclass
  AND conname = 'users_grade_check';

-- Expected output:
-- users_grade_check | CHECK ((grade IS NULL OR (grade >= 5 AND grade <= 12)))

-- 3. Check sample data (should show NULL for existing users)
SELECT id, name, email, grade
FROM users
LIMIT 5;

-- ========================================
-- NOTES
-- ========================================
-- 1. Column is nullable (NULL) so existing users won't be affected
-- 2. New registrations will automatically populate this field
-- 3. Valid grade values: 5, 6, 7, 8, 9, 10, 11, 12
-- 4. Grade determines:
--    - Which subject options are shown
--    - Which block system is used (Grades 5-8, 9-10, or 11-12)
--    - AI quiz generation blocks
-- 5. Existing users can update their grade later
-- 6. If you want to add an index for filtering:
--    CREATE INDEX idx_users_grade ON users(grade);
