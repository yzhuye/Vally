import '../../entities/course.dart';
import '../../repositories/activity_repository.dart';

class UpdateActivityUseCase {
  final ActivityRepository _repository;

  UpdateActivityUseCase(this._repository);

  Future<UpdateActivityResult> call({
    required String activityId,
    required String name,
    required String description,
    required DateTime dueDate,
  }) async {
    try {
      // Validaciones
      if (name.trim().isEmpty) {
        return UpdateActivityResult.failure(
            'El nombre de la actividad no puede estar vacío.');
      }

      if (description.trim().isEmpty) {
        return UpdateActivityResult.failure(
            'La descripción de la actividad no puede estar vacía.');
      }

      if (dueDate.isBefore(DateTime.now())) {
        return UpdateActivityResult.failure(
            'La fecha de vencimiento debe ser futura.');
      }

      // Obtener la actividad existente
      final existingActivity = _repository.getActivityById(activityId);
      if (existingActivity == null) {
        return UpdateActivityResult.failure('Actividad no encontrada.');
      }

      // Crear actividad actualizada
      final updatedActivity = Activity(
        id: existingActivity.id,
        name: name.trim(),
        description: description.trim(),
        dueDate: dueDate,
        categoryId: existingActivity.categoryId,
        evaluations: existingActivity.evaluations,
      );

      await _repository.updateActivity(updatedActivity);

      return UpdateActivityResult.success(
          'Actividad actualizada exitosamente.', updatedActivity);
    } catch (e) {
      return UpdateActivityResult.failure('Error al actualizar actividad: $e');
    }
  }
}

class UpdateActivityResult {
  final bool isSuccess;
  final String message;
  final Activity? activity;

  const UpdateActivityResult._({
    required this.isSuccess,
    required this.message,
    this.activity,
  });

  factory UpdateActivityResult.success(String message, Activity activity) =>
      UpdateActivityResult._(
          isSuccess: true, message: message, activity: activity);

  factory UpdateActivityResult.failure(String message) =>
      UpdateActivityResult._(isSuccess: false, message: message);
}
