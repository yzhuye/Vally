import '../../repositories/group_repository.dart';

class CreateGroupsForCategoryResult {
  final bool isSuccess;
  final String message;

  CreateGroupsForCategoryResult({
    required this.isSuccess,
    required this.message,
  });
}

class CreateGroupsForCategoryUseCase {
  final GroupRepository _repository;

  CreateGroupsForCategoryUseCase(this._repository);

  Future<CreateGroupsForCategoryResult> call({
    required String courseId,
    required String categoryId,
    required int groupCount,
    required int studentsPerGroup,
    String? categoryName,
  }) async {
    try {
      await _repository.createGroupsForCategory(
        courseId,
        categoryId,
        groupCount,
        studentsPerGroup,
        categoryName: categoryName,
      );
      
      return CreateGroupsForCategoryResult(
        isSuccess: true,
        message: 'Grupos creados exitosamente para la categoría',
      );
    } catch (e) {
      return CreateGroupsForCategoryResult(
        isSuccess: false,
        message: 'Error al crear grupos: $e',
      );
    }
  }
}
