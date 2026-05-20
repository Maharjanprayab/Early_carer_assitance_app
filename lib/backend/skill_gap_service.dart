import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SkillGapService {
  SkillGapService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  Future<Map<String, dynamic>> analyseSkillGap({
    required String careerId,
    required List<String> userSkills,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User must be logged in.');
    }

    final careerDoc = await _firestore.collection('careers').doc(careerId).get();

    if (!careerDoc.exists) {
      throw Exception('Selected career does not exist.');
    }

    final careerData = careerDoc.data()!;

    final requiredSkills = List<String>.from(
      careerData['requiredSkills'] ?? <String>[],
    );

    final normalisedUserSkills = userSkills
        .map((skill) => skill.trim().toLowerCase())
        .where((skill) => skill.isNotEmpty)
        .toSet();

    final matchedSkills = requiredSkills.where((requiredSkill) {
      return normalisedUserSkills.contains(
        requiredSkill.trim().toLowerCase(),
      );
    }).toList();

    final missingSkills = requiredSkills.where((requiredSkill) {
      return !normalisedUserSkills.contains(
        requiredSkill.trim().toLowerCase(),
      );
    }).toList();

    final matchPercentage = requiredSkills.isEmpty
        ? 0
        : ((matchedSkills.length / requiredSkills.length) * 100).round();

    final result = {
      'selectedCareerId': careerId,
      'careerTitle': careerData['title'] ?? '',
      'userSkills': userSkills,
      'requiredSkills': requiredSkills,
      'matchedSkills': matchedSkills,
      'missingSkills': missingSkills,
      'matchPercentage': matchPercentage,
      'createdAt': FieldValue.serverTimestamp(),
    };

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('skillGapResults')
        .add(result);

    return result;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMySkillGapResults() {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User must be logged in.');
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('skillGapResults')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}