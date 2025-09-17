import '../../repositories/category_repository.dart';

class DeleteCategory {
  final CategoryRepository repository;

  DeleteCategory(this.repository);

  Future<void> call(String courseId, String categoryId) async {
    return await repository.deleteCategory(courseId, categoryId);
  }
}
