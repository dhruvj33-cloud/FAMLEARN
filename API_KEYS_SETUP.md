# 🔑 API Keys Setup Guide - Fix "KEY NOT FOUND" Error

This guide shows you exactly which API keys are needed and how to configure them.

---

## ❌ The "KEY NOT FOUND" Error

This error occurs when **Brevo Email API key** is missing or invalid during registration. The app tries to send an OTP email but fails because the API key is not configured.

---

## 📋 Required API Keys

### For Registration to Work (REQUIRED):

1. **Supabase URL** - Database and authentication
2. **Supabase Anon Key** - Database access
3. **Brevo API Key** - Email OTP verification ⚠️ **This is likely missing!**
4. **Brevo Sender Email** - Verified email address
5. **Brevo Sender Name** - Display name in emails

### For Quiz Generation (REQUIRED for quizzes):

6. **GROQ API Key** - AI quiz generation

### For Payments (OPTIONAL in testing mode):

7. **Razorpay Key ID** - Payment processing (optional in testing mode)

---

## 🚀 Quick Fix - Set All Keys in Browser Console

**Step 1:** Open your browser console
- **Chrome/Edge:** Press `F12` or `Ctrl+Shift+J` (Windows) / `Cmd+Option+J` (Mac)
- **Firefox:** Press `F12` or `Ctrl+Shift+K` (Windows) / `Cmd+Option+K` (Mac)
- **Safari:** Enable Developer menu first, then `Cmd+Option+C`

**Step 2:** Copy and paste this entire block (replace with your actual keys):

```javascript
// ===== SUPABASE KEYS (Get from supabase.com dashboard) =====
localStorage.setItem('SUPABASE_URL', 'https://your-project.supabase.co');
localStorage.setItem('SUPABASE_KEY', 'your-supabase-anon-key-here');

// ===== BREVO KEYS (Get from brevo.com dashboard) ⚠️ REQUIRED FOR REGISTRATION =====
localStorage.setItem('BREVO_API_KEY', 'xkeysib-your-brevo-api-key-here');
localStorage.setItem('BREVO_SENDER_EMAIL', 'your-verified-email@example.com');
localStorage.setItem('BREVO_SENDER_NAME', 'FamLearn Pro');

// ===== GROQ API KEY (Get from console.groq.com) =====
localStorage.setItem('GROQ_API_KEY', 'gsk_your-groq-api-key-here');

// ===== RAZORPAY KEY (Optional in testing mode) =====
localStorage.setItem('RAZORPAY_KEY_ID', 'rzp_test_XXXXXXXXXXXX');

console.log('✅ All API keys configured!');
```

**Step 3:** Press `Enter` to execute

**Step 4:** Refresh the page (`F5` or `Ctrl+R`)

**Step 5:** Try registration again

---

## 🔍 Check Which Keys Are Missing

Run this in browser console to see what's configured:

```javascript
console.log('=== API KEYS STATUS ===');
console.log('Supabase URL:', localStorage.getItem('SUPABASE_URL') || '❌ NOT SET');
console.log('Supabase Key:', localStorage.getItem('SUPABASE_KEY') ? '✅ SET' : '❌ NOT SET');
console.log('Brevo API Key:', localStorage.getItem('BREVO_API_KEY') ? '✅ SET' : '❌ NOT SET');
console.log('Brevo Sender Email:', localStorage.getItem('BREVO_SENDER_EMAIL') || '❌ NOT SET');
console.log('Brevo Sender Name:', localStorage.getItem('BREVO_SENDER_NAME') || '❌ NOT SET');
console.log('GROQ API Key:', localStorage.getItem('GROQ_API_KEY') ? '✅ SET' : '❌ NOT SET');
console.log('Razorpay Key:', localStorage.getItem('RAZORPAY_KEY_ID') ? '✅ SET' : '❌ NOT SET');
```

**Expected Output:**
```
=== API KEYS STATUS ===
Supabase URL: https://xxxxx.supabase.co
Supabase Key: ✅ SET
Brevo API Key: ✅ SET
Brevo Sender Email: you@example.com
Brevo Sender Name: FamLearn Pro
GROQ API Key: ✅ SET
Razorpay Key: ✅ SET
```

---

## 📝 Detailed Setup for Each API Key

### 1. Supabase Setup

**Get Your Keys:**
1. Go to [supabase.com](https://supabase.com)
2. Login or create account
3. Click on your project
4. Go to **Settings** (gear icon) → **API**
5. Copy:
   - **Project URL** (e.g., `https://abc123.supabase.co`)
   - **Anon/Public Key** (long string starting with `eyJ...`)

**Set in Browser:**
```javascript
localStorage.setItem('SUPABASE_URL', 'https://abc123.supabase.co');
localStorage.setItem('SUPABASE_KEY', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...');
```

### 2. Brevo Email API Setup ⚠️ **CRITICAL FOR REGISTRATION**

**Why You Need This:**
- Registration requires email OTP verification
- Brevo (formerly Sendinblue) sends the OTP emails
- **Without this, registration will fail with "KEY NOT FOUND"**

**Get Your API Key:**
1. Go to [brevo.com](https://www.brevo.com) (formerly sendinblue.com)
2. **Create FREE account** (no credit card needed)
3. **Verify your sender email:**
   - Go to **Senders** → **Domains & IPs**
   - Add your email (e.g., `you@gmail.com`)
   - Click verification link sent to that email
   - ⚠️ Email must be verified or OTP emails won't send!
4. Get API Key:
   - Go to **Settings** → **SMTP & API**
   - Click **API Keys**
   - Click **Create a new API key**
   - Give it a name: "FamLearn OTP"
   - Copy the key (starts with `xkeysib-...`)

**Set in Browser:**
```javascript
localStorage.setItem('BREVO_API_KEY', 'xkeysib-abc123def456...');
localStorage.setItem('BREVO_SENDER_EMAIL', 'your-verified-email@gmail.com');
localStorage.setItem('BREVO_SENDER_NAME', 'FamLearn Pro');
```

**Important:**
- Use the SAME email you verified in Brevo
- Free tier: 300 emails/day (enough for testing)
- If email doesn't arrive, check spam folder

### 3. GROQ API Setup

**Get Your API Key:**
1. Go to [console.groq.com](https://console.groq.com)
2. Login with Google/GitHub or create account
3. Go to **API Keys**
4. Click **Create API Key**
5. Give it a name: "FamLearn Quiz Generation"
6. Copy the key (starts with `gsk_...`)

**Set in Browser:**
```javascript
localStorage.setItem('GROQ_API_KEY', 'gsk_abc123def456...');
```

### 4. Razorpay Setup (Optional in Testing Mode)

**For Testing Mode (TESTING_MODE = true):**
- ✅ **NOT REQUIRED** - payments are bypassed
- You can skip this completely

**For Production Mode (TESTING_MODE = false):**
1. Go to [razorpay.com](https://razorpay.com)
2. Create account
3. Use **Test Mode** (no KYC needed)
4. Go to **Settings** → **API Keys**
5. Generate **Test Keys**
6. Copy **Key ID** (starts with `rzp_test_...`)

**Set in Browser:**
```javascript
localStorage.setItem('RAZORPAY_KEY_ID', 'rzp_test_XXXXXXXXXXXX');
```

---

## 🐛 Troubleshooting Registration Errors

### Error: "KEY NOT FOUND"

**Cause:** Brevo API key is missing or invalid

**Solution:**
1. Check key is set:
   ```javascript
   console.log(localStorage.getItem('BREVO_API_KEY'));
   ```
2. If shows `null` or `YOUR_BREVO_API_KEY` → Key not set
3. Set the key following instructions above
4. Refresh page and try again

### Error: "Failed to send verification code"

**Possible Causes:**

**1. Brevo API Key Invalid**
- Key is wrong or expired
- Get new key from Brevo dashboard

**2. Sender Email Not Verified**
- Go to Brevo → Senders
- Make sure email has green checkmark
- If not, verify the email

**3. Brevo Account Suspended**
- Check Brevo dashboard for warnings
- Make sure account is active

**4. Network Error**
- Check internet connection
- Check browser console for detailed error

### Error: "Invalid login credentials" (after registration)

**Cause:** Supabase keys not configured

**Solution:**
1. Set Supabase URL and Key
2. Make sure they're correct
3. Refresh page
4. Try registration again

### OTP Email Not Received

**Check:**
1. ✅ Brevo API key is set correctly
2. ✅ Sender email is verified in Brevo
3. ✅ Check spam/junk folder
4. ✅ Wait 1-2 minutes (sometimes delayed)
5. ✅ Check Brevo dashboard logs (Campaigns → Email Logs)

**Quick Test:**
```javascript
// Check if OTP was generated (appears in console during registration)
// Look for: "Generated OTP (for testing): 123456"
// If you see this, you can use it to bypass email
```

### Browser Console Errors

**Open Console (F12) and look for:**

**1. "api-key not found"**
- Brevo API key is missing
- Set `BREVO_API_KEY` in localStorage

**2. "sender not authorized"**
- Sender email not verified in Brevo
- Verify email in Brevo dashboard

**3. "Failed to fetch"**
- Network error
- Check internet connection
- Check if Brevo API is down (status.brevo.com)

**4. "CORS error"**
- Not an API key issue
- This shouldn't happen with Brevo API

---

## ✅ Verification Checklist

Run this complete verification script:

```javascript
console.log('=== FAMLEARN API CONFIGURATION CHECK ===\n');

// Check Supabase
const supabaseUrl = localStorage.getItem('SUPABASE_URL');
const supabaseKey = localStorage.getItem('SUPABASE_KEY');
console.log('1. SUPABASE:');
console.log('   URL:', supabaseUrl || '❌ NOT SET');
console.log('   Key:', supabaseKey ? `✅ SET (${supabaseKey.substring(0,20)}...)` : '❌ NOT SET');
console.log('   Status:', (supabaseUrl && supabaseKey && supabaseUrl !== 'YOUR_SUPABASE_URL') ? '✅ CONFIGURED' : '❌ NOT CONFIGURED');
console.log('');

// Check Brevo (CRITICAL for registration)
const brevoKey = localStorage.getItem('BREVO_API_KEY');
const brevoEmail = localStorage.getItem('BREVO_SENDER_EMAIL');
const brevoName = localStorage.getItem('BREVO_SENDER_NAME');
console.log('2. BREVO (OTP Email) ⚠️ REQUIRED:');
console.log('   API Key:', brevoKey ? `✅ SET (${brevoKey.substring(0,15)}...)` : '❌ NOT SET');
console.log('   Sender Email:', brevoEmail || '❌ NOT SET');
console.log('   Sender Name:', brevoName || '❌ NOT SET');
console.log('   Status:', (brevoKey && brevoEmail && brevoKey !== 'YOUR_BREVO_API_KEY') ? '✅ CONFIGURED' : '❌ NOT CONFIGURED');
console.log('');

// Check GROQ
const groqKey = localStorage.getItem('GROQ_API_KEY');
console.log('3. GROQ (Quiz Generation):');
console.log('   API Key:', groqKey ? `✅ SET (${groqKey.substring(0,15)}...)` : '❌ NOT SET');
console.log('   Status:', (groqKey && groqKey !== 'YOUR_GROQ_API_KEY') ? '✅ CONFIGURED' : '❌ NOT CONFIGURED');
console.log('');

// Check Razorpay
const razorpayKey = localStorage.getItem('RAZORPAY_KEY_ID');
console.log('4. RAZORPAY (Payments):');
console.log('   Key ID:', razorpayKey ? `✅ SET (${razorpayKey.substring(0,15)}...)` : '❌ NOT SET');
console.log('   Status:', (razorpayKey && razorpayKey !== 'YOUR_RAZORPAY_KEY_ID') ? '✅ CONFIGURED' : '⚠️ OPTIONAL (testing mode)');
console.log('');

// Overall status
const registrationReady = supabaseUrl && supabaseKey && brevoKey && brevoEmail &&
                         supabaseUrl !== 'YOUR_SUPABASE_URL' && brevoKey !== 'YOUR_BREVO_API_KEY';
const quizReady = groqKey && groqKey !== 'YOUR_GROQ_API_KEY';

console.log('=== OVERALL STATUS ===');
console.log('Registration Ready:', registrationReady ? '✅ YES' : '❌ NO');
console.log('Quiz Generation Ready:', quizReady ? '✅ YES' : '❌ NO');
console.log('');

if (!registrationReady) {
    console.log('⚠️ REGISTRATION WILL FAIL - Missing keys:');
    if (!supabaseUrl || supabaseUrl === 'YOUR_SUPABASE_URL') console.log('   - Supabase URL');
    if (!supabaseKey || supabaseKey === 'YOUR_SUPABASE_ANON_KEY') console.log('   - Supabase Key');
    if (!brevoKey || brevoKey === 'YOUR_BREVO_API_KEY') console.log('   - Brevo API Key ⚠️ CRITICAL');
    if (!brevoEmail || brevoEmail === 'noreply@famlearn.com') console.log('   - Brevo Sender Email');
}
```

**Expected Output for Full Configuration:**
```
=== FAMLEARN API CONFIGURATION CHECK ===

1. SUPABASE:
   URL: https://abc123.supabase.co
   Key: ✅ SET (eyJhbGciOiJIUzI1NiI...)
   Status: ✅ CONFIGURED

2. BREVO (OTP Email) ⚠️ REQUIRED:
   API Key: ✅ SET (xkeysib-abc123d...)
   Sender Email: you@gmail.com
   Sender Name: FamLearn Pro
   Status: ✅ CONFIGURED

3. GROQ (Quiz Generation):
   API Key: ✅ SET (gsk_abc123def45...)
   Status: ✅ CONFIGURED

4. RAZORPAY (Payments):
   Key ID: ✅ SET (rzp_test_XXXXXX...)
   Status: ✅ CONFIGURED

=== OVERALL STATUS ===
Registration Ready: ✅ YES
Quiz Generation Ready: ✅ YES
```

---

## 🎯 Step-by-Step Registration Test

After setting all keys:

1. **Verify Keys:**
   ```javascript
   console.log('Brevo Key:', localStorage.getItem('BREVO_API_KEY'));
   console.log('Supabase URL:', localStorage.getItem('SUPABASE_URL'));
   ```

2. **Refresh Page:** `F5` or `Ctrl+R`

3. **Open Browser Console:** `F12` → Console tab

4. **Try Registration:**
   - Fill in registration form
   - Click "Create Account"
   - Watch console for logs

5. **Expected Console Output:**
   ```
   === REGISTRATION WITH OTP STARTED ===
   Generated OTP (for testing): 123456
   === OTP SENT SUCCESSFULLY ===
   ```

6. **Check Email:**
   - Check inbox for OTP email
   - Check spam folder if not in inbox
   - Email subject: "Your FamLearn Verification Code"

7. **Enter OTP:**
   - Enter the 6-digit code
   - Should auto-submit

8. **Success:**
   - Redirected to dashboard
   - Console: "=== REGISTRATION COMPLETED ==="

---

## 🔐 Security Notes

**Important:**
- ✅ **Safe:** These keys are safe to store in localStorage for client-side apps
- ✅ **Public Keys:** Supabase Anon Key and Razorpay Test Key are meant to be public
- ✅ **RLS Protection:** Supabase Row Level Security protects your data
- ⚠️ **Don't Commit:** Never commit real API keys to Git
- ⚠️ **Use .env:** In production, use environment variables

**Current Setup:**
- Keys in localStorage (client-side)
- No `.env` file (all keys set via console)
- Safe for development and testing

---

## 📞 Still Having Issues?

**Collect This Information:**

1. **Browser Console Output:**
   - Press F12 → Console
   - Copy ALL error messages (right-click → Save as...)

2. **API Keys Status:**
   - Run the verification script above
   - Copy the output

3. **Network Tab:**
   - F12 → Network tab
   - Try registration
   - Look for failed requests (red)
   - Click on failed request → Response tab
   - Copy the error message

4. **Brevo Dashboard:**
   - Check email logs: Campaigns → Email Logs
   - See if emails are being sent
   - Check for errors

**Common Solutions:**
- 90% of the time: Brevo API key not set
- 9% of the time: Sender email not verified
- 1% of the time: Network/API issues

---

## 🚀 Quick Start (Copy-Paste)

If you just want to get started quickly:

```javascript
// Run this in browser console (F12)
// Replace YOUR_* with actual keys

localStorage.setItem('SUPABASE_URL', 'YOUR_SUPABASE_PROJECT_URL');
localStorage.setItem('SUPABASE_KEY', 'YOUR_SUPABASE_ANON_KEY');
localStorage.setItem('BREVO_API_KEY', 'YOUR_BREVO_API_KEY');
localStorage.setItem('BREVO_SENDER_EMAIL', 'YOUR_VERIFIED_EMAIL');
localStorage.setItem('BREVO_SENDER_NAME', 'FamLearn Pro');
localStorage.setItem('GROQ_API_KEY', 'YOUR_GROQ_API_KEY');

// Refresh page
location.reload();
```

Then try registration!

---

**That's it!** If you follow this guide, your registration should work. The "KEY NOT FOUND" error specifically means the Brevo API key is missing or invalid.
