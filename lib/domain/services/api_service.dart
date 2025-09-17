import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

class ApiService {
  static var logger = Logger();
  static const storage = FlutterSecureStorage();

  static const String baseUrl =
      "https://roble-api.openlab.uninorte.edu.co/auth/vally_e89f74b54e";

  // Login user via ROBLE API
  static Future<Map<String, dynamic>> loginUser(
    String email,
    String password,
    bool rememberMe,
  ) async {
    final url = Uri.parse("$baseUrl/login");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final accessToken = data['accessToken'];
        final refreshToken = data['refreshToken'];

        // Guardar tokens de manera segura
        if (rememberMe) {
          await storage.write(key: "accessToken", value: accessToken);
          await storage.write(key: "refreshToken", value: refreshToken);
        }

        logger.i("Login successful for $email");

        return {
          "success": true,
          "message": "Login successful",
          "accessToken": accessToken,
          "refreshToken": refreshToken,
        };
      } else {
        logger.e("Login failed: ${response.statusCode} ${response.body}");
        return {
          "success": false,
          "message": "Invalid credentials or server error",
        };
      }
    } catch (e) {
      logger.e("Exception during login: $e");
      return {
        "success": false,
        "message": "Something went wrong: $e",
      };
    }
  }

  // Refrescar access token
  static Future<String?> refreshAccessToken() async {
    final refreshToken = await storage.read(key: "refreshToken");
    if (refreshToken == null) return null;

    final url = Uri.parse("$baseUrl/refresh-token");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"refreshToken": refreshToken}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final newAccessToken = data['accessToken'];

        await storage.write(key: "accessToken", value: newAccessToken);
        logger.i("Access token refreshed");
        return newAccessToken;
      } else {
        logger.e("Failed to refresh token: ${response.body}");
        return null;
      }
    } catch (e) {
      logger.e("Exception during refresh: $e");
      return null;
    }
  }

  // Logout
  static Future<void> logout() async {
    final accessToken = await storage.read(key: "accessToken");
    if (accessToken == null) return;

    final url = Uri.parse("$baseUrl/logout");

    try {
      await http.post(
        url,
        headers: {"Authorization": "Bearer $accessToken"},
      );
      await storage.deleteAll();
      logger.i("User logged out");
    } catch (e) {
      logger.e("Exception during logout: $e");
    }
  }
}
