# FamLearn Pro - AI-Powered Family Learning Platform

An advanced educational quiz application with Supabase integration, AI-powered quiz generation, and gamification features.

## Features

- **💳 Subscription System**: 3-day free trial + 3 paid tiers with Razorpay payments
- **📧 Email OTP Verification**: Secure registration with Brevo email verification
- **🔐 Supabase Integration**: Authentication, database, and storage
- **🤖 AI Quiz Generation**: GROQ-powered question generation from textbook images
- **👥 Dual Roles**: Student and Tutor interfaces
- **📚 Batch Management**: Tutors can create batches and assign quizzes
- **⚡ 50/50 Lifeline**: Eliminate 2 wrong answers (paid plans only)
- **🎮 Gamification**: Streaks, daily challenges, milestones, and leaderboards
- **🔗 Quiz Sharing**: Share quizzes with unique codes
- **📊 Analytics**: Detailed performance tracking and insights (paid plans)
- **💰 Virtual Wallet**: Points and rewards system

## Setup Instructions

### 1. Supabase Setup

1. Create a project at [supabase.com](https://supabase.com)
2. Get your **Project URL** and **Anon Key** from Project Settings → API
3. Create the following tables in your Supabase database:
   - `users`
   - `quiz_results`
   - `shared_quizzes`
   - `batches`
   - `batch_students`
   - `quiz_assignments`
   - `saved_quizzes`
   - `daily_challenges`
   - `streak_history`
   - `milestones`
   - `user_milestones`

4. Create a storage bucket named `quiz-images` (public)

### 2. GROQ API Setup

1. Get your API key from [console.groq.com](https://console.groq.com)

### 3. Brevo Email API Setup (for OTP Verification)

1. Create a free account at [brevo.com](https://www.brevo.com)
2. Verify your sender email address in Brevo dashboard
3. Get your API key from Settings → API Keys
4. Copy your API key (starts with `xkeysib-...`)

### 4. Razorpay Payment Gateway (for Subscriptions)

1. Create an account at [razorpay.com](https://razorpay.com)
2. Use **Test Mode** for development (no KYC required)
3. Get your Test Key ID from Dashboard → Settings → API Keys
4. For production, complete KYC and switch to Live Mode

### 5. Subscription Database Setup

Run the complete database schema:

```bash
# Open Supabase SQL Editor and run:
DATABASE_SUBSCRIPTION_SCHEMA.sql
```

This creates:
- Subscription columns in users table
- subscription_transactions table
- lifeline_usage table
- subscription_tiers reference table
- Automated reset functions

📖 **See [SUBSCRIPTION_SETUP_GUIDE.md](SUBSCRIPTION_SETUP_GUIDE.md) for detailed setup instructions**

### 6. Configure the Application

Open the application in your browser and set your API keys in the browser console:

```javascript
localStorage.setItem('SUPABASE_URL', 'https://your-project.supabase.co');
localStorage.setItem('SUPABASE_KEY', 'your-supabase-anon-key');
localStorage.setItem('GROQ_API_KEY', 'your-groq-api-key');
localStorage.setItem('BREVO_API_KEY', 'your-brevo-api-key');
localStorage.setItem('BREVO_SENDER_EMAIL', 'your-verified-email@example.com');
localStorage.setItem('BREVO_SENDER_NAME', 'FamLearn Pro');
localStorage.setItem('RAZORPAY_KEY_ID', 'rzp_test_XXXXXXXXXXXX');
```

Then refresh the page.

### 7. Run the Application

Simply open `index.html` in your browser or deploy to any static hosting service (Netlify, Vercel, GitHub Pages, etc.)

## Subscription Tiers

### Free Trial (3 Days)
- 2 quizzes per day, 5 total
- Store up to 5 quizzes
- No lifelines, analytics, or leaderboard

### Learner - ₹149/month
- 3 quizzes per day, 25 per month
- Store up to 25 quizzes
- 2 lifelines per quiz (50/50)
- Full analytics and leaderboard access

### Pro Student - ₹299/month
- 5 quizzes per day, unlimited per month
- Store up to 50 quizzes
- All Learner features + Priority support

### Pro Tutor - ₹1,499/quarter or ₹4,999/year
- 5 quizzes per day, unlimited per month
- Batch management and student tracking
- Quiz assignments and analytics
- Save 17% on annual plan

## Database Schema

Refer to the Supabase dashboard to set up the required tables. The application expects specific columns for each table based on the integration points in the code.

## Security Notes

- API keys are stored in browser localStorage (not committed to Git)
- Supabase Row Level Security (RLS) should be enabled on all tables
- The anon key is safe for client-side use when RLS is properly configured

## Technologies Used

- HTML5, CSS3, JavaScript (Vanilla)
- Supabase (Database, Auth, Storage)
- Razorpay (Payment Gateway)
- Brevo (Transactional Email & OTP Verification)
- GROQ AI API (Quiz Generation)
- Chart.js (Analytics)
- KaTeX (Math equation rendering)

## License

MIT
