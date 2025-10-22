import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/exercise.dart';

class HomeWorkoutPage extends StatefulWidget {
  const HomeWorkoutPage({super.key});

  @override
  State<HomeWorkoutPage> createState() => _HomeWorkoutPageState();
}

class _HomeWorkoutPageState extends State<HomeWorkoutPage> {
  final List<Map<String, dynamic>> _homeWorkouts = [
    {
      'title': 'Quick Morning Routine',
      'duration': '15 min',
      'difficulty': 'Beginner',
      'exercises': 8,
      'color': Color(0xFF4CAF50),
      'icon': Icons.wb_sunny,
      'description': 'Start your day with energy',
    },
    {
      'title': 'Full Body Blast',
      'duration': '30 min',
      'difficulty': 'Intermediate',
      'exercises': 12,
      'color': Color(0xFFFF5722),
      'icon': Icons.fitness_center,
      'description': 'Complete body workout',
    },
    {
      'title': 'Core Strengthener',
      'duration': '20 min',
      'difficulty': 'Intermediate',
      'exercises': 10,
      'color': Color(0xFF2196F3),
      'icon': Icons.accessibility_new,
      'description': 'Build a strong core',
    },
    {
      'title': 'Cardio Burn',
      'duration': '25 min',
      'difficulty': 'Advanced',
      'exercises': 15,
      'color': Color(0xFFE91E63),
      'icon': Icons.favorite,
      'description': 'High-intensity cardio',
    },
    {
      'title': 'Flexibility Flow',
      'duration': '20 min',
      'difficulty': 'Beginner',
      'exercises': 6,
      'color': Color(0xFF9C27B0),
      'icon': Icons.self_improvement,
      'description': 'Stretch and relax',
    },
    {
      'title': 'Strength Builder',
      'duration': '35 min',
      'difficulty': 'Advanced',
      'exercises': 14,
      'color': Color(0xFFFF9800),
      'icon': Icons.whatshot,
      'description': 'Build muscle at home',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Workouts'),
        backgroundColor: const Color(0xFF007BFF),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF007BFF),
              Color(0xFFE3F2FD),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '🏠 Home Workouts',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF007BFF),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'No equipment needed! Get fit in the comfort of your home.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _buildInfoChip('No Equipment', Icons.check_circle, Colors.green),
                          const SizedBox(width: 12),
                          _buildInfoChip('All Levels', Icons.people, Colors.blue),
                          const SizedBox(width: 12),
                          _buildInfoChip('Quick Sessions', Icons.timer, Colors.orange),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Workout List
                Expanded(
                  child: ListView.builder(
                    itemCount: _homeWorkouts.length,
                    itemBuilder: (context, index) {
                      final workout = _homeWorkouts[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: _buildWorkoutCard(workout),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(String text, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutCard(Map<String, dynamic> workout) {
    return GestureDetector(
      onTap: () {
        // Navigate to workout details or start workout
        _showWorkoutDetails(workout);
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: workout['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                workout['icon'],
                color: workout['color'],
                size: 30,
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workout['title'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    workout['description'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildDetailChip(
                        Icons.timer,
                        workout['duration'],
                        Colors.blue,
                      ),
                      const SizedBox(width: 8),
                      _buildDetailChip(
                        Icons.signal_cellular_alt,
                        workout['difficulty'],
                        _getDifficultyColor(workout['difficulty']),
                      ),
                      const SizedBox(width: 8),
                      _buildDetailChip(
                        Icons.fitness_center,
                        '${workout['exercises']} exercises',
                        Colors.green,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Arrow
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[400],
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Beginner':
        return Colors.green;
      case 'Intermediate':
        return Colors.orange;
      case 'Advanced':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showWorkoutDetails(Map<String, dynamic> workout) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(workout['title']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(workout['description']),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.timer, size: 16, color: Colors.blue),
                const SizedBox(width: 8),
                Text('Duration: ${workout['duration']}'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.signal_cellular_alt, size: 16, color: Colors.orange),
                const SizedBox(width: 8),
                Text('Difficulty: ${workout['difficulty']}'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.fitness_center, size: 16, color: Colors.green),
                const SizedBox(width: 8),
                Text('Exercises: ${workout['exercises']}'),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to workout timer or start workout
              context.go('/exercise-timer/sample-exercise');
            },
            child: const Text('Start Workout'),
          ),
        ],
      ),
    );
  }
}
