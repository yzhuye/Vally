import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  static final List<Category> _categories = [];
  static bool _isInitialized = false;
  final uuid = DateTime.now().millisecondsSinceEpoch.toString();

  void _initializeData() {
    if (!_isInitialized) {
      _categories.addAll([
        Category(
          id: uuid,
          name: "Trabajo en Equipo",
          groupingMethod: "random",
          groupCount: 3,
          studentsPerGroup: 5,
        ),
        Category(
          id: uuid,
          name: "Investigación",
          groupingMethod: "self-assigned",
          groupCount: 2,
          studentsPerGroup: 4,
        ),
        Category(
          id: uuid,
          name: "Proyecto Final",
          groupingMethod: "manual",
          groupCount: 4,
          studentsPerGroup: 6,
        ),
      ]);
      _isInitialized = true;
    }
  }

  @override
  List<Category> getAll() {
    _initializeData();
    return List.unmodifiable(_categories);
  }

  @override
  Category? getById(String id) {
    _initializeData();
    try {
      return _categories.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  void add(Category category) {
    _initializeData();
    _categories.add(category);
  }

  @override
  void update(Category category) {
    _initializeData();
    final index = _categories.indexWhere((c) => c.id == category.id);
    if (index != -1) {
      _categories[index] = category;
    }
  }

  @override
  void delete(String id) {
    _initializeData();
    _categories.removeWhere((c) => c.id == id);
  }
}
