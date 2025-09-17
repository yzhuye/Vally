import '../../repositories/group_repository.dart';

class DeleteGroup {
  final GroupRepository repository;

  DeleteGroup(this.repository);

  Future<void> call(String courseId, String groupId) async {
    return await repository.deleteGroup(courseId, groupId);
  }
}
