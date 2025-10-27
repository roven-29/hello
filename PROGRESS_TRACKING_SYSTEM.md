# Complete Progress Tracking System

## Overview
A comprehensive Firebase-based progress tracking system that automatically records workouts, calculates calories, tracks streaks, and displays real-time progress.

## What Was Created

### 1. New Models
**File: `lib/models/workout_session.dart`**
- Tracks individual workout sessions with:
  - Workout type and name
  - Duration in seconds
  - Calories burned (calculated)
  - Timestamp and date
  - User ID for Firebase queries

### 2. Workout Tracking Service
**File: `lib/services/workout_service.dart`**

#### Features:
- ✅ **Automatic calorie calculation** based on workout type
- ✅ **Workout recording** to Firestore `workout_sessions` collection
- ✅ **User stats update** (total workouts, total calories)
- ✅ **Streak tracking** (consecutive days)
- ✅ **Weekly stats** retrieval
- ✅ **Workout history** retrieval

#### Calorie Calculation:
```dart
- Strength Training: 8 cal/minute
- Cardio Workouts: 10 cal/minute
- Home Workouts: 7 cal/minute
- Yoga Exercises: 3 cal/minute
```

### 3. Updated Workout Timer
**File: `lib/screens/workout_timer_page.dart`**
- Automatically saves workout when completed
- Records to Firebase `workout_sessions` collection
- Updates user's total stats
- Updates streak counter

### 4. Real-Time Progress Tracker
**File: `lib/screens/progress_tracker_page.dart`**

#### What's Tracked:
1. **Weekly Workouts Chart** - Line graph showing workout calories per day
2. **Calories Burned Chart** - Bar graph of daily calories
3. **Summary Stats**:
   - Total Workouts Completed
   - Total Calories Burned
   - Current Streak (consecutive days)
   - Total Recent Workouts

#### Features:
- Pull-to-refresh to reload data
- Real-time data from Firebase
- Beautiful charts with FL Chart
- Loading state handling

### 5. Updated Home Page
**File: `lib/screens/home_page.dart`**
- Shows total workouts completed
- Shows total calories burned (formatted nicely)
- Automatically refreshes after workouts

## Firebase Data Structure

### User Document (`users` collection)
```json
{
  "email": "user@example.com",
  "name": "User Name",
  "workoutsCompleted": 10,
  "caloriesBurned": 850,
  "currentStreak": 5,
  "bestStreak": 12,
  "lastWorkoutDate": "2024-01-15T10:30:00Z"
}
```

### Workout Sessions (`workout_sessions` collection)
```json
{
  "id": "1705324800000",
  "userId": "user-id-123",
  "workoutName": "Strength Training",
  "workoutId": "strength_training",
  "duration": 1200,
  "caloriesBurned": 160,
  "timestamp": "2024-01-15T10:30:00Z",
  "date": "2024-01-15T00:00:00Z"
}
```

## How It Works

### When User Completes Workout:

1. **Timer finishes** all exercises
2. **Workout is recorded** to `workout_sessions`
3. **User stats updated**:
   - `workoutsCompleted` +1
   - `caloriesBurned` + calculated calories
4. **Streak updated**:
   - Checks if last workout was yesterday
   - Increases streak if continuous
   - Tracks best streak ever
5. **UI updates** automatically on next refresh

### Streak Logic:

```dart
- If last workout was yesterday → streak +1
- If last workout was today → streak stays same
- If last workout was > 1 day ago → reset to 1
- Always tracks best streak achieved
```

## User Experience

### Progress Tracker Page Shows:

1. **Weekly Workout Chart**
   - Line graph showing calories burned per day
   - Monday through Sunday
   - Real data from Firebase

2. **Calories Burned Chart**
   - Bar chart showing daily calories
   - Dynamic max value based on data

3. **Summary Cards**:
   - 🔵 **Workouts**: Total completed
   - 🔥 **Calories**: Total burned (formatted)
   - ✅ **Total Workouts**: This week's count
   - 🔥 **Streak**: Current consecutive days

4. **Pull to Refresh**:
   - Pull down to reload all data
   - Real-time Firebase sync

## Tracking Features

### Automatic Tracking:
- ✅ Workout completion → Saved to Firebase
- ✅ Calories calculated → Based on workout type
- ✅ Stats updated → Totals incremented
- ✅ Streak calculated → Consecutive days checked
- ✅ History stored → All workouts saved

### Manual Refresh:
- Pull down on Progress Tracker
- Data reloads from Firebase
- Charts update with latest data

## Benefits

1. **Motivation**: See total workouts and calories burned
2. **Consistency**: Streak tracking encourages daily workouts
3. **Insights**: Charts show weekly patterns
4. **Persistence**: All data saved in Firebase
5. **Real-time**: Data updates after each workout

## Files Created/Modified

### New Files:
- `lib/models/workout_session.dart`
- `lib/services/workout_service.dart`

### Modified Files:
- `lib/screens/workout_timer_page.dart` - Auto-save on completion
- `lib/screens/progress_tracker_page.dart` - Real Firebase data
- `lib/screens/home_page.dart` - Updated stats display

## Usage

### For Users:
1. Complete a workout → Data automatically saved
2. Go to Progress Tracker → See real stats
3. View charts → See weekly patterns
4. Check streak → Track consistency
5. Pull to refresh → Get latest data

### For Developers:
1. Workout completion triggers save
2. `WorkoutService().recordWorkout()` handles everything
3. Data stored in Firebase collections
4. Progress tracker reads from Firebase
5. Home page shows totals

## Next Steps

The progress tracking system is complete and working! Users can now:
1. Complete workouts
2. See their progress automatically tracked
3. View stats in real-time
4. Track their consistency (streaks)
5. Monitor their journey with charts

All data is safely stored in Firebase and updates automatically! 🎉

