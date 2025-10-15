import '../../repositories/category_repository.dart';

class DeleteCategoryUseCase {
  final CategoryRepository _repository;

  DeleteCategoryUseCase(this._repository);

  Future<DeleteCategoryResult> call({
    required String courseId,
    required String categoryId,
  }) async {
    try {
      _repository.deleteCategory(courseId, categoryId);
      return DeleteCategoryResult.success('Categoría eliminada exitosamente.');
    } catch (e) {
      return DeleteCategoryResult.failure('Error al eliminar categoría: $e');
    }
  }
}

class DeleteCategoryResult {
  final bool isSuccess;
  final String message;

  const DeleteCategoryResult._(
      {required this.isSuccess, required this.message});

  factory DeleteCategoryResult.success(String message) =>
      DeleteCategoryResult._(isSuccess: true, message: message);

  factory DeleteCategoryResult.failure(String message) =>
      DeleteCategoryResult._(isSuccess: false, message: message);
}
