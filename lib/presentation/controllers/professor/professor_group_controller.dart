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

class ProfessorGroupController extends GetxController {
  final String courseId;
  final String categoryId;

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

  void loadGroups() {
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
      students.value = await _getStudentsUseCase(courseId);
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
      return _groupRepository.findStudentGroup(
          courseId, categoryId, studentEmail);
    } catch (e) {
      return null;
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
}
