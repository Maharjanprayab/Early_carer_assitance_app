import 'package:cloud_firestore/cloud_firestore.dart';

class SkillGapResult {
  const SkillGapResult({
    required this.id,
    required this.selectedCareerId,
    required this.careerTitle,
    required this.userSkills,
    required this.requiredSkills,
    required this.matchedSkills,
    required this.missingSkills,
    required this.matchPercentage,
    required this.createdAt,
  });

  final String id;
  final String selectedCareerId;
  final String careerTitle;
  final List<String> userSkills;
  final List<String> requiredSkills;
  final List<String> matchedSkills;
  final List<String> missingSkills;
  final int matchPercentage;
  final DateTime? createdAt;

  factory SkillGapResult.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};

    return SkillGapResult(
      id: doc.id,
      selectedCareerId: data['selectedCareerId']?.toString() ?? '',
      careerTitle: data['careerTitle']?.toString() ?? '',
      userSkills: List<String>.from(data['userSkills'] ?? []),
      requiredSkills: List<String>.from(data['requiredSkills'] ?? []),
      matchedSkills: List<String>.from(data['matchedSkills'] ?? []),
      missingSkills: List<String>.from(data['missingSkills'] ?? []),
      matchPercentage: data['matchPercentage'] is int
          ? data['matchPercentage'] as int
          : int.tryParse(data['matchPercentage']?.toString() ?? '0') ?? 0,
      createdAt: data['createdAt'] is Timestamp
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'selectedCareerId': selectedCareerId,
      'careerTitle': careerTitle,
      'userSkills': userSkills,
      'requiredSkills': requiredSkills,
      'matchedSkills': matchedSkills,
      'missingSkills': missingSkills,
      'matchPercentage': matchPercentage,
      'createdAt': createdAt == null
          ? FieldValue.serverTimestamp()
          : Timestamp.fromDate(createdAt!),
    };
  }

  SkillGapResult copyWith({
    String? id,
    String? selectedCareerId,
    String? careerTitle,
    List<String>? userSkills,
    List<String>? requiredSkills,
    List<String>? matchedSkills,
    List<String>? missingSkills,
    int? matchPercentage,
    DateTime? createdAt,
  }) {
    return SkillGapResult(
      id: id ?? this.id,
      selectedCareerId: selectedCareerId ?? this.selectedCareerId,
      careerTitle: careerTitle ?? this.careerTitle,
      userSkills: userSkills ?? this.userSkills,
      requiredSkills: requiredSkills ?? this.requiredSkills,
      matchedSkills: matchedSkills ?? this.matchedSkills,
      missingSkills: missingSkills ?? this.missingSkills,
      matchPercentage: matchPercentage ?? this.matchPercentage,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}