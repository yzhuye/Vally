import '../../entities/course.dart';
import '../../repositories/category_repository.dart';

class AddCategoryUseCase {
  final CategoryRepository _repository;

  AddCategoryUseCase(this._repository);

  Future<AddCategoryResult> call({
    required String courseId,
    required String name,
    required String groupingMethod,
    required int groupCount,
    required int studentsPerGroup,
  }) async {
    try {
      if (name.trim().isEmpty) {
        return AddCategoryResult.failure(
            'El nombre de la categoría no puede estar vacío.');
      }

      if (groupCount <= 0) {
        return AddCategoryResult.failure(
            'El número de grupos debe ser mayor a 0.');
      }

      if (studentsPerGroup <= 0) {
        return AddCategoryResult.failure(
            'El número de estudiantes por grupo debe ser mayor a 0.');
      }

      final category = Category(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name.trim(),
        groupingMethod: groupingMethod,
        groupCount: groupCount,
        studentsPerGroup: studentsPerGroup,
      );

      await _repository.addCategory(courseId, category);

      return AddCategoryResult.success('Categoría agregada exitosamente.');
    } catch (e) {
      return AddCategoryResult.failure('Error al agregar categoría: $e');
    }
  }
}

class AddCategoryResult {
  final bool isSuccess;
  final String message;

  const AddCategoryResult._({required this.isSuccess, required this.message});

  factory AddCategoryResult.success(String message) =>
      AddCategoryResult._(isSuccess: true, message: message);

  factory AddCategoryResult.failure(String message) =>
      AddCategoryResult._(isSuccess: false, message: message);
}
