import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vally_app/domain/entities/course.dart';
import 'package:vally_app/data/repositories/course/course_repository_impl.dart';
import 'package:vally_app/presentation/controllers/home/home_controller.dart';
import 'dart:math';

class CourseManagementController extends GetxController {
  final Course _initialCourse;
  late Rx<Course> course;
  final CourseRepositoryImpl _repository = CourseRepositoryImpl();

  var isStudentListVisible = false.obs;

  CourseManagementController(this._initialCourse);

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
      final updatedCourse =
          await _repository.updateInvitationCode(course.value.id);

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

  String _generateInvitationCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(
        6, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
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