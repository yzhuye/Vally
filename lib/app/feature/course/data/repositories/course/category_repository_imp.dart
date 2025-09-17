import 'package:hive/hive.dart';
import 'package:vally_app/app/feature/course/domain/entities/course.dart';
import '../../../domain/repositories/category_repository.dart';
import '../../models/category_hive_model.dart';
import '../group/group_repository_impl.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  static const _boxName = 'categories';
  late final Box _box;
  late final GroupRepositoryImpl _groupRepository;

  CategoryRepositoryImpl() {
    _box = Hive.box(_boxName);
    _groupRepository = GroupRepositoryImpl();
  }

  @override
  List<Category> getCategoriesByCourse(String courseId) {
    final raw = _box.get(courseId) as List<dynamic>?;
    if (raw == null) return [];
    return raw
        .whereType<CategoryHiveModel>()
        .map((h) => h.toCategory())
        .toList();
  }

  @override
  Future<void> addCategory(String courseId, Category category) async {
    final raw = _box.get(courseId) as List<dynamic>? ?? [];
    final list = raw.whereType<CategoryHiveModel>().map((h) => h).toList();
    list.add(CategoryHiveModel.fromCategory(category));
    await _box.put(courseId, list);

    await _groupRepository.createGroupsForCategory(
        courseId, category.id, category.groupCount, category.studentsPerGroup,
        categoryName: category.name);
  }

  @override
  Future<void> updateCategory(String courseId, Category category) async {
    final raw = _box.get(courseId) as List<dynamic>?;
    if (raw == null) return;
    final list = raw.whereType<CategoryHiveModel>().toList();
    final index = list.indexWhere((c) => c.id == category.id);
    if (index != -1) {
      list[index] = CategoryHiveModel.fromCategory(category);
      await _box.put(courseId, list);
    }
  }

  @override
  Future<void> deleteCategory(String courseId, String categoryId) async {
    final raw = _box.get(courseId) as List<dynamic>?;
    if (raw == null) return;
    final list = raw.whereType<CategoryHiveModel>().toList();
    list.removeWhere((c) => c.id == categoryId);
    await _box.put(courseId, list);
  }
}
