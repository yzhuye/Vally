import 'package:vally_app/domain/entities/course.dart';
import 'package:vally_app/data/datasources/evaluation/evaluation_datasource.dart';

/// Remote implementation of the evaluation data source
/// This is a placeholder for future API integration
/// TODO: Implement actual API calls when backend is ready
class EvaluationDataSourceRemote implements EvaluationDataSource {
  // TODO: Add API service dependencies when available
  // late final EvaluationApiService _evaluationApiService;

  EvaluationDataSourceRemote() {
    // TODO: Initialize API services when available
    // _evaluationApiService = EvaluationApiService();
  }

  @override
  Future<void> createEvaluation(Evaluation evaluation) async {
    // TODO: Implement API call to create evaluation
    // return await _evaluationApiService.createEvaluation(evaluation);

    throw UnimplementedError('Remote implementation not yet available. '
        'This will be implemented when the backend API is ready.');
  }

  @override
  List<Evaluation> getEvaluationsByActivity(String activityId) {
    // TODO: Implement API call to get evaluations by activity
    // return await _evaluationApiService.getEvaluationsByActivity(activityId);

    throw UnimplementedError('Remote implementation not yet available. '
        'This will be implemented when the backend API is ready.');
  }

  @override
  List<Evaluation> getEvaluationsByEvaluator(String evaluatorId) {
    // TODO: Implement API call to get evaluations by evaluator
    // return await _evaluationApiService.getEvaluationsByEvaluator(evaluatorId);

    throw UnimplementedError('Remote implementation not yet available. '
        'This will be implemented when the backend API is ready.');
  }

  @override
  List<Evaluation> getEvaluationsForStudent(String studentId) {
    // TODO: Implement API call to get evaluations for student
    // return await _evaluationApiService.getEvaluationsForStudent(studentId);

    throw UnimplementedError('Remote implementation not yet available. '
        'This will be implemented when the backend API is ready.');
  }

  @override
  Evaluation? getEvaluationById(String evaluationId) {
    // TODO: Implement API call to get evaluation by ID
    // return await _evaluationApiService.getEvaluationById(evaluationId);

    throw UnimplementedError('Remote implementation not yet available. '
        'This will be implemented when the backend API is ready.');
  }

  @override
  Future<void> updateEvaluation(Evaluation evaluation) async {
    // TODO: Implement API call to update evaluation
    // return await _evaluationApiService.updateEvaluation(evaluation);

    throw UnimplementedError('Remote implementation not yet available. '
        'This will be implemented when the backend API is ready.');
  }

  @override
  Future<void> deleteEvaluation(String evaluationId) async {
    // TODO: Implement API call to delete evaluation
    // return await _evaluationApiService.deleteEvaluation(evaluationId);

    throw UnimplementedError('Remote implementation not yet available. '
        'This will be implemented when the backend API is ready.');
  }

  @override
  bool hasEvaluated(String activityId, String evaluatorId, String evaluatedId) {
    // TODO: Implement API call to check if evaluation exists
    // return await _evaluationApiService.hasEvaluated(activityId, evaluatorId, evaluatedId);

    throw UnimplementedError('Remote implementation not yet available. '
        'This will be implemented when the backend API is ready.');
  }

  @override
  double getAverageRatingForStudent(String activityId, String studentId) {
    // TODO: Implement API call to get average rating
    // return await _evaluationApiService.getAverageRatingForStudent(activityId, studentId);

    throw UnimplementedError('Remote implementation not yet available. '
        'This will be implemented when the backend API is ready.');
  }

  @override
  Map<String, dynamic> getActivityEvaluationStats(String activityId) {
    // TODO: Implement API call to get activity evaluation stats
    // return await _evaluationApiService.getActivityEvaluationStats(activityId);

    throw UnimplementedError('Remote implementation not yet available. '
        'This will be implemented when the backend API is ready.');
  }
}
