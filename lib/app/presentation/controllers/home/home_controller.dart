import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vally_app/app/domain/entities/course.dart';
import 'package:vally_app/app/domain/usecases/course/get_courses.dart';
import 'package:vally_app/app/data/repositories/course/course_repository_impl.dart';
import 'package:vally_app/app/presentation/controllers/course/course_management_controller.dart';

class HomeController extends GetxController {
  final GetCourses _getCourses;
  final CourseRepositoryImpl _courseRepository;

  HomeController() : 
    _courseRepository = CourseRepositoryImpl(),
    _getCourses = GetCourses(CourseRepositoryImpl());

  var courses = <Course>[].obs;
  var isLoading = true.obs;
  var selectedUserType = 'Estudiante'.obs; // 'Estudiante' o 'Profesor'
  var searchText = ''.obs;

  @override
  void onInit() {
    // Carga los cursos iniciales para el rol por defecto
    fetchCoursesForRole(selectedUserType.value);
    super.onInit();
  }

  void fetchCoursesForRole(String userType) async {
    try {
      isLoading(true);
      // Pasa el tipo de usuario al caso de uso
      var courseList = await _getCourses(userType);
      courses.assignAll(courseList);
    } finally {
      isLoading(false);
    }
  }

  void selectUserType(String userType) {
    //Actualiza el estado del tipo de usuario seleccionado
    selectedUserType.value = userType;
    //Vuelve a cargar los cursos para el nuevo rol seleccionado
    fetchCoursesForRole(userType);
  }

  Future<void> createCourse(String title, String description) async {
    try {
      isLoading(true);
      await _courseRepository.createCourse(
        title: title,
        description: description,
      );
      // Refrescar la lista de cursos después de crear uno nuevo
      fetchCoursesForRole(selectedUserType.value);
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
    try {
      isLoading(true);
      bool success = await _courseRepository.joinCourseWithCode(invitationCode);
      if (success) {
        // Refrescar la lista de cursos después de unirse
        fetchCoursesForRole(selectedUserType.value);
        
        // Actualizar cualquier CourseManagementController que esté activo
        try {
          final courseManagementController = Get.find<CourseManagementController>();
          courseManagementController.refreshCourse();
        } catch (e) {
          // CourseManagementController no está activo, no hacer nada
        }
        
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

  void updateSearchText(String text) {
    searchText.value = text;
  }

  List<Course> get filteredCourses {
    if (searchText.value.isEmpty) {
      return courses;
    }
    return courses.where((course) => 
      course.title.toLowerCase().contains(searchText.value.toLowerCase()) ||
      course.description.toLowerCase().contains(searchText.value.toLowerCase())
    ).toList();
  }
}