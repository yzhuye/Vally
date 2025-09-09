import 'package:vally_app/app/domain/entities/user.dart';

abstract class UserRepository {
  Future<User?> getUserByEmail(String email);
  Future<void> saveUser(User user);
  Future<List<User>> getAllUsers();
}
