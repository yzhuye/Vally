import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vally_app/app/feature/course/domain/entities/course.dart';
import 'package:vally_app/app/feature/course/domain/usecases/course/update_invitation_code.dart';
import 'package:vally_app/app/feature/course/domain/usecases/course/get_course_by_id.dart';
import 'package:vally_app/app/feature/course/presentation/controllers/home/home_controller.dart';

class CourseManagementController extends GetxController {
  final Course _initialCourse;
  late Rx<Course> course;
  final UpdateInvitationCode _updateInvitationCode;
  final GetCourseById _getCourseById;

  CourseManagementController(
    this._initialCourse,
    this._updateInvitationCode,
    this._getCourseById,
  );

  @override
  void onInit() {
    course = _initialCourse.obs;
    refreshCourse();
    super.onInit();
  }

  Future<void> generateNewInvitationCode() async {
    try {
      final updatedCourse = await _updateInvitationCode(course.value.id);
      course.value = updatedCourse;

      Get.snackbar(
        'Código Actualizado',
        'Se generó un nuevo código de invitación: ${updatedCourse.invitationCode}',
        backgroundColor: const Color(0xFF4FC3F7),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );

      try {
        final homeController = Get.find<HomeController>();
        await homeController.loadUserCourses();
      } catch (e) {
        // si HomeController no está en memoria, no pasa nada
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo generar un nuevo código: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void refreshCourse() async {
    try {
      final updatedCourse = await _getCourseById(course.value.id);
      if (updatedCourse != null) {
        course.value = updatedCourse;
      }

      try {
        final homeController = Get.find<HomeController>();
        await homeController.loadUserCourses();
      } catch (_) {}
    } catch (e) {
      // Manejar error silenciosamente o mostrar notificación
    }
  }

  int get totalStudents => course.value.enrolledStudents.length;
  int get totalCategories => course.value.categories.length;
  int get totalGroups => course.value.groups.length;

  String get currentInvitationCode => course.value.invitationCode;
}
