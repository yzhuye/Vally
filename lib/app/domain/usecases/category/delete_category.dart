import 'package:vally_app/app/domain/entities/course.dart';
import 'package:vally_app/app/data/repositories/course/category_repository.dart';

class UpdateCategory {
  final CategoryRepository repository;

  UpdateCategory(this.repository);

  void call(String courseId, Category category) {
    repository.updateCategory(courseId, category);
  }
}
