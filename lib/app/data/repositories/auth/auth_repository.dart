abstract class AuthRepository {
  Future<Map<String, dynamic>?> login(String usernameOrEmail, String password);

  // Podrías añadir otros métodos aquí en el futuro, como:
  // Future<void> logout();
  // Future<User> getCurrentUser();
  // Future<Map<String, dynamic>> register(String username, String email, String password);
}