import '../entities/course.dart';

abstract class CourseRepository {
  Future<List<Course>> getCourses(String userType);
  Future<Course> updateInvitationCode(String courseId);
  Future<Course?> getCourseById(String courseId);
}
