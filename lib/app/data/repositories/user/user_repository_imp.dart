import 'package:hive/hive.dart';
import 'package:vally_app/app/domain/entities/user.dart';
import '../../models/user_hive_model.dart';
import 'user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final Box<UserHiveModel> userBox;

  UserRepositoryImpl(this.userBox);

  @override
  Future<User?> getUserByEmail(String email) async {
    try {
      final user = userBox.values.firstWhere((u) => u.email == email);
      return user.toUser();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveUser(User user) async {
    await userBox.put(user.id, UserHiveModel.fromUser(user));
  }

  @override
  Future<List<User>> getAllUsers() async {
    return userBox.values.map((u) => u.toUser()).toList();
  }
}
