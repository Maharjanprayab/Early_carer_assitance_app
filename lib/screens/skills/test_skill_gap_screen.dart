import 'package:flutter/material.dart';

import '../../backend/backend.dart';

class TestSkillGapScreen extends StatefulWidget {
  const TestSkillGapScreen({super.key});

  @override
  State<TestSkillGapScreen> createState() => _TestSkillGapScreenState();
}

class _TestSkillGapScreenState extends State<TestSkillGapScreen> {
  final AuthService _authService = AuthService();
  final SkillGapService _skillGapService = SkillGapService();

  String _message = 'Skill gap not tested yet.';

  Future<void> _loginOrCreateTestUser() async {
    try {
      await _authService.login(
        email: 'skilltest@example.com',
        password: 'Password123!',
      );

      setState(() {
        _message = 'Logged in as skilltest@example.com';
      });
    } catch (_) {
      await _authService.signUp(
        fullName: 'Skill Test Student',
        email: 'skilltest@example.com',
        password: 'Password123!',
        degree: 'Bachelor of IT',
      );

      setState(() {
        _message = 'Created and logged in as skilltest@example.com';
      });
    }
  }

  Future<void> _testFrontendSkillGap() async {
    try {
      await _loginOrCreateTestUser();

      final result = await _skillGapService.analyseSkillGap(
        careerId: 'frontend_developer',
        userSkills: ['HTML', 'CSS', 'Python'],
      );

      setState(() {
        _message =
            '''
Career: ${result.careerTitle}
Match: ${result.matchPercentage}%

Matched skills:
${result.matchedSkills.join(', ')}

Missing skills:
${result.missingSkills.join(', ')}
''';
      });
    } catch (e) {
      setState(() {
        _message = 'Skill gap test failed: $e';
      });
    }
  }

  Future<void> _testBackendSkillGap() async {
    try {
      await _loginOrCreateTestUser();

      final result = await _skillGapService.analyseSkillGap(
        careerId: 'backend_developer',
        userSkills: ['Firebase', 'Git', 'Dart'],
      );

      setState(() {
        _message =
            '''
Career: ${result.careerTitle}
Match: ${result.matchPercentage}%

Matched skills:
${result.matchedSkills.join(', ')}

Missing skills:
${result.missingSkills.join(', ')}
''';
      });
    } catch (e) {
      setState(() {
        _message = 'Skill gap test failed: $e';
      });
    }
  }

  Future<void> _logout() async {
    await _authService.logout();

    setState(() {
      _message = 'Logged out.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Skill Gap Backend Test')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(_message),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _testFrontendSkillGap,
              child: const Text('Test Frontend Skill Gap'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _testBackendSkillGap,
              child: const Text('Test Backend Skill Gap'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(onPressed: _logout, child: const Text('Logout')),
          ],
        ),
      ),
    );
  }
}
