# Firebase Connection Testing Guide

## Overview
This guide will help you test if your Firebase connection is working correctly, especially for email authentication and data upload to Firestore.

## How to Access the Test Page

### Method 1: Through Settings
1. Run your app
2. Sign in (or create a new account)
3. Go to **Home** → Tap **Settings** (bottom navigation)
4. Scroll down to **Account** section
5. Tap on **"Firebase Connection Test"**
6. You'll be taken to the test page

### Method 2: Direct URL
Open your app and navigate to: `/firebase-test`

## Testing Steps

### Step 1: Test Sign Up
1. Enter a test email (e.g., `test@example.com`)
2. Enter a password (e.g., `test123456`)
3. Enter a name
4. Tap **"Test Sign Up"**
5. Check the status message:
   - ✅ **Green/Success**: User created successfully in Firebase Auth
   - ❌ **Red/Error**: Check the error message

### Step 2: Test Sign In
1. Use the same email/password from Step 1
2. Tap **"Test Sign In"**
3. Check the status message:
   - ✅ **Green/Success**: Connected to Firebase Auth successfully
   - ❌ **Red/Error**: Check the error message

### Step 3: Test Load User Data
1. After signing in, tap **"Load User Data"**
2. This will fetch data from Firestore
3. Check the status message:
   - ✅ **Green/Success**: Data loaded from Firestore successfully
   - ⚠️ **Warning**: Data is null (might need to be created)
4. If successful, you'll see the user data displayed below

### Step 4: Test Update User Data
1. Tap **"Update User Data"**
2. This will update/add a test field to Firestore
3. Check the status message:
   - ✅ **Green/Success**: Data updated in Firestore successfully
   - ❌ **Red/Error**: Check the error message
4. The user data display will refresh with updated information

## What to Check

### In Your App:
1. **Status Messages**: Look for green checkmarks (✓) for success, red X (✗) for errors
2. **User Data Display**: After successful operations, you should see user data displayed
3. **Console Logs**: Check your IDE console for detailed logs

### In Firebase Console:
1. Go to https://console.firebase.google.com/
2. Select your project: **flex-mind-fit**
3. Check **Authentication** tab:
   - You should see users you've created
   - Check if your test email is listed
4. Check **Firestore Database** tab:
   - Navigate to `users` collection
   - You should see documents with user IDs
   - Click on a document to see its data

## Expected Behavior

### Successful Connection:
- ✅ Sign up creates user in Firebase Auth
- ✅ User data is created in Firestore `users` collection
- ✅ Sign in authenticates the user
- ✅ User data can be loaded from Firestore
- ✅ User data can be updated in Firestore

### If You See Errors:

#### "Sign up failed: email-already-in-use"
- This email already exists
- Try a different email or use "Test Sign In" instead

#### "Sign in failed: user-not-found"
- User doesn't exist yet
- First run "Test Sign Up" to create the user

#### "Error loading user data" or "Failed to load data"
- Check if you have internet connection
- Check Firebase console to see if the document exists
- The app should automatically create default data if missing

## Console Logs to Watch

In your IDE console, you should see:
- `Firebase initialized successfully`
- `User data created successfully in Firestore`
- `User document missing, creating default data...`
- `Created default user data in Firestore`
- `User data updated successfully`
- `Error getting user data: [error details]`

## Verification Checklist

- [ ] App launches without Firebase initialization errors
- [ ] Test Sign Up creates user in Firebase Auth
- [ ] User appears in Firebase Console → Authentication
- [ ] User data appears in Firebase Console → Firestore → users collection
- [ ] Test Sign In authenticates successfully
- [ ] Load User Data fetches data from Firestore
- [ ] Update User Data saves changes to Firestore

## Troubleshooting

### Issue: Firebase not initialized
**Solution**: Check `lib/main.dart` for Firebase initialization

### Issue: Can't connect to Firestore
**Solution**: Check your internet connection and Firebase configuration

### Issue: Data not saving
**Solution**: Check Firebase Console to ensure Firestore is enabled
- Go to Firebase Console → Firestore Database
- Make sure it's initialized

### Issue: No data in Firestore
**Solution**: The app now auto-creates default data if missing
- Try the "Load User Data" button again
- Check Firebase Console to see if data was created

## Testing Different Scenarios

### Test New User Flow:
1. Use a **new email** that doesn't exist
2. Complete all test steps
3. Check Firebase Console to verify data creation

### Test Existing User:
1. Use an email that already exists
2. Start with "Test Sign In" (not sign up)
3. Verify data loads correctly

### Test Error Handling:
1. Turn off internet
2. Try operations
3. Check error messages
4. Turn internet back on
5. Verify operations work

## Next Steps

Once testing is complete:
1. The Firebase connection is working
2. Your email/password authentication is functional
3. Data is being saved to Firestore
4. You can confidently use the app

**Note**: The test page is for development/testing only. In production, users will use the normal registration/login flow.

