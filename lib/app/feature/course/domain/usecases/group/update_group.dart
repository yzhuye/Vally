import '../../entities/course.dart';
import '../../repositories/group_repository.dart';

class UpdateGroup {
  final GroupRepository repository;

  UpdateGroup(this.repository);

  Future<void> call(String courseId, Group group) async {
    return await repository.updateGroup(courseId, group);
  }
}
