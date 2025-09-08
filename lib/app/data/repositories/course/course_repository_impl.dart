import 'package:vally_app/app/domain/entities/course.dart';
import 'course_repository.dart';
import 'dart:math';
import 'package:hive/hive.dart';
import '../models/course_hive_model.dart';

class CourseRepositoryImpl implements CourseRepository {
  static const String _currentStudentName = 'Estudiante Actual';
  late final Box<CourseHiveModel> _courseBox;
  bool _isInitialized = false;

  CourseRepositoryImpl() {
    _courseBox = Hive.box<CourseHiveModel>('courses');
  }

  Future<void> _initializeData() async {
    if (!_isInitialized && _courseBox.isEmpty) {
      final initialCourses = [
        Course(
            id: '1',
            title: 'Curso 1: UI Móvil',
            description: 'Aprende desarrollo de interfaces móviles',
            enrolledStudents: ['Estudiante Actual'],
            invitationCode: 'UIMVL1',
            imageUrl: 'assets/images/1.jpg'),
        Course(
            id: '2',
            title: 'Curso 2: UI Móvil',
            description: 'Desarrollo avanzado de UI',
            enrolledStudents: ['Estudiante Actual', 'Juan Pérez'],
            invitationCode: 'UIMVL2',
            imageUrl: 'assets/images/2.jpg'),
        Course(
            id: '3',
            title: 'Curso 3: UI Móvil',
            description: 'Patrones de diseño móvil',
            enrolledStudents: ['Estudiante Actual'],
            invitationCode: 'UIMVL3',
            imageUrl: 'assets/images/1.jpg'),
        Course(
            id: '4',
            title: 'Curso 4: UI Móvil',
            description: 'Animaciones y transiciones',
            enrolledStudents: [
              'Estudiante Actual',
              'María García',
              'Carlos López'
            ],
            invitationCode: 'UIMVL4',
            imageUrl: 'assets/images/1.jpg'),
        Course(
            id: '5',
            title: 'Curso 5: UI Móvil',
            description: 'Responsive design',
            enrolledStudents: ['Estudiante Actual'],
            invitationCode: 'UIMVL5',
            imageUrl: 'assets/images/1.jpg'),
        Course(
            id: '6',
            title: 'Curso A: Backend',
            description: 'Desarrollo de APIs y servicios backend',
            enrolledStudents: ['Ana Martín', 'Pedro Sánchez'],
            invitationCode: 'BCKND1',
            imageUrl: 'assets/images/1.jpg'),
        Course(
            id: '7',
            title: 'Curso B: Backend',
            description: 'Bases de datos y arquitectura',
            enrolledStudents: ['Luis Fernández'],
            invitationCode: 'BCKND2',
            imageUrl: 'assets/images/1.jpg'),
        Course(
            id: '8',
            title: 'Curso C: Backend',
            description: 'Microservicios y DevOps',
            enrolledStudents: ['Elena Ruiz', 'Miguel Torres', 'Sofia Mendez'],
            invitationCode: 'BCKND3',
            imageUrl: 'assets/images/1.jpg'),
        Course(
            id: '9',
            title: 'Curso D: Backend',
            description: 'Seguridad y autenticación',
            enrolledStudents: [],
            invitationCode: 'BCKND4',
            imageUrl: 'assets/images/1.jpg'),
        Course(
            id: '10',
            title: 'Curso E: Backend',
            description: 'Optimización y performance',
            enrolledStudents: ['Roberto Kim'],
            invitationCode: 'BCKND5',
            imageUrl: 'assets/images/1.jpg'),
      ];
      for (var course in initialCourses) {
        await _courseBox.put(course.id, CourseHiveModel.fromCourse(course));
      }
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
