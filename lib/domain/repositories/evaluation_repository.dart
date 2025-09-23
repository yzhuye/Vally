import '../entities/course.dart';

abstract class EvaluationRepository {
  /// Crea una nueva evaluación
  Future<void> createEvaluation(Evaluation evaluation);
  
  /// Obtiene todas las evaluaciones de una actividad
  List<Evaluation> getEvaluationsByActivity(String activityId);
  
  /// Obtiene evaluaciones realizadas por un evaluador
  List<Evaluation> getEvaluationsByEvaluator(String evaluatorId);
  
  /// Obtiene evaluaciones recibidas por un estudiante
  List<Evaluation> getEvaluationsForStudent(String studentId);
  
  /// Obtiene una evaluación específica
  Evaluation? getEvaluationById(String evaluationId);
  
  /// Actualiza una evaluación existente
  Future<void> updateEvaluation(Evaluation evaluation);
  
  /// Elimina una evaluación
  Future<void> deleteEvaluation(String evaluationId);
  
  /// Verifica si un evaluador ya evaluó a un estudiante en una actividad
  bool hasEvaluated(String activityId, String evaluatorId, String evaluatedId);
  
  /// Obtiene el promedio de evaluaciones para un estudiante en una actividad
  double getAverageRatingForStudent(String activityId, String studentId);
  
  /// Obtiene estadísticas de evaluación para una actividad
  Map<String, dynamic> getActivityEvaluationStats(String activityId);
}
