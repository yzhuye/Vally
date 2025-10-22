import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../domain/entities/course.dart';
import '../../../domain/repositories/activity_repository.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'dart:convert';

class ActivityRepositoryImpl implements ActivityRepository {
  static const storage = FlutterSecureStorage();
  late final Logger logger = Logger();
  static const baseUrl =
      "https://roble-api.openlab.uninorte.edu.co/database/vally_e89f74b54e";

  @override
  Future<List<Activity>> getActivitiesByCategory(String categoryId) async {
    final token = await storage.read(key: "accessToken");
    final url = Uri.parse("$baseUrl/read").replace(queryParameters: {
      "tableName": "activities",
      "categoryId": categoryId,
    });

    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode != 200) {
      logger.e("Failed to fetch activities: ${response.body}");
      throw Exception('Failed to fetch activities: ${response.body}');
    }

    final data = jsonDecode(response.body);
    logger.d("Response data: $data");

    final activities = data
        .map((row) {
          return Activity(
            id: row['_id'].toString(),
            name: row['name'] ?? '',
            description: row['description'] ?? '',
            dueDate: DateTime.tryParse(row['dueDate'] ?? '') ?? DateTime.now(),
            categoryId: row['categoryId'] ?? '',
          );
        })
        .whereType<Activity>()
        .toList();

    return activities;
  }

  @override
  Future<Activity?> getActivityById(String activityId) async {
    final token = await storage.read(key: "accessToken");
    if (token == null) throw Exception("No access token found");

    final url = Uri.parse("$baseUrl/read").replace(queryParameters: {
      "tableName": "activities",
      "_id": activityId,
    });

    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      Map<String, dynamic>? row;
      if (decoded is List && decoded.isNotEmpty && decoded.first is Map) {
        row = Map<String, dynamic>.from(decoded.first as Map);
      } else if (decoded is Map<String, dynamic>) {
        row = decoded;
      }

      if (row == null || row.isEmpty) {
        return null;
      }

      final newActivity = Activity(
        id: (row['_id'] ?? '').toString(),
        name: (row['name'] ?? '').toString(),
        description: (row['description'] ?? '').toString(),
        dueDate: DateTime.tryParse((row['dueDate'] ?? '').toString()) ??
            DateTime.now(),
        categoryId: (row['categoryId'] ?? '').toString(),
      );
      return newActivity;
    } else {
      throw Exception(
          "Error obteniendo actividad: ${response.statusCode} ${response.body}");
    }
  }

  @override
  Future<Activity?> createActivity(String name, String description,
      DateTime dueDate, String categoryId) async {
    final token = await storage.read(key: "accessToken");
    if (token == null) throw Exception("No access token found");

    final url = Uri.parse("$baseUrl/insert");

    final body = {
      "tableName": "activities",
      "records": [
        {
          "name": name,
          "description": description,
          "dueDate": dueDate.toIso8601String(),
          "categoryId": categoryId,
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
      if (data.isNotEmpty) {
        logger.d("Activity created: $data");
        final activity = Activity(
          id: data['_id'].toString(),
          name: name,
          description: description,
          dueDate: dueDate,
          categoryId: categoryId,
        );
        return activity;
      } else {
        return null;
      }
    } else {
      throw Exception(
          "Error creando actividad: ${response.statusCode} ${response.body}");
    }
  }

  @override
  Future<Activity?> updateActivity(Activity activity, String name,
      String description, DateTime dueDate) async {
    final token = await storage.read(key: "accessToken");
    if (token == null) throw Exception("No access token found");

    final url = Uri.parse("$baseUrl/update");

    final body = {
      "tableName": "activities",
      "idColumn": "_id",
      "idValue": activity.id,
      "updates": {
        "name": name,
        "description": description,
        "dueDate": dueDate.toIso8601String(),
      }
    };

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

      if (data.isNotEmpty) {
        final newActivity = Activity(
          id: data['_id'].toString(),
          name: name,
          description: description,
          dueDate: dueDate,
          categoryId: activity.categoryId,
        );
        return newActivity;
      } else {
        return null;
      }
    } else {
      throw Exception(
          "Error actualizando actividad: ${response.statusCode} ${response.body}");
    }
  }

  @override
  Future<bool> deleteActivity(String activityId) async {
    final token = await storage.read(key: "accessToken");
    if (token == null) throw Exception("No access token found");

    final url = Uri.parse("$baseUrl/delete");

    final body = {
      "tableName": "activities",
      "idColumn": "_id",
      "idValue": activityId,
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
      logger.d('data: $data');
      return data["_id"] == activityId;
    } else {
      throw Exception(
          "Error eliminando actividad: ${response.statusCode} ${response.body}");
    }
  }
}
