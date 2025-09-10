import 'package:vally_app/app/domain/entities/course.dart';
import '../../../domain/repositories/course_repository.dart';
import 'dart:math';
import 'package:hive/hive.dart';
import '../../models/course_hive_model.dart';

class CourseRepositoryImpl implements CourseRepository {
  static const String _currentStudentName = 'Estudiante Actual';
  late final Box<CourseHiveModel> _courseBox;
  bool _isInitialized = false;

  CourseRepositoryImpl() {
    _courseBox = Hive.box<CourseHiveModel>('courses');
  }

  Future<void> _initializeData() async {
    if (!_isInitialized) {
      // Ya no necesitamos cursos de prueba - usamos preload_data.dart para datos iniciales
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

  // ...resto de métodos deben migrar a usar _courseBox en vez de listas estáticas...

  Future<Course> createCourse({
    required String title,
    required String description,
  }) async {
    await _initializeData();

    final course = Course(
      id: _generateId(),
      title: title,
      description: description,
      enrolledStudents: [],
      invitationCode: _generateInvitationCode(),
      imageUrl: 'assets/images/course_placeholder.png',
      createdBy:
          'system', // Placeholder - este método no se usa en el home controller
    );

    await _courseBox.put(course.id, CourseHiveModel.fromCourse(course));
    return course;
  }

  Future<bool> joinCourseWithCode(String invitationCode) async {
    await _initializeData();

    final allCourses =
        _courseBox.values.map((e) => e.toCourse()).whereType<Course>().toList();
    final course = allCourses.firstWhere(
      (c) => c.invitationCode == invitationCode,
      orElse: () => throw Exception('Código de invitación inválido'),
    );

    if (!course.enrolledStudents.contains(_currentStudentName)) {
      final updatedCourse = Course(
        id: course.id,
        title: course.title,
        description: course.description,
        enrolledStudents: [...course.enrolledStudents, _currentStudentName],
        categories: course.categories,
        groups: course.groups,
        invitationCode: course.invitationCode,
        imageUrl: course.imageUrl,
        createdBy: course.createdBy,
      );
      await _courseBox.put(
          updatedCourse.id, CourseHiveModel.fromCourse(updatedCourse));
      return true;
    }
    return false;
  }

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  Future<Course> updateInvitationCode(String courseId) async {
    await _initializeData();
    final courseHive = _courseBox.get(courseId);
    if (courseHive == null) throw Exception('Curso no encontrado');
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

  Course? getCourseById(String courseId) {
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
