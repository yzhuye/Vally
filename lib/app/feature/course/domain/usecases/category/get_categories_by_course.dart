import '../../entities/course.dart';
import '../../repositories/category_repository.dart';

class GetCategoriesByCourse {
  final CategoryRepository repository;

  GetCategoriesByCourse(this.repository);

  List<Category> call(String courseId) {
    return repository.getCategoriesByCourse(courseId);
  }
}
