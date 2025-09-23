import '../entities/course.dart';

abstract class ActivityRepository {
  /// Obtiene todas las actividades de una categoría
  List<Activity> getActivitiesByCategory(String categoryId);
  
  /// Obtiene una actividad por su ID
  Activity? getActivityById(String activityId);
  
  /// Crea una nueva actividad
  Future<void> createActivity(Activity activity);
  
  /// Actualiza una actividad existente
  Future<void> updateActivity(Activity activity);
  
  /// Elimina una actividad
  Future<void> deleteActivity(String activityId);
  
  /// Obtiene todas las actividades de un curso
  List<Activity> getActivitiesByCourse(String courseId);
}
