import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'screens/careers/test_career_screen.dart';
import 'screens/recommendations/test_recommendation_screen.dart';
import 'screens/auth/test_auth_screen.dart';
import 'screens/skills/test_skill_gap_screen.dart';
import 'screens/resume/test_resume_screen.dart';
import 'screens/portfolio/test_portfolio_screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const EarlyCareerApp());
}

class EarlyCareerApp extends StatelessWidget {
  const EarlyCareerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Early Career Assistance',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: TestResumeScreen(),
    );
  }
}

class FirebaseConnectionTestScreen extends StatelessWidget {
  const FirebaseConnectionTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Firebase connected successfully',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}