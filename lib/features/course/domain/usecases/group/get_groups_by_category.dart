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

  GetGroupsByCategoryResult call({
    required String courseId,
    required String categoryId,
  }) {
    try {
      final groups = _repository.getGroupsByCategory(courseId, categoryId);
      
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