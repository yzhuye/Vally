import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

class ApiService {
  static var logger = Logger();
  static const storage = FlutterSecureStorage();
  static Timer? _refreshTimer;
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
        await storage.write(key: "accessToken", value: accessToken);
        await storage.write(key: "refreshToken", value: refreshToken);
        scheduleRefresh(accessToken);
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

  // Refrescar token antes de que expire
  static void scheduleRefresh(String accessToken) {
    final expDate = JwtDecoder.getExpirationDate(accessToken);
    final refreshTime = expDate.subtract(const Duration(minutes: 2));
    final now = DateTime.now();
    final duration = refreshTime.difference(now);
    logger.d("Scheduling token refresh in: $duration");

    if (duration.isNegative) {
      logger.e("Token has already expired. Cannot schedule refresh.");
      return;
    }

    // Cancelar timer existente
    _refreshTimer?.cancel();

    // Programar refresco automático
    _refreshTimer = Timer.periodic(const Duration(minutes: 15), (timer) async {
      logger.d("Running periodic token refresh...");
      final newToken = await refreshAccessToken();
      if (newToken != null) {
        scheduleRefresh(newToken);
        timer.cancel();
      } else {
        logger.e("Failed to refresh token. Periodic refresh will stop.");
        timer.cancel();
      }
    });
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
