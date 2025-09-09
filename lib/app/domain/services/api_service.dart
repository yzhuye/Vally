import 'package:logger/logger.dart';

class ApiService {
  static var logger = Logger();

  // "database"
  static List<Map<String, String>> users = [
    {
      "username": "ana",
      "email": "a@a.com",
      "password": "123456"
    },
    {
      "username": "bruno",
      "email": "b@a.com",
      "password": "123456"
    },
    {
      "username": "carlos",
      "email": "c@a.com",
      "password": "123456"
    },
  ];

  // Signup
  static Future<Map<String, dynamic>?> signUpUser(
    String username,
    String email,
    String password,
  ) async {
    // Check if user already exists
    final existingUser = users.any((u) => u["username"] == username || u["email"] == email);
    if (existingUser) {
      return {
        "success": false,
        "message": "User already exists",
      };
    }

    // Add new user
    final newUser = {
      "username": username,
      "email": email,
      "password": password,
    };
    users.add(newUser);

    logger.i("User signed up: $username");
    return {
      "success": true,
      "message": "User created successfully",
      "user": newUser,
    };
  }

  // Login
  static Future<Map<String, dynamic>?> loginUser(
    String identifier,
    String password,
  ) async {
    final user = users.firstWhere(
      (u) => (u["username"] == identifier || u["email"] == identifier) && u["password"] == password,
      orElse: () => {},
    );

    if (user.isEmpty) {
      logger.e("Login failed for $identifier");
      return {
        "success": false,
        "message": "Invalid credentials",
      };
    }

    logger.i("Login successful for $identifier");
    return {
      "success": true,
      "message": "Login successful",
      "user": user,
    };
  }
}
