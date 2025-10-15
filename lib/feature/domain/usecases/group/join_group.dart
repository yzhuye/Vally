import '../../repositories/group_repository.dart';

class JoinGroupResult {
  final bool isSuccess;
  final String message;

  JoinGroupResult({
    required this.isSuccess,
    required this.message,
  });
}

class JoinGroupUseCase {
  final GroupRepository _repository;

  JoinGroupUseCase(this._repository);

  JoinGroupResult call({
    required String courseId,
    required String groupId,
    required String studentEmail,
  }) {
    try {
      final success = _repository.joinGroup(courseId, groupId, studentEmail);
      
      if (success) {
        return JoinGroupResult(
          isSuccess: true,
          message: 'Te has unido al grupo exitosamente',
        );
      } else {
        return JoinGroupResult(
          isSuccess: false,
          message: 'No se pudo unir al grupo. Puede estar lleno o ya estar en él.',
        );
      }
    } catch (e) {
      return JoinGroupResult(
        isSuccess: false,
        message: 'Error al unirse al grupo: $e',
      );
    }
  }
}
