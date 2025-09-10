import '../../entities/course.dart';
import '../../../data/repositories/course/category_repository.dart';

class GetCategoriesForCourse {
  final CategoryRepository repository;

  GetCategoriesForCourse(this.repository);

  List<Category> call(String courseId) {
    return repository.getCategoriesForCourse(courseId);
  }
}
