import '../../repositories/evaluation_repository.dart';

class GetActivityEvaluationStatsUseCase {
  final EvaluationRepository _repository;

  GetActivityEvaluationStatsUseCase(this._repository);

  Future<GetActivityEvaluationStatsResult> call({required String activityId}) async {
    try {
      final stats = await _repository.getActivityEvaluationStats(activityId);
      
      return GetActivityEvaluationStatsResult.success(stats);
    } catch (e) {
      return GetActivityEvaluationStatsResult.failure(
          'Error al obtener estadísticas: $e');
    }
  }
}

class GetActivityEvaluationStatsResult {
  final bool isSuccess;
  final String? message;
  final Map<String, dynamic> stats;

  const GetActivityEvaluationStatsResult._({
    required this.isSuccess,
    this.message,
    required this.stats,
  });

  factory GetActivityEvaluationStatsResult.success(Map<String, dynamic> stats) =>
      GetActivityEvaluationStatsResult._(
          isSuccess: true, stats: stats);

  factory GetActivityEvaluationStatsResult.failure(String message) =>
      GetActivityEvaluationStatsResult._(
          isSuccess: false, message: message, stats: {});
}
