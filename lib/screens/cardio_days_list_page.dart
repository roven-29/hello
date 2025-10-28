import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class CardioDaysListPage extends StatefulWidget {
  final int totalDays;

  const CardioDaysListPage({super.key, required this.totalDays});

  @override
  State<CardioDaysListPage> createState() => _CardioDaysListPageState();
}

class _CardioDaysListPageState extends State<CardioDaysListPage> {
  int currentCompletedDay = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please sign in to view progress')),
        );
        context.go('/login');
      }
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('user_progress')
          .doc(uid)
          .collection('cardio_workout')
          .doc('current_progress')
          .get();

      setState(() {
        if (doc.exists && doc.data() != null) {
          currentCompletedDay = doc.data()!['last_completed_day'] ?? 0;
        }
        isLoading = false;
      });
    } catch (e) {
      print('Error loading progress: $e');
      setState(() {
        isLoading = false;
      });
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
        title: Text('${widget.totalDays} Days Cardio Plan'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: widget.totalDays,
              itemBuilder: (context, index) {
                final day = index + 1;
                final isCompleted = day <= currentCompletedDay;
                final isUnlocked = day <= currentCompletedDay + 1;

                return InkWell(
                  onTap: isUnlocked
                      ? () {
                          context.go(
                            '/cardio-workout/${widget.totalDays}/$day',
                          );
                        }
                      : null,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? Theme.of(context).primaryColor.withOpacity(0.8)
                          : isUnlocked
                          ? Theme.of(context).primaryColor.withOpacity(0.2)
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Day ${index + 1}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isCompleted
                                ? Colors.white
                                : isUnlocked
                                ? Theme.of(context).primaryColor
                                : Colors.grey[600],
                          ),
                        ),
                        if (isCompleted) ...[
                          const SizedBox(height: 4),
                          const Icon(Icons.check_circle, color: Colors.white),
                        ] else if (!isUnlocked) ...[
                          const SizedBox(height: 4),
                          const Icon(Icons.lock, color: Colors.grey),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
