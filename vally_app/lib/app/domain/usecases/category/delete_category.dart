import '../../repositories/category_repository.dart';

class DeleteCategory {
  final CategoryRepository repository;

  DeleteCategory(this.repository);

  void call(String id) {
    repository.delete(id);
  }
}
