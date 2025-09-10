import 'package:vally_app/app/domain/entities/course.dart';
import '../../../domain/repositories/category_repository.dart';
import 'package:hive/hive.dart';
import '../../models/category_hive_model.dart';
import '../group/group_repository_impl.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  static const _boxName = 'categories';
  late final Box _box;
  late final GroupRepositoryImpl _groupRepository;
  bool _isInitialized = false;

  CategoryRepositoryImpl() {
    _box = Hive.box(_boxName);
    _groupRepository = GroupRepositoryImpl();
  }

  Future<void> _initializeData() async {
    if (!_isInitialized && _box.isEmpty) {
      final initial = [
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
      await _box.put(
          '1', initial.map((c) => CategoryHiveModel.fromCategory(c)).toList());
      _isInitialized = true;
    }
  }

  @override
  List<Category> getCategoriesByCourse(String courseId) {
    _initializeData();
    final raw = _box.get(courseId) as List<dynamic>?;
    if (raw == null) return [];
    return raw
        .whereType<CategoryHiveModel>()
        .map((h) => h.toCategory())
        .toList();
  }

  @override
  Future<void> addCategory(String courseId, Category category) async {
    await _initializeData();
    final raw = _box.get(courseId) as List<dynamic>? ?? [];
    final list = raw.whereType<CategoryHiveModel>().map((h) => h).toList();
    list.add(CategoryHiveModel.fromCategory(category));
    await _box.put(courseId, list);

    await _groupRepository.createGroupsForCategory(
        courseId, category.id, category.groupCount, category.studentsPerGroup,
        categoryName: category.name);
  }

  @override
  void updateCategory(String courseId, Category category) {
    _initializeData();
    final raw = _box.get(courseId) as List<dynamic>?;
    if (raw == null) return;
    final list = raw.whereType<CategoryHiveModel>().toList();
    final index = list.indexWhere((c) => c.id == category.id);
    if (index != -1) {
      list[index] = CategoryHiveModel.fromCategory(category);
      _box.put(courseId, list);
    }
  }

  @override
  void deleteCategory(String courseId, String categoryId) {
    _initializeData();
    final raw = _box.get(courseId) as List<dynamic>?;
    if (raw == null) return;
    final list = raw.whereType<CategoryHiveModel>().toList();
    list.removeWhere((c) => c.id == categoryId);
    _box.put(courseId, list);
  }
}
