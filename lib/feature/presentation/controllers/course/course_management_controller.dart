import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vally_app/feature/domain/entities/course.dart';
import 'package:vally_app/feature/data/repositories/course/course_repository_impl.dart';
import 'package:vally_app/feature/domain/usecases/course/update_invitation_code.dart';
import 'package:vally_app/feature/presentation/controllers/home/home_controller.dart';

class CourseManagementController extends GetxController {
  final Course _initialCourse;
  late Rx<Course> course;
  final CourseRepositoryImpl _repository = CourseRepositoryImpl();
  late final UpdateInvitationCodeUseCase _updateInvitationCodeUseCase;

  var isStudentListVisible = false.obs;

  CourseManagementController(this._initialCourse) {
    _updateInvitationCodeUseCase = UpdateInvitationCodeUseCase(_repository);
  }

  @override
  void onInit() {
    course = _initialCourse.obs;
    refreshCourse();
    super.onInit();
  }

  /// Cambia el estado de visibilidad de la lista de estudiantes.
  /// Si está visible, la oculta, y viceversa.
  void toggleStudentListVisibility() {
    isStudentListVisible.value = !isStudentListVisible.value;
  }

  Future<void> generateNewInvitationCode() async {
    try {
      final result = await _updateInvitationCodeUseCase(course.value.id);

      if (result.isSuccess) {
        // Refresh course data
        refreshCourse();

        Get.snackbar(
          'Código Actualizado',
          'Se generó un nuevo código de invitación: ${result.newCode}',
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
        'No se pudo generar un nuevo código: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void refreshCourse() async {
    final updatedCourse = _repository.getCourseById(course.value.id);
    if (updatedCourse != null) {
      course.value = updatedCourse;

      try {
        final homeController = Get.find<HomeController>();
        await homeController.loadUserCourses();
      } catch (_) {}
    }
  }

  int get totalStudents => course.value.enrolledStudents.length;
  int get totalCategories => course.value.categories.length;

  String get currentInvitationCode => course.value.invitationCode;
}
