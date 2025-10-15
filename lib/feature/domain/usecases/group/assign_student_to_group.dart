import '../../repositories/group_repository.dart';

class AssignStudentToGroupResult {
  final bool isSuccess;
  final String message;

  AssignStudentToGroupResult({
    required this.isSuccess,
    required this.message,
  });
}

class AssignStudentToGroupUseCase {
  final GroupRepository _repository;

  AssignStudentToGroupUseCase(this._repository);

  AssignStudentToGroupResult call({
    required String courseId,
    required String groupId,
    required String studentEmail,
  }) {
    try {
      final success = _repository.assignStudentToGroup(courseId, groupId, studentEmail);
      
      if (success) {
        return AssignStudentToGroupResult(
          isSuccess: true,
          message: 'Estudiante asignado al grupo exitosamente',
        );
      } else {
        return AssignStudentToGroupResult(
          isSuccess: false,
          message: 'No se pudo asignar al estudiante. El grupo puede estar lleno.',
        );
      }
    } catch (e) {
      return AssignStudentToGroupResult(
        isSuccess: false,
        message: 'Error al asignar estudiante: $e',
      );
    }
  }
}
