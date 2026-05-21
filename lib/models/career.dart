import 'package:cloud_firestore/cloud_firestore.dart';

class Career {
  const Career({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.requiredSkills,
    required this.entryLevelRoles,
    required this.averageSalary,
  });

  final String id;
  final String title;
  final String category;
  final String description;
  final List<String> requiredSkills;
  final List<String> entryLevelRoles;
  final String averageSalary;

  factory Career.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};

    return Career(
      id: doc.id,
      title: data['title']?.toString() ?? '',
      category: data['category']?.toString() ?? '',
      description: data['description']?.toString() ?? '',
      requiredSkills: List<String>.from(data['requiredSkills'] ?? []),
      entryLevelRoles: List<String>.from(data['entryLevelRoles'] ?? []),
      averageSalary: data['averageSalary']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'category': category,
      'description': description,
      'requiredSkills': requiredSkills,
      'entryLevelRoles': entryLevelRoles,
      'averageSalary': averageSalary,
    };
  }
}