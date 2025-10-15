import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:flutter/material.dart';

import 'package:vally_app/feature/domain/entities/course.dart';
import 'package:vally_app/feature/domain/entities/user.dart';

import 'package:vally_app/feature/presentation/screens/login/login_screen.dart';
import 'package:vally_app/feature/presentation/controllers/login/login_controller.dart';

import 'package:vally_app/core/remote/api_service.dart';
import 'package:vally_app/core/remote/api_user_courses.dart';

class HomeController extends GetxController {
  var currentUser = Rx<User?>(null);

  var professorCourses = <Course>[].obs;
  var studentCourses = <Course>[].obs;

  var _originalProfessorCourses = <Course>[];
  var _originalStudentCourses = <Course>[];

  var isLoading = false.obs;
  var searchText = ''.obs;

  var selectedUserType = 'Estudiante'.obs;
  final logger = Logger();

  @override
  void onInit() {
    _loadUserFromLoginBox();
    super.onInit();
  }

  void _loadUserFromLoginBox() async {
    final loginBox = Hive.box('login');
    final email = loginBox.get('email');

    if (email != null) {
      try {
        // Fetch the user with their courses from the backend
        final userWithCourses = await ApiUserCourses.getUserWithCourses(email);
        if (userWithCourses != null) {
          currentUser.value = userWithCourses;
          await loadUserCourses(); // Load courses after fetching the user
        } else {
          Get.snackbar(
            'Error',
            'No se pudo cargar el usuario.',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'Error al cargar el usuario: $e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  Future<void> loadUserCourses() async {
    if (currentUser.value == null) return;

    try {
      isLoading(true);

      final userWithCourses =
          await ApiUserCourses.getUserWithCourses(currentUser.value!.email);
      if (userWithCourses != null) {
        currentUser.value = userWithCourses;
        // Fetch and create teacher courses from the database
        _originalProfessorCourses = await Future.wait(
          userWithCourses.teacherCourses.map((courseId) async {
            final courseData = await ApiUserCourses.getCourseById(courseId);
            if (courseData != null) {
              return Course.fromJson(courseData);
            }
            return null;
          }),
        ).then((courses) =>
            courses.whereType<Course>().toList()); // Filter out nulls

        // Fetch and create student courses from the database
        _originalStudentCourses = await Future.wait(
          userWithCourses.studentCourses.map((courseId) async {
            final courseData = await ApiUserCourses.getCourseById(courseId);
            if (courseData != null) {
              return Course.fromJson(courseData);
            }
            return null; // Skip if the course is not found
          }),
        ).then((courses) =>
            courses.whereType<Course>().toList()); // Filter out nulls

        // Update observable lists
        professorCourses.assignAll(_originalProfessorCourses);
        studentCourses.assignAll(_originalStudentCourses);

        applySearch();
      } else {
        Get.snackbar(
          'Error',
          'No se pudieron cargar los cursos.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      logger.e("Error loading courses: $e");
      Get.snackbar(
        'Error',
        'Error al cargar los cursos: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  void selectUserType(String userType) {
    selectedUserType.value = userType;
  }

  void updateSearchText(String text) {
    searchText.value = text;
    applySearch();
  }

  void applySearch() {
    if (searchText.value.isEmpty) {
      professorCourses.assignAll(_originalProfessorCourses);
      studentCourses.assignAll(_originalStudentCourses);
      return;
    }

    final query = searchText.value.toLowerCase();
    final filteredProfessor = _originalProfessorCourses
        .where((c) => c.title.toLowerCase().contains(query))
        .toList();

    final filteredStudent = _originalStudentCourses
        .where((c) => c.title.toLowerCase().contains(query))
        .toList();

    professorCourses.assignAll(filteredProfessor);
    studentCourses.assignAll(filteredStudent);
  }

  void logout() async {
    try {
      await ApiService.logout();
      Get.delete<LoginController>();
      Get.offAll(() => const LoginScreen());

      Get.snackbar(
        'Éxito',
        'Has cerrado sesión exitosamente',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error al cerrar sesión: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  List<Course> get filteredCourses {
    if (selectedUserType.value == 'Profesor') {
      return professorCourses;
    } else {
      return studentCourses;
    }
  }

  Future<void> createCourse(String title, String description) async {
    if (currentUser.value == null) return;

    try {
      isLoading(true);
      final newCourse = Course(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        description: description,
        enrolledStudents: [],
        invitationCode: "CODE${DateTime.now().millisecondsSinceEpoch % 10000}",
        imageUrl: null,
        createdBy: currentUser.value!.email,
      );

      final createdCourse = await ApiUserCourses.createCourse(
        title: title,
        description: description,
        invittionCode: newCourse.invitationCode,
        imageUrl: newCourse.imageUrl,
        createdByUserId: currentUser.value!.id,
        createdByUserEmail: currentUser.value!.email,
      );

      if (createdCourse != null) {
        final newCourseId = createdCourse["_id"];
        final updatedUser = User(
          id: currentUser.value!.id,
          username: currentUser.value!.username,
          email: currentUser.value!.email,
          teacherCourses: [...currentUser.value!.teacherCourses, newCourseId],
          studentCourses: currentUser.value!.studentCourses,
        );

        currentUser.value = updatedUser;
        await loadUserCourses();

        Get.snackbar(
          'Éxito',
          'Curso creado exitosamente',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        throw Exception("Error al crear el curso en el backend.");
      }

      final oldUser = currentUser.value!;

      final updatedUser = User(
        id: oldUser.id,
        username: oldUser.username,
        email: oldUser.email,
        teacherCourses: [...oldUser.teacherCourses, newCourse.id],
        studentCourses: oldUser.studentCourses,
      );

      currentUser.value = updatedUser;

      await loadUserCourses();

      Get.snackbar(
        'Éxito',
        'Curso creado exitosamente',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error al crear el curso: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> joinCourseWithCode(String invitationCode) async {
    if (currentUser.value == null) return;

    try {
      isLoading(true);

      // Use the API to join the course with the invitation code
      final joinedCourse = await ApiUserCourses.joinCourseByInvitation(
        userId: currentUser.value!.id,
        invitationCode: invitationCode,
      );

      if (joinedCourse != null) {
        // Reload the user's courses after successfully joining
        await loadUserCourses();

        Get.snackbar(
          'Éxito',
          'Te has unido al curso exitosamente',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'No se pudo unir al curso. Verifica el código de invitación.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error al unirse al curso: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }
}
