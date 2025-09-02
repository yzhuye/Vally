import '../entities/category.dart';

abstract class CategoryRepository {
  List<Category> getAll();
  Category? getById(String id);
  void add(Category category);
  void update(Category category);
  void delete(String id);
}
