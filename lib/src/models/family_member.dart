import 'package:cloud_firestore/cloud_firestore.dart';

class FamilyMember {
  final String id;
  final String name;
  final int age;
  final int weight;
  final String notes;
  final Timestamp createdAt;
  final String createdBy;

  FamilyMember({
    required this.id,
    required this.name,
    required this.age,
    required this.weight,
    required this.notes,
    required this.createdAt,
    required this.createdBy,
  });

  factory FamilyMember.fromJson(Map<String, dynamic> json, String id) {
    return FamilyMember(
      id: id,
      name: json['name'] as String,
      age: json['age'] as int,
      weight: json['weight'] as int,
      notes: json['notes'] as String,
      createdAt: json['createdAt'] as Timestamp,
      createdBy: json['createdBy'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'weight': weight,
      'notes': notes,
      'createdAt': createdAt,
      'createdBy': createdBy,
    };
  }
}