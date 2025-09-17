import '../../entities/course.dart';
import '../../repositories/category_repository.dart';

class AddCategory {
  final CategoryRepository repository;

  AddCategory(this.repository);

  Future<void> call(String courseId, Category category) async {
    return await repository.addCategory(courseId, category);
  }
}
