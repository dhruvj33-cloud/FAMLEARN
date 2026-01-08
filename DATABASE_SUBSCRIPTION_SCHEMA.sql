-- FamLearn Pro Subscription System - Database Schema
-- Run these SQL commands in your Supabase SQL Editor

-- ====================================
-- 1. ADD SUBSCRIPTION COLUMNS TO USERS TABLE
-- ====================================

ALTER TABLE users ADD COLUMN IF NOT EXISTS subscription_tier VARCHAR(20) DEFAULT 'free';
ALTER TABLE users ADD COLUMN IF NOT EXISTS subscription_status VARCHAR(20) DEFAULT 'trial';
ALTER TABLE users ADD COLUMN IF NOT EXISTS trial_start_date TIMESTAMP DEFAULT NOW();
ALTER TABLE users ADD COLUMN IF NOT EXISTS trial_end_date TIMESTAMP;
ALTER TABLE users ADD COLUMN IF NOT EXISTS subscription_start_date TIMESTAMP;
ALTER TABLE users ADD COLUMN IF NOT EXISTS subscription_end_date TIMESTAMP;
ALTER TABLE users ADD COLUMN IF NOT EXISTS grace_period_end_date TIMESTAMP;

-- Quiz creation tracking columns
ALTER TABLE users ADD COLUMN IF NOT EXISTS quizzes_created_today INT DEFAULT 0;
ALTER TABLE users ADD COLUMN IF NOT EXISTS quizzes_created_this_month INT DEFAULT 0;
ALTER TABLE users ADD COLUMN IF NOT EXISTS last_quiz_creation_date DATE;
ALTER TABLE users ADD COLUMN IF NOT EXISTS monthly_reset_date TIMESTAMP;

-- Library tracking
ALTER TABLE users ADD COLUMN IF NOT EXISTS quiz_library_count INT DEFAULT 0;

-- Account status
ALTER TABLE users ADD COLUMN IF NOT EXISTS account_status VARCHAR(20) DEFAULT 'active';


-- ====================================
-- 2. CREATE SUBSCRIPTION TRANSACTIONS TABLE
-- ====================================

CREATE TABLE IF NOT EXISTS subscription_transactions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    tier VARCHAR(20) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'INR',
    payment_id VARCHAR(100),
    payment_method VARCHAR(50),
    payment_status VARCHAR(20) DEFAULT 'pending',
    razorpay_order_id VARCHAR(100),
    razorpay_payment_id VARCHAR(100),
    razorpay_signature VARCHAR(255),
    subscription_period_start TIMESTAMP,
    subscription_period_end TIMESTAMP,
    is_renewal BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_transactions_user_id ON subscription_transactions(user_id);
CREATE INDEX IF NOT EXISTS idx_transactions_payment_id ON subscription_transactions(payment_id);


-- ====================================
-- 3. CREATE LIFELINE USAGE TABLE
-- ====================================

CREATE TABLE IF NOT EXISTS lifeline_usage (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    quiz_id UUID REFERENCES quiz_results(id) ON DELETE CASCADE,
    lifeline_type VARCHAR(20) DEFAULT 'fifty_fifty',
    question_index INT NOT NULL,
    used_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_lifeline_user_quiz ON lifeline_usage(user_id, quiz_id);


-- ====================================
-- 4. SUBSCRIPTION TIER PRICING REFERENCE
-- ====================================

-- This is for reference only - actual limits are handled in the application
-- But you can create a tiers table if you want to manage this in the database

CREATE TABLE IF NOT EXISTS subscription_tiers (
    tier_code VARCHAR(20) PRIMARY KEY,
    tier_name VARCHAR(50) NOT NULL,
    monthly_price DECIMAL(10, 2),
    quarterly_price DECIMAL(10, 2),
    yearly_price DECIMAL(10, 2),
    daily_quiz_limit INT,
    monthly_quiz_limit INT,
    library_limit INT,
    features JSONB,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Insert tier configurations
INSERT INTO subscription_tiers (tier_code, tier_name, monthly_price, quarterly_price, yearly_price, daily_quiz_limit, monthly_quiz_limit, library_limit, features) VALUES
('free', 'Free Trial', 0, 0, 0, 2, 5, 5, '{"trial_days": 3, "lifelines": 2, "analytics": false, "leaderboard": false, "explanations": false}'),
('learner', 'Learner', 149, NULL, NULL, 3, 25, 25, '{"lifelines": 2, "analytics": true, "leaderboard": true, "explanations": true}'),
('pro_student', 'Pro Student', 299, NULL, NULL, 5, 999999, 50, '{"lifelines": 2, "analytics": true, "leaderboard": true, "explanations": true, "priority_support": true}'),
('pro_tutor', 'Pro Tutor', NULL, 1499, 4999, 5, 999999, 25, '{"lifelines": 2, "analytics": true, "leaderboard": true, "explanations": true, "batch_management": true, "priority_support": true}')
ON CONFLICT (tier_code) DO NOTHING;


-- ====================================
-- 5. ROW LEVEL SECURITY (RLS) POLICIES
-- ====================================

-- Enable RLS on new tables
ALTER TABLE subscription_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE lifeline_usage ENABLE ROW LEVEL SECURITY;
ALTER TABLE subscription_tiers ENABLE ROW LEVEL SECURITY;

-- Transactions: Users can only see their own transactions
CREATE POLICY "Users can view own transactions" ON subscription_transactions
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "System can insert transactions" ON subscription_transactions
    FOR INSERT WITH CHECK (true);

-- Lifeline usage: Users can view and insert their own
CREATE POLICY "Users can view own lifeline usage" ON lifeline_usage
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own lifeline usage" ON lifeline_usage
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Tiers: Everyone can read tier information
CREATE POLICY "Anyone can view tier information" ON subscription_tiers
    FOR SELECT USING (true);


-- ====================================
-- 6. FUNCTIONS FOR AUTOMATED TASKS
-- ====================================

-- Function to reset daily quiz counts at midnight
CREATE OR REPLACE FUNCTION reset_daily_quiz_counts()
RETURNS void AS $$
BEGIN
    UPDATE users
    SET quizzes_created_today = 0
    WHERE last_quiz_creation_date < CURRENT_DATE;
END;
$$ LANGUAGE plpgsql;

-- Function to reset monthly quiz counts
CREATE OR REPLACE FUNCTION reset_monthly_quiz_counts()
RETURNS void AS $$
BEGIN
    UPDATE users
    SET quizzes_created_this_month = 0,
        monthly_reset_date = NOW()
    WHERE monthly_reset_date < date_trunc('month', NOW());
END;
$$ LANGUAGE plpgsql;

-- Function to check and expire subscriptions
CREATE OR REPLACE FUNCTION expire_subscriptions()
RETURNS void AS $$
BEGIN
    -- Mark subscriptions as expired
    UPDATE users
    SET subscription_status = 'expired'
    WHERE subscription_end_date < NOW()
    AND subscription_status = 'active';

    -- Also check trial expiry
    UPDATE users
    SET subscription_status = 'expired'
    WHERE trial_end_date < NOW()
    AND subscription_status = 'trial'
    AND subscription_tier = 'free';
END;
$$ LANGUAGE plpgsql;


-- ====================================
-- 7. SETUP CRON JOBS (if using pg_cron extension)
-- ====================================

-- Note: You need to enable pg_cron extension in Supabase
-- Go to Database → Extensions → Enable pg_cron

-- Reset daily counts at midnight
-- SELECT cron.schedule('reset-daily-quiz-counts', '0 0 * * *', 'SELECT reset_daily_quiz_counts();');

-- Reset monthly counts on 1st of each month
-- SELECT cron.schedule('reset-monthly-quiz-counts', '0 0 1 * *', 'SELECT reset_monthly_quiz_counts();');

-- Check for expired subscriptions every hour
-- SELECT cron.schedule('expire-subscriptions', '0 * * * *', 'SELECT expire_subscriptions();');


-- ====================================
-- 8. MIGRATION SCRIPT FOR EXISTING USERS
-- ====================================

-- Set trial end date for existing users (3 days from their registration)
UPDATE users
SET
    trial_start_date = created_at,
    trial_end_date = created_at + INTERVAL '3 days',
    subscription_tier = 'free',
    subscription_status = CASE
        WHEN created_at + INTERVAL '3 days' > NOW() THEN 'trial'
        ELSE 'expired'
    END
WHERE trial_start_date IS NULL;


-- ====================================
-- VERIFICATION QUERIES
-- ====================================

-- Check if columns were added
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'users'
AND column_name LIKE '%subscription%' OR column_name LIKE '%quiz%' OR column_name LIKE '%trial%';

-- Check if tables were created
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
AND table_name IN ('subscription_transactions', 'lifeline_usage', 'subscription_tiers');

-- View tier configurations
SELECT * FROM subscription_tiers;

-- Check user subscription status
SELECT
    id,
    name,
    email,
    subscription_tier,
    subscription_status,
    trial_end_date,
    subscription_end_date,
    quizzes_created_today,
    quizzes_created_this_month
FROM users
LIMIT 10;
