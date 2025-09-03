import '../../repositories/category_repository.dart';

class DeleteCategory {
  final CategoryRepository repository;

  DeleteCategory(this.repository);

  void call(String courseId, String categoryId) {
    repository.deleteCategory(courseId, categoryId);
  }
}
