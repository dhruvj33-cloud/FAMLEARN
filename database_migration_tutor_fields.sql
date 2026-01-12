-- Database Migration: Add Institute Fields for Tutors
-- Date: 2026-01-12
-- Purpose: Add institute_name and institute_type columns for tutor users

-- Add new columns to users table
ALTER TABLE users
ADD COLUMN IF NOT EXISTS institute_name TEXT,
ADD COLUMN IF NOT EXISTS institute_type TEXT;

-- Add column comments for documentation
COMMENT ON COLUMN users.institute_name IS 'Name of institute for tutors (e.g., ABC Coaching Center, XYZ Tuition)';
COMMENT ON COLUMN users.institute_type IS 'Type of institute: School, Coaching Institute, or Tuition';

-- Verify the columns were added
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_name = 'users'
AND column_name IN ('institute_name', 'institute_type');

-- Optional: Update existing tutor records if needed
-- UPDATE users
-- SET institute_name = school_name
-- WHERE role = 'tutor' AND institute_name IS NULL AND school_name IS NOT NULL;
