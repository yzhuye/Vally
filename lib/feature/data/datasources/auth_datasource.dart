abstract class AuthDataSource {
  Future<Map<String, dynamic>?> login(
      String usernameOrEmail, String password, bool rememberMe);
}
