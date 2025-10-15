import '../../entities/course.dart';
import '../../repositories/activity_repository.dart';

class CreateActivityUseCase {
  final ActivityRepository _repository;

  CreateActivityUseCase(this._repository);

  Future<CreateActivityResult> call({
    required String name,
    required String description,
    required DateTime dueDate,
    required String categoryId,
  }) async {
    try {
      // Validaciones
      if (name.trim().isEmpty) {
        return CreateActivityResult.failure(
            'El nombre de la actividad no puede estar vacío.');
      }

      if (description.trim().isEmpty) {
        return CreateActivityResult.failure(
            'La descripción de la actividad no puede estar vacía.');
      }

      if (dueDate.isBefore(DateTime.now())) {
        return CreateActivityResult.failure(
            'La fecha de vencimiento debe ser futura.');
      }

      final activity = Activity(
        id: _generateId(),
        name: name.trim(),
        description: description.trim(),
        dueDate: dueDate,
        categoryId: categoryId,
      );

      await _repository.createActivity(activity);

      return CreateActivityResult.success(
          'Actividad creada exitosamente.', activity);
    } catch (e) {
      return CreateActivityResult.failure('Error al crear actividad: $e');
    }
  }

  String _generateId() {
    return 'activity_${DateTime.now().millisecondsSinceEpoch}';
  }
}

class CreateActivityResult {
  final bool isSuccess;
  final String message;
  final Activity? activity;

  const CreateActivityResult._({
    required this.isSuccess,
    required this.message,
    this.activity,
  });

  factory CreateActivityResult.success(String message, Activity activity) =>
      CreateActivityResult._(
          isSuccess: true, message: message, activity: activity);

  factory CreateActivityResult.failure(String message) =>
      CreateActivityResult._(isSuccess: false, message: message);
}
