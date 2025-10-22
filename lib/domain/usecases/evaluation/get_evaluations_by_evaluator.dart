import '../../entities/course.dart';
import '../../repositories/evaluation_repository.dart';

class GetEvaluationsByEvaluatorUseCase {
  final EvaluationRepository _repository;

  GetEvaluationsByEvaluatorUseCase(this._repository);

  Future<GetEvaluationsByEvaluatorResult> call({required String evaluatorId}) async {
    try {
      final evaluations = await _repository.getEvaluationsByEvaluator(evaluatorId);
      
      // Ordenar por fecha de creación (más recientes primero)
      evaluations.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      return GetEvaluationsByEvaluatorResult.success(evaluations);
    } catch (e) {
      return GetEvaluationsByEvaluatorResult.failure(
          'Error al obtener evaluaciones: $e');
    }
  }
}

class GetEvaluationsByEvaluatorResult {
  final bool isSuccess;
  final String? message;
  final List<Evaluation> evaluations;

  const GetEvaluationsByEvaluatorResult._({
    required this.isSuccess,
    this.message,
    required this.evaluations,
  });

  factory GetEvaluationsByEvaluatorResult.success(List<Evaluation> evaluations) =>
      GetEvaluationsByEvaluatorResult._(
          isSuccess: true, evaluations: evaluations);

  factory GetEvaluationsByEvaluatorResult.failure(String message) =>
      GetEvaluationsByEvaluatorResult._(
          isSuccess: false, message: message, evaluations: []);
}
