import 'package:vally_app/app/domain/entities/course.dart';
import 'package:vally_app/app/data/repositories/course/course_repository.dart';

class GetCourses {
  final CourseRepository repository;

  GetCourses(this.repository);

  Future<List<Course>> call(String userType) async {
    return await repository.getCourses(userType);
  }
}