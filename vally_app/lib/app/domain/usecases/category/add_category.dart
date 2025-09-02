import '../../entities/category.dart';
import '../../repositories/category_repository.dart';

class AddCategory {
  final CategoryRepository repository;

  AddCategory(this.repository);

  void call(Category category) {
    repository.add(category);
  }
}
