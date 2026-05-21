import 'package:flutter/material.dart';

import '../../backend/career_service.dart';
import '../../models/career.dart';

class TestCareerScreen extends StatelessWidget {
  TestCareerScreen({super.key});

  final CareerService _careerService = CareerService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Career Service Test'),
      ),
      body: StreamBuilder<List<Career>>(
        stream: _careerService.getCareers(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final careers = snapshot.data ?? [];

          if (careers.isEmpty) {
            return const Center(
              child: Text('No careers found. Add careers in Firestore.'),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: careers.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final career = careers[index];

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        career.title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(career.category),
                      const SizedBox(height: 8),
                      Text(career.description),
                      const SizedBox(height: 8),
                      Text(
                        'Required skills: ${career.requiredSkills.join(', ')}',
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}