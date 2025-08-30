import 'package:get/get.dart';
import '../../domain/entities/course.dart';
import '../../domain/usecases/get_courses.dart';
import '../../domain/repositories/course_repository_impl.dart';

class HomeController extends GetxController {
  final GetCourses _getCourses;

  HomeController() : _getCourses = GetCourses(CourseRepositoryImpl());

  var courses = <Course>[].obs;
  var isLoading = true.obs;
  var selectedUserType = 'Estudiante'.obs; // 'Estudiante' o 'Profesor'

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
}