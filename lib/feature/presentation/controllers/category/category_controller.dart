import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/entities/course.dart';
import '../../../domain/usecases/category/get_categories.dart';
import '../../../domain/usecases/category/add_category.dart';
import '../../../domain/usecases/category/update_category.dart';
import '../../../domain/usecases/category/delete_category.dart';
import '../../../data/repositories/course/category_repository_imp.dart';
import '../../../domain/repositories/category_repository.dart';

class CategoryController extends GetxController {
  final String courseId;

  late final GetCategoriesUseCase _getCategoriesUseCase;
  late final AddCategoryUseCase _addCategoryUseCase;
  late final UpdateCategoryUseCase _updateCategoryUseCase;
  late final DeleteCategoryUseCase _deleteCategoryUseCase;

  var categories = <Category>[].obs;
  var isLoading = false.obs;

  CategoryController({required this.courseId}) {
    final CategoryRepository repository = CategoryRepositoryImpl();
    _getCategoriesUseCase = GetCategoriesUseCase(repository);
    _addCategoryUseCase = AddCategoryUseCase(repository);
    _updateCategoryUseCase = UpdateCategoryUseCase(repository);
    _deleteCategoryUseCase = DeleteCategoryUseCase(repository);
  }

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  void loadCategories() async {
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
