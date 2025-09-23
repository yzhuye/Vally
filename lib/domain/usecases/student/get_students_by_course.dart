import '../../entities/course.dart';
import '../../repositories/course_repository.dart';

class GetStudentsByCourseUseCase {
  final CourseRepository _repository;

  GetStudentsByCourseUseCase(this._repository);

  Future<List<String>> call(String courseId) async {
    try {
      final course = _repository.getCourseById(courseId);
      if (course == null) {
        return [];
      }
      return List<String>.from(course.enrolledStudents);
    } catch (e) {
      return [];
    }
  }
}
