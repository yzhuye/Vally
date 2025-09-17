import '../../repositories/group_repository.dart';

class JoinGroup {
  final GroupRepository repository;

  JoinGroup(this.repository);

  bool call(String courseId, String groupId, String studentEmail) {
    return repository.joinGroup(courseId, groupId, studentEmail);
  }
}
