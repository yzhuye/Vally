import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:vally_app/data/models/user_hive_model.dart';

class ApiService {
  static var logger = Logger();

  static Future<Map<String, dynamic>?> loginUser(
    String identifier,
    String password,
  ) async {
    final userBox = Hive.box<UserHiveModel>('users');

    final results = userBox.values.where(
      (u) =>
          (u.email == identifier || (u.username ?? '') == identifier) &&
          u.password == password,
    );

    final userHive = results.isNotEmpty ? results.first : null;

    if (userHive == null) {
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
      "user": userHive.toUser(),
    };
  }
}
