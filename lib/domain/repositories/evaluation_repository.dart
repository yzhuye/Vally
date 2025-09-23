import '../entities/course.dart';

abstract class EvaluationRepository {
  Future<void> createEvaluation(Evaluation evaluation);
  List<Evaluation> getEvaluationsByActivity(String activityId);
  List<Evaluation> getEvaluationsByEvaluator(String evaluatorId);
  List<Evaluation> getEvaluationsForStudent(String studentId);
  Evaluation? getEvaluationById(String evaluationId);
  Future<void> updateEvaluation(Evaluation evaluation);
  Future<void> deleteEvaluation(String evaluationId);
  bool hasEvaluated(String activityId, String evaluatorId, String evaluatedId);
  double getAverageRatingForStudent(String activityId, String studentId);
  Map<String, dynamic> getActivityEvaluationStats(String activityId);
}
