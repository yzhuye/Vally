import '../entities/course.dart';

abstract class EvaluationRepository {
  Future<void> createEvaluation(Evaluation evaluation);
  Future<List<Evaluation>> getEvaluationsByActivity(String activityId);
  Future<List<Evaluation>> getEvaluationsByEvaluator(String evaluatorId);
  Future<List<Evaluation>> getEvaluationsForStudent(String studentId);
  Future<Evaluation?> getEvaluationById(String evaluationId);
  Future<void> updateEvaluation(Evaluation evaluation);
  Future<void> deleteEvaluation(String evaluationId);
  Future<bool> hasEvaluated(String activityId, String evaluatorId, String evaluatedId);
  Future<double> getAverageRatingForStudent(String activityId, String studentId);
  Future<Map<String, dynamic>> getActivityEvaluationStats(String activityId);
}
