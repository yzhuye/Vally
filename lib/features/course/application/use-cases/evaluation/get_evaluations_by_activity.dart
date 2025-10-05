import '../../../domain/entities/course.dart';
import '../../../domain/repositories/evaluation_repository.dart';

class GetEvaluationsByActivityUseCase {
  final EvaluationRepository _repository;

  GetEvaluationsByActivityUseCase(this._repository);

  GetEvaluationsByActivityResult call({required String activityId}) {
    try {
      final evaluations = _repository.getEvaluationsByActivity(activityId);
      
      // Ordenar por fecha de creación (más recientes primero)
      evaluations.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      return GetEvaluationsByActivityResult.success(evaluations);
    } catch (e) {
      return GetEvaluationsByActivityResult.failure(
          'Error al obtener evaluaciones: $e');
    }
  }
}

class GetEvaluationsByActivityResult {
  final bool isSuccess;
  final String? message;
  final List<Evaluation> evaluations;

  const GetEvaluationsByActivityResult._({
    required this.isSuccess,
    this.message,
    required this.evaluations,
  });

  factory GetEvaluationsByActivityResult.success(List<Evaluation> evaluations) =>
      GetEvaluationsByActivityResult._(
          isSuccess: true, evaluations: evaluations);

  factory GetEvaluationsByActivityResult.failure(String message) =>
      GetEvaluationsByActivityResult._(
          isSuccess: false, message: message, evaluations: []);
}
