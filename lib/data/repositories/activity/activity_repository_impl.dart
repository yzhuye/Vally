import 'package:hive/hive.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../domain/entities/course.dart';
import '../../../domain/repositories/activity_repository.dart';
import '../../models/activity_hive_model.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'dart:convert';

class ActivityRepositoryImpl implements ActivityRepository {
  static const storage = FlutterSecureStorage();
  late final Logger logger = Logger();
  static const baseUrl =
      "https://roble-api.openlab.uninorte.edu.co/database/vally_e89f74b54e";

  // REMOVE THIS LATER ❗❗❗
  final Box<ActivityHiveModel> _activityBox =
      Hive.box<ActivityHiveModel>('activities');
  // REMOVE THIS LATER ❗❗❗

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
  Activity? getActivityById(String activityId) {
    try {
      final activityHive = _activityBox.get(activityId);
      return activityHive?.toActivity();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Activity?> createActivity(String name, String description,
      DateTime dueDate, String categoryId) async {
    final token = await storage.read(key: "accessToken");
    ;
    if (token == null) throw Exception("No access token found");

    final url = Uri.parse("$baseUrl/insert");

    final body = {
      "tableName": "activities",
      "records": [
        {
          "name": name,
          "description": description ?? "",
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
  Future<void> updateActivity(Activity activity) async {
    try {
      final activityHive = ActivityHiveModel.fromActivity(activity);
      await _activityBox.put(activity.id, activityHive);
    } catch (e) {
      throw Exception('Error al actualizar actividad: $e');
    }
  }

  @override
  Future<void> deleteActivity(String activityId) async {
    try {
      await _activityBox.delete(activityId);
    } catch (e) {
      throw Exception('Error al eliminar actividad: $e');
    }
  }
}
