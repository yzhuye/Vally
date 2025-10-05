import '../../entities/course.dart';
import '../../repositories/course_repository.dart';
import 'dart:math';

class CreateCourseUseCase {
  final CourseRepository _repository;

  CreateCourseUseCase(this._repository);

  Future<CreateCourseResult> call({
    required String title,
    required String description,
    required String createdBy,
  }) async {
    try {
      if (title.trim().isEmpty) {
        return CreateCourseResult.failure(
            'El título del curso no puede estar vacío.');
      }

      if (description.trim().isEmpty) {
        return CreateCourseResult.failure(
            'La descripción del curso no puede estar vacía.');
      }

      final course = Course(
        id: _generateId(),
        title: title.trim(),
        description: description.trim(),
        enrolledStudents: [],
        invitationCode: _generateInvitationCode(),
        imageUrl: 'assets/images/course_placeholder.png',
        createdBy: createdBy,
      );

      await _repository.saveCourse(course);
      return CreateCourseResult.success('Curso creado exitosamente.', course);
    } catch (e) {
      return CreateCourseResult.failure('Error al crear curso: $e');
    }
  }

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  String _generateInvitationCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(
        6, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }
}

class CreateCourseResult {
  final bool isSuccess;
  final String message;
  final Course? course;

  const CreateCourseResult._(
      {required this.isSuccess, required this.message, this.course});

  factory CreateCourseResult.success(String message, Course course) =>
      CreateCourseResult._(isSuccess: true, message: message, course: course);

  factory CreateCourseResult.failure(String message) =>
      CreateCourseResult._(isSuccess: false, message: message);
}
