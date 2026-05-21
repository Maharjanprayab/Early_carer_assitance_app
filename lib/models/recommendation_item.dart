import 'package:cloud_firestore/cloud_firestore.dart';

class RecommendationItem {
  const RecommendationItem({
    required this.id,
    required this.basedOnCareerId,
    required this.missingSkill,
    required this.type,
    required this.title,
    required this.provider,
    required this.url,
    required this.priority,
    required this.createdAt,
  });

  final String id;
  final String basedOnCareerId;
  final String missingSkill;
  final String type;
  final String title;
  final String provider;
  final String url;
  final String priority;
  final DateTime? createdAt;

  factory RecommendationItem.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};

    return RecommendationItem(
      id: doc.id,
      basedOnCareerId: data['basedOnCareerId']?.toString() ?? '',
      missingSkill: data['missingSkill']?.toString() ?? '',
      type: data['type']?.toString() ?? 'Course',
      title: data['title']?.toString() ?? '',
      provider: data['provider']?.toString() ?? '',
      url: data['url']?.toString() ?? '',
      priority: data['priority']?.toString() ?? 'Medium',
      createdAt: data['createdAt'] is Timestamp
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'basedOnCareerId': basedOnCareerId,
      'missingSkill': missingSkill,
      'type': type,
      'title': title,
      'provider': provider,
      'url': url,
      'priority': priority,
      'createdAt': createdAt == null
          ? FieldValue.serverTimestamp()
          : Timestamp.fromDate(createdAt!),
    };
  }

  RecommendationItem copyWith({
    String? id,
    String? basedOnCareerId,
    String? missingSkill,
    String? type,
    String? title,
    String? provider,
    String? url,
    String? priority,
    DateTime? createdAt,
  }) {
    return RecommendationItem(
      id: id ?? this.id,
      basedOnCareerId: basedOnCareerId ?? this.basedOnCareerId,
      missingSkill: missingSkill ?? this.missingSkill,
      type: type ?? this.type,
      title: title ?? this.title,
      provider: provider ?? this.provider,
      url: url ?? this.url,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}