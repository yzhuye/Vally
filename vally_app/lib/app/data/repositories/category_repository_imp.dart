import '../../domain/entities/course.dart';
import 'category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  static final Map<String, List<Category>> _categoriesByCourse = {};
  static bool _isInitialized = false;

  void _initializeData() {
    if (!_isInitialized) {
      print('Inicializando categorías para curso 1');

      _categoriesByCourse['1'] = [
        Category(
          id: 'cat1',
          name: "Trabajo en Equipo",
          groupingMethod: "random",
          groupCount: 3,
          studentsPerGroup: 5,
        ),
        Category(
          id: 'cat2',
          name: "Investigación",
          groupingMethod: "self-assigned",
          groupCount: 2,
          studentsPerGroup: 4,
        ),
      ];
      _isInitialized = true;
    }
  }

  @override
  List<Category> getCategoriesForCourse(String courseId) {
    print('Fetching categories for courseId: $courseId');
    _initializeData();
    print('Contenido actual del mapa: $_categoriesByCourse');
    return List.unmodifiable(_categoriesByCourse[courseId] ?? []);
  }

  @override
  void addCategory(String courseId, Category category) {
    _initializeData();
    _categoriesByCourse.putIfAbsent(courseId, () => []);
    _categoriesByCourse[courseId]!.add(category);
  }

  @override
  void updateCategory(String courseId, Category category) {
    _initializeData();
    final categories = _categoriesByCourse[courseId];
    if (categories != null) {
      final index = categories.indexWhere((c) => c.id == category.id);
      if (index != -1) {
        categories[index] = category;
      }
    }
  }

  @override
  void deleteCategory(String courseId, String categoryId) {
    _initializeData();
    _categoriesByCourse[courseId]?.removeWhere((c) => c.id == categoryId);
  }
}
