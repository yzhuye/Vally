import '../../entities/course.dart';
import '../../repositories/activity_repository.dart';

class GetActivityByIdUseCase {
  final ActivityRepository _repository;

  GetActivityByIdUseCase(this._repository);

  GetActivityByIdResult call({required String activityId}) {
    try {
      final activity = _repository.getActivityById(activityId);
      
      if (activity == null) {
        return GetActivityByIdResult.failure('Actividad no encontrada.');
      }
      
      return GetActivityByIdResult.success(activity);
    } catch (e) {
      return GetActivityByIdResult.failure('Error al obtener actividad: $e');
    }
  }
}

class GetActivityByIdResult {
  final bool isSuccess;
  final String? message;
  final Activity? activity;

  const GetActivityByIdResult._({
    required this.isSuccess,
    this.message,
    this.activity,
  });

  factory GetActivityByIdResult.success(Activity activity) =>
      GetActivityByIdResult._(
          isSuccess: true, activity: activity);

  factory GetActivityByIdResult.failure(String message) =>
      GetActivityByIdResult._(
          isSuccess: false, message: message);
}
