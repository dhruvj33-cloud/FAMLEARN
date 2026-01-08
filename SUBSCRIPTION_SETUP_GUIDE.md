# FamLearn Pro - Subscription System Setup Guide

Complete guide to setting up and testing the subscription system with 3-day free trial and paid tiers.

---

## 📋 Table of Contents

1. [Database Setup](#1-database-setup)
2. [Razorpay Configuration](#2-razorpay-configuration)
3. [Testing the System](#3-testing-the-system)
4. [Subscription Tiers Overview](#4-subscription-tiers-overview)
5. [Email Automation Setup](#5-email-automation-setup)
6. [Troubleshooting](#6-troubleshooting)

---

## 1. Database Setup

### Step 1.1: Run Database Schema

Open your **Supabase SQL Editor** and run the entire `DATABASE_SUBSCRIPTION_SCHEMA.sql` file:

```bash
# The file contains:
- New columns for users table (subscription_tier, trial dates, quotas)
- subscription_transactions table
- lifeline_usage table
- subscription_tiers reference table
- RLS policies
- Helper functions for daily/monthly resets
```

**Important Tables Added:**
- `subscription_transactions` - Payment records
- `lifeline_usage` - Track 50/50 lifeline usage
- `subscription_tiers` - Pricing and limits reference

### Step 1.2: Verify Database

Run this query to confirm setup:

```sql
-- Check if new columns exist
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'users'
AND (column_name LIKE '%subscription%'
     OR column_name LIKE '%trial%'
     OR column_name LIKE '%quiz%');

-- Should return: subscription_tier, subscription_status, trial_start_date,
-- trial_end_date, quizzes_created_today, quizzes_created_this_month, etc.
```

### Step 1.3: Migrate Existing Users

All existing users will automatically get a 3-day trial. Run this to set their trial dates:

```sql
UPDATE users
SET
    trial_start_date = created_at,
    trial_end_date = created_at + INTERVAL '3 days',
    subscription_tier = 'free',
    subscription_status = CASE
        WHEN created_at + INTERVAL '3 days' > NOW() THEN 'trial'
        ELSE 'expired'
    END,
    quizzes_created_today = 0,
    quizzes_created_this_month = 0,
    quiz_library_count = 0
WHERE trial_start_date IS NULL;
```

---

## 2. Razorpay Configuration

### Step 2.1: Create Razorpay Account

1. Go to [razorpay.com](https://razorpay.com) and sign up
2. Complete KYC verification (required for live mode)
3. For testing, use **Test Mode** (no KYC needed)

### Step 2.2: Get API Keys

1. Dashboard → Settings → API Keys
2. Generate **Test Keys** first:
   - Key ID: `rzp_test_XXXXXXXXXXXX`
   - Key Secret: `XXXXXXXXXXXXXXXX` (keep this secure!)

### Step 2.3: Configure in Browser

Open your FamLearn app and set the Razorpay key in browser console (F12):

```javascript
localStorage.setItem('RAZORPAY_KEY_ID', 'rzp_test_XXXXXXXXXXXX');
console.log('✅ Razorpay configured!');
```

Then refresh the page (F5).

### Step 2.4: Test Payment Flow

**Test Card Details** (provided by Razorpay):
```
Card Number: 4111 1111 1111 1111
Expiry: Any future date
CVV: Any 3 digits
Name: Any name
```

**Test UPI ID**: `success@razorpay`

### Step 2.5: Enable Webhooks (Optional)

For automatic subscription upgrades without manual confirmation:

1. Dashboard → Webhooks → Add Webhook
2. URL: `https://your-domain.com/api/razorpay-webhook`
3. Secret: Generate and save
4. Events: Select `payment.captured`

---

## 3. Testing the System

### Test 1: New User Registration

1. **Register** a new account
2. **Verify**: User should have:
   - `subscription_tier = 'free'`
   - `subscription_status = 'trial'`
   - `trial_end_date = NOW() + 3 days`
   - Can create 2 quizzes per day, 5 total

**SQL Check:**
```sql
SELECT name, email, subscription_tier, subscription_status,
       trial_end_date, quizzes_created_today, quizzes_created_this_month
FROM users
WHERE email = 'test@example.com';
```

### Test 2: Quiz Creation Limits

1. **Create 2 quizzes** as a free user
2. **Try 3rd quiz** → Should show upgrade modal
3. **Check database**:
```sql
SELECT quizzes_created_today, quizzes_created_this_month
FROM users WHERE email = 'test@example.com';
-- Should show: 2, 2
```

### Test 3: 50/50 Lifeline

1. **Start a quiz** as a paid user (change tier in DB temporarily)
2. **Click ⚡ 50/50 button** → Should eliminate 2 wrong answers
3. **Use it twice** → 3rd time should be disabled
4. **Check database**:
```sql
SELECT * FROM lifeline_usage WHERE user_id = 'YOUR_USER_ID';
-- Should show 2 records
```

### Test 4: Student Lockout (Expired)

1. **Expire a student's trial**:
```sql
UPDATE users
SET trial_end_date = NOW() - INTERVAL '1 day',
    subscription_status = 'expired'
WHERE email = 'student@example.com';
```
2. **Login** as that student
3. **Go to Quiz History** → Should only show last 3 quizzes
4. **Try to access Analytics** → Should show upgrade modal

### Test 5: Payment Flow

1. **Go to Pricing page** (💎 Upgrade Plan in sidebar)
2. **Click "Upgrade Now"** on Learner plan
3. **Complete payment** with test card
4. **Verify upgrade**:
```sql
SELECT subscription_tier, subscription_status, subscription_end_date
FROM users WHERE email = 'test@example.com';
-- Should show: learner, active, NOW() + 1 month
```

### Test 6: Grace Period (Students Only)

1. **Expire a student's subscription**:
```sql
UPDATE users
SET subscription_end_date = NOW() - INTERVAL '1 day',
    grace_period_end_date = NOW() + INTERVAL '2 days',
    subscription_status = 'expired'
WHERE email = 'student@example.com';
```
2. **Login** → Student should still have access
3. **Check banner** → Should show grace period warning

---

## 4. Subscription Tiers Overview

### Free Trial (3 Days)
- **Duration**: 3 days from registration
- **Daily Limit**: 2 quizzes
- **Monthly Limit**: 5 quizzes total
- **Library**: Store up to 5 quizzes
- **Lifelines**: ❌ No access
- **Analytics**: ❌ No access
- **Leaderboard**: ❌ No access
- **After Expiry**: Students see last 3 quizzes only

### Learner - ₹149/month
- **Daily Limit**: 3 quizzes
- **Monthly Limit**: 25 quizzes
- **Library**: Store up to 25 quizzes
- **Lifelines**: ✅ 2 per quiz (50/50)
- **Analytics**: ✅ Full access
- **Leaderboard**: ✅ Full access
- **Explanations**: ✅ View answer explanations

### Pro Student - ₹299/month
- **Daily Limit**: 5 quizzes
- **Monthly Limit**: ✅ Unlimited
- **Library**: Store up to 50 quizzes
- **Lifelines**: ✅ 2 per quiz
- **Analytics**: ✅ Full access
- **Leaderboard**: ✅ Full access
- **Priority Support**: ✅ Yes

### Pro Tutor - ₹1,499/quarter or ₹4,999/year
- **Daily Limit**: 5 quizzes
- **Monthly Limit**: ✅ Unlimited
- **Library**: Store up to 25 quizzes
- **Batch Management**: ✅ Yes
- **Quiz Assignments**: ✅ Yes
- **Student Tracking**: ✅ Yes
- **Priority Support**: ✅ Yes
- **Save**: 17% on annual plan

---

## 5. Email Automation Setup

### Option 1: Manual Emails (Quick Start)

Send emails manually using Brevo's dashboard for:
- Trial expiring in 3 days
- Trial expiring in 1 day
- Trial expired
- Subscription expiring in 7 days

### Option 2: Automated Sequences (Recommended)

#### Setup in Brevo Automation:

**Sequence 1: Trial Expiry (Free Users)**
```
Day -3: "Your trial ends in 3 days! 🎯"
Day -1: "Last day of your trial! ⚡"
Day 0:  "Trial expired - Upgrade to continue 💎"
Day +3: "Miss us? Get 20% off! 🎁"
```

**Sequence 2: Subscription Expiry (Paid Users)**
```
Day -7: "Subscription renewal coming up 📅"
Day -3: "Your subscription ends in 3 days ⏰"
Day -1: "Last chance to renew! 🚨"
Day 0:  "Subscription expired - Reactivate now"
Day +7: "Come back! Special offer inside 🎉"
```

**Sequence 3: Tutor Urgent Alerts**
```
Day 0: "⚠️ URGENT: Your students can't access quizzes!"
Day +1: "Action needed: Renew to restore student access"
Day +3: "Final reminder: Students waiting for your renewal"
```

#### Implementation:

1. **Brevo Dashboard** → Automation → Create Workflow
2. **Trigger**: Tag users based on `subscription_status` and `subscription_end_date`
3. **Add email templates** with personalization:
   - `{{ contact.NAME }}`
   - `{{ contact.SUBSCRIPTION_TIER }}`
   - `{{ contact.DAYS_REMAINING }}`

---

## 6. Troubleshooting

### Issue: "Payment system not configured"

**Cause**: Razorpay key not set
**Fix**:
```javascript
localStorage.setItem('RAZORPAY_KEY_ID', 'YOUR_KEY_HERE');
location.reload();
```

### Issue: User can't create quizzes

**Check**:
```sql
SELECT subscription_tier, subscription_status,
       trial_end_date, subscription_end_date,
       quizzes_created_today, quizzes_created_this_month
FROM users WHERE id = 'USER_ID';
```

**Fix**: If expired, upgrade manually:
```sql
UPDATE users
SET subscription_tier = 'learner',
    subscription_status = 'active',
    subscription_end_date = NOW() + INTERVAL '1 month',
    quizzes_created_today = 0,
    quizzes_created_this_month = 0
WHERE id = 'USER_ID';
```

### Issue: Daily/Monthly counters not resetting

**Manual Reset**:
```sql
-- Reset daily (run daily at midnight)
UPDATE users
SET quizzes_created_today = 0
WHERE last_quiz_creation_date < CURRENT_DATE;

-- Reset monthly (run on 1st of month)
UPDATE users
SET quizzes_created_this_month = 0,
    monthly_reset_date = NOW()
WHERE monthly_reset_date < date_trunc('month', NOW());
```

**Automated Reset** (if pg_cron enabled):
```sql
SELECT cron.schedule('reset-daily', '0 0 * * *', 'SELECT reset_daily_quiz_counts();');
SELECT cron.schedule('reset-monthly', '0 0 1 * *', 'SELECT reset_monthly_quiz_counts();');
```

### Issue: Student can't see quiz history

**Check Lockout**:
```sql
SELECT subscription_tier, subscription_status,
       grace_period_end_date
FROM users WHERE id = 'STUDENT_ID';
```

If expired without grace:
- Should only see last 3 quizzes
- This is intentional behavior
- Prompt to upgrade to see all history

### Issue: Lifelines not working

**Check**:
1. User must be on paid plan (not free)
2. Maximum 2 uses per quiz
3. Can't use after answering a question

**Debug**:
```sql
-- Check lifeline availability
SELECT subscription_tier,
       (SELECT COUNT(*) FROM lifeline_usage WHERE user_id = users.id AND quiz_id = 'QUIZ_ID') as used
FROM users WHERE id = 'USER_ID';
```

---

## 🚀 Production Checklist

Before going live:

- [ ] Run complete database schema in production Supabase
- [ ] Switch Razorpay from Test to Live mode (complete KYC)
- [ ] Update Razorpay key to live key (`rzp_live_XXXX`)
- [ ] Enable Row Level Security (RLS) on all tables
- [ ] Set up Razorpay webhooks for automatic upgrades
- [ ] Configure Brevo email automation sequences
- [ ] Test complete payment flow with real payment
- [ ] Set up daily/monthly cron jobs for counter resets
- [ ] Create backup strategy for transactions table
- [ ] Add monitoring for payment failures
- [ ] Document refund process
- [ ] Create admin panel for manual subscription management

---

## 📊 Monitoring Queries

### Active Subscriptions by Tier
```sql
SELECT subscription_tier, COUNT(*) as users
FROM users
WHERE subscription_status = 'active'
GROUP BY subscription_tier;
```

### Trial Conversions
```sql
SELECT
    COUNT(CASE WHEN subscription_tier = 'free' THEN 1 END) as trials,
    COUNT(CASE WHEN subscription_tier != 'free' THEN 1 END) as paid,
    ROUND(COUNT(CASE WHEN subscription_tier != 'free' THEN 1 END)::NUMERIC / COUNT(*)::NUMERIC * 100, 2) as conversion_rate
FROM users;
```

### Revenue Summary
```sql
SELECT
    tier,
    COUNT(*) as transactions,
    SUM(amount) as total_revenue
FROM subscription_transactions
WHERE payment_status = 'completed'
AND created_at >= NOW() - INTERVAL '30 days'
GROUP BY tier;
```

### Expiring Soon (Next 7 Days)
```sql
SELECT name, email, subscription_tier, subscription_end_date
FROM users
WHERE subscription_end_date BETWEEN NOW() AND NOW() + INTERVAL '7 days'
AND subscription_status = 'active'
ORDER BY subscription_end_date;
```

---

## 🆘 Support

For issues or questions:
- Check Supabase logs for database errors
- Check browser console for JavaScript errors
- Check Razorpay dashboard for payment logs
- Check Brevo dashboard for email delivery status

**Common Support Requests:**
1. "I paid but not upgraded" → Check subscription_transactions table
2. "Can't create quiz" → Check quota limits
3. "Trial expired too soon" → Check trial_end_date field
4. "Lifelines not showing" → Check subscription_tier

---

**System Status**: ✅ Fully Implemented and Ready for Production

Last Updated: 2026-01-08
