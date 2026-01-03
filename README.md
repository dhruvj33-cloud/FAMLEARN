# FamLearn Pro - AI-Powered Family Learning Platform

An advanced educational quiz application with Supabase integration, AI-powered quiz generation, and gamification features.

## Features

- **Supabase Integration**: Authentication, database, and storage
- **AI Quiz Generation**: GROQ-powered question generation from textbook images
- **Dual Roles**: Student and Tutor interfaces
- **Batch Management**: Tutors can create batches and assign quizzes
- **Gamification**: Streaks, daily challenges, milestones, and leaderboards
- **Quiz Sharing**: Share quizzes with unique codes
- **Analytics**: Detailed performance tracking and insights
- **Virtual Wallet**: Points and rewards system

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

### 3. Configure the Application

Open the application in your browser and set your API keys in the browser console:

```javascript
localStorage.setItem('SUPABASE_URL', 'https://your-project.supabase.co');
localStorage.setItem('SUPABASE_KEY', 'your-supabase-anon-key');
localStorage.setItem('GROQ_API_KEY', 'your-groq-api-key');
```

Then refresh the page.

### 4. Run the Application

Simply open `index.html` in your browser or deploy to any static hosting service (Netlify, Vercel, GitHub Pages, etc.)

## Database Schema

Refer to the Supabase dashboard to set up the required tables. The application expects specific columns for each table based on the integration points in the code.

## Security Notes

- API keys are stored in browser localStorage (not committed to Git)
- Supabase Row Level Security (RLS) should be enabled on all tables
- The anon key is safe for client-side use when RLS is properly configured

## Technologies Used

- HTML5, CSS3, JavaScript (Vanilla)
- Supabase (Database, Auth, Storage)
- GROQ AI API
- Chart.js (Analytics)
- KaTeX (Math equation rendering)

## License

MIT
