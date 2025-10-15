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

  Future<AssignStudentToGroupResult> call({
    required String groupId,
    required String userId,
  }) async {
    try {
      final success = await _repository.assignStudentToGroup(userId, groupId);
      
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
