-- ========================================
-- Migration: Add Location Fields to Users Table
-- ========================================
-- Purpose: Add school_name, city, and town fields to the users table
-- Run this in Supabase SQL Editor ONCE
-- ========================================

-- Add the new columns to the users table
ALTER TABLE users
ADD COLUMN IF NOT EXISTS school_name TEXT,
ADD COLUMN IF NOT EXISTS city TEXT,
ADD COLUMN IF NOT EXISTS town TEXT;

-- Add comments to document the columns
COMMENT ON COLUMN users.school_name IS 'Name of the school/institution the student attends';
COMMENT ON COLUMN users.city IS 'City where the user is located';
COMMENT ON COLUMN users.town IS 'Town/Area/Locality where the user is located';

-- ========================================
-- VERIFICATION QUERIES
-- ========================================
-- Run these queries to verify the migration was successful

-- 1. Check if columns were added
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'users'
  AND column_name IN ('school_name', 'city', 'town')
ORDER BY column_name;

-- Expected output:
-- school_name | text | YES
-- city        | text | YES
-- town        | text | YES

-- 2. Check sample data (should show NULL for existing users)
SELECT id, name, email, school_name, city, town
FROM users
LIMIT 5;

-- ========================================
-- NOTES
-- ========================================
-- 1. These columns are nullable (NULL) so existing users won't be affected
-- 2. New registrations will automatically populate these fields
-- 3. Existing users will have NULL values until they update their profile
-- 4. You can optionally add indexes if you plan to filter/search by location:
--    CREATE INDEX idx_users_city ON users(city);
--    CREATE INDEX idx_users_school ON users(school_name);
