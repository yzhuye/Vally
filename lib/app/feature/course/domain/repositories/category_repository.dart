import '../entities/course.dart';

abstract class CategoryRepository {
  List<Category> getCategoriesByCourse(String courseId);
  Future<void> addCategory(String courseId, Category category);
  Future<void> updateCategory(String courseId, Category category);
  Future<void> deleteCategory(String courseId, String categoryId);
}
