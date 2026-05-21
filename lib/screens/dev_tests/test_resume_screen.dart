import 'package:flutter/material.dart';

import '../../backend/backend.dart';
import '../../models/models.dart';

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

  ResumeData _sampleResumeData() {
  return const ResumeData(
    id: '',
    personalDetails: {
      'fullName': 'Resume Test Student',
      'email': 'resumetest@example.com',
      'phone': '0400000000',
      'location': 'Melbourne, Australia',
    },
    summary:
        'Entry-level IT student interested in software development and backend systems.',
    education: [
      {
        'institution': 'Kent Institute Australia',
        'degree': 'Bachelor of Information Technology',
        'startYear': '2024',
        'endYear': 'Present',
      }
    ],
    skills: [
      'Flutter',
      'Firebase',
      'Firestore',
      'Dart',
      'Git',
    ],
    projects: [
      {
        'title': 'Early Career Assistance App',
        'description':
            'A Flutter and Firebase app that helps students explore careers and analyse skill gaps.',
        'technologies': ['Flutter', 'Firebase', 'Firestore'],
      }
    ],
    experience: [],
    createdAt: null,
    updatedAt: null,
  );
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

      await _resumeService.updateResumeFields(
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

  Stream<List<ResumeData>>? _resumeStream() {
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
                  : StreamBuilder<List<ResumeData>>(
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

                        final resumes = snapshot.data ?? [];

                        if (resumes.isEmpty) {
                          return const Text('No resumes found.');
                        }

                        return ListView.separated(
                          itemCount: resumes.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final resume = resumes[index];

                            final fullName =
                                resume.personalDetails['fullName']?.toString() ?? 'No name';
                            final summary =
                                resume.summary.isEmpty ? 'No summary' : resume.summary;

                            return Card(
                              child: ListTile(
                                title: Text(fullName),
                                subtitle: Text(summary),
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