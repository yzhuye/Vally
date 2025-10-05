import '../entities/course.dart';

abstract class CourseRepository {
  Future<List<Course>> getAllCourses();
  Course? getCourseById(String courseId);
  Future<void> saveCourse(Course course);
  Future<void> updateCourse(Course course);
  Future<bool> addStudentToCourse(String courseId, String studentEmail);
  Future<bool> removeStudentFromCourse(String courseId, String studentEmail);
}
