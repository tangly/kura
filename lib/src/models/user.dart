import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 1)
class User extends Equatable {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;

  const User({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}