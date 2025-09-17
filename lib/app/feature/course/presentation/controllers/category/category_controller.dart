import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/entities/course.dart';
import '../../../domain/usecases/category/get_categories_by_course.dart';
import '../../../domain/usecases/category/add_category.dart';
import '../../../domain/usecases/category/update_category.dart';
import '../../../domain/usecases/category/delete_category.dart';

class CategoryController extends GetxController {
  final String courseId;
  final GetCategoriesByCourse _getCategoriesByCourse;
  final AddCategory _addCategory;
  final UpdateCategory _updateCategory;
  final DeleteCategory _deleteCategory;

  var categories = <Category>[].obs;
  var isLoading = false.obs;

  CategoryController({
    required this.courseId,
    required GetCategoriesByCourse getCategoriesByCourse,
    required AddCategory addCategory,
    required UpdateCategory updateCategory,
    required DeleteCategory deleteCategory,
  })  : _getCategoriesByCourse = getCategoriesByCourse,
        _addCategory = addCategory,
        _updateCategory = updateCategory,
        _deleteCategory = deleteCategory;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  void loadCategories() {
    isLoading(true);
    try {
      categories.value = _getCategoriesByCourse(courseId);
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
      final category = Category(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        groupingMethod: groupingMethod,
        groupCount: groupCount,
        studentsPerGroup: studentsPerGroup,
      );

      await _addCategory(courseId, category);
      loadCategories();

      Get.snackbar(
        'Éxito',
        'Categoría agregada correctamente',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo agregar la categoría: $e',
        snackPosition: SnackPosition.BOTTOM,
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
      await _updateCategory(courseId, category);
      loadCategories();

      Get.snackbar(
        'Éxito',
        'Categoría actualizada correctamente',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo actualizar la categoría: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteCategory(String categoryId) async {
    isLoading(true);

    try {
      await _deleteCategory(courseId, categoryId);
      loadCategories();

      Get.snackbar(
        'Éxito',
        'Categoría eliminada correctamente',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo eliminar la categoría: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  String getMethodDisplayName(String method) {
    switch (method) {
      case 'random':
        return 'Aleatorio';
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
      case 'random':
        return Icons.shuffle;
      case 'self-assigned':
        return Icons.person_add;
      case 'manual':
        return Icons.edit;
      default:
        return Icons.help;
    }
  }
}
