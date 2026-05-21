import 'package:cloud_firestore/cloud_firestore.dart';

class ResumeData {
  const ResumeData({
    required this.id,
    required this.personalDetails,
    required this.summary,
    required this.education,
    required this.skills,
    required this.projects,
    required this.experience,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final Map<String, dynamic> personalDetails;
  final String summary;
  final List<Map<String, dynamic>> education;
  final List<String> skills;
  final List<Map<String, dynamic>> projects;
  final List<Map<String, dynamic>> experience;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory ResumeData.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};

    return ResumeData(
      id: doc.id,
      personalDetails: Map<String, dynamic>.from(
        data['personalDetails'] ?? {},
      ),
      summary: data['summary']?.toString() ?? '',
      education: _mapList(data['education']),
      skills: List<String>.from(data['skills'] ?? []),
      projects: _mapList(data['projects']),
      experience: _mapList(data['experience']),
      createdAt: data['createdAt'] is Timestamp
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: data['updatedAt'] is Timestamp
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  static List<Map<String, dynamic>> _mapList(dynamic value) {
    if (value is! List) {
      return [];
    }

    return value
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  Map<String, dynamic> toMap() {
    return {
      'personalDetails': personalDetails,
      'summary': summary,
      'education': education,
      'skills': skills,
      'projects': projects,
      'experience': experience,
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
      'personalDetails': personalDetails,
      'summary': summary,
      'education': education,
      'skills': skills,
      'projects': projects,
      'experience': experience,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  ResumeData copyWith({
    String? id,
    Map<String, dynamic>? personalDetails,
    String? summary,
    List<Map<String, dynamic>>? education,
    List<String>? skills,
    List<Map<String, dynamic>>? projects,
    List<Map<String, dynamic>>? experience,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ResumeData(
      id: id ?? this.id,
      personalDetails: personalDetails ?? this.personalDetails,
      summary: summary ?? this.summary,
      education: education ?? this.education,
      skills: skills ?? this.skills,
      projects: projects ?? this.projects,
      experience: experience ?? this.experience,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}