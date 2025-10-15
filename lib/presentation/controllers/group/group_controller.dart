import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vally_app/domain/entities/course.dart';
import 'package:vally_app/data/repositories/group/group_repository_impl.dart';
import 'package:vally_app/domain/repositories/group_repository.dart';
import 'package:vally_app/domain/usecases/group/get_groups_by_category.dart';
import 'package:vally_app/domain/usecases/group/join_group.dart';
import 'package:vally_app/domain/usecases/group/find_student_group.dart';

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
    } finally {
      isLoading(false);
    }
  }

  Future<void> joinGroup(String groupId) async {
    isLoading(true);

    try {
      // Verificar si ya está en un grupo usando el caso de uso
      final currentGroupResult = await _findStudentGroupUseCase(
        categoryId: categoryId,
        studentId: studentEmail,
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


      final result = await _joinGroupUseCase(
        groupId: groupId,
        studentId: studentEmail,
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
    return groups.firstWhereOrNull((g) => g.members.contains(studentEmail));
  }

  bool canJoinGroup(Group group) {
    if (currentGroup != null) return false;
    if (group.isFull) return false;
    return true;
  }
}
