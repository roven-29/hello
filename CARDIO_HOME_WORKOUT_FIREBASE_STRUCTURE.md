# Firebase Data Structure for Cardio & Home Workouts

## Overview
This document outlines the Firebase Firestore data structure for the cardio and home workout systems, following the same pattern as the strength training system.

## Collections Structure

### 1. User Plans Collection (`user_plans`)
Stores user's plan selections for different workout types.

```json
{
  "id": "auto-generated-id",
  "type": "cardio" | "home" | "strength",
  "days": 7 | 30,
  "startDate": "2024-01-15T10:30:00Z",
  "userId": "user-uid-123"
}
```

### 2. User Progress Collection (`user_progress`)
Tracks individual user progress for each workout type.

#### Document Structure: `user_progress/{userId}/{workout_type}/current_progress`

**For Cardio Workouts:**
```json
{
  "last_completed_day": 3,
  "total_days": 7,
  "calories_burned": 450.5,
  "last_updated": "2024-01-18T14:30:00Z"
}
```

**For Home Workouts:**
```json
{
  "last_completed_day": 5,
  "total_days": 30,
  "calories_burned": 320.0,
  "last_updated": "2024-01-20T09:15:00Z"
}
```

### 3. Workout Data Collections

#### Cardio Workouts (`cardio_workouts`)
Stores exercise data for each day of cardio workouts.

**Document Structure: `cardio_workouts/day_{dayNumber}`**

```json
{
  "day": 1,
  "title": "Day 1 - Cardio Blast",
  "exercises": [
    {
      "name": "Jumping Jacks",
      "duration": 45,
      "instructions": "Jump feet apart while raising arms overhead",
      "calPerMin": 8.0,
      "isRest": false
    },
    {
      "name": "High Knees",
      "duration": 45,
      "instructions": "Run in place, bringing knees up high",
      "calPerMin": 9.0,
      "isRest": false
    },
    {
      "name": "Rest",
      "duration": 30,
      "instructions": "Take a break and hydrate",
      "calPerMin": 1.0,
      "isRest": true
    }
  ]
}
```

#### Home Workouts (`home_workouts`)
Stores exercise data for each day of home workouts.

**Document Structure: `home_workouts/day_{dayNumber}`**

```json
{
  "day": 1,
  "title": "Day 1 - Full Body Home Workout",
  "exercises": [
    {
      "name": "Bodyweight Squats",
      "duration": 45,
      "instructions": "Lower as if sitting in a chair, rise up",
      "calPerMin": 7.0,
      "isRest": false
    },
    {
      "name": "Push-ups",
      "duration": 45,
      "instructions": "Lower chest to ground, push back up",
      "calPerMin": 8.0,
      "isRest": false
    },
    {
      "name": "Rest",
      "duration": 30,
      "instructions": "Take a break and hydrate",
      "calPerMin": 1.0,
      "isRest": true
    }
  ]
}
```

### 4. Workout Sessions Collection (`workout_sessions`)
Tracks completed workout sessions for analytics.

```json
{
  "id": "1705324800000",
  "userId": "user-uid-123",
  "workoutName": "Cardio Workout",
  "workoutType": "cardio",
  "day": 1,
  "totalDays": 7,
  "duration": 1200,
  "caloriesBurned": 160,
  "timestamp": "2024-01-15T10:30:00Z",
  "date": "2024-01-15T00:00:00Z"
}
```

## Data Flow

### 1. Plan Selection
1. User selects cardio/home workout plan (7 or 30 days)
2. Plan saved to `user_plans` collection
3. User navigated to days list page

### 2. Progress Tracking
1. User completes a workout day
2. Progress updated in `user_progress/{userId}/{workout_type}/current_progress`
3. Workout session recorded in `workout_sessions`
4. User stats updated in `users` collection

### 3. Day Access Control
- Users can only access the next day after completing the current one
- Completed days show checkmark
- Locked days show lock icon
- Progress displayed as "X/Y days completed"

## Sample Data Setup

### Cardio Workout Day 1
```json
{
  "day": 1,
  "title": "Day 1 - Cardio Blast",
  "exercises": [
    {"name": "Jumping Jacks", "duration": 45, "calPerMin": 8.0, "isRest": false},
    {"name": "High Knees", "duration": 45, "calPerMin": 9.0, "isRest": false},
    {"name": "Burpees", "duration": 45, "calPerMin": 10.0, "isRest": false},
    {"name": "Mountain Climbers", "duration": 45, "calPerMin": 9.0, "isRest": false},
    {"name": "Rest", "duration": 30, "calPerMin": 1.0, "isRest": true},
    {"name": "Skater Jumps", "duration": 45, "calPerMin": 8.0, "isRest": false},
    {"name": "Butt Kicks", "duration": 45, "calPerMin": 7.0, "isRest": false},
    {"name": "Star Jumps", "duration": 45, "calPerMin": 8.0, "isRest": false},
    {"name": "Sprint in Place", "duration": 45, "calPerMin": 10.0, "isRest": false}
  ]
}
```

### Home Workout Day 1
```json
{
  "day": 1,
  "title": "Day 1 - Full Body Home Workout",
  "exercises": [
    {"name": "Bodyweight Squats", "duration": 45, "calPerMin": 7.0, "isRest": false},
    {"name": "Push-ups", "duration": 45, "calPerMin": 8.0, "isRest": false},
    {"name": "Lunges", "duration": 45, "calPerMin": 7.0, "isRest": false},
    {"name": "Plank Hold", "duration": 45, "calPerMin": 6.0, "isRest": false},
    {"name": "Rest", "duration": 30, "calPerMin": 1.0, "isRest": true},
    {"name": "Glute Bridges", "duration": 45, "calPerMin": 6.0, "isRest": false},
    {"name": "Dips", "duration": 45, "calPerMin": 7.0, "isRest": false},
    {"name": "Wall Sit", "duration": 45, "calPerMin": 6.0, "isRest": false},
    {"name": "Calf Raises", "duration": 45, "calPerMin": 5.0, "isRest": false}
  ]
}
```

## Security Rules

The existing Firestore rules already support this structure:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow all reads/writes for development
    match /{document=**} {
      allow read, write: if request.time < timestamp.date(2025, 12, 31);
    }
  }
}
```

## Implementation Notes

1. **Consistent Naming**: All collections follow the same pattern as strength training
2. **Progress Tracking**: Each workout type has its own progress subcollection
3. **Calorie Calculation**: Different workout types have different calorie burn rates
4. **Day Progression**: Users must complete days sequentially
5. **Data Persistence**: All progress is saved to Firebase for cross-device sync

This structure ensures consistency across all workout types while maintaining the same user experience and functionality.
