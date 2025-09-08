import 'package:vally_app/app/domain/entities/course.dart';
import 'course_repository.dart';
import 'dart:math';

class CourseRepositoryImpl implements CourseRepository {
  void _initializeData() {
    if (!_isInitialized) {
      _allCourses.addAll([
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
      ]);

      // Inicializar cursos inscritos para el estudiante
      _enrolledCourses.addAll(_allCourses
          .where(
              (course) => course.enrolledStudents.contains(_currentStudentName))
          .toList());

      _isInitialized = true;
    }
  }

  @override
  Future<List<Course>> getCourses(String userType) async {
    _initializeData();

    // Simula una llamada a una API
    await Future.delayed(const Duration(seconds: 1));

    if (userType == 'Estudiante') {
      return _enrolledCourses;
    } else if (userType == 'Profesor') {
      return _allCourses;
    } else {
      // Devolver una lista vacía o lanzar un error si el tipo de usuario no es válido
      return [];
    }
  }

  // Funcionalidades adicionales para gestión de cursos
  static final List<Course> _allCourses = [];
  static final List<Course> _enrolledCourses = [];
  static const String _currentStudentName = 'Estudiante Actual';
  static bool _isInitialized = false;

  Future<Course> createCourse({
    required String title,
    required String description,
  }) async {
    _initializeData();

    final course = Course(
      id: _generateId(),
      title: title,
      description: description,
      enrolledStudents: [],
      invitationCode: _generateInvitationCode(),
      imageUrl: 'assets/images/course_placeholder.png',
    );

    _allCourses.add(course);
    return course;
  }

  Future<bool> joinCourseWithCode(String invitationCode) async {
    _initializeData();

    // Buscar el curso en la lista principal
    final courseIndex = _allCourses.indexWhere(
      (course) => course.invitationCode == invitationCode,
    );

    if (courseIndex == -1) {
      throw Exception('Código de invitación inválido');
    }

    final targetCourse = _allCourses[courseIndex];

    if (!targetCourse.enrolledStudents.contains(_currentStudentName)) {
      // Actualizar el curso en la lista principal
      final updatedCourse = Course(
        id: targetCourse.id,
        title: targetCourse.title,
        description: targetCourse.description,
        enrolledStudents: [
          ...targetCourse.enrolledStudents,
          _currentStudentName
        ],
        categories: targetCourse.categories,
        groups: targetCourse.groups,
        invitationCode: targetCourse.invitationCode,
        imageUrl: targetCourse.imageUrl,
      );

      // Actualizar en la lista principal
      _allCourses[courseIndex] = updatedCourse;

      // Agregar a la lista de cursos inscritos del estudiante
      if (!_enrolledCourses.any((c) => c.id == targetCourse.id)) {
        _enrolledCourses.add(updatedCourse);
      } else {
        // Actualizar en la lista de inscritos también
        final enrolledIndex =
            _enrolledCourses.indexWhere((c) => c.id == targetCourse.id);
        if (enrolledIndex != -1) {
          _enrolledCourses[enrolledIndex] = updatedCourse;
        }
      }

      return true;
    }
    return false;
  }

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  Future<Course> updateInvitationCode(String courseId) async {
    _initializeData();

    final courseIndex =
        _allCourses.indexWhere((course) => course.id == courseId);
    if (courseIndex == -1) throw Exception('Curso no encontrado');

    final course = _allCourses[courseIndex];
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

    // Actualizar en la lista principal
    _allCourses[courseIndex] = updatedCourse;

    // Actualizar también en cursos inscritos si existe
    final enrolledIndex = _enrolledCourses.indexWhere((c) => c.id == courseId);
    if (enrolledIndex != -1) {
      _enrolledCourses[enrolledIndex] = updatedCourse;
    }

    return updatedCourse;
  }

  Course? getCourseById(String courseId) {
    _initializeData();
    try {
      return _allCourses.firstWhere((course) => course.id == courseId);
    } catch (e) {
      return null;
    }
  }

  String _generateInvitationCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(
        6, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }
}
