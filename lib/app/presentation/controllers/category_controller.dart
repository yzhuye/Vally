import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/course.dart';
import '../../data/repositories/category_repository_imp.dart';

class CategoryManagementController extends GetxController {
  final String courseId; // cada curso maneja sus categorías
  final CategoryRepositoryImpl _repository = CategoryRepositoryImpl();

  var categories = <Category>[].obs;

  CategoryManagementController(this.courseId);

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  void loadCategories() {
    categories.value = _repository.getCategoriesForCourse(courseId);
  }

  void addCategory(Category category) {
    _repository.addCategory(courseId, category);
    loadCategories();

    Get.snackbar(
      'Categoría creada',
      'La categoría "${category.name}" fue agregada con éxito',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void updateCategory(Category category) {
    _repository.updateCategory(courseId, category);
    loadCategories();

    Get.snackbar(
      'Categoría actualizada',
      'La categoría "${category.name}" fue editada',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  void deleteCategory(String categoryId) {
    _repository.deleteCategory(courseId, categoryId);
    loadCategories();

    Get.snackbar(
      'Categoría eliminada',
      'La categoría fue borrada correctamente',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  int get totalCategories => categories.length;
  int get totalGroups => categories.fold(0, (sum, c) => sum + c.groupCount);
  int get totalCapacity =>
      categories.fold(0, (sum, c) => sum + (c.groupCount * c.studentsPerGroup));
}
