# FlexMind Fit - Complete Fitness App

A comprehensive Flutter fitness application with diet plans, workout routines, and progress tracking.

## Features

### 🏠 Home Page
- Clean blue & white UI design
- Personalized welcome message
- Quick access to Diet Plans and Workouts
- User statistics display (workouts completed, calories burned)
- Bottom navigation bar

### 🍎 Diet Plans
- Multiple diet categories (Weight Loss, Muscle Gain, Balanced Diet, Vegan)
- Detailed meal information with ingredients and nutritional breakdown
- Meal preparation tips and recipes
- "Add to My Plan" functionality

### 💪 Workouts
- Various workout categories (Upper Body, Lower Body, Abs, Full Body, Fat Loss)
- Exercise timer with countdown functionality
- Exercise instructions and guidance
- Completion celebration with confetti animation

### 👤 Profile Page
- User information display
- Progress statistics
- Edit profile functionality
- Log out option

### 📊 Progress Tracker
- Interactive charts for weekly workouts
- Calories burned visualization
- Weight progress tracking
- Weekly summary statistics

### ⚙️ Settings
- Dark mode toggle
- Notification preferences
- Workout and meal reminders
- Language selection
- Account management options

## Technical Features

- **Navigation**: GoRouter for type-safe navigation
- **Charts**: FL Chart for beautiful data visualization
- **Animations**: Confetti animations for workout completion
- **State Management**: SharedPreferences for settings persistence
- **Responsive Design**: Works on all screen sizes
- **Modern UI**: Material Design 3 with custom blue theme

## Dependencies

- `go_router`: ^14.2.7 - Navigation
- `fl_chart`: ^0.68.0 - Charts and graphs
- `confetti`: ^0.7.0 - Celebration animations
- `shared_preferences`: ^2.2.2 - Settings persistence

## Getting Started

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the app

## App Structure

```
lib/
├── main.dart                 # App entry point
├── navigation/
│   └── app_router.dart      # Navigation configuration
├── models/
│   ├── meal.dart            # Meal data model
│   ├── exercise.dart         # Exercise data model
│   └── user.dart            # User data model
├── data/
│   └── dummy_data.dart       # Sample data for meals and workouts
└── screens/
    ├── home_page.dart        # Main home screen
    ├── diet_plans_page.dart  # Diet categories
    ├── diet_category_page.dart # Meals in category
    ├── meal_details_page.dart # Individual meal details
    ├── workouts_page.dart    # Workout categories
    ├── workout_category_page.dart # Exercises in category
    ├── exercise_timer_page.dart # Exercise timer
    ├── profile_page.dart     # User profile
    ├── progress_tracker_page.dart # Charts and progress
    └── settings_page.dart    # App settings
```

## Design System

- **Primary Color**: #007BFF (Blue)
- **Secondary Colors**: Green (#4CAF50), Orange (#FF5722), Red (#FF9800)
- **Typography**: Modern, rounded fonts with proper hierarchy
- **Cards**: Rounded corners (16-20px radius) with subtle shadows
- **Gradients**: Light blue gradients for backgrounds
- **Icons**: Material Icons with consistent sizing

## Future Enhancements

- Backend integration for real user data
- Social features and community
- Advanced workout tracking
- Meal planning calendar
- Push notifications
- Offline support
- Multiple language support

## Screenshots

The app features a modern, clean interface with:
- Gradient backgrounds
- Card-based layouts
- Interactive charts
- Smooth animations
- Intuitive navigation

## License

This project is created for demonstration purposes.
