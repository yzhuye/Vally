import '../../entities/course.dart';
import '../../services/group_repository.dart';

class GetGroupsByCategory {
  final GroupRepository repository;

  GetGroupsByCategory(this.repository);

  Future<List<Group>> call(String categoryId) {
    return repository.getGroupsByCategory(categoryId);
  }
}
