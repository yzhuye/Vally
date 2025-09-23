import '../../entities/course.dart';
import '../../repositories/evaluation_repository.dart';

class GetEvaluationsForStudentUseCase {
  final EvaluationRepository _repository;

  GetEvaluationsForStudentUseCase(this._repository);

  GetEvaluationsForStudentResult call({required String studentId}) {
    try {
      final evaluations = _repository.getEvaluationsForStudent(studentId);
      
      // Ordenar por fecha de creación (más recientes primero)
      evaluations.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      // Calcular estadísticas
      final stats = _calculateStats(evaluations);
      
      return GetEvaluationsForStudentResult.success(evaluations, stats);
    } catch (e) {
      return GetEvaluationsForStudentResult.failure(
          'Error al obtener evaluaciones: $e');
    }
  }

  Map<String, dynamic> _calculateStats(List<Evaluation> evaluations) {
    if (evaluations.isEmpty) {
      return {
        'totalEvaluations': 0,
        'averageRating': 0.0,
        'averageByMetric': {
          'metric1': 0.0,
          'metric2': 0.0,
          'metric3': 0.0,
          'metric4': 0.0,
          'metric5': 0.0,
        },
      };
    }

    final totalEvaluations = evaluations.length;
    final totalRating = evaluations.fold<double>(
        0.0, (sum, eval) => sum + eval.averageRating);
    
    final averageRating = totalRating / totalEvaluations;

    // Promedios por métrica
    final metric1Avg = evaluations.fold<double>(
        0.0, (sum, eval) => sum + eval.metric1) / totalEvaluations;
    final metric2Avg = evaluations.fold<double>(
        0.0, (sum, eval) => sum + eval.metric2) / totalEvaluations;
    final metric3Avg = evaluations.fold<double>(
        0.0, (sum, eval) => sum + eval.metric3) / totalEvaluations;
    final metric4Avg = evaluations.fold<double>(
        0.0, (sum, eval) => sum + eval.metric4) / totalEvaluations;
    final metric5Avg = evaluations.fold<double>(
        0.0, (sum, eval) => sum + eval.metric5) / totalEvaluations;

    return {
      'totalEvaluations': totalEvaluations,
      'averageRating': averageRating,
      'averageByMetric': {
        'metric1': metric1Avg,
        'metric2': metric2Avg,
        'metric3': metric3Avg,
        'metric4': metric4Avg,
        'metric5': metric5Avg,
      },
    };
  }
}

class GetEvaluationsForStudentResult {
  final bool isSuccess;
  final String? message;
  final List<Evaluation> evaluations;
  final Map<String, dynamic> stats;

  const GetEvaluationsForStudentResult._({
    required this.isSuccess,
    this.message,
    required this.evaluations,
    required this.stats,
  });

  factory GetEvaluationsForStudentResult.success(
      List<Evaluation> evaluations, Map<String, dynamic> stats) =>
      GetEvaluationsForStudentResult._(
          isSuccess: true, evaluations: evaluations, stats: stats);

  factory GetEvaluationsForStudentResult.failure(String message) =>
      GetEvaluationsForStudentResult._(
          isSuccess: false, 
          message: message, 
          evaluations: [], 
          stats: {});
}
