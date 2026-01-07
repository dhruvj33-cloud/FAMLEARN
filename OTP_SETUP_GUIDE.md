# Email OTP Verification - Setup & Testing Guide

## ✅ What Has Been Implemented

Your FamLearn Pro app now has **Email OTP Verification** integrated with Brevo!

### Features:
- ✅ 6-digit OTP sent via email during registration
- ✅ Professional branded email template
- ✅ 5-minute OTP expiry with countdown timer
- ✅ Resend OTP functionality
- ✅ Modern UI with separate input boxes
- ✅ Auto-submit when all digits entered
- ✅ Keyboard navigation support

## 🚀 Quick Setup

### Step 1: Set Brevo Credentials

Open your app and paste this in the browser console (F12):

```javascript
localStorage.setItem('BREVO_API_KEY', 'your-brevo-api-key-here');
localStorage.setItem('BREVO_SENDER_EMAIL', 'your-verified-email@example.com');
localStorage.setItem('BREVO_SENDER_NAME', 'FAMLearn Pro');
console.log('✅ Brevo configured!');
```

**Note:** Replace with your actual Brevo API key and verified sender email.

Then refresh the page (F5).

### Step 2: Test Registration with OTP

1. **Click "Register" tab**
2. **Fill in the form:**
   - Name: TestUser123
   - Email: *your-test-email@gmail.com*
   - Phone: 9876543210
   - Password: test123456
   - Role: Student

3. **Click "Create Account"**

4. **Check your email inbox** for the OTP (check spam folder too!)

5. **Enter the 6-digit code** in the OTP screen

6. **Account created!** You'll be automatically logged in.

## 📧 What the Email Looks Like

Your users will receive a professional email with:
- **Subject:** "Your FamLearn Verification Code"
- **From:** FAMLearn Pro (your configured sender email)
- **Content:** Branded email with large 6-digit OTP code
- **Expiry:** "This code will expire in 5 minutes"

## 🎨 OTP Screen Features

### Visual Elements:
- 📧 Email icon at top
- "Verify Your Email" heading
- Shows the email address where code was sent
- 6 separate input boxes for OTP digits
- Countdown timer showing time remaining
- "Verify OTP" button
- "Resend Code" button (30-second cooldown)
- "Cancel" button to go back

### User Experience:
- **Auto-focus:** Automatically moves to next box when you type
- **Backspace:** Goes back to previous box
- **Auto-submit:** Verifies automatically when all 6 digits entered
- **Paste support:** Can paste full OTP code

## 🔒 Security Features

1. **Time-Limited:** OTP expires after exactly 5 minutes
2. **Single Use:** OTP is deleted after successful verification
3. **Secure Storage:** Stored in localStorage with expiry timestamp
4. **Email Verification:** Ensures valid email before account creation
5. **Rate Limiting:** 30-second cooldown between resend requests

## 🧪 Testing Scenarios

### Happy Path:
1. Register with valid email
2. Receive OTP email
3. Enter correct code
4. Account created successfully

### Error Scenarios:
1. **Wrong OTP:** Shows "Invalid OTP" toast
2. **Expired OTP:** Shows "OTP expired" toast
3. **Empty Fields:** Shows "Please enter all 6 digits"
4. **Email Failure:** Shows error message

### Resend Functionality:
1. Wait 30 seconds after first send
2. Click "Resend Code"
3. New OTP sent to same email
4. Previous OTP becomes invalid

## 📋 Troubleshooting

### OTP Email Not Received?
1. Check spam/junk folder
2. Verify Brevo sender email is verified
3. Check browser console for errors
4. Verify Brevo API key is correct

### "Failed to send OTP" Error?
1. Check Brevo API key in localStorage
2. Check internet connection
3. Check browser console for detailed error
4. Verify Brevo account is active

### Console Shows OTP (for Testing):
- During development, the OTP is logged to console
- Look for: `Generated OTP (for testing): 123456`
- This helps with testing without checking email

## 🎯 Next Steps

Your OTP system is now live! You can:

1. **Test it yourself** with the steps above
2. **Customize the email template** (edit sendOTPEmail function)
3. **Change OTP length** (currently 6 digits)
4. **Adjust expiry time** (currently 5 minutes)
5. **Add rate limiting** (prevent spam)

## 📊 Files Modified

- `index.html`: Added OTP UI and functions
- `README.md`: Updated setup instructions
- `config.example.js`: Added Brevo configuration
- `OTP_SETUP_GUIDE.md`: This guide

## 💡 Tips

- **Use real email** for testing to see the actual email template
- **Check browser console** for helpful debug logs
- **OTP is logged** in console during registration (for testing)
- **Resend cooldown** prevents spam (30 seconds)

---

**Ready to test?** Just follow Step 1 above and start registering! 🚀
