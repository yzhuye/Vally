import '../entities/course.dart';

abstract class ActivityRepository {
  Future<List<Activity>> getActivitiesByCategory(String categoryId);
  Activity? getActivityById(String activityId);
  Future<Activity?> createActivity(String name, String description, DateTime dueDate, String categoryId);
  Future<void> updateActivity(Activity activity);
  Future<void> deleteActivity(String activityId);
}
