import '../entities/course.dart';

abstract class ActivityRepository {
  Future<List<Activity>> getActivitiesByCategory(String categoryId);
  Activity? getActivityById(String activityId);
  Future<void> createActivity(Activity activity);
  Future<void> updateActivity(Activity activity);
  Future<void> deleteActivity(String activityId);
}
