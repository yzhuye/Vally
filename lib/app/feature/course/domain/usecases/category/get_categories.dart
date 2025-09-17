import '../../entities/course.dart';
import '../../repositories/category_repository.dart';

class GetCategoriesUseCase {
  final CategoryRepository _repository;

  GetCategoriesUseCase(this._repository);

  List<Category> call(String courseId) {
    return _repository.getCategoriesByCourse(courseId);
  }
}
