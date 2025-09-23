import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vally_app/domain/entities/user.dart';
import 'package:logger/logger.dart';

class ApiUserCourses {
  static const baseUrl =
      "https://roble-api.openlab.uninorte.edu.co/database/vally_e89f74b54e";
  static const storage = FlutterSecureStorage();

  static Future<String?> _getAccessToken() async {
    return await storage.read(key: "accessToken");
  }

  // Consulta genérica en ROBLE
  static Future<List<dynamic>> _readTable(String tableName,
      {Map<String, String>? filters}) async {
    final token = await _getAccessToken();
    final logger = Logger();
    if (token == null) throw Exception("No access token found");

    final uri = Uri.parse("$baseUrl/read").replace(queryParameters: {
      "tableName": tableName,
      ...?filters,
    });

    final response = await http.get(
      uri,
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      logger.e(response.body);
      throw Exception("Failed to read table $tableName: ${response.body}");
    }
  }

  // Obtiene un curso por su ID
  static Future<Map<String, dynamic>?> getCourseById(String courseId) async {
    final courses = await _readTable("courses", filters: {"_id": courseId});
    if (courses.isEmpty) return null;
    return courses.first as Map<String, dynamic>;
  }

  // Obtiene todos los cursos
  static Future<List<Map<String, dynamic>>> getAllCourses() async {
    final courses = await _readTable("courses");
    return courses.cast<Map<String, dynamic>>();
  }

  // Obtiene un usuario con sus cursos como teacher y student
  static Future<User?> getUserWithCourses(String email) async {
    final users = await _readTable("users", filters: {"email": email});
    if (users.isEmpty) return null;

    final user = users.first;
    final userId = user["_id"];

    final relations =
        await _readTable("user_courses", filters: {"user_id": userId});

    List<String> teacherCourses = [];
    List<String> studentCourses = [];

    for (var rel in relations) {
      final courseId = rel["course_id"];
      final role = rel["role"];

      final courseRows =
          await _readTable("courses", filters: {"_id": courseId});
      if (courseRows.isEmpty) continue;

      final course = courseId;

      if (role == "teacher") {
        teacherCourses.add(course);
      } else if (role == "student") {
        studentCourses.add(course);
      }
    }

    return User(
      id: user["_id"],
      email: user["email"],
      username: user["username"] ?? "",
      teacherCourses: teacherCourses,
      studentCourses: studentCourses,
    );
  }

  // Crear un curso nuevo
  static Future<Map<String, dynamic>?> createCourse({
    required String title,
    String? description,
    required String invittionCode,
    String? imageUrl,
    required String createdByUserId,
    required String createdByUserEmail,
  }) async {
    final token = await _getAccessToken();
    if (token == null) throw Exception("No access token found");

    final url = Uri.parse("$baseUrl/insert");

    final body = {
      "tableName": "courses",
      "records": [
        {
          "title": title,
          "description": description ?? "",
          "invitationCode": invittionCode,
          "imageUrl": imageUrl,
          "createdBy": createdByUserEmail,
        }
      ]
    };

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      if (data["inserted"].isEmpty) return null;

      final course = data["inserted"].first;
      final courseId = course["_id"];

      // Paso 2: insertar en user_courses
      final userCourseBody = {
        "tableName": "user_courses",
        "records": [
          {
            "user_id": createdByUserId,
            "course_id": courseId,
            "role": "teacher",
          }
        ]
      };

      final relResponse = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: jsonEncode(userCourseBody),
      );

      if (relResponse.statusCode == 200 || relResponse.statusCode == 201) {
        return course;
      } else {
        throw Exception(
          "Curso creado pero error al asignar user_courses: ${relResponse.statusCode} ${relResponse.body}",
        );
      }
    } else {
      throw Exception(
          "Error creando curso: ${response.statusCode} ${response.body}");
    }
  }

  // Unirse a un curso usando invitationCode
  static Future<Map<String, dynamic>?> joinCourseByInvitation({
    required String userId,
    required String invitationCode,
  }) async {
    final token = await _getAccessToken();
    if (token == null) throw Exception("No access token found");

    final url = Uri.parse("$baseUrl/read");

    final uri = url.replace(queryParameters: {
      "tableName": "courses",
      "invitationCode": invitationCode,
    });

    final response = await http.get(
      uri,
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode != 200) {
      throw Exception(
          "Error buscando curso: ${response.statusCode} ${response.body}");
    }

    final courses = jsonDecode(response.body) as List<dynamic>;
    if (courses.isEmpty) {
      throw Exception("No existe curso con ese invitationCode");
    }

    final course = courses.first;
    final courseId = course["_id"];

    final insertUrl = Uri.parse("$baseUrl/insert");
    final body = {
      "tableName": "user_courses",
      "records": [
        {
          "user_id": userId,
          "course_id": courseId,
          "role": "student",
        }
      ]
    };

    final relResponse = await http.post(
      insertUrl,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      body: jsonEncode(body),
    );

    if (relResponse.statusCode == 200 || relResponse.statusCode == 201) {
      return course;
    } else {
      throw Exception(
          "Error al unirse al curso: ${relResponse.statusCode} ${relResponse.body}");
    }
  }
}
