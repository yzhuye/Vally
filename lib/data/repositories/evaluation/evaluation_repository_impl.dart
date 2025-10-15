import 'package:hive/hive.dart';
import '../../../domain/entities/course.dart';
import '../../../domain/repositories/evaluation_repository.dart';
import '../../datasources/in-memory/models/evaluation_hive_model.dart';

class EvaluationRepositoryImpl implements EvaluationRepository {
  Box<EvaluationHiveModel> get _evaluationBox => Hive.box<EvaluationHiveModel>('evaluations');

  @override
  Future<void> createEvaluation(Evaluation evaluation) async {
    try {
      
      final evaluationHive = EvaluationHiveModel.fromEvaluation(evaluation);
      await _evaluationBox.put(evaluation.id, evaluationHive);
      
    } catch (e) {
      throw Exception('Error al crear evaluación: $e');
    }
  }

  @override
  List<Evaluation> getEvaluationsByActivity(String activityId) {
    try {
      return _evaluationBox.values
          .where((evalHive) => evalHive.activityId == activityId)
          .map((evalHive) => evalHive.toEvaluation())
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  List<Evaluation> getEvaluationsByEvaluator(String evaluatorId) {
    try {
      return _evaluationBox.values
          .where((evalHive) => evalHive.evaluatorId == evaluatorId)
          .map((evalHive) => evalHive.toEvaluation())
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  List<Evaluation> getEvaluationsForStudent(String studentId) {
    try {
      return _evaluationBox.values
          .where((evalHive) => evalHive.evaluatedId == studentId)
          .map((evalHive) => evalHive.toEvaluation())
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Evaluation? getEvaluationById(String evaluationId) {
    try {
      final evaluationHive = _evaluationBox.get(evaluationId);
      return evaluationHive?.toEvaluation();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> updateEvaluation(Evaluation evaluation) async {
    try {
      final evaluationHive = EvaluationHiveModel.fromEvaluation(evaluation);
      await _evaluationBox.put(evaluation.id, evaluationHive);
    } catch (e) {
      throw Exception('Error al actualizar evaluación: $e');
    }
  }

  @override
  Future<void> deleteEvaluation(String evaluationId) async {
    try {
      await _evaluationBox.delete(evaluationId);
    } catch (e) {
      throw Exception('Error al eliminar evaluación: $e');
    }
  }

  @override
  bool hasEvaluated(String activityId, String evaluatorId, String evaluatedId) {
    try {
      return _evaluationBox.values.any((evalHive) =>
          evalHive.activityId == activityId &&
          evalHive.evaluatorId == evaluatorId &&
          evalHive.evaluatedId == evaluatedId);
    } catch (e) {
      return false;
    }
  }

  @override
  double getAverageRatingForStudent(String activityId, String studentId) {
    try {
      final evaluations = _evaluationBox.values
          .where((evalHive) =>
              evalHive.activityId == activityId &&
              evalHive.evaluatedId == studentId)
          .map((evalHive) => evalHive.toEvaluation())
          .toList();

      if (evaluations.isEmpty) return 0.0;

      final totalRating = evaluations.fold<double>(
          0.0, (sum, eval) => sum + eval.averageRating);
      return totalRating / evaluations.length;
    } catch (e) {
      return 0.0;
    }
  }

  @override
  Map<String, dynamic> getActivityEvaluationStats(String activityId) {
    try {
      final evaluations = getEvaluationsByActivity(activityId);

      if (evaluations.isEmpty) {
        return {
          'totalEvaluations': 0,
          'averageRating': 0.0,
          'participationRate': 0.0,
          'completedEvaluations': 0,
        };
      }

      final totalEvaluations = evaluations.length;
      final totalRating = evaluations.fold<double>(
          0.0, (sum, eval) => sum + eval.averageRating);
      final averageRating = totalRating / totalEvaluations;

      // Agrupar por estudiante evaluado
      final evaluationsByStudent = <String, List<Evaluation>>{};
      for (final eval in evaluations) {
        evaluationsByStudent[eval.evaluatedId] ??= [];
        evaluationsByStudent[eval.evaluatedId]!.add(eval);
      }

      return {
        'totalEvaluations': totalEvaluations,
        'averageRating': averageRating,
        'studentsEvaluated': evaluationsByStudent.keys.length,
        'evaluationsByStudent': evaluationsByStudent.map(
          (studentId, evals) => MapEntry(
            studentId,
            {
              'count': evals.length,
              'averageRating': evals.fold<double>(
                      0.0, (sum, eval) => sum + eval.averageRating) /
                  evals.length,
            },
          ),
        ),
      };
    } catch (e) {
      return {
        'totalEvaluations': 0,
        'averageRating': 0.0,
        'error': e.toString(),
      };
    }
  }
}
