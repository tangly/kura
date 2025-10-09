import 'package:kura/src/models/user.dart';

abstract class UserService {
  Future<void> init();
  Future<List<User>> getUsers();
  Future<User> addUser(User user);
  Future<void> updateUser(User user);
  Future<void> deleteUser(int? userId);
}
