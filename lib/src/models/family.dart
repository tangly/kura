import 'package:cloud_firestore/cloud_firestore.dart';

class Family {
  final String id;
  final String name;
  final Timestamp createdAt;
  final String createdBy;
  final List<String> admins;

  Family({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.createdBy,
    required this.admins,
  });

  factory Family.fromJson(Map<String, dynamic> json) {
    return Family(
      id: json['id'] as String,
      name: json['name'] as String,
      createdAt: json['createdAt'] as Timestamp,
      createdBy: json['createdBy'] as String,
      admins: List<String>.from(json['admins'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'createdAt': createdAt,
      'createdBy': createdBy,
      'admins': admins,
    };
  }
}