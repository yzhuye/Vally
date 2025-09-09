import 'package:vally_app/app/domain/entities/course.dart';

abstract class GroupRepository {
  Future<List<Group>> getGroupsByCategory(String categoryId);
  Future<void> joinGroup(String groupId, String studentName);
}
