import '../entities/user.dart';

abstract class UserRepository {
  Future<User?> getUserByEmail(String email);
  Future<void> saveUser(User user);
  Future<List<User>> getAllUsers();
}
