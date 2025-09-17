import '../../entities/course.dart';
import '../../repositories/group_repository.dart';

class GetGroupsByCourse {
  final GroupRepository repository;

  GetGroupsByCourse(this.repository);

  List<Group> call(String courseId) {
    return repository.getGroupsByCourse(courseId);
  }
}
