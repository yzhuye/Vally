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
          'punctuality': 0.0,
          'contributions': 0.0,
          'commitment': 0.0,
          'attitude': 0.0,
        },
      };
    }

    final totalEvaluations = evaluations.length;
    final totalRating = evaluations.fold<double>(
        0.0, (sum, eval) => sum + eval.averageRating);
    
    final averageRating = totalRating / totalEvaluations;

    // Promedios por métrica
    final punctualityAvg = evaluations.fold<double>(
        0.0, (sum, eval) => sum + eval.punctuality) / totalEvaluations;
    final contributionsAvg = evaluations.fold<double>(
        0.0, (sum, eval) => sum + eval.contributions) / totalEvaluations;
    final commitmentAvg = evaluations.fold<double>(
        0.0, (sum, eval) => sum + eval.commitment) / totalEvaluations;
    final attitudeAvg = evaluations.fold<double>(
        0.0, (sum, eval) => sum + eval.attitude) / totalEvaluations;

    return {
      'totalEvaluations': totalEvaluations,
      'averageRating': averageRating,
      'averageByMetric': {
        'punctuality': punctualityAvg,
        'contributions': contributionsAvg,
        'commitment': commitmentAvg,
        'attitude': attitudeAvg,
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
