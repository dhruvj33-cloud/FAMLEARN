-- Migration Script: Fix Existing Users Without Subscription Fields
-- Run this ONCE in your Supabase SQL Editor to fix all existing users at once
--
-- This script:
-- 1. Sets trial dates for users missing them (3 days from their registration)
-- 2. Initializes quiz counters to 0
-- 3. Sets subscription status based on trial expiry
--
-- NOTE: The app will also auto-fix users when they log in, but this script
-- fixes everyone immediately without waiting for them to log in.

-- Fix existing users missing subscription fields
UPDATE users
SET
    subscription_tier = COALESCE(subscription_tier, 'free'),
    trial_start_date = COALESCE(trial_start_date, created_at, NOW()),
    trial_end_date = COALESCE(trial_end_date, created_at + INTERVAL '3 days', NOW() + INTERVAL '3 days'),
    subscription_status = CASE
        WHEN trial_end_date IS NULL THEN
            CASE
                WHEN (created_at + INTERVAL '3 days') > NOW() THEN 'trial'
                ELSE 'expired'
            END
        WHEN trial_end_date > NOW() THEN 'trial'
        ELSE 'expired'
    END,
    quizzes_created_today = COALESCE(quizzes_created_today, 0),
    quizzes_created_this_month = COALESCE(quizzes_created_this_month, 0),
    quiz_library_count = COALESCE(quiz_library_count, 0),
    last_quiz_creation_date = COALESCE(last_quiz_creation_date, NULL),
    monthly_reset_date = COALESCE(monthly_reset_date, NOW())
WHERE
    subscription_tier IS NULL
    OR trial_end_date IS NULL
    OR quizzes_created_today IS NULL
    OR quizzes_created_this_month IS NULL;

-- Verify the migration
SELECT
    COUNT(*) as total_users,
    COUNT(CASE WHEN subscription_tier IS NOT NULL THEN 1 END) as users_with_tier,
    COUNT(CASE WHEN trial_end_date IS NOT NULL THEN 1 END) as users_with_trial_date,
    COUNT(CASE WHEN subscription_status = 'trial' THEN 1 END) as active_trials,
    COUNT(CASE WHEN subscription_status = 'expired' THEN 1 END) as expired_trials
FROM users;

-- Show sample of updated users
SELECT
    id,
    name,
    email,
    subscription_tier,
    subscription_status,
    trial_start_date,
    trial_end_date,
    quizzes_created_today,
    quizzes_created_this_month
FROM users
LIMIT 10;
