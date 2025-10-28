import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class CardioPlanSelectionPage extends StatelessWidget {
  const CardioPlanSelectionPage({super.key});

  Future<void> _handlePlanSelection(BuildContext context, int days) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign in to select a plan')),
      );
      context.go('/login');
      return;
    }

    try {
      // Save the selected plan to Firestore
      await FirebaseFirestore.instance.collection('user_plans').add({
        'userId': uid,
        'type': 'cardio',
        'days': days,
        'startDate': DateTime.now(),
      });

      if (context.mounted) {
        context.go('/cardio-days/$days');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving plan: $e')));
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
        title: const Text('Choose Your Cardio Plan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Select your preferred plan duration:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 24),
            _buildPlanCard(
              context,
              days: 7,
              title: '7 Days Challenge',
              description: 'Perfect for beginners or a quick cardio boost',
            ),
            const SizedBox(height: 16),
            _buildPlanCard(
              context,
              days: 30,
              title: '30 Days Transformation',
              description: 'Comprehensive cardio program for lasting results',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(
    BuildContext context, {
    required int days,
    required String title,
    required String description,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () => _handlePlanSelection(context, days),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.timer_outlined),
                  const SizedBox(width: 8),
                  Text('$days days'),
                  const Spacer(),
                  const Icon(Icons.arrow_forward),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
