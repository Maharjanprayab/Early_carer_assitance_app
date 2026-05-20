import 'package:flutter/material.dart';

import '../../backend/skill_gap_service.dart';

class TestSkillGapScreen extends StatefulWidget {
  const TestSkillGapScreen({super.key});

  @override
  State<TestSkillGapScreen> createState() => _TestSkillGapScreenState();
}

class _TestSkillGapScreenState extends State<TestSkillGapScreen> {
  final _skillGapService = SkillGapService();

  String _message = 'Skill gap not tested yet';

  Future<void> _testSkillGap() async {
    try {
      final result = await _skillGapService.analyseSkillGap(
        careerId: 'frontend_developer',
        userSkills: ['HTML', 'CSS', 'Python'],
      );

      setState(() {
        _message = result.toString();
      });
    } catch (e) {
      setState(() {
        _message = 'Skill gap test failed: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Skill Gap Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(_message),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _testSkillGap,
              child: const Text('Test Skill Gap'),
            ),
          ],
        ),
      ),
    );
  }
}