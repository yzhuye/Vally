import '../../entities/course.dart';
import '../../repositories/evaluation_repository.dart';

class UpdateEvaluationUseCase {
  final EvaluationRepository _repository;

  UpdateEvaluationUseCase(this._repository);

  Future<UpdateEvaluationResult> call({
    required String evaluationId,
    required int metric1,
    required int metric2,
    required int metric3,
    required int metric4,
    required int metric5,
    String? comments,
  }) async {
    try {
      // Obtener la evaluación existente
      final existingEvaluation = _repository.getEvaluationById(evaluationId);
      if (existingEvaluation == null) {
        return UpdateEvaluationResult.failure('Evaluación no encontrada.');
      }

      // Crear evaluación actualizada
      final updatedEvaluation = Evaluation(
        id: existingEvaluation.id,
        activityId: existingEvaluation.activityId,
        evaluatorId: existingEvaluation.evaluatorId,
        evaluatedId: existingEvaluation.evaluatedId,
        metric1: metric1,
        metric2: metric2,
        metric3: metric3,
        metric4: metric4,
        metric5: metric5,
        comments: comments?.trim(),
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
