import '../../repositories/group_repository.dart';

class MoveStudentToGroupUseCase {
  final GroupRepository _repository;

  MoveStudentToGroupUseCase(this._repository);

  Future<MoveStudentResult> call({
    required String studentId,
    required String toGroupId, 
  }) async {
    try {
      if (studentId.trim().isEmpty) {
        return MoveStudentResult.failure( 
          'El id del estudiante no puede estar vacío.');
      }

      final success = await _repository.assignStudentToGroup(studentId, toGroupId);

      if (success) {
        return MoveStudentResult.success(
            'Estudiante movido al grupo exitosamente.');
      } else {
        return MoveStudentResult.failure(
            'No se pudo mover el estudiante al grupo. Verifique que el grupo destino no esté lleno.');
      }
    } catch (e) {
      return MoveStudentResult.failure('Error al mover estudiante: $e');
    }
  }
}

class MoveStudentResult {
  final bool isSuccess;
  final String message;

  const MoveStudentResult._({required this.isSuccess, required this.message});

  factory MoveStudentResult.success(String message) =>
      MoveStudentResult._(isSuccess: true, message: message);

  factory MoveStudentResult.failure(String message) =>
      MoveStudentResult._(isSuccess: false, message: message);
}
