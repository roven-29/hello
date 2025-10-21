import 'package:flutter/material.dart';
import 'screens/welcome_page.dart';
import 'screens/fitness_quote_page.dart';
import 'screens/motivational_quote_page.dart';
import 'screens/login_page.dart';
import 'screens/register_page.dart';
import 'screens/gender_selection_page.dart';
import 'screens/age_height_page.dart';
import 'screens/weight_goals_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlexMind Fit',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WelcomePage(),
      routes: {
        '/fitness': (context) => const FitnessQuotePage(),
        '/motivational': (context) => const MotivationalQuotePage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/gender': (context) => const GenderSelectionPage(),
        '/age-height': (context) => const AgeHeightPage(),
        '/weight-goals': (context) => const WeightGoalsPage(),
      },
    );
  }
}
