abstract class AuthRepository {
  Future<Map<String, dynamic>?> login(String usernameOrEmail, String password, bool rememberMe);
}
