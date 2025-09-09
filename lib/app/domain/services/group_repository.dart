import '../entities/course.dart';

abstract class GroupRepository {
  Future<List<Group>> getGroupsByCategory(String categoryId);
  Future<void> joinGroup(String groupId, String studentName);
}
