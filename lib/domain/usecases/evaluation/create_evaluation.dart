import '../../entities/course.dart';
import '../../repositories/evaluation_repository.dart';
import '../../repositories/activity_repository.dart';

class CreateEvaluationUseCase {
  final EvaluationRepository _evaluationRepository;
  final ActivityRepository _activityRepository;

  CreateEvaluationUseCase(this._evaluationRepository, this._activityRepository);

  Future<CreateEvaluationResult> call({
    required String activityId,
    required String evaluatorId,
    required String evaluatedId,
    required int punctuality,
    required int contributions,
    required int commitment,
    required int attitude,
  }) async {
    try {
      // Validaciones básicas
      if (evaluatorId == evaluatedId) {
        return CreateEvaluationResult.failure(
            'No puedes evaluarte a ti mismo.');
      }

      // Verificar que la actividad existe
      final activity = _activityRepository.getActivityById(activityId);
      if (activity == null) {
        return CreateEvaluationResult.failure('Actividad no encontrada.');
      }

      // Verificar que no haya evaluado antes
      if (await _evaluationRepository.hasEvaluated(activityId, evaluatorId, evaluatedId)) {
        return CreateEvaluationResult.failure(
            'Ya has evaluado a este compañero en esta actividad.');
      }

      // Crear la evaluación
      final evaluation = Evaluation(
        id: _generateId(),
        activityId: activityId,
        evaluatorId: evaluatorId,
        evaluatedId: evaluatedId,
        punctuality: punctuality,
        contributions: contributions,
        commitment: commitment,
        attitude: attitude,
        createdAt: DateTime.now(),
      );

      // Validar métricas
      if (!evaluation.isValid) {
        return CreateEvaluationResult.failure(
            'Las métricas deben estar entre 0 y 5 estrellas.');
      }

      await _evaluationRepository.createEvaluation(evaluation);

      return CreateEvaluationResult.success(
          'Evaluación creada exitosamente.', evaluation);
    } catch (e) {
      return CreateEvaluationResult.failure('Error al crear evaluación: $e');
    }
  }

  String _generateId() {
    return 'eval_${DateTime.now().millisecondsSinceEpoch}';
  }
}

class CreateEvaluationResult {
  final bool isSuccess;
  final String message;
  final Evaluation? evaluation;

  const CreateEvaluationResult._({
    required this.isSuccess,
    required this.message,
    this.evaluation,
  });

  factory CreateEvaluationResult.success(String message, Evaluation evaluation) =>
      CreateEvaluationResult._(
          isSuccess: true, message: message, evaluation: evaluation);

  factory CreateEvaluationResult.failure(String message) =>
      CreateEvaluationResult._(isSuccess: false, message: message);
}
