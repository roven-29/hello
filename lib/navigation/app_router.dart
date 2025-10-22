import 'package:go_router/go_router.dart';
import '../screens/home_page.dart';
import '../screens/diet_plans_page.dart';
import '../screens/diet_category_page.dart';
import '../screens/meal_details_page.dart';
import '../screens/workouts_page.dart';
import '../screens/workout_category_page.dart';
import '../screens/exercise_timer_page.dart';
import '../screens/profile_page.dart';
import '../screens/progress_tracker_page.dart';
import '../screens/settings_page.dart';
import '../screens/welcome_page.dart';
import '../screens/login_page.dart';
import '../screens/register_page.dart';
import '../screens/user_details_page.dart';
import '../screens/splash_page.dart';
import '../screens/motivation_page.dart';
import '../screens/height_selection_page.dart';
import '../screens/weight_selection_page.dart';
import '../screens/goals_selection_page.dart';
import '../screens/home_workout_page.dart';
import '../screens/yoga_page.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/motivation',
      builder: (context, state) => const MotivationPage(),
    ),
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
      path: '/user-details',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return UserDetailsPage(
          email: extra?['email'] ?? '',
          password: extra?['password'] ?? '',
        );
      },
    ),
    GoRoute(
      path: '/height-selection',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return HeightSelectionPage(
          email: extra?['email'] ?? '',
          password: extra?['password'] ?? '',
          name: extra?['name'] ?? '',
          age: extra?['age'] ?? 25,
          gender: extra?['gender'] ?? 'Male',
        );
      },
    ),
    GoRoute(
      path: '/weight-selection',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return WeightSelectionPage(
          email: extra?['email'] ?? '',
          password: extra?['password'] ?? '',
          name: extra?['name'] ?? '',
          age: extra?['age'] ?? 25,
          gender: extra?['gender'] ?? 'Male',
          height: (extra?['height'] ?? 170.0).toDouble(),
        );
      },
    ),
    GoRoute(
      path: '/goals-selection',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return GoalsSelectionPage(
          email: extra?['email'] ?? '',
          password: extra?['password'] ?? '',
          name: extra?['name'] ?? '',
          age: extra?['age'] ?? 25,
          gender: extra?['gender'] ?? 'Male',
          height: (extra?['height'] ?? 170.0).toDouble(),
          weight: (extra?['weight'] ?? 70.0).toDouble(),
        );
      },
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
    GoRoute(
      path: '/home-workout',
      builder: (context, state) => const HomeWorkoutPage(),
    ),
    GoRoute(
      path: '/yoga',
      builder: (context, state) => const YogaPage(),
    ),
  ],
);
