import '../../entities/course.dart';
import '../../repositories/evaluation_repository.dart';

class UpdateEvaluationUseCase {
  final EvaluationRepository _repository;

  UpdateEvaluationUseCase(this._repository);

  Future<UpdateEvaluationResult> call({
    required String evaluationId,
    required int punctuality,
    required int contributions,
    required int commitment,
    required int attitude,
  }) async {
    try {
      // Obtener la evaluación existente
      final existingEvaluation = await _repository.getEvaluationById(evaluationId);
      if (existingEvaluation == null) {
        return UpdateEvaluationResult.failure('Evaluación no encontrada.');
      }

      // Crear evaluación actualizada
      final updatedEvaluation = Evaluation(
        id: existingEvaluation.id,
        activityId: existingEvaluation.activityId,
        evaluatorId: existingEvaluation.evaluatorId,
        evaluatedId: existingEvaluation.evaluatedId,
        punctuality: punctuality,
        contributions: contributions,
        commitment: commitment,
        attitude: attitude,
        createdAt: existingEvaluation.createdAt,
      );

      // Validar métricas
      if (!updatedEvaluation.isValid) {
        return UpdateEvaluationResult.failure(
            'Las métricas deben estar entre 0 y 5 estrellas.');
      }

      await _repository.updateEvaluation(updatedEvaluation);

      return UpdateEvaluationResult.success(
          'Evaluación actualizada exitosamente.', updatedEvaluation);
    } catch (e) {
      return UpdateEvaluationResult.failure('Error al actualizar evaluación: $e');
    }
  }
}

class UpdateEvaluationResult {
  final bool isSuccess;
  final String message;
  final Evaluation? evaluation;

  const UpdateEvaluationResult._({
    required this.isSuccess,
    required this.message,
    this.evaluation,
  });

  factory UpdateEvaluationResult.success(String message, Evaluation evaluation) =>
      UpdateEvaluationResult._(
          isSuccess: true, message: message, evaluation: evaluation);

  factory UpdateEvaluationResult.failure(String message) =>
      UpdateEvaluationResult._(isSuccess: false, message: message);
}
