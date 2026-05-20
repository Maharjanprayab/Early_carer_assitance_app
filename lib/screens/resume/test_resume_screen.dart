import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../backend/auth_service.dart';
import '../../backend/resume_service.dart';

class TestResumeScreen extends StatefulWidget {
  const TestResumeScreen({super.key});

  @override
  State<TestResumeScreen> createState() => _TestResumeScreenState();
}

class _TestResumeScreenState extends State<TestResumeScreen> {
  final AuthService _authService = AuthService();
  final ResumeService _resumeService = ResumeService();

  String _message = 'Resume backend not tested yet.';
  String? _lastResumeId;

  Future<void> _loginOrCreateTestUser() async {
    try {
      await _authService.login(
        email: 'resumetest@example.com',
        password: 'Password123!',
      );
    } catch (_) {
      await _authService.signUp(
        fullName: 'Resume Test Student',
        email: 'resumetest@example.com',
        password: 'Password123!',
        degree: 'Bachelor of IT',
      );
    }
  }

  Map<String, dynamic> _sampleResumeData() {
    return {
      'personalDetails': {
        'fullName': 'Resume Test Student',
        'email': 'resumetest@example.com',
        'phone': '0400000000',
        'location': 'Melbourne, Australia',
      },
      'summary':
          'Entry-level IT student interested in software development and backend systems.',
      'education': [
        {
          'institution': 'Kent Institute Australia',
          'degree': 'Bachelor of Information Technology',
          'startYear': '2024',
          'endYear': 'Present',
        }
      ],
      'skills': [
        'Flutter',
        'Firebase',
        'Firestore',
        'Dart',
        'Git',
      ],
      'projects': [
        {
          'title': 'Early Career Assistance App',
          'description':
              'A Flutter and Firebase app that helps students explore careers and analyse skill gaps.',
          'technologies': ['Flutter', 'Firebase', 'Firestore'],
        }
      ],
      'experience': [],
    };
  }

  Future<void> _createResume() async {
    try {
      await _loginOrCreateTestUser();

      final resumeId = await _resumeService.createResume(
        resumeData: _sampleResumeData(),
      );

      setState(() {
        _lastResumeId = resumeId;
        _message = 'Resume created successfully. ID: $resumeId';
      });
    } catch (e) {
      setState(() {
        _message = 'Create resume failed: $e';
      });
    }
  }

  Future<void> _updateLastResume() async {
    try {
      await _loginOrCreateTestUser();

      final resumeId = _lastResumeId;

      if (resumeId == null) {
        setState(() {
          _message = 'Create a resume first before updating.';
        });
        return;
      }

      await _resumeService.updateResume(
        resumeId: resumeId,
        resumeData: {
          'summary':
              'Updated summary: IT student focused on Flutter, Firebase, and backend development.',
          'skills': [
            'Flutter',
            'Firebase',
            'Firestore',
            'Dart',
            'Git',
            'REST APIs',
          ],
        },
      );

      setState(() {
        _message = 'Resume updated successfully. ID: $resumeId';
      });
    } catch (e) {
      setState(() {
        _message = 'Update resume failed: $e';
      });
    }
  }

  Future<void> _deleteLastResume() async {
    try {
      await _loginOrCreateTestUser();

      final resumeId = _lastResumeId;

      if (resumeId == null) {
        setState(() {
          _message = 'Create a resume first before deleting.';
        });
        return;
      }

      await _resumeService.deleteResume(resumeId: resumeId);

      setState(() {
        _message = 'Resume deleted successfully. ID: $resumeId';
        _lastResumeId = null;
      });
    } catch (e) {
      setState(() {
        _message = 'Delete resume failed: $e';
      });
    }
  }

  Future<void> _logout() async {
    await _authService.logout();

    setState(() {
      _message = 'Logged out.';
      _lastResumeId = null;
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? _resumeStream() {
    if (_authService.currentUser == null) {
      return null;
    }

    return _resumeService.getMyResumes();
  }

  @override
  Widget build(BuildContext context) {
    final stream = _resumeStream();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resume Backend Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(_message),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _createResume,
              child: const Text('Create Sample Resume'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _updateLastResume,
              child: const Text('Update Last Resume'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: _deleteLastResume,
              child: const Text('Delete Last Resume'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: _logout,
              child: const Text('Logout'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: stream == null
                  ? const Text('Login or create a resume to view data.')
                  : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final docs = snapshot.data?.docs ?? [];

                        if (docs.isEmpty) {
                          return const Text('No resumes found.');
                        }

                        return ListView.separated(
                          itemCount: docs.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final resume = docs[index].data();

                            final personalDetails =
                                Map<String, dynamic>.from(
                              resume['personalDetails'] ?? {},
                            );

                            final fullName =
                                personalDetails['fullName'] ?? 'No name';
                            final summary =
                                resume['summary'] ?? 'No summary';

                            return Card(
                              child: ListTile(
                                title: Text(fullName.toString()),
                                subtitle: Text(summary.toString()),
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