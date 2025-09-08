import 'package:vally_app/app/domain/entities/course.dart';

abstract class CourseRepository {
  Future<List<Course>> getCourses(String userType);
}