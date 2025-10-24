
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Prescription extends Equatable {
  const Prescription({
    this.id,
    required this.medicationName,
    required this.dosage,
    required this.frequency,
    required this.duration,
    required this.startDate,
  });

  final String? id;
  final String medicationName;
  final String dosage;
  final String frequency;
  final String duration;
  final DateTime startDate;

  @override
  List<Object?> get props => [
  id,
  medicationName,
  dosage,
  frequency,
  duration,
  startDate,
      ];

  // Serialization
  factory Prescription.fromJson(Map<String, dynamic> json, String documentId) {
    return Prescription(
      id: documentId,
      medicationName: json['medicationName'] as String,
      dosage: json['dosage'] as String,
      frequency: json['frequency'] as String,
      duration: json['duration'] as String,
      startDate: (json['startDate'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medicationName': medicationName,
      'dosage': dosage,
      'frequency': frequency,
      'duration': duration,
      'startDate': Timestamp.fromDate(startDate),
    };
  }
}

