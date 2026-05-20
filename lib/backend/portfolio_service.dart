import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

    final docRef = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('portfolioProjects')
        .add({
      'title': title.trim(),
      'description': description.trim(),
      'technologies': technologies,
      'githubUrl': githubUrl.trim(),
      'imageUrl': imageUrl.trim(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return docRef.id;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMyProjects() {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User must be logged in.');
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('portfolioProjects')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getProjectById({
    required String projectId,
  }) {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User must be logged in.');
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('portfolioProjects')
        .doc(projectId)
        .get();
  }

  Future<void> updateProject({
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