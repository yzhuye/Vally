import '../../repositories/group_repository.dart';

class MoveStudentToGroupResult {
  final bool isSuccess;
  final String message;

  MoveStudentToGroupResult({
    required this.isSuccess,
    required this.message,
  });
}

class MoveStudentToGroupUseCase {
  final GroupRepository _repository;

  MoveStudentToGroupUseCase(this._repository);

  MoveStudentToGroupResult call({
    required String courseId,
    required String fromGroupId,
    required String toGroupId,
    required String studentEmail,
  }) {
    try {
      final success = _repository.moveStudentToGroup(
        courseId, 
        fromGroupId, 
        toGroupId, 
        studentEmail
      );
      
      if (success) {
        return MoveStudentToGroupResult(
          isSuccess: true,
          message: 'Estudiante movido al nuevo grupo exitosamente',
        );
      } else {
        return MoveStudentToGroupResult(
          isSuccess: false,
          message: 'No se pudo mover al estudiante. El grupo destino puede estar lleno.',
        );
      }
    } catch (e) {
      return MoveStudentToGroupResult(
        isSuccess: false,
        message: 'Error al mover estudiante: $e',
      );
    }
  }
}
