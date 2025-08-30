import '../../domain/entities/course.dart';
import '../../data/repositories/course_repository.dart';

class CourseRepositoryImpl implements CourseRepository {
  @override
  Future<List<Course>> getCourses(String userType) async {
    // Simula una llamada a una API
    await Future.delayed(const Duration(seconds: 1));
    if (userType == 'Estudiante') {
      return [
      Course(id: '1', title: 'Curso 1: UI Móvil', imageUrl: 'assets/images/1.jpg'),
      Course(id: '2', title: 'Curso 2: UI Móvil', imageUrl: 'assets/images/2.jpg'),
      Course(id: '3', title: 'Curso 3: UI Móvil', imageUrl: 'assets/images/1.jpg'),
      Course(id: '4', title: 'Curso 4: UI Móvil', imageUrl: 'assets/images/1.jpg'),
      Course(id: '5', title: 'Curso 5: UI Móvil', imageUrl: 'assets/images/1.jpg'),
    ];
    } else if (userType == 'Profesor') {
      return [
      Course(id: '6', title: 'Curso A: Backend', imageUrl: 'assets/images/1.jpg'),
      Course(id: '7', title: 'Curso B: Backend', imageUrl: 'assets/images/1.jpg'),
      Course(id: '8', title: 'Curso C: Backend', imageUrl: 'assets/images/1.jpg'),
      Course(id: '9', title: 'Curso D: Backend', imageUrl: 'assets/images/1.jpg'),
      Course(id: '10', title: 'Curso E: Backend', imageUrl: 'assets/images/1.jpg'),
    ];
    } else {
      // Devolver una lista vacía o lanzar un error si el tipo de usuario no es válido
      return [];
    }
  }
}