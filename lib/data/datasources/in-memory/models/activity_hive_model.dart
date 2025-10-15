import 'package:hive/hive.dart';
import '../../../../domain/entities/course.dart';
part 'activity_hive_model.g.dart';

@HiveType(typeId: 4)
class ActivityHiveModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String description;

  @HiveField(3)
  DateTime dueDate;

  @HiveField(4)
  String categoryId;

  ActivityHiveModel({
    required this.id,
    required this.name,
    required this.description,
    required this.dueDate,
    required this.categoryId,
  });

  factory ActivityHiveModel.fromActivity(Activity activity) =>
      ActivityHiveModel(
        id: activity.id,
        name: activity.name,
        description: activity.description,
        dueDate: activity.dueDate,
        categoryId: activity.categoryId,
      );

  Activity toActivity() => Activity(
        id: id,
        name: name,
        description: description,
        dueDate: dueDate,
        categoryId: categoryId,
      );
}
