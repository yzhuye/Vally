import '../entities/report.dart';
import '../entities/course.dart';

abstract class ReportRepository {
  /// Generate comprehensive report data for a specific category
  Future<ReportData> generateReportData({
    required String courseId,
    required String categoryId,
  });

  /// Get activity averages across all groups in a category
  Future<ActivityAverageReport> getActivityAverageReport({
    required String courseId,
    required String categoryId,
  });

  /// Get group averages across all activities in a category
  Future<List<GroupAverageReport>> getGroupAverageReports({
    required String courseId,
    required String categoryId,
  });

  /// Get student averages across all activities in a category
  Future<List<StudentAverageReport>> getStudentAverageReports({
    required String courseId,
    required String categoryId,
  });

  /// Get detailed results per group > student > criteria score
  Future<List<DetailedResultReport>> getDetailedResultReports({
    required String courseId,
    required String categoryId,
  });

  /// Get all evaluations for a specific category
  Future<List<Evaluation>> getEvaluationsByCategory({
    required String categoryId,
  });

  /// Get all activities for a specific category
  Future<List<Activity>> getActivitiesByCategory({
    required String categoryId,
  });

  /// Get all groups for a specific category
  Future<List<Group>> getGroupsByCategory({
    required String courseId,
    required String categoryId,
  });
}
