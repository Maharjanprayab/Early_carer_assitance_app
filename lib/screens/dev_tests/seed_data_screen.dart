import 'package:flutter/material.dart';

import '../../backend/backend.dart';

class SeedDataScreen extends StatefulWidget {
  const SeedDataScreen({super.key});

  @override
  State<SeedDataScreen> createState() => _SeedDataScreenState();
}

class _SeedDataScreenState extends State<SeedDataScreen> {
  final SeedDataService _seedDataService = SeedDataService();

  bool _isLoading = false;
  String _message = 'Seed data has not been uploaded yet.';

  Future<void> _seedData() async {
    setState(() {
      _isLoading = true;
      _message = 'Uploading careers and recommendation rules...';
    });

    try {
      await _seedDataService.seedCareersAndRecommendationRules();

      if (!mounted) return;

      setState(() {
        _message = 'Seed data uploaded successfully.';
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _message = 'Seed data upload failed: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text('Seed Firestore Data'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(_message),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
              ),
              onPressed: _isLoading ? null : _seedData,
              icon: _isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.cloud_upload),
              label: Text(_isLoading ? 'Uploading...' : 'Upload Seed Data'),
            ),
          ],
        ),
      ),
    );
  }
}