import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResumeService {
  ResumeService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  Future<String> createResume(Map<String, dynamic> resumeData) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User must be logged in.');
    }

    final docRef = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('resumes')
        .add({
      ...resumeData,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return docRef.id;
  }

  Future<void> updateResume({
    required String resumeId,
    required Map<String, dynamic> resumeData,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User must be logged in.');
    }

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('resumes')
        .doc(resumeId)
        .update({
      ...resumeData,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMyResumes() {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User must be logged in.');
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('resumes')
        .orderBy('updatedAt', descending: true)
        .snapshots();
  }

  Future<void> deleteResume(String resumeId) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User must be logged in.');
    }

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('resumes')
        .doc(resumeId)
        .delete();
  }
}