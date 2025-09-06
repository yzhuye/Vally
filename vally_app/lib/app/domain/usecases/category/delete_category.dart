import '../../entities/course.dart';
import '../../../data/repositories/category_repository.dart';

class UpdateCategory {
  final CategoryRepository repository;

  UpdateCategory(this.repository);

  void call(String courseId, Category category) {
    repository.updateCategory(courseId, category);
  }
}
