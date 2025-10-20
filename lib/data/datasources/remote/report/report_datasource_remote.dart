import 'package:vally_app/domain/entities/course.dart';
import 'package:vally_app/domain/entities/report.dart';
import 'package:vally_app/data/datasources/report/report_datasource.dart';

/// Remote implementation of the report data source
/// This is a placeholder for future API integration
/// TODO: Implement actual API calls when backend is ready
class ReportDataSourceRemote implements ReportDataSource {
  // TODO: Add API service dependencies when available
  // late final ReportApiService _reportApiService;
  // late final UserApiService _userApiService;

  ReportDataSourceRemote() {
    // TODO: Initialize API services when available
    // _reportApiService = ReportApiService();
    // _userApiService = UserApiService();
  }

  @override
  Future<ReportData> generateReportData({
    required String courseId,
    required String categoryId,
  }) async {
    // TODO: Implement API call to generate report data
    // return await _reportApiService.generateReportData(courseId, categoryId);

    throw UnimplementedError('Remote implementation not yet available. '
        'This will be implemented when the backend API is ready.');
  }

  @override
  Future<ActivityAverageReport> getActivityAverageReport({
    required String courseId,
    required String categoryId,
  }) async {
    // TODO: Implement API call to get activity average report
    // return await _reportApiService.getActivityAverageReport(courseId, categoryId);

    throw UnimplementedError('Remote implementation not yet available. '
        'This will be implemented when the backend API is ready.');
  }

  @override
  Future<List<GroupAverageReport>> getGroupAverageReports({
    required String courseId,
    required String categoryId,
  }) async {
    // TODO: Implement API call to get group average reports
    // return await _reportApiService.getGroupAverageReports(courseId, categoryId);

    throw UnimplementedError('Remote implementation not yet available. '
        'This will be implemented when the backend API is ready.');
  }

  @override
  Future<List<StudentAverageReport>> getStudentAverageReports({
    required String courseId,
    required String categoryId,
  }) async {
    // TODO: Implement API call to get student average reports
    // return await _reportApiService.getStudentAverageReports(courseId, categoryId);

    throw UnimplementedError('Remote implementation not yet available. '
        'This will be implemented when the backend API is ready.');
  }

  @override
  Future<List<DetailedResultReport>> getDetailedResultReports({
    required String courseId,
    required String categoryId,
  }) async {
    // TODO: Implement API call to get detailed result reports
    // return await _reportApiService.getDetailedResultReports(courseId, categoryId);

    throw UnimplementedError('Remote implementation not yet available. '
        'This will be implemented when the backend API is ready.');
  }

  @override
  Future<List<Evaluation>> getEvaluationsByCategory({
    required String categoryId,
  }) async {
    // TODO: Implement API call to get evaluations by category
    // return await _reportApiService.getEvaluationsByCategory(categoryId);

    throw UnimplementedError('Remote implementation not yet available. '
        'This will be implemented when the backend API is ready.');
  }

  @override
  Future<List<Activity>> getActivitiesByCategory({
    required String categoryId,
  }) async {
    // TODO: Implement API call to get activities by category
    // return await _reportApiService.getActivitiesByCategory(categoryId);

    throw UnimplementedError('Remote implementation not yet available. '
        'This will be implemented when the backend API is ready.');
  }

  @override
  Future<List<Group>> getGroupsByCategory({
    required String courseId,
    required String categoryId,
  }) async {
    // TODO: Implement API call to get groups by category
    // return await _reportApiService.getGroupsByCategory(courseId, categoryId);

    throw UnimplementedError('Remote implementation not yet available. '
        'This will be implemented when the backend API is ready.');
  }

  @override
  Future<List<Category>> getCategoriesByCourse(String courseId) async {
    // TODO: Implement API call to get categories by course
    // return await _reportApiService.getCategoriesByCourse(courseId);

    throw UnimplementedError('Remote implementation not yet available. '
        'This will be implemented when the backend API is ready.');
  }

  @override
  Future<String> getStudentName(String studentId) async {
    // TODO: Implement API call to get student name
    // return await _userApiService.getStudentName(studentId);

    throw UnimplementedError('Remote implementation not yet available. '
        'This will be implemented when the backend API is ready.');
  }

  @override
  Future<String> getEvaluatorName(String evaluatorId) async {
    // TODO: Implement API call to get evaluator name
    // return await _userApiService.getEvaluatorName(evaluatorId);

    throw UnimplementedError('Remote implementation not yet available. '
        'This will be implemented when the backend API is ready.');
  }
}
