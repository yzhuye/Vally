import '../../entities/course.dart';
import '../../repositories/course_repository.dart';
import 'dart:math';

class UpdateInvitationCodeUseCase {
  final CourseRepository _repository;

  UpdateInvitationCodeUseCase(this._repository);

  Future<UpdateInvitationCodeResult> call(String courseId) async {
    try {
      final course = _repository.getCourseById(courseId);
      if (course == null) {
        return UpdateInvitationCodeResult.failure('Curso no encontrado.');
      }

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

      await _repository.updateCourse(updatedCourse);
      return UpdateInvitationCodeResult.success(
          'Código de invitación actualizado.', newCode);
    } catch (e) {
      return UpdateInvitationCodeResult.failure(
          'Error al actualizar código: $e');
    }
  }

  String _generateInvitationCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(
        6, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }
}

class UpdateInvitationCodeResult {
  final bool isSuccess;
  final String message;
  final String? newCode;

  const UpdateInvitationCodeResult._(
      {required this.isSuccess, required this.message, this.newCode});

  factory UpdateInvitationCodeResult.success(String message, String newCode) =>
      UpdateInvitationCodeResult._(
          isSuccess: true, message: message, newCode: newCode);

  factory UpdateInvitationCodeResult.failure(String message) =>
      UpdateInvitationCodeResult._(isSuccess: false, message: message);
}
