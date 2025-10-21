import 'package:hive/hive.dart';
import 'package:vally_app/domain/entities/course.dart';
import 'package:vally_app/data/datasources/evaluation/evaluation_datasource.dart';
import 'package:vally_app/data/datasources/in-memory/models/evaluation_hive_model.dart';

/// In-memory implementation of the evaluation data source
/// Uses Hive for local data storage
class EvaluationDataSourceInMemory implements EvaluationDataSource {
  Box<EvaluationHiveModel> get _evaluationBox =>
      Hive.box<EvaluationHiveModel>('evaluations');

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
  Future<List<Evaluation>> getEvaluationsByActivity(String activityId) async {
    try {
      return Future.value(_evaluationBox.values
          .where((evalHive) => evalHive.activityId == activityId)
          .map((evalHive) => evalHive.toEvaluation())
          .toList());
    } catch (e) {
      return Future.value([]);
    }
  }

  @override
  Future<List<Evaluation>> getEvaluationsByEvaluator(String evaluatorId) async {
    try {
      return Future.value(_evaluationBox.values
          .where((evalHive) => evalHive.evaluatorId == evaluatorId)
          .map((evalHive) => evalHive.toEvaluation())
          .toList());
    } catch (e) {
      return Future.value([]);
    }
  }

  @override
  Future<List<Evaluation>> getEvaluationsForStudent(String studentId) async {
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
  Future<Evaluation?> getEvaluationById(String evaluationId) async {
    try {
      final evaluationHive = _evaluationBox.get(evaluationId);
      return Future.value(evaluationHive?.toEvaluation());
    } catch (e) {
      return Future.value(null);
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
  Future<bool> hasEvaluated(String activityId, String evaluatorId, String evaluatedId) async {
    try {
      return Future.value(_evaluationBox.values.any((evalHive) =>
          evalHive.activityId == activityId &&
          evalHive.evaluatorId == evaluatorId &&
          evalHive.evaluatedId == evaluatedId));
    } catch (e) {
      return Future.value(false);
    }
  }

  @override
  Future<double> getAverageRatingForStudent(String activityId, String studentId) async {
    try {
      final evaluations = await _evaluationBox.values
          .where((evalHive) =>
              evalHive.activityId == activityId &&
              evalHive.evaluatedId == studentId)
          .map((evalHive) => evalHive.toEvaluation())
          .toList();

      if (evaluations.isEmpty) return Future.value(0.0);

      final totalRating = evaluations.fold<double>(
          0.0, (sum, eval) => sum + eval.averageRating);
      return Future.value(totalRating / evaluations.length);
    } catch (e) {
      return Future.value(0.0);
    }
  }

  @override
  Future<Map<String, dynamic>> getActivityEvaluationStats(String activityId) async {
    try {
      final evaluations = await getEvaluationsByActivity(activityId);

      if (evaluations.isEmpty) {
        return Future.value({
          'totalEvaluations': 0,
          'averageRating': 0.0,
          'participationRate': 0.0,
          'completedEvaluations': 0,
        });
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

      return Future.value({
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
      });
    } catch (e) {
      return {
        'totalEvaluations': 0,
        'averageRating': 0.0,
        'error': e.toString(),
      };
    }
  }
}
