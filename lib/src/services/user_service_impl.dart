import 'package:hive/hive.dart';
import 'package:kura/src/models/user.dart';
import 'package:kura/src/services/user_service.dart';

class UserServiceImpl extends UserService {
  final HiveInterface hive;
  late Box<User> _userBox;

  UserServiceImpl({required this.hive});

  @override
  Future<void> init() async {
    if (!hive.isAdapterRegistered(UserAdapter().typeId)) {
      hive.registerAdapter(UserAdapter());
    }
    _userBox = await hive.openBox<User>('users');
    if (_userBox.isEmpty) {
      await _userBox.add(const User(id: 1, name: 'John'));
      await _userBox.add(const User(id: 2, name: 'Jane'));
    }
  }

  @override
  Future<List<User>> getUsers() async {
    return _userBox.values.toList();
  }

  @override
  Future<void> saveUser(User user) async {
    await _userBox.put(user.id, user);
  }

  @override
  Future<void> deleteUser(int userId) async {
    await _userBox.delete(userId);
  }
}
