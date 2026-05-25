import 'package:flutter/material.dart';

import 'backend/backend.dart';

class FindJobsScreen extends StatelessWidget {
  const FindJobsScreen({super.key});

  final List<Map<String, String>> jobs = const [
    {
      'title': 'Junior Flutter Developer',
      'company': 'TechNova Solutions',
      'location': 'Sydney, NSW',
      'salary': r'$70,000 - $85,000',
      'skills': 'Flutter, Firebase, Git',
      'category': 'Mobile App Developer',
    },
    {
      'title': 'Frontend Developer Intern',
      'company': 'BrightWeb Studio',
      'location': 'Melbourne, VIC',
      'salary': r'$55,000 - $65,000',
      'skills': 'HTML, CSS, JavaScript, React',
      'category': 'Web Developer',
    },
    {
      'title': 'IT Support Technician',
      'company': 'CloudCare IT',
      'location': 'Brisbane, QLD',
      'salary': r'$60,000 - $72,000',
      'skills': 'Networking, Troubleshooting, Windows',
      'category': 'IT Support',
    },
    {
      'title': 'Data Analyst Graduate',
      'company': 'DataPath Analytics',
      'location': 'Remote',
      'salary': r'$68,000 - $80,000',
      'skills': 'SQL, Excel, Power BI, Python',
      'category': 'Data Analyst',
    },
  ];

  Future<void> _applyForJob(
    BuildContext context,
    Map<String, String> job,
  ) async {
    try {
      await JobApplicationService().applyForJob(
        jobTitle: job['title'] ?? '',
        company: job['company'] ?? '',
        location: job['location'] ?? '',
        category: job['category'] ?? 'General',
      );

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Applied for ${job['title']}')),
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Apply failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text('Find Jobs'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: jobs.length,
        itemBuilder: (context, index) {
          final job = jobs[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    job['title'] ?? '',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Company: ${job['company'] ?? ''}'),
                  Text('Location: ${job['location'] ?? ''}'),
                  Text('Salary: ${job['salary'] ?? ''}'),
                  const SizedBox(height: 8),
                  Text('Skills: ${job['skills'] ?? ''}'),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => _applyForJob(context, job),
                      icon: const Icon(Icons.send),
                      label: const Text('Apply Now'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}