import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vally_app/features/course/domain/entities/course.dart';
import 'package:vally_app/features/course/data/repositories/group/group_repository_impl.dart';
import 'package:vally_app/features/course/domain/repositories/group_repository.dart';
import 'package:vally_app/features/course/application/use-cases/group/get_groups_by_category.dart';
import 'package:vally_app/features/course/application/use-cases/group/join_group.dart';
import 'package:vally_app/features/course/application/use-cases/group/find_student_group.dart';

class GroupController extends GetxController {
  final String courseId;
  final String categoryId;
  final String studentEmail;

  late final GroupRepository _repository;
  late final GetGroupsByCategoryUseCase _getGroupsUseCase;
  late final JoinGroupUseCase _joinGroupUseCase;
  late final FindStudentGroupUseCase _findStudentGroupUseCase;

  var groups = <Group>[].obs;
  var isLoading = false.obs;

  GroupController({
    required this.courseId,
    required this.categoryId,
    required this.studentEmail,
  }) {
    _repository = GroupRepositoryImpl();
    _getGroupsUseCase = GetGroupsByCategoryUseCase(_repository);
    _joinGroupUseCase = JoinGroupUseCase(_repository);
    _findStudentGroupUseCase = FindStudentGroupUseCase(_repository);
  }

  @override
  void onInit() {
    super.onInit();
    loadGroups();
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

  Future<void> joinGroup(String groupId) async {
    isLoading(true);

    try {
      // Verificar si ya está en un grupo usando el caso de uso
      final currentGroupResult = _findStudentGroupUseCase(
        courseId: courseId,
        categoryId: categoryId,
        studentEmail: studentEmail,
      );

      if (currentGroupResult.isSuccess && currentGroupResult.group != null) {
        Get.snackbar(
          'Ya estás en un grupo',
          'Ya perteneces al grupo "${currentGroupResult.group!.name}"',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      final result = _joinGroupUseCase(
        courseId: courseId,
        groupId: groupId,
        studentEmail: studentEmail,
      );

      if (result.isSuccess) {
        loadGroups();
        Get.snackbar(
          'Éxito',
          result.message,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
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

  Group? get currentGroup {
    // Convertir el email del estudiante a nombre para comparar con los miembros
    final studentName = _getNameForEmail(studentEmail);

    print('🔍 DEBUG GroupController - Student email: $studentEmail');
    print('🔍 DEBUG GroupController - Student name: $studentName');
    print(
        '🔍 DEBUG GroupController - Available groups: ${groups.map((g) => '${g.name}: ${g.members}').toList()}');

    final foundGroup = groups.firstWhereOrNull((g) {
      final hasEmail = g.members.contains(studentEmail);
      final hasName = g.members.contains(studentName);
      print(
          '🔍 DEBUG GroupController - Group ${g.name}: hasEmail=$hasEmail, hasName=$hasName, members=${g.members}');
      return hasEmail || hasName;
    });

    print(
        '🔍 DEBUG GroupController - Found group: ${foundGroup?.name ?? "None"}');
    return foundGroup;
  }

  // Helper method to convert emails to names
  String _getNameForEmail(String email) {
    final nameMappings = {
      'a@a.com': 'gabriela', // Usar email real
      'b@a.com': 'betty',
      'c@a.com': 'camila',
      'd@a.com': 'daniela', // Usar email real
      'e@a.com': 'eliana', // Usar email real
      'f@a.com': 'fernanda', // Usar email real
    };

    // Si está en el mapeo, usar el nombre
    if (nameMappings.containsKey(email.toLowerCase())) {
      return nameMappings[email.toLowerCase()]!;
    }

    // Si no está en el mapeo, extraer nombre del email (antes del @)
    final emailParts = email.toLowerCase().split('@');
    if (emailParts.isNotEmpty) {
      return emailParts[0];
    }

    return email;
  }

  bool canJoinGroup(Group group) {
    if (currentGroup != null) return false;
    if (group.isFull) return false;
    return true;
  }
}
