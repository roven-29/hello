import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';

class HomeWorkoutPage extends StatefulWidget {
  final int totalDays;
  final int currentDay;

  const HomeWorkoutPage({
    super.key,
    required this.totalDays,
    required this.currentDay,
  });

  @override
  State<HomeWorkoutPage> createState() => _HomeWorkoutPageState();
}

class _HomeWorkoutPageState extends State<HomeWorkoutPage> {
  List<Map<String, dynamic>> exercises = [];
  bool isLoading = true;
  bool isCompleted = false;
  
  List<Map<String, dynamic>> sequence = [];
  int currentIndex = 0;
  int remainingSeconds = 0;
  Timer? _seqTimer;
  bool playing = false;

  double _pendingCaloriesToFlush = 0.0;
  DateTime? _lastCaloriesFlush;
  final Duration _caloriesFlushInterval = const Duration(seconds: 15);

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    setState(() => isLoading = true);

    try {
      // Load the exercises for the current day
      final ref = FirebaseFirestore.instance
          .collection('workouts')
          .doc('home_workout')
          .collection('days')
          .doc('day${widget.currentDay}');

      final doc = await ref.get();
      
      if (!doc.exists) {
        setState(() {
          isLoading = false;
          exercises = [];
        });
        return;
      }

      final data = doc.data() as Map<String, dynamic>;
      final List<dynamic> rawExercises = data['exercises'] ?? [];
      
      exercises = rawExercises.map((e) => Map<String, dynamic>.from(e)).toList();

      // Check completion status
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final progressRef = FirebaseFirestore.instance
            .collection('user_progress')
            .doc(user.uid)
            .collection('home_workout')
            .doc('current_progress');

        final progress = await progressRef.get();
        if (progress.exists) {
          final data = progress.data() as Map<String, dynamic>;
          isCompleted = (data['last_completed_day'] ?? 0) >= widget.currentDay;
        }
      }

      // Build timer sequence
      sequence = [];
      for (final exercise in exercises) {
        sequence.add({
          'name': exercise['name'],
          'duration': exercise['duration'] ?? 30,
          'isRest': false,
          'calPerMin': 7.0 // Average calories burned per minute for home exercises
        });

        // Add rest period after each exercise except the last one
        if (exercise != exercises.last) {
          sequence.add({
            'name': 'Rest',
            'duration': 30, // 30 seconds rest between exercises
            'isRest': true,
            'calPerMin': 1.0 // Minimal calories during rest
          });
        }
      }

    } catch (e) {
      print('Error loading exercises: $e');
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load exercises: $e'))
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _seqTimer?.cancel();
    super.dispose();
  }

  Future<void> _flushPendingCalories() async {
    if (_pendingCaloriesToFlush <= 0) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final progressRef = FirebaseFirestore.instance
          .collection('user_progress')
          .doc(user.uid)
          .collection('home_workout')
          .doc('current_progress');

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final doc = await transaction.get(progressRef);
        final currentCalories = (doc.data()?['calories_burned'] as num?)?.toDouble() ?? 0.0;
        
        transaction.set(progressRef, {
          'calories_burned': currentCalories + _pendingCaloriesToFlush,
          'last_updated': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      });

      _pendingCaloriesToFlush = 0;
      _lastCaloriesFlush = DateTime.now();

    } catch (e) {
      print('Error flushing calories: $e');
    }
  }

  void _updateCalories(double additionalCalories) {
    _pendingCaloriesToFlush += additionalCalories;
    
    final now = DateTime.now();
    if (_lastCaloriesFlush == null || 
        now.difference(_lastCaloriesFlush!) >= _caloriesFlushInterval) {
      _flushPendingCalories();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Home Workout')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (exercises.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Home Workout')),
        body: const Center(
          child: Text('No exercises found for this day'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Day ${widget.currentDay} of ${widget.totalDays}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (!isCompleted) ...[
              Card(
                child: ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('Complete all exercises to finish the day\'s workout'),
                  trailing: Text('${exercises.length} exercises'),
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            if (playing) ...[
              // Timer display
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        sequence[currentIndex]['name'],
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${remainingSeconds ~/ 60}:${(remainingSeconds % 60).toString().padLeft(2, '0')}',
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _seqTimer?.cancel();
                              setState(() {
                                playing = false;
                              });
                            },
                            child: const Text('Stop'),
                          ),
                          if (currentIndex > 0)
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  currentIndex--;
                                  remainingSeconds = sequence[currentIndex]['duration'];
                                });
                              },
                              child: const Text('Previous'),
                            ),
                          if (currentIndex < sequence.length - 1)
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  currentIndex++;
                                  remainingSeconds = sequence[currentIndex]['duration'];
                                });
                              },
                              child: const Text('Next'),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              // Exercise list
              Expanded(
                child: ListView.builder(
                  itemCount: exercises.length,
                  itemBuilder: (context, index) {
                    final exercise = exercises[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text('${index + 1}'),
                        ),
                        title: Text(exercise['name']),
                        subtitle: Text('${exercise['duration']} seconds'),
                        trailing: exercise['completed'] == true
                            ? const Icon(Icons.check_circle, color: Colors.green)
                            : const Icon(Icons.circle_outlined),
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 16),
              
              if (!isCompleted)
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      currentIndex = 0;
                      remainingSeconds = sequence[0]['duration'];
                      playing = true;
                    });
                    
                    _seqTimer?.cancel();
                    _seqTimer = Timer.periodic(
                      const Duration(seconds: 1),
                      (timer) {
                        if (remainingSeconds > 0) {
                          setState(() {
                            remainingSeconds--;
                            
                            // Calculate calories burned in this second
                            final calPerMin = sequence[currentIndex]['calPerMin'];
                            _updateCalories(calPerMin / 60);
                          });
                        } else {
                          // Current exercise/rest completed
                          if (currentIndex < sequence.length - 1) {
                            // Move to next exercise
                            setState(() {
                              currentIndex++;
                              remainingSeconds = sequence[currentIndex]['duration'];
                            });
                          } else {
                            // Workout completed!
                            timer.cancel();
                            setState(() {
                              playing = false;
                              isCompleted = true;
                            });
                            
                            // Update progress in Firestore
                            final user = FirebaseAuth.instance.currentUser;
                            if (user != null) {
                              FirebaseFirestore.instance
                                  .collection('user_progress')
                                  .doc(user.uid)
                                  .collection('home_workout')
                                  .doc('current_progress')
                                  .set({
                                'last_completed_day': widget.currentDay,
                                'total_days': widget.totalDays,
                                'last_updated': FieldValue.serverTimestamp(),
                              }, SetOptions(merge: true));
                            }

                            // Final calories flush
                            _flushPendingCalories();

                            // Show completion dialog
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Workout Complete! 🎉'),
                                content: const Text(
                                  'Great job! You\'ve completed today\'s workout.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      context.go('/home-days/${widget.totalDays}');
                                    },
                                    child: const Text('Back to Days'),
                                  ),
                                ],
                              ),
                            );
                          }
                        }
                      },
                    );
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Start Workout'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
