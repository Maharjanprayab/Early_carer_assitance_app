import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/portfolio_project.dart';

class PortfolioService {
  PortfolioService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  Future<String> addProject({
    required String title,
    required String description,
    required List<String> technologies,
    String githubUrl = '',
    String imageUrl = '',
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User must be logged in.');
    }

    final projectRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('portfolioProjects')
        .doc();

    final project = PortfolioProject(
      id: projectRef.id,
      title: title.trim(),
      description: description.trim(),
      technologies: technologies,
      githubUrl: githubUrl.trim(),
      imageUrl: imageUrl.trim(),
      createdAt: null,
      updatedAt: null,
    );

    await projectRef.set(project.toMap());

    return projectRef.id;
  }

  Stream<List<PortfolioProject>> getMyProjects() {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User must be logged in.');
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('portfolioProjects')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map(PortfolioProject.fromFirestore).toList();
    });
  }

  Future<PortfolioProject?> getProjectById({
    required String projectId,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User must be logged in.');
    }

    final doc = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('portfolioProjects')
        .doc(projectId)
        .get();

    if (!doc.exists) {
      return null;
    }

    return PortfolioProject.fromFirestore(doc);
  }

  Future<void> updateProject({
    required String projectId,
    required PortfolioProject project,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User must be logged in.');
    }

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('portfolioProjects')
        .doc(projectId)
        .update(project.toUpdateMap());
  }

  Future<void> updateProjectFields({
    required String projectId,
    required Map<String, dynamic> projectData,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User must be logged in.');
    }

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('portfolioProjects')
        .doc(projectId)
        .update({
      ...projectData,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteProject({
    required String projectId,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User must be logged in.');
    }

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('portfolioProjects')
        .doc(projectId)
        .delete();
  }
}