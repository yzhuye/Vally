import '../../entities/course.dart';
import '../../repositories/group_repository.dart';

class GetGroupsByCategory {
  final GroupRepository repository;

  GetGroupsByCategory(this.repository);

  List<Group> call(String courseId, String categoryId) {
    return repository.getGroupsByCategory(courseId, categoryId);
  }
}
