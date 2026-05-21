import 'package:flutter/material.dart';

import '../../models/recommendation_item.dart';

import '../../backend/auth_service.dart';
import '../../backend/recommendation_service.dart';
import '../../backend/skill_gap_service.dart';

class TestRecommendationScreen extends StatefulWidget {
  const TestRecommendationScreen({super.key});

  @override
  State<TestRecommendationScreen> createState() =>
      _TestRecommendationScreenState();
}

class _TestRecommendationScreenState extends State<TestRecommendationScreen> {
  final AuthService _authService = AuthService();
  final SkillGapService _skillGapService = SkillGapService();
  final RecommendationService _recommendationService = RecommendationService();

  String _message = 'Recommendations not tested yet.';

  Future<void> _loginOrCreateTestUser() async {
    try {
      await _authService.login(
        email: 'recommendationtest@example.com',
        password: 'Password123!',
      );
    } catch (_) {
      await _authService.signUp(
        fullName: 'Recommendation Test Student',
        email: 'recommendationtest@example.com',
        password: 'Password123!',
        degree: 'Bachelor of IT',
      );
    }
  }

  Future<void> _testFrontendRecommendations() async {
    try {
      await _loginOrCreateTestUser();

      final skillGapResult = await _skillGapService.analyseSkillGap(
        careerId: 'frontend_developer',
        userSkills: ['HTML', 'CSS', 'Python'],
      );

      final missingSkills = skillGapResult.missingSkills;

      await _recommendationService.generateRecommendations(
        careerId: 'frontend_developer',
        missingSkills: missingSkills,
      );

      setState(() {
        _message = 'Recommendations generated for: ${missingSkills.join(', ')}';
      });
    } catch (e) {
      setState(() {
        _message = 'Recommendation test failed: $e';
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
      appBar: AppBar(title: const Text('Recommendation Backend Test')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(_message),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _testFrontendRecommendations,
              child: const Text('Generate Frontend Recommendations'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(onPressed: _logout, child: const Text('Logout')),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<List<RecommendationItem>>(
                stream: _authService.currentUser == null
                ? const Stream.empty()
                : _recommendationService.getMyRecommendations(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final recommendations = snapshot.data ?? [];

                  if (recommendations.isEmpty) {
                    return const Text('No recommendations found yet.');
                  }

                  return ListView.separated(
                    itemCount: recommendations.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final recommendation = recommendations[index];

                      return Card(
                        child: ListTile(
                          title: Text(
                            recommendation.title.isEmpty
                                ? 'No title'
                                : recommendation.title,
                          ),
                          subtitle: Text(
                            '${recommendation.missingSkill} • '
                            '${recommendation.provider} • '
                            '${recommendation.priority}',
                          ),
                        ),
                      );
                    },
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
