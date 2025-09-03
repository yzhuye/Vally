import '../../entities/course.dart';
import '../../repositories/category_repository.dart';

class GetCategories {
  final CategoryRepository repository;

  GetCategories(this.repository);

  List<Category> call(String courseId) {
    return repository.getCategoriesForCourse(courseId);
  }
}
