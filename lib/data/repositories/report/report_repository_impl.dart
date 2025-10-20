import 'package:vally_app/domain/repositories/report_repository.dart';
import 'package:vally_app/domain/entities/report.dart';
import 'package:vally_app/domain/entities/course.dart';
import 'package:vally_app/data/datasources/report/report_datasource.dart';
import 'package:vally_app/data/datasources/in-memory/report/report_datasource_in_memory.dart';
import 'package:vally_app/data/datasources/remote/report/report_datasource_remote.dart';

/// Enum to define the available data source types
enum ReportDataSourceType {
  inMemory,
  remote,
}

/// Implementation wrapper that uses the data source pattern
/// This maintains backward compatibility while allowing easy switching between data sources
class ReportRepositoryImpl implements ReportRepository {
  late final ReportDataSource _dataSource;

  ReportRepositoryImpl({
    ReportDataSourceType dataSourceType = ReportDataSourceType.inMemory,
  }) {
    _dataSource = _createDataSource(dataSourceType);
  }

  /// Factory method to create data source instances
  static ReportDataSource _createDataSource(
      ReportDataSourceType dataSourceType) {
    switch (dataSourceType) {
      case ReportDataSourceType.inMemory:
        return ReportDataSourceInMemory();
      case ReportDataSourceType.remote:
        return ReportDataSourceRemote();
    }
  }

  /// Creates an in-memory report repository instance
  static ReportRepositoryImpl createInMemory() {
    return ReportRepositoryImpl(dataSourceType: ReportDataSourceType.inMemory);
  }

  /// Creates a remote report repository instance
  static ReportRepositoryImpl createRemote() {
    return ReportRepositoryImpl(dataSourceType: ReportDataSourceType.remote);
  }

  /// Creates a report repository with the specified data source type
  static ReportRepositoryImpl create({
    ReportDataSourceType dataSourceType = ReportDataSourceType.inMemory,
  }) {
    return ReportRepositoryImpl(dataSourceType: dataSourceType);
  }

  @override
  Future<ReportData> generateReportData({
    required String courseId,
    required String categoryId,
  }) async {
    return _dataSource.generateReportData(
      courseId: courseId,
      categoryId: categoryId,
    );
  }

  @override
  Future<ActivityAverageReport> getActivityAverageReport({
    required String courseId,
    required String categoryId,
  }) async {
    return _dataSource.getActivityAverageReport(
      courseId: courseId,
      categoryId: categoryId,
    );
  }

  @override
  Future<List<GroupAverageReport>> getGroupAverageReports({
    required String courseId,
    required String categoryId,
  }) async {
    return _dataSource.getGroupAverageReports(
      courseId: courseId,
      categoryId: categoryId,
    );
  }

  @override
  Future<List<StudentAverageReport>> getStudentAverageReports({
    required String courseId,
    required String categoryId,
  }) async {
    return _dataSource.getStudentAverageReports(
      courseId: courseId,
      categoryId: categoryId,
    );
  }

  @override
  Future<List<DetailedResultReport>> getDetailedResultReports({
    required String courseId,
    required String categoryId,
  }) async {
    return _dataSource.getDetailedResultReports(
      courseId: courseId,
      categoryId: categoryId,
    );
  }

  @override
  Future<List<Evaluation>> getEvaluationsByCategory({
    required String categoryId,
  }) async {
    return _dataSource.getEvaluationsByCategory(categoryId: categoryId);
  }

  @override
  Future<List<Activity>> getActivitiesByCategory({
    required String categoryId,
  }) async {
    return _dataSource.getActivitiesByCategory(categoryId: categoryId);
  }

  @override
  Future<List<Group>> getGroupsByCategory({
    required String courseId,
    required String categoryId,
  }) async {
    return _dataSource.getGroupsByCategory(
      courseId: courseId,
      categoryId: categoryId,
    );
  }
}

/// Configuration class for report repository
/// This can be used to store configuration and easily switch data sources
class ReportRepositoryConfig {
  static ReportDataSourceType _dataSourceType = ReportDataSourceType.inMemory;

  /// Get the current data source type
  static ReportDataSourceType get dataSourceType => _dataSourceType;

  /// Set the data source type
  static void setDataSourceType(ReportDataSourceType type) {
    _dataSourceType = type;
  }

  /// Create a report repository with the current configuration
  static ReportRepositoryImpl createRepository() {
    return ReportRepositoryImpl(dataSourceType: _dataSourceType);
  }

  /// Switch to in-memory data source
  static void useInMemory() {
    setDataSourceType(ReportDataSourceType.inMemory);
  }

  /// Switch to remote data source
  static void useRemote() {
    setDataSourceType(ReportDataSourceType.remote);
  }
}
