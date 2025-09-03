import '../../entities/category.dart';
import '../../repositories/category_repository.dart';

class GetCategories {
  final CategoryRepository repository;

  GetCategories(this.repository);

  List<Category> call() {
    return repository.getAll();
  }
}
