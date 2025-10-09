import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 1)
class User extends Equatable {
  @HiveField(0)
  final int? id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final int? age;
  @HiveField(3)
  final double? weight;
  @HiveField(4)
  final String? allergies;
  @HiveField(5)
  final String? notes;

  const User({
    this.id,
    required this.name,
    this.age,
    this.weight,
    this.allergies,
    this.notes,
  });

  User copyWith({
    int? id,
    String? name,
    int? age,
    double? weight,
    String? allergies,
    String? notes,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      allergies: allergies ?? this.allergies,
      notes: notes ?? this.notes,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  List<Object?> get props => [id, name, age, weight, allergies, notes];
}