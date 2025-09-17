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

  CategoryHiveModel({
    required this.id,
    required this.name,
    required this.groupingMethod,
    required this.groupCount,
    required this.studentsPerGroup,
  });

  factory CategoryHiveModel.fromCategory(Category category) =>
      CategoryHiveModel(
        id: category.id,
        name: category.name,
        groupingMethod: category.groupingMethod,
        groupCount: category.groupCount,
        studentsPerGroup: category.studentsPerGroup,
      );

  Category toCategory() => Category(
        id: id,
        name: name,
        groupingMethod: groupingMethod,
        groupCount: groupCount,
        studentsPerGroup: studentsPerGroup,
      );
}
