import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/workout_session.dart';
import 'auth_service.dart';

class WorkoutService {
  static final WorkoutService _instance = WorkoutService._internal();
  factory WorkoutService() => _instance;
  WorkoutService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _auth = AuthService();

  // Calculate calories burned based on workout type
  int _calculateCaloriesBurned(String workoutId, int durationMinutes) {
    // Approximate calories per minute for different workout types
    final Map<String, int> caloriesPerMinute = {
      'strength_training': 8,
      'cardio_workouts': 10,
      'home_workouts': 7,
      'yoga_exercises': 3,
    };

    final baseCalories = caloriesPerMinute[workoutId] ?? 8;
    return baseCalories * durationMinutes;
  }

  // Record a completed workout
  Future<String?> recordWorkout({
    required String workoutId,
    required String workoutName,
    required int durationSeconds,
  }) async {
    final userId = _auth.currentUserId;
    if (userId == null) return 'Not signed in';

    try {
      final durationMinutes = (durationSeconds / 60).ceil();
      final caloriesBurned = _calculateCaloriesBurned(workoutId, durationMinutes);
      
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      
      final session = WorkoutSession(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        workoutName: workoutName,
        workoutId: workoutId,
        duration: durationSeconds,
        caloriesBurned: caloriesBurned,
        timestamp: now,
        date: today,
      );

      // Save workout session
      await _firestore
          .collection('workout_sessions')
          .doc(session.id)
          .set(session.toMap());

      // Update user's total stats
      await _updateUserStats(1, caloriesBurned);

      // Update streak
      await _updateStreak();

      print('✓ Workout recorded: $workoutName, $caloriesBurned calories');
      return null;
    } catch (e) {
      print('✗ Error recording workout: $e');
      return 'Error recording workout: $e';
    }
  }

  // Update user's total workout stats
  Future<void> _updateUserStats(int workoutCount, int calories) async {
    final userId = _auth.currentUserId;
    if (userId == null) return;

    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      
      if (userDoc.exists) {
        final currentData = userDoc.data() as Map<String, dynamic>;
        final currentWorkouts = currentData['workoutsCompleted'] ?? 0;
        final currentCalories = currentData['caloriesBurned'] ?? 0;
        
        await _firestore.collection('users').doc(userId).update({
          'workoutsCompleted': currentWorkouts + workoutCount,
          'caloriesBurned': currentCalories + calories,
          'lastWorkoutDate': DateTime.now().toIso8601String(),
        });
      }
    } catch (e) {
      print('Error updating user stats: $e');
    }
  }

  // Update user's workout streak
  Future<void> _updateStreak() async {
    final userId = _auth.currentUserId;
    if (userId == null) return;

    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      
      if (userDoc.exists) {
        final currentData = userDoc.data() as Map<String, dynamic>;
        final currentStreak = currentData['currentStreak'] ?? 0;
        final lastWorkoutDate = currentData['lastWorkoutDate'];
        
        int newStreak = 1;
        
        if (lastWorkoutDate != null) {
          final lastDate = DateTime.parse(lastWorkoutDate);
          final today = DateTime.now();
          final yesterday = today.subtract(const Duration(days: 1));
          
          // Check if last workout was yesterday (continuous streak)
          if (lastDate.year == yesterday.year &&
              lastDate.month == yesterday.month &&
              lastDate.day == yesterday.day) {
            newStreak = currentStreak + 1;
          } else if (lastDate.year == today.year &&
                     lastDate.month == today.month &&
                     lastDate.day == today.day) {
            // Already worked out today, keep current streak
            return;
          }
        }
        
        await _firestore.collection('users').doc(userId).update({
          'currentStreak': newStreak,
          'bestStreak': (currentData['bestStreak'] ?? 0) > newStreak 
              ? currentData['bestStreak'] 
              : newStreak,
        });
      }
    } catch (e) {
      print('Error updating streak: $e');
    }
  }

  // Get workout history
  Future<List<WorkoutSession>> getWorkoutHistory({int days = 7}) async {
    final userId = _auth.currentUserId;
    if (userId == null) return [];

    try {
      final cutoffDate = DateTime.now().subtract(Duration(days: days));
      
      final querySnapshot = await _firestore
          .collection('workout_sessions')
          .where('userId', isEqualTo: userId)
          .where('timestamp', isGreaterThan: cutoffDate.toIso8601String())
          .orderBy('timestamp', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => WorkoutSession.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print('Error getting workout history: $e');
      return [];
    }
  }

  // Get weekly workout stats
  Future<Map<String, int>> getWeeklyStats() async {
    final userId = _auth.currentUserId;
    if (userId == null) return {};

    try {
      final now = DateTime.now();
      final weekStart = now.subtract(Duration(days: now.weekday - 1));
      final weekStartDate = DateTime(weekStart.year, weekStart.month, weekStart.day);

      final querySnapshot = await _firestore
          .collection('workout_sessions')
          .where('userId', isEqualTo: userId)
          .where('date', isGreaterThan: weekStartDate.toIso8601String())
          .get();

      final Map<String, int> weeklyStats = {};
      
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final date = DateTime.parse(data['date']);
        final weekday = date.weekday; // 1 = Monday, 7 = Sunday
        
        if (!weeklyStats.containsKey(weekday.toString())) {
          weeklyStats[weekday.toString()] = 0;
        }
        weeklyStats[weekday.toString()] = 
            (weeklyStats[weekday.toString()] ?? 0) + (data['caloriesBurned'] as num? ?? 0).toInt();
      }

      return weeklyStats;
    } catch (e) {
      print('Error getting weekly stats: $e');
      return {};
    }
  }

  // Get user's streak information
  Future<Map<String, dynamic>> getStreakInfo() async {
    final userId = _auth.currentUserId;
    if (userId == null) return {};

    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      
      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        return {
          'currentStreak': data['currentStreak'] ?? 0,
          'bestStreak': data['bestStreak'] ?? 0,
          'lastWorkoutDate': data['lastWorkoutDate'],
        };
      }
      return {};
    } catch (e) {
      print('Error getting streak info: $e');
      return {};
    }
  }
}

