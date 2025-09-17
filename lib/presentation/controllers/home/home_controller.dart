import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

import 'package:vally_app/domain/entities/course.dart';
import 'package:vally_app/domain/entities/user.dart';

import 'package:vally_app/data/models/course_hive_model.dart';
import 'package:vally_app/data/models/user_hive_model.dart';

import 'package:vally_app/presentation/screens/login/login_screen.dart';
import 'package:vally_app/presentation/controllers/login/login_controller.dart';

import 'package:vally_app/domain/services/api_service.dart';

class HomeController extends GetxController {
  var currentUser = Rx<User?>(null);

  var professorCourses = <Course>[].obs;
  var studentCourses = <Course>[].obs;

  var _originalProfessorCourses = <Course>[];
  var _originalStudentCourses = <Course>[];

  var isLoading = false.obs;
  var searchText = ''.obs;

  var selectedUserType = 'Estudiante'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserFromLoginBox();
  }

  void _loadUserFromLoginBox() {
    final loginBox = Hive.box('login');
    final email = loginBox.get('email');

    if (email != null) {
      final userBox = Hive.box<UserHiveModel>('users');
      final userHive = userBox.values.firstWhere((u) => u.email == email);
      currentUser.value = userHive.toUser();

      loadUserCourses();
    }
  }

  Future<void> loadUserCourses() async {
    if (currentUser.value == null) return;

    isLoading(true);
    final courseBox = Hive.box<CourseHiveModel>('courses');
    final allCourses = courseBox.values.map((c) => c.toCourse()).toList();
    if (currentUser.value!.isTeacher) {
      _originalProfessorCourses = allCourses.where((c) {
        final isCreatedByUser = c.createdBy == currentUser.value!.email;
        return isCreatedByUser;
      }).toList();
    } else {
      _originalProfessorCourses = [];
    }

    _originalStudentCourses = allCourses
        .where((c) => c.enrolledStudents.contains(currentUser.value!.email))
        .toList();

    professorCourses.assignAll(_originalProfessorCourses);
    studentCourses.assignAll(_originalStudentCourses);

    applySearch();
    isLoading(false);
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

  void logout() async{
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

      final courseBox = Hive.box<CourseHiveModel>('courses');
      final userBox = Hive.box<UserHiveModel>('users');

      final newCourse = Course(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        description: description,
        enrolledStudents: [],
        invitationCode: "CODE${DateTime.now().millisecondsSinceEpoch % 10000}",
        imageUrl: null,
        createdBy: currentUser.value!.email,
      );

      await courseBox.put(newCourse.id, CourseHiveModel.fromCourse(newCourse));

      final oldUser = currentUser.value!;

      final updatedUser = User(
        id: oldUser.id,
        username: oldUser.username,
        email: oldUser.email,
        password: oldUser.password,
        isTeacher: true,
        courseIds: [...oldUser.courseIds, newCourse.id],
      );

      await userBox.put(updatedUser.id, UserHiveModel.fromUser(updatedUser));
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
      final courseBox = Hive.box<CourseHiveModel>('courses');

      final courseHive = courseBox.values.firstWhere(
        (c) => c.invitationCode == invitationCode,
        orElse: () => throw Exception("Curso no encontrado"),
      );

      final course = courseHive.toCourse();

      if (!course.enrolledStudents.contains(currentUser.value!.email)) {
        course.enrolledStudents.add(currentUser.value!.email);

        await courseBox.put(course.id, CourseHiveModel.fromCourse(course));

        await loadUserCourses();

        Get.snackbar(
          'Éxito',
          'Te has unido al curso exitosamente',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Info',
          'Ya estás inscrito en este curso',
          backgroundColor: Colors.orange,
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
