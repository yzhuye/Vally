import 'package:hive/hive.dart';
import '../../../../domain/entities/course.dart';
part 'evaluation_hive_model.g.dart';

@HiveType(typeId: 5)
class EvaluationHiveModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String activityId;

  @HiveField(2)
  String evaluatorId;

  @HiveField(3)
  String evaluatedId;

  @HiveField(4)
  int punctuality;

  @HiveField(5)
  int contributions;

  @HiveField(6)
  int commitment;

  @HiveField(7)
  int attitude;

  @HiveField(8)
  DateTime createdAt;

  EvaluationHiveModel({
    required this.id,
    required this.activityId,
    required this.evaluatorId,
    required this.evaluatedId,
    required this.punctuality,
    required this.contributions,
    required this.commitment,
    required this.attitude,
    required this.createdAt,
  });

  factory EvaluationHiveModel.fromEvaluation(Evaluation evaluation) =>
      EvaluationHiveModel(
        id: evaluation.id,
        activityId: evaluation.activityId,
        evaluatorId: evaluation.evaluatorId,
        evaluatedId: evaluation.evaluatedId,
        punctuality: evaluation.punctuality,
        contributions: evaluation.contributions,
        commitment: evaluation.commitment,
        attitude: evaluation.attitude,
        createdAt: evaluation.createdAt,
      );

  Evaluation toEvaluation() => Evaluation(
        id: id,
        activityId: activityId,
        evaluatorId: evaluatorId,
        evaluatedId: evaluatedId,
        punctuality: punctuality,
        contributions: contributions,
        commitment: commitment,
        attitude: attitude,
        createdAt: createdAt,
      );
}
