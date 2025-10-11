import '../entities/course.dart';

abstract class CategoryRepository {
  Future<List<Category>> getCategoriesByCourse(String courseId);
  Future<void> addCategory(String courseId, Category category);
  Future<Map<String, dynamic>?> updateCategory(String courseId, Category category);
  void deleteCategory(String courseId, String categoryId);
}
