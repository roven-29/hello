import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/auth_service.dart';
import '../services/workout_service.dart';

class ProgressTrackerPage extends StatefulWidget {
  const ProgressTrackerPage({super.key});

  @override
  State<ProgressTrackerPage> createState() => _ProgressTrackerPageState();
}

class _ProgressTrackerPageState extends State<ProgressTrackerPage> {
  Map<String, dynamic>? _userData;
  List<dynamic> _workoutHistory = [];
  Map<String, int> _weeklyStats = {};
  Map<String, dynamic> _streakInfo = {};
  List<Map<String, dynamic>> _planEntries = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProgressData();
  }

  Future<void> _loadProgressData() async {
    setState(() => _isLoading = true);
    try {
      final userData = await AuthService().getUserData();
      final history = await WorkoutService().getWorkoutHistory();
      final weeklyStats = await WorkoutService().getWeeklyStats();
      final streakInfo = await WorkoutService().getStreakInfo();
      final planEntries = await WorkoutService().getPlanProgressEntries(
        limit: 30,
      );

      setState(() {
        _userData = userData;
        _workoutHistory = history;
        _weeklyStats = weeklyStats;
        _streakInfo = streakInfo;
        _planEntries = planEntries;
        _isLoading = false;
      });
    } catch (e) {
      // keep simple error handling here
      debugPrint('Error loading progress data: $e');
      setState(() => _isLoading = false);
    }
  }

  List<FlSpot> _getWeeklyCaloriesSpots() {
    const days = 7;
    return List.generate(days, (i) {
      final key = (i + 1).toString();
      final calories = _weeklyStats[key] ?? 0;
      return FlSpot(i.toDouble(), calories.toDouble());
    });
  }

  List<BarChartGroupData> _getWeeklyWorkoutBars() {
    return List.generate(7, (i) {
      final key = (i + 1).toString();
      final calories = _weeklyStats[key] ?? 0;
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: calories.toDouble(),
            width: 16,
            color: const Color(0xFF007BFF),
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Progress Tracker')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildChartSection(
                    title: 'Weekly Calories (line)',
                    icon: Icons.local_fire_department,
                    child: SizedBox(
                      height: 180,
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(show: false),
                          titlesData: FlTitlesData(show: true),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: _getWeeklyCaloriesSpots(),
                              isCurved: true,
                              color: const Color(0xFFFF5722),
                              barWidth: 3,
                              dotData: FlDotData(show: true),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  _buildChartSection(
                    title: 'Calories Burned (bar)',
                    icon: Icons.bar_chart,
                    child: SizedBox(
                      height: 200,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: _weeklyStats.values.isEmpty
                              ? 100
                              : (_weeklyStats.values.reduce(
                                          (a, b) => a > b ? a : b,
                                        ) *
                                        1.2)
                                    .toDouble(),
                          titlesData: FlTitlesData(show: true),
                          borderData: FlBorderData(show: false),
                          barGroups: _getWeeklyWorkoutBars(),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Plan Progress section (separate)
                  _buildChartSection(
                    title: 'Plan Progress',
                    icon: Icons.calendar_today,
                    child: SizedBox(
                      height: _planEntries.isEmpty
                          ? 80
                          : (_planEntries.length.clamp(0, 6) * 80).toDouble(),
                      child: _planEntries.isEmpty
                          ? const Center(child: Text('No plan progress yet'))
                          : ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _planEntries.length.clamp(0, 6),
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 8),
                              itemBuilder: (context, index) {
                                final entry = _planEntries[index];
                                final date =
                                    entry['date'] ?? entry['timestamp'] ?? '';
                                final dayIndex = entry['dayIndex'] ?? 0;
                                final calories = entry['caloriesBurned'] ?? 0;
                                final exerciseDetails =
                                    (entry['exerciseDetails'] as List?) ?? [];
                                return ExpansionTile(
                                  title: Text(
                                    'Day $dayIndex • ${date.toString().split('T').first}',
                                  ),
                                  subtitle: Text('$calories cal'),
                                  children: exerciseDetails.map<Widget>((ex) {
                                    return ListTile(
                                      dense: true,
                                      title: Text(ex['name'] ?? ''),
                                      trailing: Text(
                                        '${ex['caloriesBurned'] ?? 0} cal',
                                      ),
                                      subtitle: Text(
                                        'Completed at: ${ex['completedAt'] ?? ''}',
                                      ),
                                    );
                                  }).toList(),
                                );
                              },
                            ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  _buildSummaryStats(),
                ],
              ),
            ),
    );
  }

  Widget _buildChartSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF007BFF)),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildSummaryStats() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'This Week Summary',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Workouts',
                  '${_userData?['workoutsCompleted'] ?? 0}',
                  Icons.fitness_center,
                  const Color(0xFF007BFF),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  'Calories',
                  '${_userData?['caloriesBurned'] ?? 0}',
                  Icons.local_fire_department,
                  const Color(0xFFFF5722),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Total Workouts',
                  '${_workoutHistory.length}',
                  Icons.check_circle,
                  const Color(0xFF4CAF50),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  'Streak',
                  '${_streakInfo['currentStreak'] ?? 0} days',
                  Icons.whatshot,
                  const Color(0xFFFF9800),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
        ],
      ),
    );
  }
}
