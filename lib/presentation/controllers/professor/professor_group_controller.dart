import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/entities/course.dart';
import '../../../domain/usecases/group/get_groups_by_category.dart';
import '../../../domain/usecases/group/assign_student_to_group.dart';
import '../../../domain/usecases/group/move_student_to_group.dart';
import '../../../domain/usecases/group/find_student_group.dart';
import '../../../domain/usecases/student/get_students_by_course.dart';
import '../../../data/repositories/group/group_repository_impl.dart';
import '../../../data/repositories/course/course_repository_impl.dart';
import '../../../domain/repositories/group_repository.dart';
import '../../../domain/repositories/course_repository.dart';

class ProfessorGroupController extends GetxController {
  final String courseId;
  final String categoryId;
  Course? course; // Make course mutable

  late final GetGroupsByCategoryUseCase _getGroupsUseCase;
  late final AssignStudentToGroupUseCase _assignStudentUseCase;
  late final MoveStudentToGroupUseCase _moveStudentUseCase;
  late final FindStudentGroupUseCase _findStudentGroupUseCase;
  late final GetStudentsByCourseUseCase _getStudentsUseCase;
  late final GroupRepository _groupRepository;

  var groups = <Group>[].obs;
  var students = <String>[].obs; // Mantener para compatibilidad
  var studentInfo = <StudentInfo>[].obs; // Nueva estructura con nombres
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
    _findStudentGroupUseCase = FindStudentGroupUseCase(groupRepository);
    _getStudentsUseCase = GetStudentsByCourseUseCase(courseRepository);
  }

  @override
  void onInit() {
    super.onInit();
    loadGroups();
    loadStudents();
  }

  void loadGroups() async {
    isLoading(true);
    try {
      final result = await _getGroupsUseCase(
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
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error inesperado: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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
      if (course != null && course!.enrolledStudentInfo.isNotEmpty) {
        studentInfo.value = course!.enrolledStudentInfo;
        students.value =
            course!.enrolledStudentInfo.map((s) => s.email).toList();
        return;
      }

      // Fallback to repository if course object doesn't have students
      final studentList = await _getStudentsUseCase(courseId);
      students.value = studentList;
      // Crear StudentInfo desde la lista de emails (estructura antigua)
      studentInfo.value = studentList
          .map((email) => StudentInfo(
                email: email,
                name:
                    email.split('@').first, // Usar parte del email como nombre
              ))
          .toList();
    } catch (e) {
      students.value = [];
      studentInfo.value = [];
    }
  }

  Future<bool> assignStudentToGroup(String studentId, String groupId) async {

    isAssigningStudent(true);
    try {
      final result = await _assignStudentUseCase(
        groupId: groupId,
        userId: studentId,
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

  Future<bool> moveStudentToGroup(String studentEmail, String toGroupId) async {
    isAssigningStudent(true);
    try {
      final result = await _moveStudentUseCase(
        toGroupId: toGroupId,
        studentId: studentEmail,
      );

      if (result.isSuccess) {
        loadGroups(); // Recargar grupos para reflejar cambios
        loadStudents(); // Recargar estudiantes para reflejar cambios
        return true;
      } else {
        return false;
      }
    } finally {
      isAssigningStudent(false);
    }
  }

  // Versión asíncrona que hace la búsqueda completa
  Future<Group?> findStudentGroup(String studentId) async {
    try {
      final result = await _findStudentGroupUseCase(
        categoryId: categoryId,
        studentId: studentId,
      );

      if (result.isSuccess) {
        return result.group;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<void> assignStudentsRandomly() async {
    isLoading(true);

    try {
      final unassignedStudents = getStudentsNotInAnyGroup();

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

  List<String> getStudentsNotInAnyGroup() {

    final unassigned = students.where((studentEmail) {
      final isInGroup = _findStudentGroupSync(studentEmail) != null;
      return !isInGroup;
    }).toList();

    return unassigned;
  }

  // Versión síncrona que busca en los grupos ya cargados
  Group? _findStudentGroupSync(String studentEmail) {
    for (final group in groups) {
      if (group.members.contains(studentEmail)) {
        return group;
      }
    }
    return null;
  }

  List<String> getStudentsInGroup(Group group) {
    return group.members;
  }

  // Reactive computed properties for counters
  int get totalStudentsCount => students.length;

  int get studentsInGroupsCount {
    return students
        .where((studentEmail) => _findStudentGroupSync(studentEmail) != null)
        .length;
  }

  int get studentsNotInGroupsCount {
    return students
        .where((studentEmail) => _findStudentGroupSync(studentEmail) == null)
        .length;
  }

  int get totalGroupsCount => groups.length;

  // Métodos helper para obtener nombres y emails
  String getStudentName(String email) {
    final info = studentInfo.firstWhereOrNull((s) => s.email == email);
    return info?.name ?? email.split('@').first;
  }

  String getStudentEmail(String name) {
    final info = studentInfo.firstWhereOrNull((s) => s.name == name);
    return info?.email ?? name;
  }

  List<String> get studentNames => studentInfo.map((s) => s.name).toList();
  List<String> get studentEmails => studentInfo.map((s) => s.email).toList();
}
