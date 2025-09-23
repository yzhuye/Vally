import '../../repositories/activity_repository.dart';

class DeleteActivityUseCase {
  final ActivityRepository _repository;

  DeleteActivityUseCase(this._repository);

  Future<DeleteActivityResult> call({required String activityId}) async {
    try {
      // Verificar que la actividad existe
      final activity = _repository.getActivityById(activityId);
      if (activity == null) {
        return DeleteActivityResult.failure('Actividad no encontrada.');
      }

      // Verificar si la actividad tiene evaluaciones
      if (activity.evaluations.isNotEmpty) {
        return DeleteActivityResult.failure(
            'No se puede eliminar una actividad que ya tiene evaluaciones.');
      }

      await _repository.deleteActivity(activityId);

      return DeleteActivityResult.success('Actividad eliminada exitosamente.');
    } catch (e) {
      return DeleteActivityResult.failure('Error al eliminar actividad: $e');
    }
  }
}

class DeleteActivityResult {
  final bool isSuccess;
  final String message;

  const DeleteActivityResult._({
    required this.isSuccess,
    required this.message,
  });

  factory DeleteActivityResult.success(String message) =>
      DeleteActivityResult._(isSuccess: true, message: message);

  factory DeleteActivityResult.failure(String message) =>
      DeleteActivityResult._(isSuccess: false, message: message);
}
