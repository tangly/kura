import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'medication.g.dart';

@HiveType(typeId: 0)
class Medication extends Equatable {
  @HiveField(0)
  final int? id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String? dosage;
  @HiveField(3)
  final DateTime expirationDate;
  @HiveField(4)
  final int? userId;
  @HiveField(5)
  final String? reason;

  const Medication({
    this.id,
    required this.name,
    this.dosage,
    required this.expirationDate,
    this.userId,
    this.reason,
  });

  Medication copyWith({
    int? id,
    String? name,
    String? dosage,
    DateTime? expirationDate,
    int? userId,
    String? reason,
  }) {
    return Medication(
      id: id ?? this.id,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      expirationDate: expirationDate ?? this.expirationDate,
      userId: userId ?? this.userId,
      reason: reason ?? this.reason,
    );
  }

  @override
  List<Object?> get props => [id, name, dosage, expirationDate, userId, reason];
}
