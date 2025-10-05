import '../../repositories/course_repository.dart';

class JoinCourseWithCodeUseCase {
  final CourseRepository _repository;
  static const String _currentStudentName = 'Estudiante Actual';

  JoinCourseWithCodeUseCase(this._repository);

  Future<JoinCourseResult> call(String invitationCode) async {
    try {
      if (invitationCode.trim().isEmpty) {
        return JoinCourseResult.failure(
            'El código de invitación no puede estar vacío.');
      }

      final allCourses = await _repository.getAllCourses();
      final course = allCourses.firstWhere(
        (c) => c.invitationCode == invitationCode.trim(),
        orElse: () => throw Exception('Código de invitación inválido'),
      );

      if (course.enrolledStudents.contains(_currentStudentName)) {
        return JoinCourseResult.failure('Ya estás inscrito en este curso.');
      }

      final success =
          await _repository.addStudentToCourse(course.id, _currentStudentName);

      if (success) {
        return JoinCourseResult.success(
            'Te has inscrito exitosamente en el curso: ${course.title}');
      } else {
        return JoinCourseResult.failure('No se pudo completar la inscripción.');
      }
    } catch (e) {
      return JoinCourseResult.failure('Error al unirse al curso: $e');
    }
  }
}

class JoinCourseResult {
  final bool isSuccess;
  final String message;

  const JoinCourseResult._({required this.isSuccess, required this.message});

  factory JoinCourseResult.success(String message) =>
      JoinCourseResult._(isSuccess: true, message: message);

  factory JoinCourseResult.failure(String message) =>
      JoinCourseResult._(isSuccess: false, message: message);
}
