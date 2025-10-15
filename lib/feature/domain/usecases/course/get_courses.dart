import '../../entities/course.dart';
import '../../repositories/course_repository.dart';

class GetCourses {
  final CourseRepository repository;
  static const String _currentStudentName = 'Estudiante Actual';

  GetCourses(this.repository);

  Future<List<Course>> call(String userType) async {
    final allCourses = await repository.getAllCourses();

    if (userType == 'Estudiante') {
      return allCourses
          .where((c) => c.enrolledStudents.contains(_currentStudentName))
          .toList();
    } else if (userType == 'Profesor') {
      return allCourses;
    } else {
      return [];
    }
  }
}
