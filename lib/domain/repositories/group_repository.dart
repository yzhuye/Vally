import '../entities/course.dart';

abstract class GroupRepository {
  Future<List<Group>> getGroupsByCategory(String categoryId);
  Future<Group?> addGroup(String name, int maxCapacity, String categoryId);
  Future<bool> joinGroup({
    required String userId,
    required String groupId,
  });
  Future<bool> leaveGroup({
    required String userId,
    required String groupId,
  });
  Future<void> createGroupsForCategory(String categoryId, int groupCount,
      int studentsPerGroup, String? categoryName);
  Future<bool> assignStudentToGroup(String userId, String newGroupId);
  Future<Group?> findStudentGroup(String categoryId, String studentId);
}