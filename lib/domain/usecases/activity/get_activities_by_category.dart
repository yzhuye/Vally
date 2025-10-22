import '../../entities/course.dart';
import '../../repositories/activity_repository.dart';

class GetActivitiesByCategoryUseCase {
  final ActivityRepository _repository;

  GetActivitiesByCategoryUseCase(this._repository);

  Future<GetActivitiesResult> call({required String categoryId}) async {
    try {
      // Await the Future to get the actual List<Activity>
      final activities = await _repository.getActivitiesByCategory(categoryId);

      // Ordenar por fecha de vencimiento (más próximas primero)
      activities.sort((a, b) => a.dueDate.compareTo(b.dueDate));

      return GetActivitiesResult.success(activities);
    } catch (e) {
      return GetActivitiesResult.failure('Error al obtener actividades: $e');
    }
  }
}

class GetActivitiesResult {
  final bool isSuccess;
  final String? message;
  final List<Activity> activities;

  const GetActivitiesResult._({
    required this.isSuccess,
    this.message,
    required this.activities,
  });

  factory GetActivitiesResult.success(List<Activity> activities) =>
      GetActivitiesResult._(isSuccess: true, activities: activities);

  factory GetActivitiesResult.failure(String message) =>
      GetActivitiesResult._(isSuccess: false, message: message, activities: []);
}
