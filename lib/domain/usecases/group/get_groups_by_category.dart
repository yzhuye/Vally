import '../../entities/course.dart';
import '../../repositories/group_repository.dart';

class GetGroupsByCategoryResult {
  final bool isSuccess;
  final List<Group> groups;
  final String message;

  GetGroupsByCategoryResult({
    required this.isSuccess,
    required this.groups,
    required this.message,
  });
}

class GetGroupsByCategoryUseCase {
  final GroupRepository _repository;

  GetGroupsByCategoryUseCase(this._repository);

  Future<GetGroupsByCategoryResult> call({
    required String categoryId,
  }) async {
    try {
      final groups = await _repository.getGroupsByCategory(categoryId);
      
      return GetGroupsByCategoryResult(
        isSuccess: true,
        groups: groups,
        message: 'Grupos cargados exitosamente',
      );
    } catch (e) {
      return GetGroupsByCategoryResult(
        isSuccess: false,
        groups: [],
        message: 'Error al cargar grupos: $e',
      );
    }
  }
}