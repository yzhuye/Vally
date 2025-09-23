import 'package:hive/hive.dart';
import '../../domain/entities/course.dart';
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
  int metric1;

  @HiveField(5)
  int metric2;

  @HiveField(6)
  int metric3;

  @HiveField(7)
  int metric4;

  @HiveField(8)
  int metric5;

  @HiveField(9)
  String? comments;

  @HiveField(10)
  DateTime createdAt;

  EvaluationHiveModel({
    required this.id,
    required this.activityId,
    required this.evaluatorId,
    required this.evaluatedId,
    required this.metric1,
    required this.metric2,
    required this.metric3,
    required this.metric4,
    required this.metric5,
    this.comments,
    required this.createdAt,
  });

  factory EvaluationHiveModel.fromEvaluation(Evaluation evaluation) =>
      EvaluationHiveModel(
        id: evaluation.id,
        activityId: evaluation.activityId,
        evaluatorId: evaluation.evaluatorId,
        evaluatedId: evaluation.evaluatedId,
        metric1: evaluation.metric1,
        metric2: evaluation.metric2,
        metric3: evaluation.metric3,
        metric4: evaluation.metric4,
        metric5: evaluation.metric5,
        comments: evaluation.comments,
        createdAt: evaluation.createdAt,
      );

  Evaluation toEvaluation() => Evaluation(
        id: id,
        activityId: activityId,
        evaluatorId: evaluatorId,
        evaluatedId: evaluatedId,
        metric1: metric1,
        metric2: metric2,
        metric3: metric3,
        metric4: metric4,
        metric5: metric5,
        comments: comments,
        createdAt: createdAt,
      );
}
