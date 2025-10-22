import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class YogaPage extends StatefulWidget {
  const YogaPage({super.key});

  @override
  State<YogaPage> createState() => _YogaPageState();
}

class _YogaPageState extends State<YogaPage> {
  final List<Map<String, dynamic>> _yogaCategories = [
    {
      'title': 'Morning Yoga',
      'subtitle': 'Start your day with energy',
      'duration': '15-20 min',
      'difficulty': 'Beginner',
      'poses': 8,
      'color': Color(0xFFFF9800),
      'icon': Icons.wb_sunny,
      'description': 'Gentle poses to wake up your body and mind',
    },
    {
      'title': 'Evening Yoga',
      'subtitle': 'Wind down and relax',
      'duration': '20-25 min',
      'difficulty': 'Beginner',
      'poses': 10,
      'color': Color(0xFF673AB7),
      'icon': Icons.nightlight_round,
      'description': 'Calming poses to prepare for rest',
    },
    {
      'title': 'Power Yoga',
      'subtitle': 'Build strength and flexibility',
      'duration': '30-45 min',
      'difficulty': 'Intermediate',
      'poses': 15,
      'color': Color(0xFFE91E63),
      'icon': Icons.fitness_center,
      'description': 'Dynamic flow to build strength',
    },
    {
      'title': 'Yin Yoga',
      'subtitle': 'Deep relaxation and flexibility',
      'duration': '25-40 min',
      'difficulty': 'Beginner',
      'poses': 6,
      'color': Color(0xFF4CAF50),
      'icon': Icons.self_improvement,
      'description': 'Long-held poses for deep stretch',
    },
    {
      'title': 'Meditation',
      'subtitle': 'Mindfulness and inner peace',
      'duration': '10-30 min',
      'difficulty': 'All Levels',
      'poses': 3,
      'color': Color(0xFF2196F3),
      'icon': Icons.psychology,
      'description': 'Guided meditation sessions',
    },
    {
      'title': 'Prenatal Yoga',
      'subtitle': 'Safe practice for expecting mothers',
      'duration': '20-30 min',
      'difficulty': 'Beginner',
      'poses': 8,
      'color': Color(0xFF9C27B0),
      'icon': Icons.favorite,
      'description': 'Gentle poses for pregnancy',
    },
  ];

  final List<Map<String, dynamic>> _yogaPoses = [
    {
      'name': 'Mountain Pose (Tadasana)',
      'sanskrit': 'ताडासन',
      'duration': '30-60 seconds',
      'benefits': 'Improves posture, strengthens legs',
      'difficulty': 'Beginner',
      'instructions': 'Stand tall with feet together, arms at sides. Ground through feet, lengthen spine.',
      'image': '🧘‍♀️',
    },
    {
      'name': 'Downward Dog (Adho Mukha Svanasana)',
      'sanskrit': 'अधो मुख श्वानासन',
      'duration': '30-90 seconds',
      'benefits': 'Strengthens arms, stretches hamstrings',
      'difficulty': 'Beginner',
      'instructions': 'Start on hands and knees, lift hips up and back, straighten legs.',
      'image': '🐕',
    },
    {
      'name': 'Warrior I (Virabhadrasana I)',
      'sanskrit': 'वीरभद्रासन I',
      'duration': '30-60 seconds',
      'benefits': 'Strengthens legs, opens chest',
      'difficulty': 'Beginner',
      'instructions': 'Step one foot forward, bend knee, raise arms overhead.',
      'image': '⚔️',
    },
    {
      'name': 'Tree Pose (Vrksasana)',
      'sanskrit': 'वृक्षासन',
      'duration': '30-60 seconds',
      'benefits': 'Improves balance, strengthens legs',
      'difficulty': 'Beginner',
      'instructions': 'Stand on one leg, place other foot on inner thigh, hands in prayer.',
      'image': '🌳',
    },
    {
      'name': 'Child\'s Pose (Balasana)',
      'sanskrit': 'बालासन',
      'duration': '30-90 seconds',
      'benefits': 'Relaxes spine, calms mind',
      'difficulty': 'Beginner',
      'instructions': 'Kneel, sit back on heels, fold forward, arms extended.',
      'image': '👶',
    },
    {
      'name': 'Cobra Pose (Bhujangasana)',
      'sanskrit': 'भुजंगासन',
      'duration': '15-30 seconds',
      'benefits': 'Strengthens back, opens chest',
      'difficulty': 'Beginner',
      'instructions': 'Lie on stomach, place hands under shoulders, lift chest up.',
      'image': '🐍',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yoga & Flexibility'),
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4CAF50),
              Color(0xFFE8F5E8),
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
                        '🧘 Yoga & Flexibility',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4CAF50),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Find balance, strength, and inner peace through yoga practice.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _buildInfoChip('All Levels', Icons.people, Colors.blue),
                          const SizedBox(width: 12),
                          _buildInfoChip('Flexibility', Icons.accessibility_new, Colors.green),
                          const SizedBox(width: 12),
                          _buildInfoChip('Mindfulness', Icons.psychology, Colors.purple),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Yoga Categories
                Text(
                  'Yoga Sessions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                Expanded(
                  child: ListView.builder(
                    itemCount: _yogaCategories.length,
                    itemBuilder: (context, index) {
                      final category = _yogaCategories[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: _buildYogaCategoryCard(category),
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

  Widget _buildYogaCategoryCard(Map<String, dynamic> category) {
    return GestureDetector(
      onTap: () => _showYogaSessionDetails(category),
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
                color: category['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                category['icon'],
                color: category['color'],
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
                    category['title'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category['description'],
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
                        category['duration'],
                        Colors.blue,
                      ),
                      const SizedBox(width: 8),
                      _buildDetailChip(
                        Icons.signal_cellular_alt,
                        category['difficulty'],
                        _getDifficultyColor(category['difficulty']),
                      ),
                      const SizedBox(width: 8),
                      _buildDetailChip(
                        Icons.accessibility_new,
                        '${category['poses']} poses',
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

  void _showYogaSessionDetails(Map<String, dynamic> category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(category['title']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(category['description']),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.timer, size: 16, color: Colors.blue),
                const SizedBox(width: 8),
                Text('Duration: ${category['duration']}'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.signal_cellular_alt, size: 16, color: Colors.orange),
                const SizedBox(width: 8),
                Text('Difficulty: ${category['difficulty']}'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.accessibility_new, size: 16, color: Colors.green),
                const SizedBox(width: 8),
                Text('Poses: ${category['poses']}'),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Yoga Poses in this session:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ..._yogaPoses.take(3).map((pose) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text('• ${pose['name']} (${pose['duration']})'),
            )),
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
              _showYogaPoses();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
            ),
            child: const Text('Start Session'),
          ),
        ],
      ),
    );
  }

  void _showYogaPoses() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Yoga Poses',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _yogaPoses.length,
                itemBuilder: (context, index) {
                  final pose = _yogaPoses[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Text(pose['image'], style: const TextStyle(fontSize: 32)),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pose['name'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                pose['sanskrit'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${pose['duration']} • ${pose['difficulty']}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.play_circle_outline, color: Colors.green),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
