import 'package:hive/hive.dart';
import '../../../domain/entities/course.dart';
import '../../../domain/repositories/activity_repository.dart';
import '../../models/activity_hive_model.dart';

class ActivityRepositoryImpl implements ActivityRepository {
  Box<ActivityHiveModel> get _activityBox => Hive.box<ActivityHiveModel>('activities');

  @override
  List<Activity> getActivitiesByCategory(String categoryId) {
    try {
      return _activityBox.values
          .where((activityHive) => activityHive.categoryId == categoryId)
          .map((activityHive) => activityHive.toActivity())
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Activity? getActivityById(String activityId) {
    try {
      final activityHive = _activityBox.get(activityId);
      return activityHive?.toActivity();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> createActivity(Activity activity) async {
    try {
      final activityHive = ActivityHiveModel.fromActivity(activity);
      await _activityBox.put(activity.id, activityHive);
    } catch (e) {
      throw Exception('Error al crear actividad: $e');
    }
  }

  @override
  Future<void> updateActivity(Activity activity) async {
    try {
      final activityHive = ActivityHiveModel.fromActivity(activity);
      await _activityBox.put(activity.id, activityHive);
    } catch (e) {
      throw Exception('Error al actualizar actividad: $e');
    }
  }

  @override
  Future<void> deleteActivity(String activityId) async {
    try {
      await _activityBox.delete(activityId);
    } catch (e) {
      throw Exception('Error al eliminar actividad: $e');
    }
  }

  @override
  List<Activity> getActivitiesByCourse(String courseId) {
    try {
      // Para obtener actividades por curso, necesitamos obtener todas las categorías del curso
      // y luego sus actividades. Por simplicidad, retornamos todas las actividades por ahora.
      return _activityBox.values
          .map((activityHive) => activityHive.toActivity())
          .toList();
    } catch (e) {
      return [];
    }
  }
}
