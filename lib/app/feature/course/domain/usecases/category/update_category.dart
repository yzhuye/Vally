import '../../entities/course.dart';
import '../../repositories/category_repository.dart';

class UpdateCategory {
  final CategoryRepository repository;

  UpdateCategory(this.repository);

  Future<void> call(String courseId, Category category) async {
    return await repository.updateCategory(courseId, category);
  }
}
