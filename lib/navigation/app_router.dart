import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/home_page.dart';
import 'screens/diet_plans_page.dart';
import 'screens/diet_category_page.dart';
import 'screens/meal_details_page.dart';
import 'screens/workouts_page.dart';
import 'screens/workout_category_page.dart';
import 'screens/exercise_timer_page.dart';
import 'screens/profile_page.dart';
import 'screens/progress_tracker_page.dart';
import 'screens/settings_page.dart';
import 'screens/welcome_page.dart';
import 'screens/login_page.dart';
import 'screens/register_page.dart';

final GoRouter router = GoRouter(
  initialLocation: '/welcome',
  routes: [
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomePage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/diet-plans',
      builder: (context, state) => const DietPlansPage(),
    ),
    GoRoute(
      path: '/diet-category/:categoryId',
      builder: (context, state) {
        final categoryId = state.pathParameters['categoryId']!;
        return DietCategoryPage(categoryId: categoryId);
      },
    ),
    GoRoute(
      path: '/meal-details/:mealId',
      builder: (context, state) {
        final mealId = state.pathParameters['mealId']!;
        return MealDetailsPage(mealId: mealId);
      },
    ),
    GoRoute(
      path: '/workouts',
      builder: (context, state) => const WorkoutsPage(),
    ),
    GoRoute(
      path: '/workout-category/:categoryId',
      builder: (context, state) {
        final categoryId = state.pathParameters['categoryId']!;
        return WorkoutCategoryPage(categoryId: categoryId);
      },
    ),
    GoRoute(
      path: '/exercise-timer/:exerciseId',
      builder: (context, state) {
        final exerciseId = state.pathParameters['exerciseId']!;
        return ExerciseTimerPage(exerciseId: exerciseId);
      },
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfilePage(),
    ),
    GoRoute(
      path: '/progress-tracker',
      builder: (context, state) => const ProgressTrackerPage(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsPage(),
    ),
  ],
);
