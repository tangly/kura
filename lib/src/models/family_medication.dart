import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class FamilyMedication extends Equatable {
  final String? id;
  final String name;
  final String? dosage;
  final DateTime expirationDate;
  final String? reason;
  final List<String>? members;


  const FamilyMedication({
    this.id,
    required this.name,
    this.dosage,
    required this.expirationDate,
    this.reason,
    this.members,
  });

  FamilyMedication copyWith({
    String? id,
    String? name,
    String? dosage,
    DateTime? expirationDate,
    String? reason,
    List<String>? members,
  }) {
    return FamilyMedication(
      id: id ?? this.id,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      expirationDate: expirationDate ?? this.expirationDate,
      reason: reason ?? this.reason,
      members: members ?? this.members,
    );
  }

  factory FamilyMedication.fromJson(Map<String, dynamic> json, String id) {
    return FamilyMedication(
      id: id,
      name: json['name'] as String,
      dosage: json['dosage'] as String?,
      expirationDate: (json['expirationDate'] as Timestamp).toDate(),
      reason: json['reason'] as String?,
      members: List<String>.from(json['members'] as List? ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dosage': dosage,
      'expirationDate': expirationDate,
      'reason': reason,
      'members': members,
    };
  }

  @override
  List<Object?> get props => [id, name, dosage, expirationDate, reason, members];
}
