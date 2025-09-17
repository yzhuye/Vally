import '../../entities/course.dart';
import '../../repositories/course_repository.dart';

class GetCourseById {
  final CourseRepository repository;

  GetCourseById(this.repository);

  Future<Course?> call(String courseId) async {
    return await repository.getCourseById(courseId);
  }
}
