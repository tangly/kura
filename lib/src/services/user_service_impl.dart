import 'package:hive/hive.dart';
import 'package:kura/src/models/user.dart';
import 'package:kura/src/services/user_service.dart';

class UserServiceImpl extends UserService {
  final HiveInterface hive;
  late Box<User> _userBox;

  UserServiceImpl({required this.hive});

  @override
  Future<void> init() async {
    _userBox = await hive.openBox<User>('users');  
  }

  @override
  Future<List<User>> getUsers() async {
    return _userBox.values.toList();
  }

  @override
  Future<User> addUser(User user) async {
    final id = await _userBox.add(user);
    final newUser = user.copyWith(id: id);
    await _userBox.put(id, newUser);
    return newUser;
  }

  @override
  Future<void> updateUser(User user) async {
    await _userBox.put(user.id, user);
  }

  @override
  Future<void> deleteUser(int? userId) async {
    await _userBox.delete(userId);
  }
}
