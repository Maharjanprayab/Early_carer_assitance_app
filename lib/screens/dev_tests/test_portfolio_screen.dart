import 'package:flutter/material.dart';

import '../../backend/backend.dart';
import '../../models/models.dart';

class TestPortfolioScreen extends StatefulWidget {
  const TestPortfolioScreen({super.key});

  @override
  State<TestPortfolioScreen> createState() => _TestPortfolioScreenState();
}

class _TestPortfolioScreenState extends State<TestPortfolioScreen> {
  final AuthService _authService = AuthService();
  final PortfolioService _portfolioService = PortfolioService();

  String _message = 'Portfolio backend not tested yet.';
  String? _lastProjectId;

  Future<void> _loginOrCreateTestUser() async {
    try {
      await _authService.login(
        email: 'portfoliotest@example.com',
        password: 'Password123!',
      );
    } catch (_) {
      await _authService.signUp(
        fullName: 'Portfolio Test Student',
        email: 'portfoliotest@example.com',
        password: 'Password123!',
        degree: 'Bachelor of IT',
      );
    }
  }

  Future<void> _createProject() async {
    try {
      await _loginOrCreateTestUser();

      final projectId = await _portfolioService.addProject(
        title: 'Early Career Assistance App',
        description:
            'A Flutter and Firebase app that helps IT students explore career paths, analyse skill gaps, build resumes, and showcase projects.',
        technologies: [
          'Flutter',
          'Firebase',
          'Firestore',
          'Firebase Auth',
          'Firebase Storage',
        ],
        githubUrl: 'https://github.com/example/early-career-assistance-app',
      );

      setState(() {
        _lastProjectId = projectId;
        _message = 'Portfolio project created successfully. ID: $projectId';
      });
    } catch (e) {
      setState(() {
        _message = 'Create project failed: $e';
      });
    }
  }

  Future<void> _updateLastProject() async {
    try {
      await _loginOrCreateTestUser();

      final projectId = _lastProjectId;

      if (projectId == null) {
        setState(() {
          _message = 'Create a project first before updating.';
        });
        return;
      }

      await _portfolioService.updateProjectFields(
        projectId: projectId,
        projectData: {
          'description':
              'Updated project description: backend services implemented using Firebase Auth, Firestore, and Firebase Storage.',
          'technologies': [
            'Flutter',
            'Firebase',
            'Firestore',
            'Authentication',
            'Cloud Storage',
            'GitHub',
          ],
        },
      );

      setState(() {
        _message = 'Portfolio project updated successfully. ID: $projectId';
      });
    } catch (e) {
      setState(() {
        _message = 'Update project failed: $e';
      });
    }
  }

  Future<void> _deleteLastProject() async {
    try {
      await _loginOrCreateTestUser();

      final projectId = _lastProjectId;

      if (projectId == null) {
        setState(() {
          _message = 'Create a project first before deleting.';
        });
        return;
      }

      await _portfolioService.deleteProject(projectId: projectId);

      setState(() {
        _message = 'Portfolio project deleted successfully. ID: $projectId';
        _lastProjectId = null;
      });
    } catch (e) {
      setState(() {
        _message = 'Delete project failed: $e';
      });
    }
  }

  Future<void> _logout() async {
    await _authService.logout();

    setState(() {
      _message = 'Logged out.';
      _lastProjectId = null;
    });
  }

  Stream<List<PortfolioProject>>? _projectStream() {
    if (_authService.currentUser == null) {
      return null;
    }

    return _portfolioService.getMyProjects();
  }

  @override
  Widget build(BuildContext context) {
    final stream = _projectStream();

    return Scaffold(
      appBar: AppBar(title: const Text('Portfolio Backend Test')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(_message),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _createProject,
              child: const Text('Create Sample Portfolio Project'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _updateLastProject,
              child: const Text('Update Last Project'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: _deleteLastProject,
              child: const Text('Delete Last Project'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(onPressed: _logout, child: const Text('Logout')),
            const SizedBox(height: 16),
            Expanded(
              child: stream == null
                  ? const Text('Login or create a project to view data.')
                  : StreamBuilder<List<PortfolioProject>>(
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

                        final projects = snapshot.data ?? [];

                        if (projects.isEmpty) {
                          return const Text('No portfolio projects found.');
                        }

                        return ListView.separated(
                          itemCount: projects.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final project = projects[index];

                            return Card(
                              child: ListTile(
                                title: Text(
                                  project.title.isEmpty
                                      ? 'No title'
                                      : project.title,
                                ),
                                subtitle: Text(
                                  '${project.description}\n\n'
                                  'Technologies: ${project.technologies.join(', ')}',
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
