import 'package:flutter/material.dart';

import 'test_auth_screen.dart';
import 'test_career_screen.dart';
import 'test_skill_gap_screen.dart';
import 'test_recommendation_screen.dart';
import 'test_resume_screen.dart';
import 'test_portfolio_screen.dart';
import 'test_user_profile_screen.dart';

class DevTestMenuScreen extends StatelessWidget {
  const DevTestMenuScreen({super.key});

  void _openScreen(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    final testScreens = [
      _DevTestItem(
        title: 'Auth Test',
        screen: const TestAuthScreen(),
      ),
      _DevTestItem(
        title: 'Career Test',
        screen: TestCareerScreen(),
      ),
      _DevTestItem(
        title: 'Skill Gap Test',
        screen: const TestSkillGapScreen(),
      ),
      _DevTestItem(
        title: 'Recommendation Test',
        screen: const TestRecommendationScreen(),
      ),
      _DevTestItem(
        title: 'Resume Test',
        screen: const TestResumeScreen(),
      ),
      _DevTestItem(
        title: 'Portfolio Test',
        screen: const TestPortfolioScreen(),
      ),
      _DevTestItem(
        title: 'User Profile Test',
        screen: const TestUserProfileScreen(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Backend Dev Test Menu'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: testScreens.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final item = testScreens[index];

          return Card(
            child: ListTile(
              title: Text(item.title),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _openScreen(context, item.screen),
            ),
          );
        },
      ),
    );
  }
}

class _DevTestItem {
  const _DevTestItem({
    required this.title,
    required this.screen,
  });

  final String title;
  final Widget screen;
}