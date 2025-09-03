import '../../entities/course.dart';
import '../../repositories/category_repository.dart';

class AddCategory {
  final CategoryRepository repository;

  AddCategory(this.repository);

  void call(String courseId, Category category) {
    repository.addCategory(courseId, category);
  }
}
