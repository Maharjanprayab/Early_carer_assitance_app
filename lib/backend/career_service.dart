import 'package:cloud_firestore/cloud_firestore.dart';

class CareerService {
  CareerService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Stream<QuerySnapshot<Map<String, dynamic>>> getCareers() {
    return _firestore.collection('careers').orderBy('title').snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getCareerById(
    String careerId,
  ) {
    return _firestore.collection('careers').doc(careerId).get();
  }

  Future<List<Map<String, dynamic>>> getCareersByCategory(
    String category,
  ) async {
    final snapshot = await _firestore
        .collection('careers')
        .where('category', isEqualTo: category)
        .orderBy('title')
        .get();

    return snapshot.docs.map((doc) {
      return {
        'id': doc.id,
        ...doc.data(),
      };
    }).toList();
  }
}