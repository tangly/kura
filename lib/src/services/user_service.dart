import 'package:kura/src/models/user.dart';

abstract class UserService {
  Future<void> init();
  Future<List<User>> getUsers();
  Future<void> saveUser(User user);
  Future<void> deleteUser(int userId);
}
