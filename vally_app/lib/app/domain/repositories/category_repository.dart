import '../entities/course.dart';

abstract class CategoryRepository {
  List<Category> getCategoriesForCourse(String courseId);
  void addCategory(String courseId, Category category);
  void updateCategory(String courseId, Category category);
  void deleteCategory(String courseId, String categoryId);
}
