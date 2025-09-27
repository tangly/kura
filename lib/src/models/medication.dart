import 'package:hive/hive.dart';

part 'medication.g.dart';

@HiveType(typeId: 0)
class Medication {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String user;

  @HiveField(2)
  final String reason;

  @HiveField(3)
  final DateTime expirationDate;

  Medication({
    required this.name,
    required this.user,
    required this.reason,
    required this.expirationDate,
  });
}
