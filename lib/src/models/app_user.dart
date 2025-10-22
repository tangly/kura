import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  final String id;
  final String name;
  final Timestamp createdAt;
  final List<String> families;

  const AppUser({
    required this.id,
    required this.name,
    required this.createdAt,
    this.families = const [],
  });

  factory AppUser.fromJson(Map<String, dynamic> json, String id) {
    return AppUser(
      id: id,
      name: json['name'] as String,
      createdAt: json['createdAt'] as Timestamp,
      families: List<String>.from(json['families'] as List? ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'createdAt': createdAt,
      'families': families,
    };
  }

  AppUser copyWith({
    String? id,
    String? name,
    Timestamp? createdAt,
    List<String>? families,
  }) {
    return AppUser(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      families: families ?? this.families,
    );
  }

  @override
  List<Object?> get props => [id, name, createdAt, families];
}