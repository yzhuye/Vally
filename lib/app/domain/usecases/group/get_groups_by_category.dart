import '../../entities/course.dart';
import '../../repositories/group_repository.dart';

class GetGroupsByCategoryUseCase {
  final GroupRepository _repository;

  GetGroupsByCategoryUseCase(this._repository);

  List<Group> call({
    required String courseId,
    required String categoryId,
  }) {
    return _repository.getGroupsByCategory(courseId, categoryId);
  }
}
