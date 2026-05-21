import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/resume_data.dart';

class ResumeService {
  ResumeService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  Future<String> createResume({
    required ResumeData resumeData,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User must be logged in.');
    }

    final resumeRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('resumes')
        .doc();

    final resume = resumeData.copyWith(id: resumeRef.id);

    await resumeRef.set(resume.toMap());

    return resumeRef.id;
  }

  Stream<List<ResumeData>> getMyResumes() {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User must be logged in.');
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('resumes')
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map(ResumeData.fromFirestore).toList();
    });
  }

  Future<ResumeData?> getResumeById({
    required String resumeId,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User must be logged in.');
    }

    final doc = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('resumes')
        .doc(resumeId)
        .get();

    if (!doc.exists) {
      return null;
    }

    return ResumeData.fromFirestore(doc);
  }

  Future<void> updateResume({
    required String resumeId,
    required ResumeData resumeData,
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
        .update(resumeData.toUpdateMap());
  }

  Future<void> updateResumeFields({
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

  Future<void> deleteResume({
    required String resumeId,
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
        .delete();
  }
}