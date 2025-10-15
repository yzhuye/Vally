import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vally_app/feature/domain/entities/course.dart';
import '../../../domain/repositories/category_repository.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  static const storage = FlutterSecureStorage();
  late final Logger logger = Logger();
  static const baseUrl =
      "https://roble-api.openlab.uninorte.edu.co/database/vally_e89f74b54e";

  @override
  Future<List<Category>> getCategoriesByCourse(String courseId) async {
    logger.d("Fetching categories for courseId: $courseId");
    final token = await storage.read(key: "accessToken");
    final url = Uri.parse("$baseUrl/read").replace(queryParameters: {
      "tableName": "categories",
      "course_id": courseId,
    });

    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode != 200) {
      logger.e("Failed to fetch categories: ${response.body}");
      throw Exception('Failed to fetch categories: ${response.body}');
    }

    final data = jsonDecode(response.body);
    logger.d("Response data: $data");

    final categories = data
        .map((row) {
          return Category(
            id: row['_id'].toString(),
            name: row['name'] ?? '',
            groupingMethod: row['groupingMethod'] ?? '',
            groupCount: row['groupCount'] is int
                ? row['groupCount']
                : int.tryParse(row['groupCount'].toString()) ?? 0,
            studentsPerGroup: row['studentsPerGroup'] is int
                ? row['studentsPerGroup']
                : int.tryParse(row['studentsPerGroup'].toString()) ?? 0,
          );
        })
        .whereType<Category>()
        .toList();

    return categories;
  }

  @override
  Future<void> addCategory(String courseId, Category category) async {
    final url = Uri.parse("$baseUrl/insert");
    final token = await storage.read(key: "accessToken");

    final body = {
      "tableName": "categories",
      "records": [
        {
          "name": category.name,
          "groupingMethod": category.groupingMethod,
          "groupCount": category.groupCount,
          "studentsPerGroup": category.studentsPerGroup,
          "course_id": courseId,
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

    if (response.statusCode != 201) {
      logger.e("Failed to add category: ${response.body}");
      throw Exception('Failed to add category: ${response.body}');
    }
  }

  @override
  Future<Map<String, dynamic>?> updateCategory(
      String courseId, Category category) async {
    final token = await storage.read(key: "accessToken");
    if (token == null) throw Exception("No access token found");

    final url = Uri.parse("$baseUrl/update");

    final body = {
      "tableName": "categories",
      "idColumn": "_id",
      "idValue": category.id,
      "updates": {
        "name": category.name,
        "groupingMethod": category.groupingMethod,
        "groupCount": category.groupCount,
        "studentsPerGroup": category.studentsPerGroup,
        "course_id": courseId,
      }
    };
    logger.d("Request body: $body");

    final response = await http.put(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      // ROBLE devuelve "updated" con los registros modificados
      if (data.isNotEmpty) {
        logger.i("Categoría actualizada: $data");
        return data;
      } else {
        logger.w("No se actualizó ninguna categoría.");
        return null;
      }
    } else {
      logger.e(
          "Error actualizando categoría: ${response.statusCode} ${response.body}");
      throw Exception(
          "Error actualizando categoría: ${response.statusCode} ${response.body}");
    }
  }

  @override
  Future<bool> deleteCategory(String courseId, String categoryId) async {
    final token = await storage.read(key: "accessToken");
    if (token == null) throw Exception("No access token found");

    final url = Uri.parse("$baseUrl/delete");

    final body = {
      "tableName": "categories",
      "idColumn": "_id",
      "idValue": categoryId,
    };

    final response = await http.delete(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);

      if (data.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } else {
      throw Exception(
          "Error eliminando categoría: ${response.statusCode} ${response.body}");
    }
  }
}
