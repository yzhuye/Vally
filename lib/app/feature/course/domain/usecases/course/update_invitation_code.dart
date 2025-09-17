import '../../entities/course.dart';
import '../../repositories/course_repository.dart';

class UpdateInvitationCode {
  final CourseRepository repository;

  UpdateInvitationCode(this.repository);

  Future<Course> call(String courseId) async {
    return await repository.updateInvitationCode(courseId);
  }
}
