import 'package:hive/hive.dart';
import 'package:vally_app/app/feature/course/domain/entities/course.dart';
import '../../../domain/repositories/course_repository.dart';
import '../../models/course_hive_model.dart';
import 'dart:math';

class CourseRepositoryImpl implements CourseRepository {
  static const String _currentStudentName = 'Estudiante Actual';
  late final Box<CourseHiveModel> _courseBox;
  bool _isInitialized = false;

  CourseRepositoryImpl() {
    _courseBox = Hive.box<CourseHiveModel>('courses');
  }

  Future<void> _initializeData() async {
    if (!_isInitialized) {
      _isInitialized = true;
    }
  }

  @override
  Future<List<Course>> getCourses(String userType) async {
    await _initializeData();
    await Future.delayed(const Duration(seconds: 1));

    final allCourses =
        _courseBox.values.map((e) => e.toCourse()).whereType<Course>().toList();

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

  @override
  Future<Course> updateInvitationCode(String courseId) async {
    await _initializeData();

    final courseHive = _courseBox.get(courseId);
    if (courseHive == null) {
      throw Exception('Curso no encontrado');
    }

    final course = courseHive.toCourse();
    final newCode = _generateInvitationCode();

    final updatedCourse = Course(
      id: course.id,
      title: course.title,
      description: course.description,
      enrolledStudents: course.enrolledStudents,
      categories: course.categories,
      groups: course.groups,
      invitationCode: newCode,
      imageUrl: course.imageUrl,
      createdBy: course.createdBy,
    );

    await _courseBox.put(
        updatedCourse.id, CourseHiveModel.fromCourse(updatedCourse));
    return updatedCourse;
  }

  @override
  Future<Course?> getCourseById(String courseId) async {
    await _initializeData();

    final courseHive = _courseBox.get(courseId);
    if (courseHive != null) {
      return courseHive.toCourse();
    }
    return null;
  }

  String _generateInvitationCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(
        6, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }
}
