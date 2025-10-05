import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vally_app/domain/entities/course.dart';
import '../../../domain/repositories/category_repository.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import '../../models/category_hive_model.dart';
import '../group/group_repository_impl.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  static const _boxName = 'categories';
  late final Box _box;
  late final GroupRepositoryImpl _groupRepository;
  bool _isInitialized = false;
  static const storage = FlutterSecureStorage();
  late final Logger logger = Logger();
  static const baseUrl =
      "https://roble-api.openlab.uninorte.edu.co/database/vally_e89f74b54e";

  CategoryRepositoryImpl() {
    _box = Hive.box(_boxName);
    _groupRepository = GroupRepositoryImpl();
  }

  Future<void> _initializeData() async {
    if (!_isInitialized && _box.isEmpty) {
      final initial = [
        Category(
          id: 'cat1',
          name: "Trabajo en Equipo",
          groupingMethod: "random",
          groupCount: 3,
          studentsPerGroup: 5,
        ),
        Category(
          id: 'cat2',
          name: "Investigación",
          groupingMethod: "self-assigned",
          groupCount: 2,
          studentsPerGroup: 4,
        ),
      ];
      await _box.put(
          '1', initial.map((c) => CategoryHiveModel.fromCategory(c)).toList());
      _isInitialized = true;
    }
  }

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

    final categories = data.map((row) {
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
    }).whereType<Category>().toList();

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
  void updateCategory(String courseId, Category category) {
    _initializeData();
    final raw = _box.get(courseId) as List<dynamic>?;
    if (raw == null) return;
    final list = raw.whereType<CategoryHiveModel>().toList();
    final index = list.indexWhere((c) => c.id == category.id);
    if (index != -1) {
      list[index] = CategoryHiveModel.fromCategory(category);
      _box.put(courseId, list);
    }
  }

  @override
  void deleteCategory(String courseId, String categoryId) {
    _initializeData();
    final raw = _box.get(courseId) as List<dynamic>?;
    if (raw == null) return;
    final list = raw.whereType<CategoryHiveModel>().toList();
    list.removeWhere((c) => c.id == categoryId);
    _box.put(courseId, list);
  }
}
