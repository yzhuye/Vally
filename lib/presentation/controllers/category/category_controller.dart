import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/entities/course.dart';
import '../../../domain/usecases/category/get_categories.dart';
import '../../../domain/usecases/category/add_category.dart';
import '../../../domain/usecases/category/update_category.dart';
import '../../../domain/usecases/category/delete_category.dart';
import '../../../domain/usecases/group/create_groups_for_category.dart';
import '../../../data/repositories/course/category_repository_imp.dart';
import '../../../data/repositories/group/group_repository_impl.dart';
import '../../../domain/repositories/category_repository.dart';
import '../../../domain/repositories/group_repository.dart';

class CategoryController extends GetxController {
  final String courseId;

  late final GetCategoriesUseCase _getCategoriesUseCase;
  late final AddCategoryUseCase _addCategoryUseCase;
  late final UpdateCategoryUseCase _updateCategoryUseCase;
  late final DeleteCategoryUseCase _deleteCategoryUseCase;
  late final CreateGroupsForCategoryUseCase _createGroupsUseCase;

  var categories = <Category>[].obs;
  var isLoading = false.obs;

  CategoryController({required this.courseId}) {
    final CategoryRepository categoryRepository = CategoryRepositoryImpl();
    final GroupRepository groupRepository = GroupRepositoryImpl();

    _getCategoriesUseCase = GetCategoriesUseCase(categoryRepository);
    _addCategoryUseCase = AddCategoryUseCase(categoryRepository);
    _updateCategoryUseCase = UpdateCategoryUseCase(categoryRepository);
    _deleteCategoryUseCase = DeleteCategoryUseCase(categoryRepository);
    _createGroupsUseCase = CreateGroupsForCategoryUseCase(groupRepository);
  }

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  Future<void> loadCategories() async {
    isLoading(true);
    try {
      categories.value = await _getCategoriesUseCase(courseId);
    } finally {
      isLoading(false);
    }
  }

  Future<void> addCategory({
    required String name,
    required String groupingMethod,
    required int groupCount,
    required int studentsPerGroup,
  }) async {
    isLoading(true);

    try {
      final result = await _addCategoryUseCase(
        courseId: courseId,
        name: name,
        groupingMethod: groupingMethod,
        groupCount: groupCount,
        studentsPerGroup: studentsPerGroup,
      );

      if (result.isSuccess) {
        // Recargar categorías para obtener el ID de la nueva categoría
        await loadCategories();

        // Buscar la categoría recién creada
        final newCategory = categories.firstWhere(
          (cat) => cat.name == name.trim(),
          orElse: () =>
              throw Exception('Categoría no encontrada después de crear'),
        );

        // Crear grupos para la nueva categoría
        final groupsResult = await _createGroupsUseCase(
          courseId: courseId,
          categoryId: newCategory.id,
          groupCount: groupCount,
          studentsPerGroup: studentsPerGroup,
          categoryName: name,
        );

        if (groupsResult.isSuccess) {
          Get.back(); // <-- Cierra el diálogo
          Get.snackbar(
            'Éxito',
            'Categoría y grupos creados exitosamente',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            'Advertencia',
            'Categoría creada pero error al crear grupos: ${groupsResult.message}',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          result.message,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error inesperado: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateCategory(Category category) async {
    isLoading(true);

    try {
      final result = await _updateCategoryUseCase(
        courseId: courseId,
        category: category,
      );

      if (result.isSuccess) {
        loadCategories();
        Get.back(); // <-- Cierra el diálogo
        Get.snackbar(
          'Éxito',
          result.message,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          result.message,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteCategory(String categoryId) async {
    isLoading(true);

    try {
      final result = await _deleteCategoryUseCase(
        courseId: courseId,
        categoryId: categoryId,
      );

      if (result.isSuccess) {
        loadCategories();
        Get.back(); // <-- Cierra el diálogo
        Get.snackbar(
          'Éxito',
          result.message,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          result.message,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } finally {
      isLoading(false);
    }
  }

  String getMethodDisplayName(String method) {
    switch (method) {
      case 'self-assigned':
        return 'Auto-asignado';
      case 'manual':
        return 'Manual';
      default:
        return method;
    }
  }

  IconData getMethodIcon(String method) {
    switch (method) {
      case 'self-assigned':
        return Icons.person_add;
      case 'manual':
        return Icons.edit;
      default:
        return Icons.help;
    }
  }
}
