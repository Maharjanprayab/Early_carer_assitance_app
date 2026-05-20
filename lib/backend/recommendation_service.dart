import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecommendationService {
  RecommendationService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  Future<void> generateRecommendations({
    required String careerId,
    required List<String> missingSkills,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User must be logged in.');
    }

    final batch = _firestore.batch();

    for (final skill in missingSkills) {
      final rulesSnapshot = await _firestore
          .collection('recommendationRules')
          .where('careerId', isEqualTo: careerId)
          .where('skill', isEqualTo: skill)
          .get();

      for (final ruleDoc in rulesSnapshot.docs) {
        final data = ruleDoc.data();

        final recommendationRef = _firestore
            .collection('users')
            .doc(user.uid)
            .collection('recommendations')
            .doc();

        batch.set(recommendationRef, {
          'basedOnCareerId': careerId,
          'missingSkill': skill,
          'type': data['type'] ?? 'Course',
          'title': data['title'] ?? data['recommendationTitle'] ?? '',
          'provider': data['provider'] ?? '',
          'url': data['url'] ?? '',
          'priority': data['priority'] ?? 'Medium',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    }

    await batch.commit();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMyRecommendations() {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User must be logged in.');
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('recommendations')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> deleteRecommendation(String recommendationId) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User must be logged in.');
    }

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('recommendations')
        .doc(recommendationId)
        .delete();
  }
}