import '../../entities/course.dart';
import '../../../data/repositories/group/group_repository_impl.dart';

class GetGroupsByCategory {
  final GroupRepository repository;

  GetGroupsByCategory(this.repository);

  Future<List<Group>> call(String categoryId) {
    return repository.getGroupsByCategory(categoryId);
  }
}
