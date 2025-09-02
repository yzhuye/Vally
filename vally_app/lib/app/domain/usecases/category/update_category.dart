import '../../entities/category.dart';
import '../../repositories/category_repository.dart';

class UpdateCategory {
  final CategoryRepository repository;

  UpdateCategory(this.repository);

  void call(Category category) {
    repository.update(category);
  }
}
