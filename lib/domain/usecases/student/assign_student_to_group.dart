import '../../entities/course.dart';
import '../../repositories/group_repository.dart';

class AssignStudentToGroupUseCase {
  final GroupRepository _repository;

  AssignStudentToGroupUseCase(this._repository);

  Future<AssignStudentResult> call({
    required String courseId,
    required String groupId,
    required String studentEmail,
  }) async {
    try {
      if (studentEmail.trim().isEmpty) {
        return AssignStudentResult.failure(
            'El email del estudiante no puede estar vacío.');
      }

      final success = _repository.assignStudentToGroup(
          courseId, groupId, studentEmail.trim());

      if (success) {
        return AssignStudentResult.success(
            'Estudiante asignado al grupo exitosamente.');
      } else {
        return AssignStudentResult.failure(
            'No se pudo asignar el estudiante al grupo. Verifique que el grupo no esté lleno.');
      }
    } catch (e) {
      return AssignStudentResult.failure('Error al asignar estudiante: $e');
    }
  }
}

class AssignStudentResult {
  final bool isSuccess;
  final String message;

  const AssignStudentResult._({required this.isSuccess, required this.message});

  factory AssignStudentResult.success(String message) =>
      AssignStudentResult._(isSuccess: true, message: message);

  factory AssignStudentResult.failure(String message) =>
      AssignStudentResult._(isSuccess: false, message: message);
}
