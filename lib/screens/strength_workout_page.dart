import 'package:flutter/material.dart';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';

class StrengthWorkoutPage extends StatefulWidget {
  final int totalDays;
  final int currentDay;

  const StrengthWorkoutPage({
    super.key,
    required this.totalDays,
    required this.currentDay,
  });

  @override
  State<StrengthWorkoutPage> createState() => _StrengthWorkoutPageState();
}

class _StrengthWorkoutPageState extends State<StrengthWorkoutPage> {
  List<Map<String, dynamic>> exercises = [];
  bool isLoading = true;
  bool isCompleted = false;

  Future<void> _markDayAsCompleted() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please sign in to mark progress')),
        );
        context.go('/login');
      }
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('user_progress')
          .doc(uid)
          .collection('strength_workout')
          .doc('current_progress')
          .set({
            'last_completed_day': widget.currentDay,
            'total_days': widget.totalDays,
            'last_updated': DateTime.now(),
          }, SetOptions(merge: true));

      setState(() {
        isCompleted = true;
      });

      if (context.mounted) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Day Completed! 🎉'),
            content: Text(
              'You\'ve completed Day ${widget.currentDay} of ${widget.totalDays}.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );

        // Return to days list to show updated progress
        context.go('/strength-days/${widget.totalDays}');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error updating progress: $e')));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('strength_workouts')
          .doc('day_${widget.currentDay}')
          .get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        setState(() {
          exercises = List<Map<String, dynamic>>.from(data['exercises'] ?? []);
          isLoading = false;
        });
        _buildSequenceFromExercises();
        setState(() {});
      } else {
        // If no specific exercises found, load default exercises
        setState(() {
          exercises = _getDefaultExercises();
          isLoading = false;
        });
        _buildSequenceFromExercises();
        setState(() {});
      }
    } catch (e) {
      print('Error loading exercises: $e');
      setState(() {
        exercises = _getDefaultExercises();
        isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> _getDefaultExercises() {
    // Default exercises if none are found in Firestore
    return [
      {
        'name': 'Push-ups',
        'sets': 3,
        'reps': '12-15',
        'restTime': '60 seconds',
      },
      {'name': 'Squats', 'sets': 3, 'reps': '15-20', 'restTime': '60 seconds'},
      {
        'name': 'Dumbbell Rows',
        'sets': 3,
        'reps': '12 each side',
        'restTime': '60 seconds',
      },
      {
        'name': 'Plank',
        'sets': 3,
        'reps': '30-45 seconds',
        'restTime': '45 seconds',
      },
    ];
  }

  // Workout sequence used by the timer UI. Each item: {name, duration, isRest, calPerMin}
  List<Map<String, dynamic>> sequence = [];
  int currentIndex = 0;
  int remainingSeconds = 0;
  Timer? _seqTimer;
  bool playing = false;
  // keep a simple session accumulator (used in earlier iterations)
  double _accumulatedCalories = 0.0;

  void _buildSequenceFromExercises() {
    // If Firestore exercises include durationSeconds, use them; otherwise generate a sample routine
    if (exercises.isNotEmpty &&
        exercises.first.containsKey('durationSeconds')) {
      sequence = exercises.map((e) {
        return {
          'name': e['name'] ?? 'Exercise',
          'duration': e['durationSeconds'] ?? 60,
          'isRest': e['isRest'] ?? false,
          'calPerMin': e['calPerMin'] ?? 8.0,
        };
      }).toList();
    } else {
      // generate a sample 20-minute strength routine
      sequence = _generateSampleRoutine('strength');
    }

    currentIndex = 0;
    remainingSeconds = sequence.isNotEmpty ? sequence[0]['duration'] as int : 0;
  }

  List<Map<String, dynamic>> _generateSampleRoutine(String category) {
    // Returns a list of steps (exercises + rests) totalling ~20 minutes.
    if (category == 'strength') {
      final exercises = [
        'Push-ups',
        'Goblet Squats',
        'Dumbbell Rows',
        'Glute Bridges',
        'Overhead Press',
        'Lunges',
        'Chest Press',
        'Deadlifts',
        'Bent-over Rows',
        'Romanian Deadlift',
        'Plank',
        'Russian Twists',
      ];

      // durations in seconds (mix upper/lower/full), target ~20min with rests after every 4 exercises
      final durations = [60, 60, 60, 60, 60, 60, 60, 60, 45, 45, 60, 60];
      final rest = 45; // rest after every 4 exercises

      List<Map<String, dynamic>> seq = [];
      for (var i = 0; i < exercises.length; i++) {
        seq.add({
          'name': exercises[i],
          'duration': durations[i],
          'isRest': false,
          'calPerMin': 8.0,
        });
        if ((i + 1) % 4 == 0 && i != exercises.length - 1) {
          seq.add({
            'name': 'Rest',
            'duration': rest,
            'isRest': true,
            'calPerMin': 0.0,
          });
        }
      }

      // If total less than 20 min, append a short set
      int total = seq.fold(0, (s, e) => s + (e['duration'] as int));
      if (total < 18 * 60) {
        seq.add({
          'name': 'Finisher: Jump Squats',
          'duration': 60,
          'isRest': false,
          'calPerMin': 10.0,
        });
      }
      return seq;
    }

    if (category == 'cardio') {
      final exercises = [
        'High Knees',
        'Burpees',
        'Jump Squats',
        'Mountain Climbers',
        'Skaters',
        'Butt Kicks',
        'Plank Jacks',
        'Alternating Lunges (plyo)',
        'Tuck Jumps',
        'Speed Skaters',
      ];
      final durations = [50, 50, 50, 50, 50, 50, 50, 50, 50, 50];
      final rest = 40;
      List<Map<String, dynamic>> seq = [];
      for (var i = 0; i < exercises.length; i++) {
        seq.add({
          'name': exercises[i],
          'duration': durations[i],
          'isRest': false,
          'calPerMin': 10.0,
        });
        if ((i + 1) % 4 == 0 && i != exercises.length - 1) {
          seq.add({
            'name': 'Rest',
            'duration': rest,
            'isRest': true,
            'calPerMin': 0.0,
          });
        }
      }
      return seq;
    }

    // home workouts (no equipment)
    final homeExercises = [
      'Push-ups',
      'Bodyweight Squats',
      'Walking Lunges',
      'Plank',
      'Glute Bridges',
      'Tricep Dips (chair)',
      'Step-ups (stairs)',
      'Bicycle Crunches',
      'Calf Raises',
      'Supermans',
    ];
    final homeDurations = [60, 60, 60, 45, 60, 45, 60, 45, 45, 45];
    final homeRest = 45;
    List<Map<String, dynamic>> seq = [];
    for (var i = 0; i < homeExercises.length; i++) {
      seq.add({
        'name': homeExercises[i],
        'duration': homeDurations[i],
        'isRest': false,
        'calPerMin': 7.0,
      });
      if ((i + 1) % 4 == 0 && i != homeExercises.length - 1) {
        seq.add({
          'name': 'Rest',
          'duration': homeRest,
          'isRest': true,
          'calPerMin': 0.0,
        });
      }
    }
    return seq;
  }

  void _startSequence() {
    if (sequence.isEmpty) return;
    if (playing) return;
    setState(() => playing = true);
    _seqTimer = Timer.periodic(const Duration(seconds: 1), (_) async {
      if (remainingSeconds > 0) {
        setState(() => remainingSeconds--);
      } else {
        // step finished
        await _onStepComplete();
      }
    });
  }

  void _pauseSequence() {
    _seqTimer?.cancel();
    _seqTimer = null;
    setState(() => playing = false);
  }

  void _resetSequence() {
    _pauseSequence();
    setState(() {
      currentIndex = 0;
      remainingSeconds = sequence.isNotEmpty
          ? sequence[0]['duration'] as int
          : 0;
    });
  }

  Future<void> _onStepComplete() async {
    // vibrate / sound
    try {
      HapticFeedback.mediumImpact();
      SystemSound.play(SystemSoundType.click);
    } catch (_) {}

    final step = sequence[currentIndex];
    if (!(step['isRest'] as bool)) {
      final dur = step['duration'] as int;
      final calPerMin = (step['calPerMin'] as num).toDouble();
      final calories = dur * (calPerMin / 60.0);
      await _addCalories(calories);
    }

    // advance
    if (currentIndex < sequence.length - 1) {
      setState(() {
        currentIndex++;
        remainingSeconds = sequence[currentIndex]['duration'] as int;
      });
      // continue automatically
    } else {
      // finished workout
      _pauseSequence();
      if (context.mounted) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Workout Complete 🎉'),
            content: const Text('Great job! You completed the workout.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  void _goToNext() {
    if (currentIndex < sequence.length - 1) {
      setState(() {
        currentIndex++;
        remainingSeconds = sequence[currentIndex]['duration'] as int;
      });
    }
  }

  void _goToPrevious() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        remainingSeconds = sequence[currentIndex]['duration'] as int;
      });
    }
  }

  Future<void> _addCalories(double calories) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please sign in to save calories')),
        );
      }
      return;
    }

    try {
      final docRef = FirebaseFirestore.instance
          .collection('user_progress')
          .doc(uid)
          .collection('strength_workout')
          .doc('current_progress');

      final snapshot = await docRef.get();
      final current = (snapshot.exists && snapshot.data() != null)
          ? (snapshot.data()!['calories_burned'] as num? ?? 0)
          : 0;

      await docRef.set({
        'calories_burned': current + calories,
        'last_updated': DateTime.now(),
      }, SetOptions(merge: true));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving calories: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
        title: Text('Day ${widget.currentDay} of ${widget.totalDays}'),
      ),
      floatingActionButton: !isCompleted
          ? FloatingActionButton.extended(
              onPressed: _markDayAsCompleted,
              icon: const Icon(Icons.check),
              label: const Text('Complete Workout'),
            )
          : null,

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Day ${widget.currentDay}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${exercises.length} Exercises',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                // Workout Timer UI (auto-sequencing)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: sequence.isEmpty
                        ? Center(child: Text('No workout sequence available'))
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Circular progress
                              SizedBox(
                                width: 200,
                                height: 200,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      value: sequence[currentIndex].isNotEmpty
                                          ? 1 -
                                                (remainingSeconds /
                                                    (sequence[currentIndex]['duration']
                                                        as int))
                                          : 0,
                                      strokeWidth: 10,
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          sequence[currentIndex]['name'],
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '${(remainingSeconds ~/ 60).toString().padLeft(2, '0')}:${(remainingSeconds % 60).toString().padLeft(2, '0')}',
                                          style: const TextStyle(
                                            fontSize: 36,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      const Text('Next Up'),
                                      const SizedBox(height: 6),
                                      Text(
                                        currentIndex < sequence.length - 1
                                            ? sequence[currentIndex + 1]['name']
                                            : '—',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      _goToPrevious();
                                    },
                                    icon: const Icon(Icons.skip_previous),
                                    iconSize: 36,
                                  ),
                                  FloatingActionButton(
                                    onPressed: () {
                                      if (playing) {
                                        _pauseSequence();
                                      } else {
                                        _startSequence();
                                      }
                                    },
                                    child: Icon(
                                      playing ? Icons.pause : Icons.play_arrow,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _goToNext();
                                    },
                                    icon: const Icon(Icons.skip_next),
                                    iconSize: 36,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  OutlinedButton.icon(
                                    onPressed: () {
                                      _resetSequence();
                                    },
                                    icon: const Icon(Icons.refresh),
                                    label: const Text('Reset'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                  ),
                ),
                // Navigation to next day is gated by completing the current day.
              ],
            ),
    );
  }

  Widget _buildExerciseDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 8),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

class _ExerciseTimerSheet extends StatefulWidget {
  final Map<String, dynamic> exercise;

  const _ExerciseTimerSheet({required this.exercise});

  @override
  State<_ExerciseTimerSheet> createState() => _ExerciseTimerSheetState();
}

class _ExerciseTimerSheetState extends State<_ExerciseTimerSheet> {
  Timer? _timer;
  int _seconds = 0;
  bool _running = false;

  double get _calPerMin {
    final v = widget.exercise['calPerMin'];
    if (v is num) return v.toDouble();
    return 8.0; // default cal/min for strength
  }

  void _start() {
    if (_running) return;
    _running = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _seconds++;
      });
    });
  }

  void _pause() {
    _timer?.cancel();
    _timer = null;
    setState(() {
      _running = false;
    });
  }

  void _reset() {
    _timer?.cancel();
    _timer = null;
    setState(() {
      _seconds = 0;
      _running = false;
    });
  }

  double get _caloriesBurned => _seconds * (_calPerMin / 60.0);

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _format(int seconds) {
    final mm = (seconds ~/ 60).toString().padLeft(2, '0');
    final ss = (seconds % 60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.exercise['name'] ?? 'Exercise';
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              _format(_seconds),
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text('Calories: ${_caloriesBurned.toStringAsFixed(1)} kcal'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _running ? _pause : _start,
                  child: Text(_running ? 'Pause' : 'Start'),
                ),
                const SizedBox(width: 12),
                OutlinedButton(onPressed: _reset, child: const Text('Reset')),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // Return calories to caller and close sheet
                Navigator.of(context).pop(_caloriesBurned);
              },
              icon: const Icon(Icons.save),
              label: const Text('Save & Close'),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
