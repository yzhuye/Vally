import '../../entities/course.dart';
import '../../../data/repositories/course_repository.dart';

class GetCourses {
  final CourseRepository repository;

  GetCourses(this.repository);

  Future<List<Course>> call(String userType) async {
    return await repository.getCourses(userType);
  }
}