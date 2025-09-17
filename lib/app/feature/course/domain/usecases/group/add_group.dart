import '../../entities/course.dart';
import '../../repositories/group_repository.dart';

class AddGroup {
  final GroupRepository repository;

  AddGroup(this.repository);

  Future<void> call(String courseId, Group group) async {
    return await repository.addGroup(courseId, group);
  }
}
