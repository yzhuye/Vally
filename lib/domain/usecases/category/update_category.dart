import '../../entities/course.dart';
import '../../repositories/category_repository.dart';

class UpdateCategoryUseCase {
  final CategoryRepository _repository;

  UpdateCategoryUseCase(this._repository);

  Future<UpdateCategoryResult> call({
    required String courseId,
    required Category category,
  }) async {
    try {
      if (category.name.trim().isEmpty) {
        return UpdateCategoryResult.failure(
            'El nombre de la categoría no puede estar vacío.');
      }

      if (category.groupCount <= 0) {
        return UpdateCategoryResult.failure(
            'El número de grupos debe ser mayor a 0.');
      }

      if (category.studentsPerGroup <= 0) {
        return UpdateCategoryResult.failure(
            'El número de estudiantes por grupo debe ser mayor a 0.');
      }

      _repository.updateCategory(courseId, category);

      return UpdateCategoryResult.success(
          'Categoría actualizada exitosamente.');
    } catch (e) {
      return UpdateCategoryResult.failure('Error al actualizar categoría: $e');
    }
  }
}

class UpdateCategoryResult {
  final bool isSuccess;
  final String message;

  const UpdateCategoryResult._(
      {required this.isSuccess, required this.message});

  factory UpdateCategoryResult.success(String message) =>
      UpdateCategoryResult._(isSuccess: true, message: message);

  factory UpdateCategoryResult.failure(String message) =>
      UpdateCategoryResult._(isSuccess: false, message: message);
}
