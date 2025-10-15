import 'package:vally_app/domain/entities/course.dart';
import '../../../domain/repositories/course_repository.dart';
import 'package:hive/hive.dart';
import '../../datasources/in-memory/models/course_hive_model.dart';

class CourseRepositoryImpl implements CourseRepository {
  Box<CourseHiveModel> get _courseBox => Hive.box<CourseHiveModel>('courses');
  bool _isInitialized = false;

  Future<void> _initializeData() async {
    if (!_isInitialized) {
      // Ya no necesitamos cursos de prueba - usamos preload_data.dart para datos iniciales
      _isInitialized = true;
    }
  }

  @override
  Future<List<Course>> getAllCourses() async {
    await _initializeData();
    await Future.delayed(const Duration(seconds: 1));
    return _courseBox.values
        .map((e) => e.toCourse())
        .whereType<Course>()
        .toList();
  }

  @override
  Future<void> saveCourse(Course course) async {
    await _initializeData();
    await _courseBox.put(course.id, CourseHiveModel.fromCourse(course));
  }

  @override
  Future<void> updateCourse(Course course) async {
    await _initializeData();
    await _courseBox.put(course.id, CourseHiveModel.fromCourse(course));
  }

  @override
  Future<bool> addStudentToCourse(String courseId, String studentEmail) async {
    await _initializeData();
    final courseHive = _courseBox.get(courseId);
    if (courseHive == null) return false;

    final course = courseHive.toCourse();
    if (course.enrolledStudents.contains(studentEmail)) return false;

    final updatedCourse = Course(
      id: course.id,
      title: course.title,
      description: course.description,
      enrolledStudents: [...course.enrolledStudents, studentEmail],
      categories: course.categories,
      groups: course.groups,
      invitationCode: course.invitationCode,
      imageUrl: course.imageUrl,
      createdBy: course.createdBy,
    );

    await _courseBox.put(courseId, CourseHiveModel.fromCourse(updatedCourse));
    return true;
  }

  @override
  Future<bool> removeStudentFromCourse(
      String courseId, String studentEmail) async {
    await _initializeData();
    final courseHive = _courseBox.get(courseId);
    if (courseHive == null) return false;

    final course = courseHive.toCourse();
    final updatedStudents = course.enrolledStudents
        .where((email) => email != studentEmail)
        .toList();

    final updatedCourse = Course(
      id: course.id,
      title: course.title,
      description: course.description,
      enrolledStudents: updatedStudents,
      categories: course.categories,
      groups: course.groups,
      invitationCode: course.invitationCode,
      imageUrl: course.imageUrl,
      createdBy: course.createdBy,
    );

    await _courseBox.put(courseId, CourseHiveModel.fromCourse(updatedCourse));
    return true;
  }

  Course? getCourseById(String courseId) {
    final courseHive = _courseBox.get(courseId);
    if (courseHive != null) {
      final course = courseHive.toCourse();
      return course;
    }
    return null;
  }
}
