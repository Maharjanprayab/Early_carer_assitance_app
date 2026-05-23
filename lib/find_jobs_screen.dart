import 'package:flutter/material.dart';

class FindJobsScreen extends StatelessWidget {
  const FindJobsScreen({super.key});

  final List<Map<String, String>> jobs = const [
    {
      'title': 'Junior Flutter Developer',
      'company': 'TechNova Solutions',
      'location': 'Sydney, NSW',
      'salary': '\$70,000 - \$85,000',
      'skills': 'Flutter, Firebase, Git',
    },
    {
      'title': 'Frontend Developer Intern',
      'company': 'BrightWeb Studio',
      'location': 'Melbourne, VIC',
      'salary': '\$55,000 - \$65,000',
      'skills': 'HTML, CSS, JavaScript, React',
    },
    {
      'title': 'IT Support Technician',
      'company': 'CloudCare IT',
      'location': 'Brisbane, QLD',
      'salary': '\$60,000 - \$72,000',
      'skills': 'Networking, Troubleshooting, Windows',
    },
    {
      'title': 'Data Analyst Graduate',
      'company': 'DataPath Analytics',
      'location': 'Remote',
      'salary': '\$68,000 - \$80,000',
      'skills': 'SQL, Excel, Power BI, Python',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    job['title']!,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Company: ${job['company']}'),
                  Text('Location: ${job['location']}'),
                  Text('Salary: ${job['salary']}'),
                  const SizedBox(height: 8),
                  Text('Skills: ${job['skills']}'),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Apply feature coming soon'),
                          ),
                        );
                      },
                      child: const Text('Apply Now'),
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
