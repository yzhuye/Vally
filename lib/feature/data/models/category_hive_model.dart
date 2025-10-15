import 'package:hive/hive.dart';
import '../../domain/entities/course.dart';
part 'category_hive_model.g.dart';

@HiveType(typeId: 1)
class CategoryHiveModel extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String groupingMethod;
  @HiveField(3)
  int groupCount;
  @HiveField(4)
  int studentsPerGroup;

  @HiveField(5)
  List<String> activityIds;

  CategoryHiveModel({
    required this.id,
    required this.name,
    required this.groupingMethod,
    required this.groupCount,
    required this.studentsPerGroup,
    this.activityIds = const [],
  });

  factory CategoryHiveModel.fromCategory(Category category) =>
      CategoryHiveModel(
        id: category.id,
        name: category.name,
        groupingMethod: category.groupingMethod,
        groupCount: category.groupCount,
        studentsPerGroup: category.studentsPerGroup,
        activityIds: category.activities.map((activity) => activity.id).toList(),
      );

  Category toCategory() => Category(
        id: id,
        name: name,
        groupingMethod: groupingMethod,
        groupCount: groupCount,
        studentsPerGroup: studentsPerGroup,
        // Note: activities list will need to be populated separately from ActivityHiveModel
        // since we only store activity IDs here to avoid circular dependencies
      );
}
