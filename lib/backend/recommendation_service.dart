import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/recommendation_item.dart';

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

        final recommendation = RecommendationItem(
          id: recommendationRef.id,
          basedOnCareerId: careerId,
          missingSkill: skill,
          type: data['type']?.toString() ?? 'Course',
          title: data['title']?.toString() ?? '',
          provider: data['provider']?.toString() ?? '',
          url: data['url']?.toString() ?? '',
          priority: data['priority']?.toString() ?? 'Medium',
          createdAt: null,
        );

        batch.set(recommendationRef, recommendation.toMap());
      }
    }

    await batch.commit();
  }

  Stream<List<RecommendationItem>> getMyRecommendations() {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User must be logged in.');
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('recommendations')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map(RecommendationItem.fromFirestore).toList();
    });
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