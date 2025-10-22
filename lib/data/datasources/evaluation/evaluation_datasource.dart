import 'package:vally_app/domain/entities/course.dart';

/// Abstract interface for evaluation data sources
/// This allows switching between in-memory and remote implementations
abstract class EvaluationDataSource {
  /// Create a new evaluation
  Future<void> createEvaluation(Evaluation evaluation);

  /// Get all evaluations for a specific activity
  Future<List<Evaluation>> getEvaluationsByActivity(String activityId);

  /// Get all evaluations made by a specific evaluator
  Future<List<Evaluation>> getEvaluationsByEvaluator(String evaluatorId);

  /// Get all evaluations for a specific student
  Future<List<Evaluation>> getEvaluationsForStudent(String studentId);

  /// Get a specific evaluation by ID
  Future<Evaluation?> getEvaluationById(String evaluationId);

  /// Update an existing evaluation
  Future<void> updateEvaluation(Evaluation evaluation);

  /// Delete an evaluation
  Future<void> deleteEvaluation(String evaluationId);

  /// Check if an evaluator has already evaluated a student for an activity
  Future<bool> hasEvaluated(String activityId, String evaluatorId, String evaluatedId);

  /// Get average rating for a student in a specific activity
  Future<double> getAverageRatingForStudent(String activityId, String studentId);

  /// Get evaluation statistics for an activity
  Future<Map<String, dynamic>> getActivityEvaluationStats(String activityId);
}
