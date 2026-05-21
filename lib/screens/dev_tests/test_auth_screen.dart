import 'package:flutter/material.dart';
import '../../backend/backend.dart';

class TestAuthScreen extends StatefulWidget {
  const TestAuthScreen({super.key});

  @override
  State<TestAuthScreen> createState() => _TestAuthScreenState();
}

class _TestAuthScreenState extends State<TestAuthScreen> {
  final _authService = AuthService();

  String _message = 'Not tested yet';

  Future<void> _testSignup() async {
    try {
      final email =
          'test${DateTime.now().millisecondsSinceEpoch}@example.com';

      await _authService.signUp(
        fullName: 'Test Student',
        email: email,
        password: 'Password123!',
        degree: 'Bachelor of IT',
      );

      setState(() {
        _message = 'Signup successful: $email';
      });
    } catch (e) {
      setState(() {
        _message = 'Signup failed: $e';
      });
    }
  }

  Future<void> _testLogout() async {
    await _authService.logout();

    setState(() {
      _message = 'Logged out successfully';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Backend Auth Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(_message),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _testSignup,
              child: const Text('Test Signup'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _testLogout,
              child: const Text('Test Logout'),
            ),
          ],
        ),
      ),
    );
  }
}