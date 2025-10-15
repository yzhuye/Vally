import '../../entities/course.dart';
import '../../repositories/group_repository.dart';

class FindStudentGroupResult {
  final bool isSuccess;
  final Group? group;
  final String message;

  FindStudentGroupResult({
    required this.isSuccess,
    this.group,
    required this.message,
  });
}

class FindStudentGroupUseCase {
  final GroupRepository _repository;

  FindStudentGroupUseCase(this._repository);

  Future<FindStudentGroupResult> call({
    required String categoryId,
    required String studentId,
  }) async {
    try {
      final group = await _repository.findStudentGroup(categoryId, studentId);

      if (group != null) {
        return FindStudentGroupResult(
          isSuccess: true,
          group: group,
          message: 'Grupo del estudiante encontrado',
        );
      } else {
        return FindStudentGroupResult(
          isSuccess: false,
          group: null,
          message:
              'El estudiante no está asignado a ningún grupo en esta categoría',
        );
      }
    } catch (e) {
      return FindStudentGroupResult(
        isSuccess: false,
        group: null,
        message: 'Error al buscar grupo del estudiante: $e',
      );
    }
  }
}
