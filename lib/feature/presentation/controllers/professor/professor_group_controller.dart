import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/entities/course.dart';
import '../../../domain/usecases/group/get_groups_by_category.dart';
import '../../../domain/usecases/group/assign_student_to_group.dart';
import '../../../domain/usecases/group/move_student_to_group.dart';
import '../../../domain/usecases/student/get_students_by_course.dart';
import '../../../data/repositories/group/group_repository_impl.dart';
import '../../../data/repositories/course/course_repository_impl.dart';
import '../../../domain/repositories/group_repository.dart';
import '../../../domain/repositories/course_repository.dart';
import 'dart:math';

class ProfessorGroupController extends GetxController {
  final String courseId;
  final String categoryId;
  Course? course; // Make course mutable

  late final GetGroupsByCategoryUseCase _getGroupsUseCase;
  late final AssignStudentToGroupUseCase _assignStudentUseCase;
  late final MoveStudentToGroupUseCase _moveStudentUseCase;
  late final GetStudentsByCourseUseCase _getStudentsUseCase;
  late final GroupRepository _groupRepository;

  var groups = <Group>[].obs;
  var students = <String>[].obs;
  var isLoading = false.obs;
  var isAssigningStudent = false.obs;
  var selectedCategory = Rxn<Category>();

  ProfessorGroupController({
    required this.courseId,
    required this.categoryId,
    this.course,
  }) {
    final GroupRepository groupRepository = GroupRepositoryImpl();
    final CourseRepository courseRepository = CourseRepositoryImpl();
    _groupRepository = groupRepository;
    _getGroupsUseCase = GetGroupsByCategoryUseCase(groupRepository);
    _assignStudentUseCase = AssignStudentToGroupUseCase(groupRepository);
    _moveStudentUseCase = MoveStudentToGroupUseCase(groupRepository);
    _getStudentsUseCase = GetStudentsByCourseUseCase(courseRepository);
  }

  @override
  void onInit() {
    super.onInit();
    loadGroups();
    loadStudents();
  }

  Future<void> loadGroups() async {
    isLoading(true);
    try {
      final result = _getGroupsUseCase(
        courseId: courseId,
        categoryId: categoryId,
      );

      if (result.isSuccess) {
        groups.value = result.groups;
      } else {
        Get.snackbar(
          'Error',
          result.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } finally {
      isLoading(false);
    }
  }

  void setCategory(Category category) {
    selectedCategory.value = category;
    loadGroups();
  }

  int get totalGroups => groups.length;
  int get totalStudents =>
      groups.fold(0, (sum, group) => sum + group.members.length);
  int get totalCapacity =>
      groups.fold(0, (sum, group) => sum + group.maxCapacity);
  double get occupancyRate =>
      totalCapacity > 0 ? (totalStudents / totalCapacity) * 100 : 0.0;

  List<Group> get groupsWithSpace =>
      groups.where((group) => !group.isFull).toList();

  List<Group> get fullGroups => groups.where((group) => group.isFull).toList();

  List<Group> getGroupsByStatus(String status) {
    switch (status) {
      case 'available':
        return groupsWithSpace;
      case 'full':
        return fullGroups;
      default:
        return groups;
    }
  }

  Map<String, dynamic> getGroupStats(Group group) {
    return {
      'membersCount': group.members.length,
      'maxCapacity': group.maxCapacity,
      'occupancyRate': (group.members.length / group.maxCapacity) * 100,
      'isFull': group.isFull,
      'hasSpace': !group.isFull,
    };
  }

  Future<void> loadStudents() async {
    try {
      // First try to use students from the course object if available
      if (course != null && course!.enrolledStudents.isNotEmpty) {
        students.value = course!.enrolledStudents;
        return;
      }

      // Fallback to repository if course object doesn't have students
      final studentList = await _getStudentsUseCase(courseId);
      students.value = studentList;
    } catch (e) {
      students.value = [];
    }
  }

  Future<bool> assignStudentToGroup(String studentEmail, String groupId) async {
    isAssigningStudent(true);
    try {
      final result = _assignStudentUseCase(
        courseId: courseId,
        groupId: groupId,
        studentEmail: studentEmail,
      );

      if (result.isSuccess) {
        loadGroups(); // Recargar grupos para reflejar cambios
        loadStudents(); // Recargar estudiantes para reflejar cambios
        Get.snackbar('Éxito', result.message,
            backgroundColor: Colors.green, colorText: Colors.white);
        return true;
      } else {
        Get.snackbar('Error', result.message,
            backgroundColor: Colors.red, colorText: Colors.white);
        return false;
      }
    } finally {
      isAssigningStudent(false);
    }
  }

  Future<bool> moveStudentToGroup(
      String studentEmail, String fromGroupId, String toGroupId) async {
    isAssigningStudent(true);
    try {
      final result = _moveStudentUseCase(
        courseId: courseId,
        fromGroupId: fromGroupId,
        toGroupId: toGroupId,
        studentEmail: studentEmail,
      );

      if (result.isSuccess) {
        loadGroups(); // Recargar grupos para reflejar cambios
        loadStudents(); // Recargar estudiantes para reflejar cambios
        Get.snackbar('Éxito', result.message,
            backgroundColor: Colors.green, colorText: Colors.white);
        return true;
      } else {
        Get.snackbar('Error', result.message,
            backgroundColor: Colors.red, colorText: Colors.white);
        return false;
      }
    } finally {
      isAssigningStudent(false);
    }
  }

  Group? findStudentGroup(String studentEmail) {
    try {
      // First try to find in the loaded groups
      for (var group in groups) {
        if (group.members.contains(studentEmail)) {
          return group;
        }
      }

      // Fallback to repository (but handle the exception properly)
      try {
        final result = _groupRepository.findStudentGroup(
            courseId, categoryId, studentEmail);
        return result;
      } catch (e) {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<void> assignStudentsRandomly() async {
    isLoading(true);

    try {
      // Obtener estudiantes no asignados
      final unassignedStudents = getStudentsNotInAnyGroup();

      print('🔍 DEBUG ProfessorGroupController - All students: $students');
      print(
          '🔍 DEBUG ProfessorGroupController - Unassigned students: $unassignedStudents');
      print('🔍 DEBUG ProfessorGroupController - Groups: $groups');

      if (unassignedStudents.isEmpty) {
        Get.snackbar(
          'Información',
          'No hay estudiantes sin asignar a grupos',
          backgroundColor: Colors.blue,
          colorText: Colors.white,
        );
        return;
      }

      if (groups.isEmpty) {
        Get.snackbar(
          'Error',
          'No hay grupos disponibles para asignar estudiantes',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Mezclar estudiantes aleatoriamente
      final shuffledStudents = List<String>.from(unassignedStudents);
      shuffledStudents.shuffle(Random());

      // Distribuir estudiantes entre grupos de forma equilibrada
      int studentIndex = 0;
      int groupIndex = 0;

      while (studentIndex < shuffledStudents.length) {
        final group = groups[groupIndex];

        // Verificar si el grupo tiene espacio
        if (!group.isFull) {
          String studentIdentifier = shuffledStudents[studentIndex];

          // Asignar estudiante al grupo
          final success =
              await assignStudentToGroup(studentIdentifier, group.id);

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

      // Recargar datos
      loadGroups();
      loadStudents();

      Get.snackbar(
        'Éxito',
        'Asignación aleatoria completada',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error al realizar asignación aleatoria: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  /// Asigna aleatoriamente todos los estudiantes (incluyendo los ya asignados)
  Future<void> reassignAllStudentsRandomly() async {
    isLoading(true);

    try {
      // Obtener todos los estudiantes asignados
      final allAssignedStudents = <String>[];
      for (final group in groups) {
        allAssignedStudents.addAll(group.members);
      }

      // Limpiar todos los grupos
      for (final group in groups) {
        final emptyGroup = Group(
          id: group.id,
          name: group.name,
          maxCapacity: group.maxCapacity,
          members: [],
          categoryId: group.categoryId,
        );
        _groupRepository.updateGroup(courseId, emptyGroup);
      }

      // Recargar grupos
      loadGroups();

      // Asignar aleatoriamente todos los estudiantes que estaban asignados
      if (allAssignedStudents.isNotEmpty) {
        await _assignStudentsToGroupsRandomly(allAssignedStudents);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error al reasignar estudiantes: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  /// Asigna una lista de estudiantes a grupos de forma aleatoria
  Future<void> _assignStudentsToGroupsRandomly(
      List<String> studentsToAssign) async {
    if (studentsToAssign.isEmpty || groups.isEmpty) return;

    // Mezclar estudiantes aleatoriamente
    final shuffledStudents = List<String>.from(studentsToAssign);
    shuffledStudents.shuffle(Random());

    // Distribuir estudiantes entre grupos de forma equilibrada
    int studentIndex = 0;
    int groupIndex = 0;

    while (studentIndex < shuffledStudents.length) {
      final group = groups[groupIndex];

      // Verificar si el grupo tiene espacio
      if (!group.isFull) {
        String studentIdentifier = shuffledStudents[studentIndex];

        // Asignar estudiante al grupo
        final success = await assignStudentToGroup(studentIdentifier, group.id);

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

  GroupRepository get groupRepository => _groupRepository;

  List<String> getStudentsNotInAnyGroup() {
    return students
        .where((studentEmail) => findStudentGroup(studentEmail) == null)
        .toList();
  }

  List<String> getStudentsInGroup(Group group) {
    return group.members;
  }

  // Reactive computed properties for counters
  int get totalStudentsCount => students.length;

  int get studentsInGroupsCount {
    return students
        .where((studentEmail) => findStudentGroup(studentEmail) != null)
        .length;
  }

  int get studentsNotInGroupsCount {
    return students
        .where((studentEmail) => findStudentGroup(studentEmail) == null)
        .length;
  }

  int get totalGroupsCount => groups.length;
}
