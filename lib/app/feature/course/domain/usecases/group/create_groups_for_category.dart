import '../../repositories/group_repository.dart';

class CreateGroupsForCategory {
  final GroupRepository repository;

  CreateGroupsForCategory(this.repository);

  Future<void> call(
    String courseId,
    String categoryId,
    int groupCount,
    int studentsPerGroup, {
    String? categoryName,
  }) async {
    return await repository.createGroupsForCategory(
      courseId,
      categoryId,
      groupCount,
      studentsPerGroup,
      categoryName: categoryName,
    );
  }
}
