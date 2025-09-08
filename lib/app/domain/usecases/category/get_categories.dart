import 'package:vally_app/app/domain/entities/course.dart';
import 'package:vally_app/app/data/repositories/course/category_repository.dart';

class GetCategories {
  final CategoryRepository repository;

  GetCategories(this.repository);

  List<Category> call(String courseId) {
    return repository.getCategoriesForCourse(courseId);
  }
}
