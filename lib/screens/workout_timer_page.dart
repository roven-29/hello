import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:confetti/confetti.dart';
import '../data/dummy_data.dart';
import '../models/workout.dart';
import '../services/workout_service.dart';

class WorkoutTimerPage extends StatefulWidget {
  final String workoutId;

  const WorkoutTimerPage({super.key, required this.workoutId});

  @override
  State<WorkoutTimerPage> createState() => _WorkoutTimerPageState();
}

class _WorkoutTimerPageState extends State<WorkoutTimerPage> with TickerProviderStateMixin {
  Timer? _timer;
  late Workout _workout;
  int _currentExerciseIndex = 0;
  int _timeLeft = 0;
  bool _isRunning = false;
  bool _isCompleted = false;
  bool _isPaused = false;
  late ConfettiController _confettiController;
  late AnimationController _progressController;
  
  @override
  void initState() {
    super.initState();
    _workout = DummyData.getWorkoutById(widget.workoutId)!;
    _timeLeft = _workout.exercises[0].duration;
    _confettiController = ConfettiController(duration: const Duration(seconds: 5));
    _progressController = AnimationController(
      vsync: this,
      duration: Duration(seconds: _timeLeft),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _confettiController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  void _startTimer() {
    if (_isRunning) return;
    
    setState(() {
      _isRunning = true;
      _isPaused = false;
    });

    if (!_isPaused) {
      _progressController.forward();
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
          _progressController.value = 1 - (_timeLeft / _workout.exercises[_currentExerciseIndex].duration);
        } else {
          _progressController.reset();
          _nextExercise();
        }
      });
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _isPaused = true;
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _currentExerciseIndex = 0;
      _timeLeft = _workout.exercises[0].duration;
      _isRunning = false;
      _isCompleted = false;
      _isPaused = false;
      _progressController.reset();
    });
  }

  void _nextExercise() {
    if (_currentExerciseIndex < _workout.exercises.length - 1) {
      setState(() {
        _currentExerciseIndex++;
        _timeLeft = _workout.exercises[_currentExerciseIndex].duration;
        _progressController.duration = Duration(seconds: _timeLeft);
        _progressController.forward();
      });
    } else {
      _completeWorkout();
    }
  }

  void _previousExercise() {
    if (_currentExerciseIndex > 0) {
      _timer?.cancel();
      setState(() {
        _currentExerciseIndex--;
        _timeLeft = _workout.exercises[_currentExerciseIndex].duration;
        _progressController.duration = Duration(seconds: _timeLeft);
        _progressController.value = 0;
        _isRunning = false;
        _isPaused = true;
      });
    }
  }

  void _completeWorkout() async {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _isCompleted = true;
      _isPaused = false;
    });
    _confettiController.play();
    
    // Save workout to Firebase
    final error = await WorkoutService().recordWorkout(
      workoutId: widget.workoutId,
      workoutName: _workout.name,
      durationSeconds: _workout.totalDuration,
    );
    
    if (error != null) {
      print('Failed to save workout: $error');
    }
  }

  String _formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  double _getProgress() {
    if (_workout.exercises.isEmpty) return 0;
    return (_currentExerciseIndex + 1) / _workout.exercises.length;
  }

  WorkoutExercise? _getNextExercise() {
    if (_currentExerciseIndex < _workout.exercises.length - 1) {
      return _workout.exercises[_currentExerciseIndex + 1];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final currentExercise = _workout.exercises[_currentExerciseIndex];
    final nextExercise = _getNextExercise();

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: currentExercise.isRest
                    ? [const Color(0xFF4CAF50), const Color(0xFF66BB6A)]
                    : [const Color(0xFF007BFF), const Color(0xFF0056B3)],
              ),
            ),
          ),
          
          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Header
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => context.go('/home'),
                      ),
                      Expanded(
                        child: Text(
                          _workout.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.info_outline, color: Colors.white),
                        onPressed: () => _showWorkoutInfo(),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Exercise name
                  Text(
                    currentExercise.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 10),
                  
                  // Exercise number
                  Text(
                    'Exercise ${_currentExerciseIndex + 1} of ${_workout.exercises.length}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Circular timer
                  Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.2),
                    ),
                    child: Stack(
                      children: [
                        // Progress ring
                        AnimatedBuilder(
                          animation: _progressController,
                          builder: (context, child) {
                            return CustomPaint(
                              size: const Size(250, 250),
                              painter: CircularProgressPainter(
                                progress: _progressController.value,
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                        // Time display
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _formatTime(_timeLeft),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                currentExercise.isRest ? 'REST' : 'TIME',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Instructions
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      currentExercise.instructions,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Next up section
                  if (nextExercise != null) ...[
                    Text(
                      'Next Up',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            nextExercise.isRest ? '🧘' : '⚡',
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  nextExercise.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${_formatTime(nextExercise.duration)}',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                  
                  // Controls
                  if (!_isCompleted) ...[
                    // Back and forward buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildControlButton(
                          icon: Icons.skip_previous,
                          onPressed: _currentExerciseIndex > 0 ? _previousExercise : null,
                        ),
                        _buildControlButton(
                          icon: _isPaused ? Icons.play_arrow : Icons.pause,
                          size: 64,
                          onPressed: _isRunning ? _pauseTimer : _startTimer,
                        ),
                        _buildControlButton(
                          icon: Icons.skip_next,
                          onPressed: _nextExercise,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Reset button
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _resetTimer,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.2),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text('RESET'),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    // Completion screen
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 80,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Workout Complete!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'You completed ${_workout.exercises.length} exercises',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => context.pop(),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: const Color(0xFF007BFF),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                  ),
                                  child: const Text(
                                    'DONE',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          
          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: math.pi / 2,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
              ],
            ),
          ),
          
          // Progress bar at top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 4,
              color: Colors.white.withOpacity(0.3),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: _getProgress(),
                child: Container(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({required IconData icon, required VoidCallback? onPressed, double size = 48}) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
      iconSize: size,
      color: Colors.white,
      disabledColor: Colors.white.withOpacity(0.3),
    );
  }

  void _showWorkoutInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_workout.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_workout.description),
            const SizedBox(height: 16),
            Text('Total Duration: ${(_workout.totalDuration / 60).toStringAsFixed(0)} minutes'),
            const SizedBox(height: 8),
            Text('Exercises: ${_workout.exercises.length}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;

  CircularProgressPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = color
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;

    canvas.drawCircle(center, radius, paint);
    
    if (progress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

