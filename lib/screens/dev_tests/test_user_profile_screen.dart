import 'package:flutter/material.dart';

import '../../backend/backend.dart';
import '../../models/models.dart';

class TestUserProfileScreen extends StatefulWidget {
  const TestUserProfileScreen({super.key});

  @override
  State<TestUserProfileScreen> createState() => _TestUserProfileScreenState();
}

class _TestUserProfileScreenState extends State<TestUserProfileScreen> {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  String _message = 'User profile backend not tested yet.';

  Future<void> _loginOrCreateTestUser() async {
    try {
      await _authService.login(
        email: 'profiletest@example.com',
        password: 'Password123!',
      );
    } catch (_) {
      await _authService.signUp(
        fullName: 'Profile Test Student',
        email: 'profiletest@example.com',
        password: 'Password123!',
        degree: 'Bachelor of IT',
      );
    }
  }

  Future<void> _loadProfile() async {
    try {
      await _loginOrCreateTestUser();

      final profile = await _userService.getCurrentUserProfile();

      if (profile == null) {
        setState(() {
          _message = 'No profile found.';
        });
        return;
      }

      setState(() {
        _message = '''
Profile loaded:

UID: ${profile.uid}
Name: ${profile.fullName}
Email: ${profile.email}
Degree: ${profile.degree}
Career Interest: ${profile.careerInterest.isEmpty ? 'Not set' : profile.careerInterest}
''';
      });
    } catch (e) {
      setState(() {
        _message = 'Load profile failed: $e';
      });
    }
  }

  Future<void> _updateProfile() async {
    try {
      await _loginOrCreateTestUser();

      await _userService.updateCurrentUserProfile(
        fullName: 'Updated Profile Test Student',
        degree: 'Bachelor of Information Technology',
        careerInterest: 'Backend Developer',
      );

      setState(() {
        _message = 'Profile updated successfully.';
      });
    } catch (e) {
      setState(() {
        _message = 'Update profile failed: $e';
      });
    }
  }

  Future<void> _updateCareerInterest() async {
    try {
      await _loginOrCreateTestUser();

      await _userService.updateCareerInterest('Frontend Developer');

      setState(() {
        _message = 'Career interest updated to Frontend Developer.';
      });
    } catch (e) {
      setState(() {
        _message = 'Update career interest failed: $e';
      });
    }
  }

  Future<void> _logout() async {
    await _authService.logout();

    setState(() {
      _message = 'Logged out.';
    });
  }

  Stream<AppUser?>? _profileStream() {
    if (_authService.currentUser == null) {
      return null;
    }

    return _userService.currentUserProfileStream();
  }

  @override
  Widget build(BuildContext context) {
    final stream = _profileStream();

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile Backend Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(_message),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadProfile,
              child: const Text('Load Profile'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _updateProfile,
              child: const Text('Update Profile'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _updateCareerInterest,
              child: const Text('Update Career Interest'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: _logout,
              child: const Text('Logout'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: stream == null
                  ? const Text('Login or load profile to view live profile.')
                  : StreamBuilder<AppUser?>(
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

                        final profile = snapshot.data;

                        if (profile == null) {
                          return const Text('No live profile found.');
                        }

                        return Card(
                          child: ListTile(
                            title: Text(profile.fullName),
                            subtitle: Text(
                              '${profile.email}\n'
                              '${profile.degree}\n'
                              'Interest: ${profile.careerInterest}',
                            ),
                          ),
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