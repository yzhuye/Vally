import '../entities/course.dart';

abstract class GroupRepository {
  List<Group> getGroupsByCategory(String courseId, String categoryId);
  List<Group> getGroupsByCourse(String courseId);
  Future<void> addGroup(String courseId, Group group);
  void updateGroup(String courseId, Group group);
  void deleteGroup(String courseId, String groupId);
  bool joinGroup(String courseId, String groupId, String studentEmail);
  Future<void> createGroupsForCategory(
      String courseId, String categoryId, int groupCount, int studentsPerGroup,
      {String? categoryName});
  bool assignStudentToGroup(String courseId, String groupId, String studentEmail);
  bool moveStudentToGroup(String courseId, String fromGroupId, String toGroupId, String studentEmail);
  Group? findStudentGroup(String courseId, String categoryId, String studentEmail);
}
