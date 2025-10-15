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

  Future<JoinGroupResult> call({
    required String groupId,
    required String studentId,
  }) async {
    try {
      final success = await _repository.joinGroup(userId: studentId, groupId: groupId);
      
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
