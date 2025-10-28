import 'package:flutter/material.dart';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';

class CardioWorkoutPage extends StatefulWidget {
  final int totalDays;
  final int currentDay;

  const CardioWorkoutPage({
    super.key,
    required this.totalDays,
    required this.currentDay,
  });

  @override
  State<CardioWorkoutPage> createState() => _CardioWorkoutPageState();
}

class _CardioWorkoutPageState extends State<CardioWorkoutPage> {
  List<Map<String, dynamic>> exercises = [];
  bool isLoading = true;
  bool isCompleted = false;

  // Workout sequence used by the timer UI. Each item: {name, duration, isRest, calPerMin}
  List<Map<String, dynamic>> sequence = [];
  int currentIndex = 0;
  int remainingSeconds = 0;
  Timer? _seqTimer;
  bool playing = false;

  // track pending calories to flush to Firestore
  double _pendingCaloriesToFlush = 0.0;
  DateTime? _lastCaloriesFlush;
  final Duration _caloriesFlushInterval = const Duration(seconds: 15);

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('cardio_workouts')
          .doc('day_${widget.currentDay}')
          .get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        setState(() {
          exercises = List<Map<String, dynamic>>.from(data['exercises'] ?? []);
          isLoading = false;
        });
        _buildSequenceFromExercises();
      } else {
        // If no specific exercises found, generate a sample routine
        setState(() {
          exercises = _getDefaultExercises();
          isLoading = false;
        });
        _buildSequenceFromExercises();
      }
    } catch (e) {
      print('Error loading exercises: $e');
      setState(() {
        exercises = _getDefaultExercises();
        isLoading = false;
      });
      _buildSequenceFromExercises();
    }
  }

  List<Map<String, dynamic>> _getDefaultExercises() {
    return [
      {
        'name': 'High Knees',
        'sets': 3,
        'reps': '45 seconds',
        'restTime': '30 seconds',
      },
      {
        'name': 'Mountain Climbers',
        'sets': 3,
        'reps': '45 seconds',
        'restTime': '30 seconds',
      },
      {
        'name': 'Jumping Jacks',
        'sets': 3,
        'reps': '45 seconds',
        'restTime': '30 seconds',
      },
      {
        'name': 'Burpees',
        'sets': 3,
        'reps': '30 seconds',
        'restTime': '45 seconds',
      },
    ];
  }

  void _buildSequenceFromExercises() {
    // If Firestore exercises include durationSeconds, use them; otherwise generate a sample routine
    if (exercises.isNotEmpty &&
        exercises.first.containsKey('durationSeconds')) {
      sequence = exercises.map((e) {
        return {
          'name': e['name'] ?? 'Exercise',
          'duration': e['durationSeconds'] ?? 60,
          'isRest': e['isRest'] ?? false,
          'calPerMin': e['calPerMin'] ?? 10.0, // higher for cardio
        };
      }).toList();
    } else {
      sequence = _generateSampleRoutine('cardio');
    }

    currentIndex = 0;
    remainingSeconds = sequence.isNotEmpty ? sequence[0]['duration'] as int : 0;
  }

  List<Map<String, dynamic>> _generateSampleRoutine(String category) {
    // cardio-focused exercises with higher intensity
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
        'calPerMin': 10.0, // cardio burns more calories per minute
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

    // If total less than 20 min, append a finisher
    int total = seq.fold(0, (s, e) => s + (e['duration'] as int));
    if (total < 18 * 60) {
      seq.add({
        'name': 'Finisher Sprint',
        'duration': 60,
        'isRest': false,
        'calPerMin': 12.0, // higher intensity finisher
      });
    }
    return seq;
  }

  void _startSequence() {
    if (sequence.isEmpty) return;
    if (playing) return;
    setState(() => playing = true);

    _seqTimer = Timer.periodic(const Duration(seconds: 1), (_) async {
      if (remainingSeconds > 0) {
        // accumulate calories per second for the current step
        try {
          final step = sequence[currentIndex];
          final calPerMin = (step['calPerMin'] as num).toDouble();
          final calThisSecond = calPerMin / 60.0;
          _pendingCaloriesToFlush += calThisSecond;
        } catch (_) {}

        // flush to Firestore occasionally to avoid too many writes
        if (_shouldFlushCalories()) {
          await _flushPendingCalories();
        }

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

    // Ensure any pending calories are flushed
    await _flushPendingCalories(force: true);

    // advance to next step
    if (currentIndex < sequence.length - 1) {
      setState(() {
        currentIndex++;
        remainingSeconds = sequence[currentIndex]['duration'] as int;
      });
    } else {
      // finished workout
      _pauseSequence();
      // final flush
      await _flushPendingCalories(force: true);
      await _markDayAsCompleted();
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

  bool _shouldFlushCalories() {
    if (_pendingCaloriesToFlush >= 1.0) return true;
    if (_lastCaloriesFlush == null) return true;
    return DateTime.now().difference(_lastCaloriesFlush!) >=
        _caloriesFlushInterval;
  }

  Future<void> _flushPendingCalories({bool force = false}) async {
    if (!force && _pendingCaloriesToFlush <= 0) return;
    final toFlush = _pendingCaloriesToFlush;
    if (toFlush <= 0) return;

    await _addCalories(toFlush);
    _pendingCaloriesToFlush = 0.0;
    _lastCaloriesFlush = DateTime.now();
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
          .collection('cardio_workout')
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

  Future<void> _markDayAsCompleted() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please sign in to mark progress')),
        );
        context.go('/login');
      }
      return;
    }

    try {
      // flush any remaining calories
      await _flushPendingCalories(force: true);

      await FirebaseFirestore.instance
          .collection('user_progress')
          .doc(uid)
          .collection('cardio_workout')
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

        // Return to days list
        context.go('/cardio-days/${widget.totalDays}');
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
                // Timer UI
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: sequence.isEmpty
                        ? const Center(
                            child: Text('No workout sequence available'),
                          )
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
              ],
            ),
    );
  }
}
