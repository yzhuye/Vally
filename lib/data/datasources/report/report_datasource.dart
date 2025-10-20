import 'package:vally_app/domain/entities/report.dart';
import 'package:vally_app/domain/entities/course.dart';

/// Abstract interface for report data sources
/// This allows switching between in-memory and remote implementations
abstract class ReportDataSource {
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

  /// Get categories by course (used in generateReportData)
  Future<List<Category>> getCategoriesByCourse(String courseId);

  /// Get student name by ID (used in student reports)
  Future<String> getStudentName(String studentId);

  /// Get evaluator name by ID (used in detailed results)
  Future<String> getEvaluatorName(String evaluatorId);
}
