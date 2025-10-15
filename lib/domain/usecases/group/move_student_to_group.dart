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

  Future<MoveStudentToGroupResult> call({
    required String toGroupId,
    required String studentId,
  }) async {
    try {
      final success = await _repository.assignStudentToGroup(
        studentId,
        toGroupId,
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
