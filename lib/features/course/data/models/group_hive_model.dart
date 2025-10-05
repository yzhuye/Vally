import 'package:hive/hive.dart';
import '../../domain/entities/course.dart';
part 'group_hive_model.g.dart';

@HiveType(typeId: 3)
class GroupHiveModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  int maxCapacity;

  @HiveField(3)
  List<String> members;

  @HiveField(4)
  String categoryId;

  @HiveField(5)
  String courseId; // Para facilitar las consultas

  GroupHiveModel({
    required this.id,
    required this.name,
    required this.maxCapacity,
    required this.members,
    required this.categoryId,
    required this.courseId,
  });

  factory GroupHiveModel.fromGroup(Group group, String courseId) =>
      GroupHiveModel(
        id: group.id,
        name: group.name,
        maxCapacity: group.maxCapacity,
        members: List<String>.from(group.members),
        categoryId: group.categoryId,
        courseId: courseId,
      );

  Group toGroup() => Group(
        id: id,
        name: name,
        maxCapacity: maxCapacity,
        members: List<String>.from(members),
        categoryId: categoryId,
      );
}
