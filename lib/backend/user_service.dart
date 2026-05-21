import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/app_user.dart';

class UserService {
  UserService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  User? get currentFirebaseUser => _auth.currentUser;

  Future<AppUser?> getCurrentUserProfile() async {
    final user = _auth.currentUser;

    if (user == null) {
      return null;
    }

    final doc = await _firestore.collection('users').doc(user.uid).get();

    if (!doc.exists) {
      return null;
    }

    return AppUser.fromFirestore(doc);
  }

  Stream<AppUser?> currentUserProfileStream() {
    final user = _auth.currentUser;

    if (user == null) {
      return const Stream.empty();
    }

    return _firestore.collection('users').doc(user.uid).snapshots().map((doc) {
      if (!doc.exists) {
        return null;
      }

      return AppUser.fromFirestore(doc);
    });
  }

  Future<void> createUserProfile(AppUser appUser) async {
    await _firestore.collection('users').doc(appUser.uid).set(appUser.toMap());
  }

  Future<void> updateCurrentUserProfile({
    required String fullName,
    required String degree,
    required String careerInterest,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User must be logged in.');
    }

    await _firestore.collection('users').doc(user.uid).update({
      'fullName': fullName.trim(),
      'degree': degree.trim(),
      'careerInterest': careerInterest.trim(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateCareerInterest(String careerInterest) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User must be logged in.');
    }

    await _firestore.collection('users').doc(user.uid).update({
      'careerInterest': careerInterest.trim(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteCurrentUserProfile() async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User must be logged in.');
    }

    await _firestore.collection('users').doc(user.uid).delete();
  }
}