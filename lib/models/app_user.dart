import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  const AppUser({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.degree,
    required this.careerInterest,
    required this.createdAt,
    required this.updatedAt,
  });

  final String uid;
  final String fullName;
  final String email;
  final String degree;
  final String careerInterest;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory AppUser.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};

    return AppUser(
      uid: data['uid']?.toString() ?? doc.id,
      fullName: data['fullName']?.toString() ?? '',
      email: data['email']?.toString() ?? '',
      degree: data['degree']?.toString() ?? '',
      careerInterest: data['careerInterest']?.toString() ?? '',
      createdAt: data['createdAt'] is Timestamp
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: data['updatedAt'] is Timestamp
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'degree': degree,
      'careerInterest': careerInterest,
      'createdAt': createdAt == null
          ? FieldValue.serverTimestamp()
          : Timestamp.fromDate(createdAt!),
      'updatedAt': updatedAt == null
          ? FieldValue.serverTimestamp()
          : Timestamp.fromDate(updatedAt!),
    };
  }

  Map<String, dynamic> toUpdateMap() {
    return {
      'fullName': fullName,
      'degree': degree,
      'careerInterest': careerInterest,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  AppUser copyWith({
    String? uid,
    String? fullName,
    String? email,
    String? degree,
    String? careerInterest,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      degree: degree ?? this.degree,
      careerInterest: careerInterest ?? this.careerInterest,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}