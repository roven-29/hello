# Firestore Security Rules Setup Guide

## Problem
If you're getting "failed to load data from firestore" errors, it's likely due to Firestore security rules blocking read/write operations.

## Solution

### Step 1: Update Firestore Rules in Firebase Console

1. Go to https://console.firebase.google.com/
2. Select your project: **flex-mind-fit**
3. Click on **Firestore Database** in the left sidebar
4. Click on the **"Rules"** tab at the top
5. Replace the existing rules with the following:

```javascript
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    
    // Helper function to check if user is authenticated
    function isAuthenticated() {
      return request.auth != null;
    }
    
    // Helper function to check if user owns the document
    function isOwner(userId) {
      return isAuthenticated() && request.auth.uid == userId;
    }
    
    // Users collection - users can only read/write their own data
    match /users/{userId} {
      allow read: if isOwner(userId);
      allow create: if isAuthenticated() && request.auth.uid == userId;
      allow update: if isOwner(userId);
      allow delete: if isOwner(userId);
    }
    
    // Allow all reads/writes for development (remove in production)
    match /{document=**} {
      allow read, write: if request.time < timestamp.date(2025, 12, 31);
    }
  }
}
```

### Step 2: Publish the Rules

1. Click **"Publish"** button at the top
2. Rules will take effect immediately

## What These Rules Do

### For Users Collection:
- ✅ Users can only read their own data
- ✅ Users can only create documents for themselves
- ✅ Users can only update their own data
- ✅ Users can only delete their own data

### For Development:
- ⚠️ Allows all reads/writes temporarily (for testing)
- 🔒 **IMPORTANT**: Remove the last `match /{document=**}` block in production!

## Alternative: Temporarily Allow All Access (For Testing Only)

If you just want to test quickly, you can temporarily allow all access:

```javascript
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```

⚠️ **WARNING**: This allows anyone to read/write to your database. Only use this for testing, then update to the secure rules above.

## Verify Rules Are Working

1. Run your app
2. Sign in with an account
3. Check your IDE console for logs:
   - `✓ User document found in Firestore` - Success
   - `✗ Firebase error: permission-denied` - Rules issue
   - `✗ Firebase error: unavailable` - Connection issue

## Common Issues

### Issue: Still getting permission-denied errors

**Solution**: 
1. Make sure you've published the rules in Firebase Console
2. Wait a few seconds for rules to propagate
3. Sign out and sign back in
4. Check console logs for detailed error messages

### Issue: Cannot access Firestore

**Solution**:
1. Check if Firestore is enabled in Firebase Console
2. Click "Create Database" if it's not created yet
3. Choose "Start in test mode" for development
4. Select a location (us-central, etc.)

### Issue: Data not loading after rules update

**Solution**:
1. Clear app data/cache
2. Sign out and sign back in
3. Check that user document exists in Firestore Console
4. Check console logs for specific error codes

## Next Steps

After setting up the rules:
1. Your app should be able to read/write user data
2. Data will be secure (users can only access their own data)
3. You can test with the Firebase Test Page

## Security Note

The temporary open access rules should only be used for development and testing. For production, use the specific rules that only allow users to access their own data.

