import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/entities/course.dart';
import '../../../application/use-cases/category/get_categories.dart';
import '../../../application/use-cases/category/add_category.dart';
import '../../../application/use-cases/category/update_category.dart';
import '../../../application/use-cases/category/delete_category.dart';
import '../../../application/use-cases/group/create_groups_for_category.dart';
import '../../../application/use-cases/student/get_students_by_course.dart';
import '../../../data/repositories/course/category_repository_imp.dart';
import '../../../data/repositories/group/group_repository_impl.dart';
import '../../../data/repositories/course/course_repository_impl.dart';
import '../../../domain/repositories/category_repository.dart';
import '../../../domain/repositories/group_repository.dart';
import '../../../domain/repositories/course_repository.dart';

class CategoryController extends GetxController {
  final String courseId;

  late final GetCategoriesUseCase _getCategoriesUseCase;
  late final AddCategoryUseCase _addCategoryUseCase;
  late final UpdateCategoryUseCase _updateCategoryUseCase;
  late final DeleteCategoryUseCase _deleteCategoryUseCase;
  late final CreateGroupsForCategoryUseCase _createGroupsUseCase;
  late final GetStudentsByCourseUseCase _getStudentsUseCase;
  late final GroupRepository _groupRepository;

  var categories = <Category>[].obs;
  var isLoading = false.obs;

  CategoryController({required this.courseId}) {
    final CategoryRepository categoryRepository = CategoryRepositoryImpl();
    final GroupRepository groupRepository = GroupRepositoryImpl();
    final CourseRepository courseRepository = CourseRepositoryImpl();

    _getCategoriesUseCase = GetCategoriesUseCase(categoryRepository);
    _addCategoryUseCase = AddCategoryUseCase(categoryRepository);
    _updateCategoryUseCase = UpdateCategoryUseCase(categoryRepository);
    _deleteCategoryUseCase = DeleteCategoryUseCase(categoryRepository);
    _createGroupsUseCase = CreateGroupsForCategoryUseCase(groupRepository);
    _getStudentsUseCase = GetStudentsByCourseUseCase(courseRepository);
    _groupRepository = groupRepository;
  }

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  void loadCategories() {
    isLoading(true);
    try {
      categories.value = _getCategoriesUseCase(courseId);
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
      // Crear la categoría
      final result = await _addCategoryUseCase(
        courseId: courseId,
        name: name,
        groupingMethod: groupingMethod,
        groupCount: groupCount,
        studentsPerGroup: studentsPerGroup,
      );

      if (result.isSuccess) {
        // Recargar categorías para obtener la nueva categoría con su ID
        loadCategories();

        // Si el método es "random", crear grupos y asignar estudiantes automáticamente
        if (groupingMethod == 'random') {
          await _createGroupsAndAssignStudentsRandomly(
            name: name,
            groupCount: groupCount,
            studentsPerGroup: studentsPerGroup,
          );
        }

        Get.back(); // <-- Cierra el diálogo
        Get.snackbar(
          'Éxito',
          groupingMethod == 'random'
              ? 'Categoría creada y estudiantes asignados aleatoriamente'
              : result.message,
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

  /// Crea grupos para la categoría y asigna estudiantes aleatoriamente
  Future<void> _createGroupsAndAssignStudentsRandomly({
    required String name,
    required int groupCount,
    required int studentsPerGroup,
  }) async {
    try {
      // Obtener la categoría recién creada
      final newCategory = categories.firstWhere(
        (cat) => cat.name == name,
        orElse: () => throw Exception('Categoría no encontrada'),
      );

      // Crear grupos para la categoría
      final createGroupsResult = await _createGroupsUseCase(
        courseId: courseId,
        categoryId: newCategory.id,
        groupCount: groupCount,
        studentsPerGroup: studentsPerGroup,
        categoryName: name,
      );

      if (!createGroupsResult.isSuccess) {
        throw Exception(createGroupsResult.message);
      }

      // Obtener estudiantes del curso
      final students = await _getStudentsUseCase(courseId);

      if (students.isEmpty) {
        return; // No hay estudiantes para asignar
      }

      // Obtener grupos creados
      final groups =
          _groupRepository.getGroupsByCategory(courseId, newCategory.id);

      if (groups.isEmpty) {
        throw Exception('No se pudieron crear los grupos');
      }

      // Asignar estudiantes aleatoriamente
      await _assignStudentsToGroupsRandomly(students, groups);
    } catch (e) {
      Get.snackbar(
        'Advertencia',
        'Categoría creada pero error en asignación: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }

  /// Asigna estudiantes a grupos de forma aleatoria
  Future<void> _assignStudentsToGroupsRandomly(
      List<String> students, List<Group> groups) async {
    if (students.isEmpty || groups.isEmpty) return;

    // Mezclar estudiantes aleatoriamente
    final shuffledStudents = List<String>.from(students);
    shuffledStudents.shuffle();

    // Distribuir estudiantes entre grupos de forma equilibrada
    int studentIndex = 0;
    int groupIndex = 0;

    while (studentIndex < shuffledStudents.length) {
      final group = groups[groupIndex];

      // Verificar si el grupo tiene espacio
      if (!group.isFull) {
        final studentEmail = shuffledStudents[studentIndex];

        // Asignar estudiante al grupo
        final success = _groupRepository.assignStudentToGroup(
            courseId, group.id, studentEmail);

        if (success) {
          studentIndex++;
        } else {
          // Si no se pudo asignar, continuar con el siguiente grupo
          studentIndex++;
        }
      }

      // Mover al siguiente grupo (circular)
      groupIndex = (groupIndex + 1) % groups.length;

      // Si todos los grupos están llenos, salir del bucle
      if (groups.every((g) => g.isFull)) {
        break;
      }
    }
  }
}
