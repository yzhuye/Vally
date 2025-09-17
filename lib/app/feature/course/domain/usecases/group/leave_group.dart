import '../../repositories/group_repository.dart';

class LeaveGroup {
  final GroupRepository repository;

  LeaveGroup(this.repository);

  bool call(String courseId, String groupId, String studentEmail) {
    return repository.leaveGroup(courseId, groupId, studentEmail);
  }
}
