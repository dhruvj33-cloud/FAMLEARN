# 🧪 FamLearn Pro - Comprehensive Testing Checklist

**Last Updated:** 2026-01-09
**Testing Mode:** Make sure `TESTING_MODE = true` (line 2423) for unlimited access during testing

---

## 📋 Table of Contents

1. [Pre-Testing Setup](#1-pre-testing-setup)
2. [Authentication & Registration](#2-authentication--registration)
3. [Student Mode - Core Features](#3-student-mode---core-features)
4. [Student Mode - Quiz Features](#4-student-mode---quiz-features)
5. [Student Mode - Analytics & Tracking](#5-student-mode---analytics--tracking)
6. [Student Mode - Social Features](#6-student-mode---social-features)
7. [Tutor Mode - All Features](#7-tutor-mode---all-features)
8. [Subscription & Payment](#8-subscription--payment)
9. [Profile & Settings](#9-profile--settings)
10. [Edge Cases & Error Handling](#10-edge-cases--error-handling)
11. [Cross-Device & Browser Testing](#11-cross-device--browser-testing)
12. [Performance & UX Testing](#12-performance--ux-testing)

---

## 1. Pre-Testing Setup

### Environment Configuration

- [ ] **Testing Mode Enabled**
  - Open index.html, line 2423: `TESTING_MODE = true`
  - Orange banner appears: "🧪 TESTING MODE ACTIVE"
  - All features should be unlocked

- [ ] **API Keys Configured** (in browser console F12)
  - [ ] `localStorage.getItem('SUPABASE_URL')` returns URL
  - [ ] `localStorage.getItem('SUPABASE_KEY')` returns key
  - [ ] `localStorage.getItem('GROQ_API_KEY')` returns key
  - [ ] `localStorage.getItem('BREVO_API_KEY')` returns key
  - [ ] `localStorage.getItem('RAZORPAY_KEY_ID')` returns key (optional in testing mode)

- [ ] **Database Access**
  - [ ] Open Supabase dashboard
  - [ ] Verify all tables exist (users, quiz_results, batches, etc.)
  - [ ] Check Row Level Security (RLS) is configured
  - [ ] Verify storage bucket 'quiz-images' exists

- [ ] **Browser Console Check**
  - [ ] No critical errors (red messages) on page load
  - [ ] Testing mode logs appear: "🧪 TESTING MODE ACTIVE"
  - [ ] Supabase client initialized successfully

---

## 2. Authentication & Registration

### 2.1 User Registration (Student)

**Happy Path:**
- [ ] Click "Register" tab on auth screen
- [ ] Enter valid details:
  - [ ] Name: "Test Student" (accepts letters and spaces)
  - [ ] Email: "teststudent@example.com" (valid format)
  - [ ] Phone: "9876543210" (10 digits)
  - [ ] Password: "Test@123" (min 6 characters)
  - [ ] Confirm password matches
  - [ ] Select Role: "Student"
- [ ] Click "Create Account"
- [ ] **Expected:** OTP screen appears
- [ ] Check email inbox for OTP code (6 digits)
- [ ] Enter OTP in 6 separate boxes
- [ ] **Expected:** Auto-submit when all 6 digits entered
- [ ] **Expected:** Redirected to student dashboard
- [ ] **Expected:** Welcome toast message appears

**Email OTP Screen:**
- [ ] OTP email received within 30 seconds
- [ ] Email shows: "Your FamLearn Verification Code"
- [ ] OTP is 6 digits and readable
- [ ] Email shows expiry time (5 minutes)
- [ ] OTP boxes auto-focus to next box when typing
- [ ] Backspace moves to previous box
- [ ] Can paste full 6-digit OTP
- [ ] Countdown timer shows time remaining
- [ ] "Resend Code" button appears (disabled for 30 seconds)
- [ ] After 30 seconds, can click "Resend Code"
- [ ] New OTP received, old one invalidated
- [ ] "Cancel" button returns to registration form

**Error Scenarios:**
- [ ] Empty name → Error: "Please enter all fields"
- [ ] Invalid email format → Error toast
- [ ] Phone < 10 digits → Error toast
- [ ] Password < 6 characters → Error toast
- [ ] Passwords don't match → Error toast
- [ ] Email already registered → Error: "User already exists"
- [ ] Wrong OTP entered → Error: "Invalid OTP"
- [ ] Expired OTP (after 5 minutes) → Error: "OTP expired"
- [ ] Empty OTP boxes → Error: "Please enter all 6 digits"

### 2.2 User Registration (Tutor)

**Happy Path:**
- [ ] Same as student registration
- [ ] Select Role: "Tutor" instead of "Student"
- [ ] Complete OTP verification
- [ ] **Expected:** Redirected to tutor dashboard (different UI)
- [ ] **Expected:** Tutor-specific navigation visible

### 2.3 User Login

**Happy Path:**
- [ ] Enter registered email
- [ ] Enter correct password
- [ ] Click "Login"
- [ ] **Expected:** Loading indicator appears
- [ ] **Expected:** Redirected to appropriate dashboard (student/tutor)
- [ ] **Expected:** "Welcome back!" toast message
- [ ] **Expected:** User data loads (points, name, avatar)

**Error Scenarios:**
- [ ] Wrong email → Error: "Invalid login credentials"
- [ ] Wrong password → Error: "Invalid login credentials"
- [ ] Empty fields → Error: "Please enter all fields"
- [ ] Non-existent email → Error: "Invalid login credentials"
- [ ] Network error → Error toast with message

**Remember Me / Session Persistence:**
- [ ] Login successfully
- [ ] Close browser completely
- [ ] Reopen browser, navigate to app
- [ ] **Expected:** Still logged in (session restored)
- [ ] **Expected:** User data loads correctly

### 2.4 Logout

- [ ] Click logout button (⏻ icon) in sidebar
- [ ] **Expected:** Confirmation dialog: "Are you sure you want to logout?"
- [ ] Click "Cancel" → Dialog closes, stays logged in
- [ ] Click "OK" → Logged out, redirected to auth screen
- [ ] **Expected:** Cannot access app without re-login
- [ ] Try browser back button → Still on auth screen

---

## 3. Student Mode - Core Features

### 3.1 Dashboard Page

**Initial Load:**
- [ ] Dashboard page is active by default
- [ ] Page title shows "Dashboard"
- [ ] Top right shows total points (starts at 0)

**Statistics Cards:**
- [ ] "Quizzes Taken" card shows correct count
- [ ] "Average Score" card shows percentage
- [ ] "Time Spent" card shows total time
- [ ] "Current Streak" card shows streak count
- [ ] All cards have proper icons and colors

**Recent Activity Section:**
- [ ] Shows list of recent quizzes (if any)
- [ ] Each quiz shows: subject, score, date, time taken
- [ ] Click quiz → Opens detailed view
- [ ] Empty state shows: "No quizzes yet. Create your first quiz!"
- [ ] "Start New Quiz" button visible in empty state

**Daily Challenge Card:**
- [ ] Shows today's challenge
- [ ] Challenge has target (e.g., "Score 80% or higher")
- [ ] Shows progress toward challenge
- [ ] Progress bar fills based on completion
- [ ] Completed challenges show checkmark
- [ ] "View All Challenges" button works

**Subject Performance Chart:**
- [ ] Chart renders without errors
- [ ] Shows bars for each subject attempted
- [ ] Hover shows exact score percentage
- [ ] Colors are distinct and readable
- [ ] Legend shows subject names

### 3.2 Navigation Sidebar

**Visual Elements:**
- [ ] User avatar shows first letter of name
- [ ] User name displays correctly
- [ ] Subscription tier shows with emoji (🎫 Free Trial)
- [ ] Testing mode: Orange banner visible

**Navigation Items:**
- [ ] 📊 Dashboard - highlighted when active
- [ ] ✏️ New Quiz - clickable
- [ ] 📚 Quiz History - clickable
- [ ] 📈 Performance - clickable (no lock icon in testing mode)
- [ ] 📖 Saved Topics - clickable
- [ ] 🏆 Leaderboard - clickable (no lock icon in testing mode)
- [ ] 💎 Upgrade Plan - clickable

**Subscription Info Panel:**
- [ ] Shows "Time Remaining" with days count
- [ ] Shows "Quizzes Today" with count/limit (e.g., "0/2")
- [ ] Colors update based on status (green/orange/red)
- [ ] Upgrade button visible for free/learner tiers

**User Profile Popup:**
- [ ] Click on user name/avatar → Popup appears
- [ ] Popup shows large avatar with first letter
- [ ] Shows full name
- [ ] Shows email (📧 format)
- [ ] Shows phone if available (📱 format)
- [ ] Shows subscription tier with emoji
- [ ] Shows expiry date (formatted nicely)
- [ ] Shows quizzes this month (e.g., "4/5")
- [ ] Colors change based on status
- [ ] "⚙️ Settings" button works
- [ ] "🚪 Logout" button works
- [ ] Click outside popup → Closes
- [ ] Click username again → Toggles popup

---

## 4. Student Mode - Quiz Features

### 4.1 New Quiz Page - Quiz from Images

**Upload Images Section:**
- [ ] Drag & drop area visible
- [ ] Click to upload button works
- [ ] Can select multiple images at once
- [ ] **Supported formats:** JPG, PNG, JPEG
- [ ] **Max images:** 5 per quiz
- [ ] **Max size:** 5MB per image
- [ ] Preview thumbnails appear after upload
- [ ] Each thumbnail has "X" delete button
- [ ] Can delete individual images
- [ ] Image count shows: "3/5 images"

**Quiz Configuration:**
- [ ] Subject dropdown has all subjects (Math, Physics, Chemistry, etc.)
- [ ] Chapter/Topic input field accepts text
- [ ] Difficulty dropdown: Easy, Medium, Hard
- [ ] Question count dropdown: 5, 10, 15, 20, 25
- [ ] All fields have default values

**Generate Quiz Button:**
- [ ] Button is disabled if no images uploaded
- [ ] Button is enabled when images are uploaded
- [ ] Click "Generate Quiz from Images"
- [ ] **Expected:** Loading overlay appears
- [ ] **Expected:** Loading message: "Generating quiz from images..."
- [ ] **Expected:** Quiz generates within 30-60 seconds
- [ ] **Expected:** Quiz interface appears with questions

**Error Scenarios:**
- [ ] Upload file > 5MB → Error: "File too large"
- [ ] Upload unsupported format (PDF, TXT) → Error: "Unsupported format"
- [ ] Upload > 5 images → Error: "Maximum 5 images allowed"
- [ ] Try to generate with 0 images → Button disabled
- [ ] Network error during generation → Error toast
- [ ] GROQ API error → Error with details

### 4.2 New Quiz Page - Quiz from Topic

**Topic Input:**
- [ ] Click "Quiz from Topic" tab (if exists) or use topic input
- [ ] Enter topic: "Photosynthesis"
- [ ] Subject: Select "Biology"
- [ ] Difficulty: Select "Medium"
- [ ] Question count: Select 10

**Generate Quiz Button:**
- [ ] Button is disabled if topic is empty
- [ ] Button is enabled when topic is entered
- [ ] Click "Generate Quiz"
- [ ] **Expected:** Loading overlay appears
- [ ] **Expected:** Quiz generates within 15-30 seconds
- [ ] **Expected:** Quiz interface appears

**Error Scenarios:**
- [ ] Empty topic → Button disabled
- [ ] Very long topic (> 100 chars) → Still works or shows error
- [ ] Special characters in topic → Still works
- [ ] Network error → Error toast
- [ ] GROQ API error → Error with details

### 4.3 Active Quiz Interface

**Quiz Header:**
- [ ] Shows subject and topic
- [ ] Shows question counter: "Question 1/10"
- [ ] Shows timer counting down from 12:00
- [ ] Shows current score: "Score: 0/10"
- [ ] Timer turns red when < 2 minutes remaining

**Question Display:**
- [ ] Question text is readable
- [ ] Question numbers correctly (1, 2, 3...)
- [ ] If math equations: KaTeX renders properly
- [ ] If images referenced: Images display

**Options Display:**
- [ ] 4 options labeled A, B, C, D
- [ ] Options are clickable cards
- [ ] Hover effect on options
- [ ] Can click any option

**Answering Questions:**
- [ ] Click an option → Becomes selected (highlighted)
- [ ] Click different option → Previous deselects, new one selects
- [ ] "Next Question" button appears when option selected
- [ ] Click "Next Question" → Moves to next question
- [ ] **Expected:** Smooth transition to next question
- [ ] Previous question's answer is saved

**50/50 Lifeline (Testing Mode):**
- [ ] "⚡ 50/50" button visible above options
- [ ] Button shows uses remaining: "2 uses left"
- [ ] Click button → 2 wrong answers disappear (greyed out)
- [ ] Counter updates: "1 use left"
- [ ] Can use second lifeline on different question
- [ ] After 2 uses → Button disabled and greyed out
- [ ] Cannot use lifeline after answering question

**Navigation:**
- [ ] "Next Question" button only appears after selecting answer
- [ ] "Previous Question" button available (if implemented)
- [ ] Cannot skip questions without answering
- [ ] Progress bar shows completion (if exists)

**Last Question:**
- [ ] "Submit Quiz" button appears instead of "Next"
- [ ] Click "Submit Quiz"
- [ ] **Expected:** Confirmation dialog: "Submit quiz? You cannot change answers."
- [ ] Click "Cancel" → Stays on quiz
- [ ] Click "Submit" → Quiz ends, results shown

**Timer Expiry:**
- [ ] Let timer reach 0:00
- [ ] **Expected:** Quiz auto-submits
- [ ] **Expected:** Toast message: "Time's up!"
- [ ] **Expected:** Results screen appears
- [ ] Unanswered questions marked as incorrect

### 4.4 Quiz Results Screen

**Score Display:**
- [ ] Large score shown: "8/10" or "80%"
- [ ] Circular progress ring shows percentage
- [ ] Color coded: Green (>80%), Orange (50-80%), Red (<50%)
- [ ] Shows total points earned: "+80 points"

**Statistics:**
- [ ] "Correct Answers" count shown
- [ ] "Wrong Answers" count shown
- [ ] "Time Taken" shown (e.g., "8m 32s")
- [ ] All stats have icons and colors

**Question Review:**
- [ ] List of all questions shown
- [ ] Each shows: Question number, your answer, correct answer
- [ ] Correct answers have green checkmark ✓
- [ ] Wrong answers have red X ✗
- [ ] Unanswered questions shown differently
- [ ] Click question → Expands to show details
- [ ] Details show: Full question, all options, explanation (if available)

**Explanations (Testing Mode):**
- [ ] Each question has "Show Explanation" button
- [ ] Click button → Explanation text appears
- [ ] Explanation is relevant and helpful
- [ ] Can collapse explanation

**Action Buttons:**
- [ ] "Retake Quiz" button visible
- [ ] "Share Quiz" button visible
- [ ] "Save Quiz" button visible
- [ ] "Go to Dashboard" button visible

**Retake Quiz:**
- [ ] Click "Retake Quiz"
- [ ] **Expected:** Modal/dropdown appears
- [ ] Can select different difficulty
- [ ] Can select different question count
- [ ] Click "Start Retake"
- [ ] **Expected:** New quiz generated with same images/topic
- [ ] **Expected:** Different questions generated

**Share Quiz:**
- [ ] Click "Share Quiz"
- [ ] **Expected:** Share modal appears
- [ ] Shows unique share code (e.g., "ABC-XYZ-123")
- [ ] Has "Copy Code" button
- [ ] Click "Copy Code" → Copies to clipboard
- [ ] **Expected:** Toast: "Code copied!"
- [ ] Has "Copy Link" button (if implemented)
- [ ] Close button works

**Save Quiz:**
- [ ] Click "Save Quiz"
- [ ] **Expected:** Quiz saved to library
- [ ] **Expected:** Toast: "Quiz saved!"
- [ ] **Expected:** Can find in "Saved Topics" page

**Results Persistence:**
- [ ] Results are saved to database
- [ ] Can see this quiz in Quiz History
- [ ] Points are added to total points
- [ ] Stats update on dashboard

### 4.5 Quiz History Page

**Initial Load:**
- [ ] Page title shows "Quiz History"
- [ ] List of completed quizzes appears
- [ ] Quizzes sorted by date (newest first)

**Quiz Cards:**
- [ ] Each card shows: Subject icon, Topic, Score, Date, Time taken
- [ ] Color coded by score (green/orange/red)
- [ ] Percentage displayed: "85%"
- [ ] Points earned shown: "+85 points"

**Filters (if implemented):**
- [ ] Filter by subject dropdown works
- [ ] Filter by date range works
- [ ] Filter by score range works
- [ ] "Clear Filters" button resets all

**Search:**
- [ ] Search box for topic/subject
- [ ] Type query → Results filter in real-time
- [ ] Empty search shows all quizzes

**Quiz Details:**
- [ ] Click quiz card → Expands or navigates to details
- [ ] Shows full question review
- [ ] Shows all statistics
- [ ] Can view explanations (testing mode)
- [ ] "Retake" button available
- [ ] "Share" button available
- [ ] "Delete" button available (if implemented)

**Delete Quiz:**
- [ ] Click delete button
- [ ] **Expected:** Confirmation dialog
- [ ] Click "Confirm" → Quiz deleted
- [ ] **Expected:** Removed from list
- [ ] **Expected:** Toast: "Quiz deleted"

**Empty State:**
- [ ] No quizzes → Shows empty state message
- [ ] "Create Your First Quiz" button visible
- [ ] Click button → Navigates to New Quiz page

**Pagination:**
- [ ] If > 20 quizzes → Pagination appears
- [ ] Page numbers clickable
- [ ] "Next" and "Previous" buttons work
- [ ] Current page highlighted

---

## 5. Student Mode - Analytics & Tracking

### 5.1 Performance Page (Analytics)

**Note:** Should be accessible in testing mode without payment

**Page Access:**
- [ ] Click "Performance" in sidebar
- [ ] **Expected:** No upgrade modal in testing mode
- [ ] Page loads without errors

**Overview Stats:**
- [ ] Total quizzes taken
- [ ] Average score percentage
- [ ] Total time spent
- [ ] Best subject shown
- [ ] All stats accurate based on quiz history

**Performance Over Time Chart:**
- [ ] Line chart shows score trends
- [ ] X-axis shows dates
- [ ] Y-axis shows scores (%)
- [ ] Points are plotted correctly
- [ ] Hover shows exact values
- [ ] Chart legend visible

**Subject-wise Performance:**
- [ ] Bar chart or table shows each subject
- [ ] Shows: Subject name, quizzes taken, average score
- [ ] Color coded by performance
- [ ] Can sort by score, quizzes, etc.

**Recent Improvements:**
- [ ] Shows subjects with score improvements
- [ ] Shows percentage improvement
- [ ] Positive trends highlighted in green

**Weak Areas:**
- [ ] Shows subjects/topics with low scores
- [ ] Suggests topics to practice
- [ ] Shows average score for weak areas

**Time Analysis:**
- [ ] Average time per question
- [ ] Fastest quiz time
- [ ] Slowest quiz time
- [ ] Time trends over quizzes

**Difficulty Analysis:**
- [ ] Performance by difficulty (Easy, Medium, Hard)
- [ ] Shows success rate for each level
- [ ] Chart or table display

**Export Options (if implemented):**
- [ ] "Download Report" button
- [ ] Click → Downloads PDF/CSV
- [ ] Report contains all analytics data

### 5.2 Saved Topics Page

**Page Load:**
- [ ] Shows list of saved/favorite topics
- [ ] Each topic has: Name, Subject, Last attempted date
- [ ] Icon or color for each subject

**Topic Actions:**
- [ ] Click topic → Quick quiz generation
- [ ] "Practice" button → Generates quiz on that topic
- [ ] "Remove" button → Removes from saved topics
- [ ] "Share" button → Share topic with others

**Add New Topic:**
- [ ] "Add Topic" button visible
- [ ] Click → Opens input modal
- [ ] Enter topic name and subject
- [ ] Click "Save" → Topic added to list

**Empty State:**
- [ ] No saved topics → Shows empty state
- [ ] Message: "Save topics you want to practice"
- [ ] Button to start quiz and save topic

### 5.3 Streaks & Challenges

**Streak Display (Dashboard or Dedicated Section):**
- [ ] Current streak count shown: "5 day streak! 🔥"
- [ ] Streak calendar shows active days
- [ ] Today highlighted if quiz completed
- [ ] Longest streak shown
- [ ] Streak broken shows message

**Daily Challenges:**
- [ ] Today's challenge visible
- [ ] Challenge description clear
- [ ] Progress bar shows completion
- [ ] Completed challenges have checkmark
- [ ] Rewards shown (points, badges)

**Challenge Types:**
- [ ] Score-based: "Score 80% or higher"
- [ ] Volume-based: "Complete 3 quizzes today"
- [ ] Subject-based: "Take a Math quiz"
- [ ] Streak-based: "Maintain 7-day streak"

**Challenge Completion:**
- [ ] Complete a challenge's requirements
- [ ] **Expected:** Confetti animation or celebration
- [ ] **Expected:** Toast: "Challenge completed! +50 points"
- [ ] Points added to total
- [ ] Challenge marked as complete

**Challenge History:**
- [ ] View past challenges
- [ ] See completion status
- [ ] See rewards earned

### 5.4 Milestones & Achievements

**Milestone System:**
- [ ] List of milestones visible
- [ ] Each shows: Icon, Title, Description, Progress
- [ ] Examples:
  - [ ] "First Steps" - Complete 1 quiz
  - [ ] "Quiz Master" - Complete 10 quizzes
  - [ ] "Perfect Score" - Score 100% on a quiz
  - [ ] "Speed Demon" - Complete quiz in under 5 minutes
  - [ ] "Subject Expert" - Score 90%+ in 5 Math quizzes

**Milestone Progress:**
- [ ] Progress bar for each milestone
- [ ] Shows current/target (e.g., "7/10")
- [ ] Locked milestones greyed out
- [ ] Unlocked milestones highlighted

**Milestone Unlock:**
- [ ] Achieve milestone requirements
- [ ] **Expected:** Modal popup: "Milestone Unlocked!"
- [ ] Shows milestone badge/icon
- [ ] Shows reward (points, title, etc.)
- [ ] Badge added to profile
- [ ] Points added to total

**Badges Display:**
- [ ] Earned badges shown in profile
- [ ] Badges displayed with icons
- [ ] Can click badge to see details
- [ ] Locked badges shown as silhouettes

---

## 6. Student Mode - Social Features

### 6.1 Leaderboard Page

**Note:** Should be accessible in testing mode without payment

**Page Access:**
- [ ] Click "Leaderboard" in sidebar
- [ ] **Expected:** No upgrade modal in testing mode
- [ ] Page loads without errors

**Global Leaderboard:**
- [ ] Shows top users ranked by points
- [ ] Each entry shows: Rank, Name, Points, Avatar
- [ ] Your position highlighted in different color
- [ ] Top 3 have special badges (🥇🥈🥉)
- [ ] Shows at least top 20 users

**Leaderboard Filters:**
- [ ] "All Time" tab selected by default
- [ ] "This Week" tab shows weekly rankings
- [ ] "This Month" tab shows monthly rankings
- [ ] Filter by subject (if implemented)
- [ ] Filter by difficulty (if implemented)

**Your Position:**
- [ ] Your rank clearly shown
- [ ] Your points shown
- [ ] "Points needed for next rank" displayed
- [ ] Can scroll to find yourself easily

**User Profiles (if clickable):**
- [ ] Click user → Opens profile (if implemented)
- [ ] Shows user stats
- [ ] Shows badges earned
- [ ] "Challenge" button (if PvP implemented)

**Refresh:**
- [ ] "Refresh" button updates leaderboard
- [ ] Updates without page reload
- [ ] Loading indicator during refresh

**Empty State:**
- [ ] No data → Shows empty state
- [ ] Message: "Be the first to compete!"

### 6.2 Quiz Sharing

**Generate Share Code:**
- [ ] Complete a quiz
- [ ] Click "Share Quiz" on results screen
- [ ] **Expected:** Modal appears
- [ ] Share code generated: "ABC-DEF-GHI" format
- [ ] Code is unique
- [ ] Code saved to database

**Share Options:**
- [ ] "Copy Code" button works
- [ ] Code copied to clipboard
- [ ] Toast: "Code copied!"
- [ ] "Copy Link" button (if implemented)
- [ ] Full link copied including code

**Receive Shared Quiz:**
- [ ] Have another user share a quiz code
- [ ] Go to "New Quiz" or "Join Quiz" section
- [ ] Enter share code in input field
- [ ] Click "Join Quiz"
- [ ] **Expected:** Quiz loads with same questions
- [ ] Can take the quiz
- [ ] Results tracked separately

**Shared Quiz Metadata:**
- [ ] Shows who shared it: "Shared by John"
- [ ] Shows when it was created
- [ ] Shows difficulty and subject
- [ ] Shows how many people completed it

**Error Scenarios:**
- [ ] Invalid code → Error: "Invalid quiz code"
- [ ] Expired code → Error: "Quiz code expired"
- [ ] Already attempted → Shows message or allows retake

---

## 7. Tutor Mode - All Features

### 7.1 Tutor Dashboard

**Switch to Tutor:**
- [ ] Logout from student account
- [ ] Login with tutor account
- [ ] **Expected:** Different UI (tutor app container)
- [ ] **Expected:** Tutor-specific navigation

**Dashboard Overview:**
- [ ] Shows total batches created
- [ ] Shows total students
- [ ] Shows total quizzes assigned
- [ ] Shows recent activity

**Batch List:**
- [ ] Shows list of batches (if any)
- [ ] Each batch shows: Name, student count, creation date
- [ ] Click batch → Opens batch details

**Quick Actions:**
- [ ] "Create New Batch" button
- [ ] "Create Quiz" button
- [ ] "Add Student" button
- [ ] All buttons work

### 7.2 Batch Management

**Create New Batch:**
- [ ] Click "Create Batch" button
- [ ] **Expected:** Modal appears
- [ ] Enter batch name: "Class 10A Mathematics"
- [ ] Enter batch code (optional): "C10A-MATH"
- [ ] Click "Create"
- [ ] **Expected:** Batch created successfully
- [ ] **Expected:** Toast: "Batch created!"
- [ ] **Expected:** Batch appears in list

**Batch Details Page:**
- [ ] Click existing batch
- [ ] Shows batch name and code
- [ ] Shows list of students in batch
- [ ] Shows list of assigned quizzes
- [ ] Shows batch performance stats

**Add Students to Batch:**
- [ ] Click "Add Student" button in batch details
- [ ] **Expected:** Modal appears
- [ ] Search student by email or name
- [ ] Select student from list
- [ ] Click "Add"
- [ ] **Expected:** Student added to batch
- [ ] **Expected:** Student appears in batch student list

**Remove Student from Batch:**
- [ ] Click "Remove" on student in batch
- [ ] **Expected:** Confirmation dialog
- [ ] Click "Confirm" → Student removed
- [ ] **Expected:** Student no longer in batch

**Edit Batch:**
- [ ] Click "Edit Batch" button
- [ ] Modify batch name
- [ ] Modify batch code
- [ ] Click "Save"
- [ ] **Expected:** Changes saved
- [ ] **Expected:** Toast: "Batch updated!"

**Delete Batch:**
- [ ] Click "Delete Batch" button
- [ ] **Expected:** Confirmation dialog with warning
- [ ] Click "Confirm" → Batch deleted
- [ ] **Expected:** Removed from batch list
- [ ] **Expected:** Students not deleted, only unassigned

### 7.3 Quiz Creation (Tutor)

**Create Quiz Page:**
- [ ] Click "Create Quiz" in tutor navigation
- [ ] Same interface as student quiz creation
- [ ] Upload images OR enter topic
- [ ] Configure subject, difficulty, question count
- [ ] Click "Generate Quiz"
- [ ] **Expected:** Quiz generated
- [ ] **Expected:** Preview of quiz questions

**Save Quiz for Assignment:**
- [ ] After generating quiz
- [ ] Click "Save Quiz" button
- [ ] **Expected:** Quiz saved to tutor's library
- [ ] Can assign this quiz to batches later

**Saved Quizzes Page (Tutor):**
- [ ] Navigate to "Saved Quizzes"
- [ ] List of all saved quizzes
- [ ] Each shows: Title, subject, question count, date
- [ ] Actions: View, Assign, Edit, Delete

**View Saved Quiz:**
- [ ] Click "View" on saved quiz
- [ ] Shows all questions and answers
- [ ] Can see correct answers
- [ ] Can see explanations

**Delete Saved Quiz:**
- [ ] Click "Delete" on saved quiz
- [ ] **Expected:** Confirmation dialog
- [ ] Click "Confirm" → Quiz deleted
- [ ] **Expected:** Removed from list

### 7.4 Quiz Assignment

**Assign Quiz to Batch:**
- [ ] Go to batch details page
- [ ] Click "Assign Quiz" button
- [ ] **Expected:** Modal appears
- [ ] Select quiz from saved quizzes dropdown
- [ ] OR click "Create New Quiz" to generate on the spot
- [ ] Set due date (optional)
- [ ] Set time limit (optional)
- [ ] Click "Assign"
- [ ] **Expected:** Quiz assigned to all students in batch
- [ ] **Expected:** Toast: "Quiz assigned successfully!"

**Quiz Assignments List:**
- [ ] Shows list of assigned quizzes
- [ ] Each shows: Quiz name, assigned date, due date, completion status
- [ ] Shows completion count: "15/20 completed"

**Assignment Details:**
- [ ] Click on assignment
- [ ] Shows which students completed
- [ ] Shows which students pending
- [ ] Shows individual scores
- [ ] Can send reminder to pending students

**Unassign Quiz:**
- [ ] Click "Unassign" or "Delete Assignment"
- [ ] **Expected:** Confirmation dialog
- [ ] Click "Confirm" → Assignment removed
- [ ] Students can no longer access quiz

### 7.5 Student Management

**Students Page:**
- [ ] Navigate to "Students" page
- [ ] Shows list of all students across all batches
- [ ] Each shows: Name, email, batches, quizzes completed

**Student Filters:**
- [ ] Filter by batch
- [ ] Filter by completion status
- [ ] Search by name or email

**Student Details:**
- [ ] Click student name
- [ ] Shows student profile
- [ ] Shows batches they're in
- [ ] Shows all quizzes completed
- [ ] Shows performance analytics
- [ ] Shows score trends

**Student Performance:**
- [ ] View subject-wise performance
- [ ] View quiz history
- [ ] View time spent
- [ ] View weak areas
- [ ] Export student report (if implemented)

**Remove Student:**
- [ ] Click "Remove Student" (from system or batch)
- [ ] **Expected:** Confirmation dialog
- [ ] Specify if removing from batch or system
- [ ] Click "Confirm" → Student removed

### 7.6 Tutor Analytics

**Batch Analytics:**
- [ ] View analytics for specific batch
- [ ] Shows average score for batch
- [ ] Shows completion rates
- [ ] Shows subject-wise performance
- [ ] Shows time spent by batch

**Comparative Analytics:**
- [ ] Compare multiple batches
- [ ] Shows which batch performs better
- [ ] Shows subject strengths/weaknesses by batch
- [ ] Charts for visual comparison

**Individual Student Tracking:**
- [ ] Track specific student's progress
- [ ] View score trends over time
- [ ] Identify struggling students (red flags)
- [ ] Identify high performers (green flags)

**Quiz Analytics:**
- [ ] For each assigned quiz, see:
  - [ ] Average score
  - [ ] Completion rate
  - [ ] Difficult questions (most people got wrong)
  - [ ] Easy questions (most people got right)
  - [ ] Time analysis

**Export Reports:**
- [ ] "Download Report" button for batch
- [ ] "Download Report" button for student
- [ ] Reports in PDF or CSV format
- [ ] Contains all relevant analytics

---

## 8. Subscription & Payment

**Note:** In testing mode, payment flows are bypassed. Test these in production mode.

### 8.1 Testing Mode Behavior

**Testing Mode ON (TESTING_MODE = true):**
- [ ] Orange banner visible: "🧪 TESTING MODE ACTIVE"
- [ ] No quiz creation limits
- [ ] No daily/monthly restrictions
- [ ] All premium features accessible
- [ ] Analytics page works without upgrade
- [ ] Leaderboard page works without upgrade
- [ ] Lifelines available in quizzes
- [ ] Explanations visible

**Pricing Page in Testing Mode:**
- [ ] Click "Upgrade Plan" in sidebar
- [ ] Pricing page loads with plans
- [ ] Shows Free Trial, Learner, Pro Student, Pro Tutor
- [ ] Click "Upgrade Now" on any plan
- [ ] **Expected:** Toast: "🧪 Testing Mode Active - All features are unlocked for free!"
- [ ] **Expected:** No Razorpay popup
- [ ] Console log: "🧪 Testing Mode: Payment bypassed"

### 8.2 Subscription Limits (Testing Mode OFF)

**When TESTING_MODE = false:**

**Free Trial (Day 1-3):**
- [ ] Can create 2 quizzes per day
- [ ] Can create max 5 quizzes total
- [ ] Can save max 5 quizzes in library
- [ ] Analytics page locked (shows upgrade modal)
- [ ] Leaderboard locked (shows upgrade modal)
- [ ] No lifelines in quizzes
- [ ] No answer explanations
- [ ] Try to create 3rd quiz today → Upgrade modal appears
- [ ] Try to create 6th quiz overall → Upgrade modal appears

**Trial Expired:**
- [ ] After 3 days, trial expires
- [ ] Student mode: Can only see last 3 quiz results
- [ ] Student mode: Cannot create new quizzes
- [ ] All locked features show upgrade modal
- [ ] Upgrade button prominent everywhere

**Learner Plan:**
- [ ] 3 quizzes per day
- [ ] 25 quizzes per month
- [ ] 25 quiz library limit
- [ ] Analytics unlocked
- [ ] Leaderboard unlocked
- [ ] 2 lifelines per quiz
- [ ] Explanations visible
- [ ] Try to create 4th quiz today → Upgrade modal
- [ ] Try to create 26th quiz this month → Upgrade modal

**Pro Student Plan:**
- [ ] 5 quizzes per day
- [ ] Unlimited quizzes per month
- [ ] 50 quiz library limit
- [ ] All Learner features
- [ ] Priority support badge

**Pro Tutor Plan:**
- [ ] 5 quizzes per day
- [ ] Unlimited quizzes per month
- [ ] Batch management unlocked
- [ ] Quiz assignments unlocked
- [ ] Student tracking unlocked

### 8.3 Payment Flow (Testing Mode OFF)

**Razorpay Configuration:**
- [ ] Set `TESTING_MODE = false` in code
- [ ] Set Razorpay key: `localStorage.setItem('RAZORPAY_KEY_ID', 'rzp_test_XXX')`
- [ ] Refresh page

**Initiate Payment:**
- [ ] Go to Pricing page
- [ ] Click "Upgrade Now" on Learner plan
- [ ] **Expected:** Console logs payment flow
- [ ] **Expected:** Razorpay popup appears
- [ ] Popup shows: Plan name, amount, user details

**Complete Payment (Test Mode):**
- [ ] Use test card: 4111 1111 1111 1111
- [ ] Expiry: Any future date
- [ ] CVV: 123
- [ ] Click "Pay"
- [ ] **Expected:** Payment succeeds
- [ ] **Expected:** Toast: "🎉 Payment successful! Your account has been upgraded!"
- [ ] **Expected:** Page reloads
- [ ] **Expected:** Sidebar shows new tier

**Verify Upgrade:**
- [ ] Check subscription tier in sidebar
- [ ] Should show "📚 Learner" (or Pro Student, etc.)
- [ ] Try creating 3 quizzes today → Should work (new limit)
- [ ] Try accessing analytics → Should work
- [ ] Check database: subscription_tier updated
- [ ] Check database: subscription_transactions record exists

**Payment Failure:**
- [ ] Use failure test card (check Razorpay docs)
- [ ] **Expected:** Error message appears
- [ ] **Expected:** Subscription not upgraded
- [ ] **Expected:** Transaction marked as failed in DB

**Payment Cancellation:**
- [ ] Open Razorpay popup
- [ ] Click "X" or "Cancel"
- [ ] **Expected:** Toast: "Payment cancelled"
- [ ] **Expected:** Stays on pricing page
- [ ] **Expected:** No subscription change

### 8.4 Subscription Management

**View Subscription:**
- [ ] Sidebar shows current tier and expiry
- [ ] Profile popup shows subscription end date
- [ ] Pricing page shows "Current Plan" banner

**Subscription Expiry Warning:**
- [ ] 7 days before expiry → Warning toast/banner
- [ ] 3 days before expiry → Urgent warning
- [ ] 1 day before expiry → Critical warning
- [ ] On expiry day → Subscription expires

**Grace Period (Students):**
- [ ] Subscription expires
- [ ] 3-day grace period begins
- [ ] Can still access features during grace
- [ ] Banner shows: "Grace period: 2 days left"
- [ ] After grace period → Features locked

**Renewal:**
- [ ] Click "Renew" button (if implemented)
- [ ] Same payment flow as initial purchase
- [ ] Subscription extended from expiry date

---

## 9. Profile & Settings

### 9.1 User Profile

**View Profile:**
- [ ] Click username in sidebar → Popup appears
- [ ] Shows all user information
- [ ] Avatar, name, email, phone, tier, expiry

**Edit Profile (if Settings page exists):**
- [ ] Navigate to Settings page
- [ ] Shows editable fields: Name, Phone, Password
- [ ] Email not editable (read-only)

**Update Name:**
- [ ] Change name to "New Name"
- [ ] Click "Save"
- [ ] **Expected:** Name updated
- [ ] **Expected:** Toast: "Profile updated!"
- [ ] **Expected:** Sidebar shows new name
- [ ] **Expected:** Database updated

**Update Phone:**
- [ ] Change phone number
- [ ] Click "Save"
- [ ] **Expected:** Phone updated
- [ ] Validate format (10 digits)

**Change Password:**
- [ ] Enter current password
- [ ] Enter new password
- [ ] Confirm new password
- [ ] Click "Update Password"
- [ ] **Expected:** Password updated
- [ ] **Expected:** Toast: "Password changed!"
- [ ] Logout and login with new password → Works

**Password Validation:**
- [ ] Current password wrong → Error
- [ ] New password < 6 chars → Error
- [ ] Passwords don't match → Error
- [ ] Empty fields → Error

### 9.2 Settings Page

**Account Settings Section:**
- [ ] Shows account creation date
- [ ] Shows email (read-only)
- [ ] Shows role (Student/Tutor)
- [ ] "Delete Account" button (if implemented)

**Notification Settings (if implemented):**
- [ ] Toggle email notifications
- [ ] Toggle streak reminders
- [ ] Toggle challenge notifications
- [ ] Save preferences → Settings updated

**Privacy Settings (if implemented):**
- [ ] Toggle profile visibility
- [ ] Toggle leaderboard participation
- [ ] Save preferences → Settings updated

**Theme Settings (if implemented):**
- [ ] Toggle dark/light mode
- [ ] Save preference
- [ ] Theme persists across sessions

**Delete Account:**
- [ ] Click "Delete Account"
- [ ] **Expected:** Warning dialog with multiple confirmations
- [ ] Enter password to confirm
- [ ] Click "Permanently Delete"
- [ ] **Expected:** Account deleted
- [ ] **Expected:** All user data removed
- [ ] **Expected:** Logged out
- [ ] Cannot login with same credentials

---

## 10. Edge Cases & Error Handling

### 10.1 Input Validation

**Empty Inputs:**
- [ ] Leave name empty on registration → Error
- [ ] Leave email empty → Error
- [ ] Leave password empty → Error
- [ ] Try to create quiz with no images/topic → Button disabled
- [ ] Submit form with all fields empty → Error

**Invalid Formats:**
- [ ] Email without @ symbol → Error: "Invalid email"
- [ ] Email without domain → Error
- [ ] Phone with letters → Error
- [ ] Phone with < 10 digits → Error
- [ ] Password with spaces → Accepted or rejected consistently

**Special Characters:**
- [ ] Name with emojis → Accepts or rejects consistently
- [ ] Topic with special chars: "C++ Programming" → Works
- [ ] Quiz topic: "What is H₂O?" → Works
- [ ] Math symbols in questions → Renders properly

**Long Inputs:**
- [ ] Very long name (> 100 chars) → Truncated or error
- [ ] Very long topic (> 200 chars) → Truncated or error
- [ ] Very long quiz question → Displays properly

**SQL Injection Attempts:**
- [ ] Enter: `'; DROP TABLE users; --` in name → Safely handled
- [ ] Enter SQL in any input field → Sanitized or escaped
- [ ] No SQL errors in console

**XSS Attempts:**
- [ ] Enter: `<script>alert('XSS')</script>` in name → Escaped, not executed
- [ ] HTML tags in inputs → Displayed as text, not rendered
- [ ] No alerts or scripts execute

### 10.2 Network & API Errors

**No Internet Connection:**
- [ ] Disconnect internet
- [ ] Try to login → Error: "Network error"
- [ ] Try to create quiz → Error toast
- [ ] Try to load data → Error message
- [ ] **Expected:** Graceful error messages, not crashes

**Supabase Connection Error:**
- [ ] Incorrect Supabase URL in config
- [ ] Try to login → Error: "Connection failed"
- [ ] Try to load dashboard → Shows error
- [ ] Console shows connection error

**GROQ API Error:**
- [ ] Invalid GROQ API key
- [ ] Try to generate quiz → Error: "Failed to generate quiz"
- [ ] Console shows API error details
- [ ] User sees friendly error message

**GROQ Rate Limit:**
- [ ] Generate many quizzes quickly
- [ ] If rate limited → Error: "Too many requests, try again later"
- [ ] Shows retry time if available

**Brevo Email API Error:**
- [ ] Invalid Brevo API key during registration
- [ ] Try to register → Error: "Failed to send OTP"
- [ ] User informed, can retry

**Razorpay Script Not Loaded:**
- [ ] Block Razorpay CDN in browser
- [ ] Try to make payment → Error: "Payment system not loaded"
- [ ] Console shows script load error

**Database Write Errors:**
- [ ] Complete quiz
- [ ] If DB write fails → Error: "Failed to save quiz"
- [ ] User notified
- [ ] Can retry saving

### 10.3 Session & Authentication

**Session Timeout:**
- [ ] Login successfully
- [ ] Wait for long period (or manipulate session)
- [ ] Try to perform action → Redirected to login
- [ ] Toast: "Session expired, please login again"

**Token Expiry:**
- [ ] Token expires while using app
- [ ] Try to load page → Auto-logout
- [ ] Redirected to auth screen

**Concurrent Logins:**
- [ ] Login on Browser 1
- [ ] Login with same account on Browser 2
- [ ] Both sessions work independently
- [ ] Data syncs across both

**Logout on One Device:**
- [ ] Login on two browsers
- [ ] Logout on Browser 1
- [ ] Browser 2 still logged in (or logs out depending on implementation)

### 10.4 Data Integrity

**Duplicate Prevention:**
- [ ] Register with email
- [ ] Try to register again with same email → Error: "Email already registered"
- [ ] No duplicate user records in database

**Concurrent Quiz Creation:**
- [ ] User A and User B in same batch
- [ ] Tutor assigns quiz
- [ ] Both attempt simultaneously → Both can attempt
- [ ] No conflicts in database

**Counter Accuracy:**
- [ ] Complete 5 quizzes
- [ ] Check "Quizzes Taken" stat → Shows 5
- [ ] Check database → quiz_attempts = 5
- [ ] Points calculated correctly

**Data Race Conditions:**
- [ ] Complete quiz
- [ ] While saving, close browser
- [ ] Reopen → Check if quiz saved
- [ ] Should be saved or marked as incomplete

### 10.5 UI/UX Edge Cases

**Very Long Names:**
- [ ] User name is 50+ characters
- [ ] Sidebar displays correctly (truncated with ...)
- [ ] Profile popup displays full name
- [ ] Leaderboard displays correctly

**Empty States:**
- [ ] No quizzes taken → Dashboard shows empty state
- [ ] No batches (tutor) → Batches page shows empty state
- [ ] No students → Students page shows empty state
- [ ] All empty states have helpful messages and CTAs

**Loading States:**
- [ ] During quiz generation → Loading overlay visible
- [ ] During login → Button shows loading spinner
- [ ] During data fetch → Skeleton loaders or spinners
- [ ] No blank white screens

**Error States:**
- [ ] Network error → Error message displayed
- [ ] API error → User-friendly error shown
- [ ] Not just generic "Error occurred"
- [ ] Provides actionable steps (retry, refresh, etc.)

**Browser Back Button:**
- [ ] During quiz → Back button doesn't exit quiz (or confirms)
- [ ] After logout → Back button doesn't re-login
- [ ] Navigation consistent with browser history

**Multiple Tabs:**
- [ ] Open app in two tabs
- [ ] Complete quiz in Tab 1
- [ ] Refresh Tab 2 → Data updates
- [ ] No stale data shown

**Modal Overlays:**
- [ ] Open modal
- [ ] Click outside modal → Closes
- [ ] Press ESC key → Closes
- [ ] Click "X" button → Closes
- [ ] Background is dimmed
- [ ] Can't interact with background while modal open

**Form Reset:**
- [ ] Fill registration form
- [ ] Click "Cancel" or navigate away
- [ ] Come back → Form is cleared
- [ ] No old data lingering

---

## 11. Cross-Device & Browser Testing

### 11.1 Desktop Browsers

**Google Chrome (Latest):**
- [ ] All features work
- [ ] UI renders correctly
- [ ] No console errors
- [ ] Animations smooth
- [ ] Charts render properly

**Mozilla Firefox (Latest):**
- [ ] All features work
- [ ] UI consistent with Chrome
- [ ] No JavaScript errors
- [ ] File uploads work
- [ ] Modals display correctly

**Microsoft Edge (Latest):**
- [ ] All features work
- [ ] UI renders correctly
- [ ] Payment gateway works
- [ ] Charts render

**Safari (Mac):**
- [ ] All features work
- [ ] UI renders correctly
- [ ] No webkit-specific issues
- [ ] File uploads work
- [ ] Animations work

**Browser Compatibility:**
- [ ] Test on older browsers (if supporting IE11, etc.)
- [ ] Polyfills loaded for older browsers
- [ ] Graceful degradation for unsupported features

### 11.2 Mobile Devices

**Responsive Design:**
- [ ] Open on mobile browser (Chrome Mobile, Safari iOS)
- [ ] UI scales properly
- [ ] No horizontal scrolling
- [ ] All text readable
- [ ] Buttons large enough to tap

**Mobile Navigation:**
- [ ] Sidebar becomes hamburger menu (or collapsed)
- [ ] Menu opens/closes smoothly
- [ ] All navigation items accessible
- [ ] Bottom navigation (if implemented) works

**Touch Interactions:**
- [ ] Tap buttons → Works
- [ ] Swipe gestures (if implemented) → Works
- [ ] Pinch to zoom on images → Works
- [ ] No accidental taps (buttons properly spaced)

**Mobile Quiz Taking:**
- [ ] Quiz interface fits screen
- [ ] Options are tappable
- [ ] Timer visible
- [ ] Can scroll to see all content
- [ ] Submit button reachable

**Mobile Forms:**
- [ ] Registration form usable on mobile
- [ ] Keyboard types correct (email keyboard for email, number pad for phone)
- [ ] Form fields not obscured by keyboard
- [ ] Can submit forms easily

**Mobile Image Upload:**
- [ ] Can access device camera
- [ ] Can select from gallery
- [ ] Images upload successfully
- [ ] Preview shows correctly

**Mobile Performance:**
- [ ] App loads quickly on mobile data
- [ ] Animations don't lag
- [ ] Scrolling smooth
- [ ] No memory issues

### 11.3 Tablet Testing

**iPad / Android Tablets:**
- [ ] UI scales appropriately
- [ ] Uses more screen space than mobile
- [ ] Touch targets appropriately sized
- [ ] Charts and tables display well
- [ ] Landscape and portrait modes work

### 11.4 Screen Sizes

**Large Desktop (1920x1080+):**
- [ ] UI doesn't stretch too wide
- [ ] Max-width applied to content
- [ ] Sidebars and layout look good
- [ ] No excessive whitespace

**Small Laptop (1366x768):**
- [ ] All content visible
- [ ] No elements cut off
- [ ] Scrolling available where needed

**Mobile Portrait (375x667):**
- [ ] All content accessible
- [ ] UI stacks vertically
- [ ] No overlapping elements

**Mobile Landscape (667x375):**
- [ ] UI adapts to landscape
- [ ] Header doesn't take too much space
- [ ] Quiz questions readable

---

## 12. Performance & UX Testing

### 12.1 Page Load Performance

**Initial Page Load:**
- [ ] Time from URL to visible content < 3 seconds
- [ ] Loading indicators shown during load
- [ ] Progressive rendering (content appears gradually)
- [ ] No flash of unstyled content

**Dashboard Load:**
- [ ] Stats load quickly
- [ ] Charts render without delay
- [ ] Recent activity appears fast

**Quiz History Load:**
- [ ] List of quizzes loads < 2 seconds
- [ ] Pagination loads instantly
- [ ] Filters apply without delay

**Image Loading:**
- [ ] Uploaded images show thumbnails quickly
- [ ] Large images don't block UI
- [ ] Lazy loading implemented (if applicable)

### 12.2 Quiz Generation Performance

**Small Quiz (5 questions):**
- [ ] Generates in < 20 seconds
- [ ] Loading indicator shows progress
- [ ] No freezing or hangs

**Large Quiz (25 questions):**
- [ ] Generates in < 60 seconds
- [ ] Loading message updates
- [ ] User can cancel if needed

**Multiple Images:**
- [ ] 5 images upload quickly
- [ ] Processing time reasonable
- [ ] No timeouts

**Topic-Based Quiz:**
- [ ] Generates faster than image-based
- [ ] < 15 seconds for 10 questions
- [ ] Consistent performance

### 12.3 Database Performance

**Large Dataset:**
- [ ] User with 100+ quizzes
- [ ] Quiz history loads without lag
- [ ] Pagination smooth
- [ ] Analytics calculations fast

**Concurrent Users:**
- [ ] Multiple users logged in
- [ ] No slow queries
- [ ] Data fetching remains fast
- [ ] No database locks

### 12.4 Animation & Transitions

**Smooth Animations:**
- [ ] Page transitions smooth (< 300ms)
- [ ] Modal animations smooth
- [ ] Hover effects instant
- [ ] Loading spinners don't stutter

**Chart Animations:**
- [ ] Charts animate on load
- [ ] Hover interactions smooth
- [ ] No lag when updating data

### 12.5 Memory & Resource Usage

**Memory Leaks:**
- [ ] Use app for 30+ minutes
- [ ] Check browser memory (DevTools)
- [ ] Memory usage stable
- [ ] No continuous growth

**CPU Usage:**
- [ ] App doesn't cause high CPU
- [ ] Animations don't peg CPU
- [ ] Background tabs don't consume resources

**Battery Impact (Mobile):**
- [ ] App doesn't drain battery excessively
- [ ] No continuous polling or timers
- [ ] Efficient resource usage

### 12.6 Accessibility

**Keyboard Navigation:**
- [ ] Can navigate with Tab key
- [ ] Focus indicators visible
- [ ] Can submit forms with Enter
- [ ] Can close modals with Esc

**Screen Reader Compatibility:**
- [ ] Test with screen reader (NVDA, JAWS)
- [ ] Alt text on images
- [ ] ARIA labels on buttons
- [ ] Semantic HTML used

**Color Contrast:**
- [ ] Text readable on all backgrounds
- [ ] Pass WCAG AA standards (4.5:1 ratio)
- [ ] High contrast mode works

**Font Sizes:**
- [ ] Text not too small (min 14px)
- [ ] Can zoom page to 200% without breaking layout
- [ ] Responsive font sizes

### 12.7 User Experience

**Error Messages:**
- [ ] Errors are clear and specific
- [ ] Not just "Error occurred"
- [ ] Provides guidance on fixing
- [ ] Positioned near relevant field

**Success Feedback:**
- [ ] Toast messages appear for actions
- [ ] Toasts auto-dismiss after 3-5 seconds
- [ ] Toasts don't block content
- [ ] Can manually dismiss toasts

**Confirmations:**
- [ ] Destructive actions require confirmation
- [ ] Delete confirmations clear
- [ ] Logout confirmation (optional but good UX)

**Help & Guidance:**
- [ ] Tooltips on hover (if implemented)
- [ ] Placeholder text in inputs helpful
- [ ] Empty states guide user
- [ ] First-time user onboarding (if implemented)

**Consistency:**
- [ ] Button styles consistent
- [ ] Color scheme consistent
- [ ] Spacing consistent
- [ ] Icons consistent style

---

## 13. Security Testing

### 13.1 Authentication Security

**Password Storage:**
- [ ] Passwords are hashed (check Supabase Auth)
- [ ] Not stored in plaintext
- [ ] Cannot retrieve raw password

**Session Security:**
- [ ] Session tokens in secure cookies/local storage
- [ ] Tokens expire after inactivity
- [ ] Cannot access app with expired token

**HTTPS:**
- [ ] App served over HTTPS in production
- [ ] No mixed content warnings
- [ ] Secure flag on cookies

### 13.2 Data Access Control

**Row Level Security (RLS):**
- [ ] Users can only see their own quizzes
- [ ] Cannot access other users' data via API manipulation
- [ ] Tutors can only see their students
- [ ] Students can only see their batches

**API Endpoint Security:**
- [ ] Cannot call Supabase functions without auth
- [ ] Cannot modify other users' data
- [ ] Database operations require valid user ID

### 13.3 Input Sanitization

**XSS Prevention:**
- [ ] User inputs are escaped
- [ ] HTML tags not executed
- [ ] Scripts not run from user input

**SQL Injection Prevention:**
- [ ] Parameterized queries (Supabase handles this)
- [ ] No raw SQL with user input
- [ ] Test with malicious inputs → Safely handled

---

## ✅ Testing Completion Checklist

### Before Declaring "Tested"

- [ ] **All authentication flows tested** (register, login, logout, OTP)
- [ ] **All student mode features tested** (dashboard, quiz creation, quiz taking, results)
- [ ] **All quiz types tested** (image-based, topic-based, shared quizzes)
- [ ] **All analytics tested** (performance, leaderboard, streaks, challenges)
- [ ] **All tutor mode features tested** (batches, students, assignments, analytics)
- [ ] **All modals and popups tested** (user profile, upgrade modal, share modal, etc.)
- [ ] **All edge cases tested** (empty states, errors, invalid inputs, network issues)
- [ ] **All devices tested** (desktop Chrome, Firefox, Edge, Safari, mobile browsers, tablets)
- [ ] **All screen sizes tested** (large desktop, laptop, tablet, mobile portrait/landscape)
- [ ] **Performance tested** (load times, quiz generation, database queries)
- [ ] **Accessibility tested** (keyboard nav, screen reader, color contrast)
- [ ] **Security tested** (authentication, data access, input sanitization)

### Production Readiness

- [ ] **Set TESTING_MODE = false** in code (line 2423)
- [ ] **Configure Razorpay live keys** (not test keys)
- [ ] **Test real payment flow** with small amount
- [ ] **Verify subscription limits enforce** correctly
- [ ] **Run database migration** (DATABASE_SUBSCRIPTION_SCHEMA.sql)
- [ ] **Set up daily/monthly cron jobs** for counter resets
- [ ] **Configure email automation** in Brevo
- [ ] **Enable RLS policies** on all Supabase tables
- [ ] **Set up monitoring** (error tracking, analytics)
- [ ] **Create backup strategy** for database
- [ ] **Test deployment** on staging environment
- [ ] **Final smoke test** on production

---

## 📝 Bug Tracking Template

When you find a bug, document it like this:

```
**Bug ID:** BUG-001
**Severity:** High / Medium / Low
**Feature:** Quiz Creation
**Description:** Image upload fails for PNG files > 3MB
**Steps to Reproduce:**
1. Go to New Quiz page
2. Upload PNG image of 4MB
3. Click upload
**Expected:** Image uploads successfully
**Actual:** Error: "Upload failed"
**Browser:** Chrome 120
**Device:** Desktop
**Screenshot:** [attach if available]
**Console Errors:** [paste errors]
**Status:** Open / In Progress / Fixed
**Fixed In:** [commit hash or version]
```

---

## 🎉 Completion

Once you've checked off all items:

1. **Review unchecked items** - Are they intentionally not tested? Document why.
2. **Document all bugs found** - Use the bug tracking template above.
3. **Prioritize bug fixes** - Critical bugs must be fixed before launch.
4. **Re-test after fixes** - Check off items again after bug fixes.
5. **Get stakeholder sign-off** - Show tested features to team/client.
6. **Prepare for launch** - Follow the Production Readiness checklist.

---

**Good luck with testing!** 🚀

This checklist is comprehensive but adapt it to your specific needs. Not every item may apply to your implementation.

**Remember:** Testing is iterative. Test, fix, re-test, repeat!
