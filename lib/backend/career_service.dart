import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/career.dart';

class CareerService {
  CareerService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Stream<List<Career>> getCareers() {
    return _firestore
        .collection('careers')
        .orderBy('title')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map(Career.fromFirestore).toList();
    });
  }

  Future<Career?> getCareerById(String careerId) async {
    final doc = await _firestore.collection('careers').doc(careerId).get();

    if (!doc.exists) {
      return null;
    }

    return Career.fromFirestore(doc);
  }

  Future<List<Career>> getCareersByCategory(String category) async {
    final snapshot = await _firestore
        .collection('careers')
        .where('category', isEqualTo: category)
        .orderBy('title')
        .get();

    return snapshot.docs.map(Career.fromFirestore).toList();
  }
}