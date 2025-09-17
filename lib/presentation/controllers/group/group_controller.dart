import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vally_app/domain/entities/course.dart';
import 'package:vally_app/data/repositories/group/group_repository_impl.dart';

class GroupController extends GetxController {
  final String courseId;
  final String categoryId;
  final String studentEmail;
  final GroupRepositoryImpl _repository = GroupRepositoryImpl();

  var groups = <Group>[].obs;
  var isLoading = false.obs;

  GroupController({
    required this.courseId,
    required this.categoryId,
    required this.studentEmail,
  });

  @override
  void onInit() {
    super.onInit();
    loadGroups();
  }

  void loadGroups() {
    isLoading(true);
    groups.value = _repository.getGroupsByCategory(courseId, categoryId);
    isLoading(false);
  }

  Future<void> joinGroup(String groupId) async {
    isLoading(true);

    try {
      final currentGroup =
          groups.firstWhereOrNull((g) => g.members.contains(studentEmail));

      if (currentGroup != null) {
        Get.snackbar(
          'Ya estás en un grupo',
          'Debes salir del grupo "${currentGroup.name}" primero',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        isLoading(false);
        return;
      }

      final success = _repository.joinGroup(courseId, groupId, studentEmail);

      if (success) {
        loadGroups();
        Get.snackbar(
          'Éxito',
          'Te has unido al grupo exitosamente',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'No se pudo unir al grupo. Puede estar lleno.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error al unirse al grupo: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> leaveGroup(String groupId) async {
    isLoading(true);

    try {
      final success = _repository.leaveGroup(courseId, groupId, studentEmail);

      if (success) {
        loadGroups();
        Get.snackbar(
          'Éxito',
          'Has salido del grupo',
          backgroundColor: Colors.blue,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'No se pudo salir del grupo',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error al salir del grupo: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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
