import '../entities/course.dart';

abstract class ActivityRepository {
  Future<List<Activity>> getActivitiesByCategory(String categoryId);
  Future<Activity?> getActivityById(String activityId);
  Future<Activity?> createActivity(String name, String description, DateTime dueDate, String categoryId);
  Future<Activity?> updateActivity(Activity activity, String name, String description, DateTime dueDate);
  Future<void> deleteActivity(String activityId);
}
