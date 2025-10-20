import 'package:vally_app/domain/entities/course.dart';
import 'package:vally_app/domain/repositories/evaluation_repository.dart';
import 'package:vally_app/data/datasources/evaluation/evaluation_datasource.dart';
import 'package:vally_app/data/datasources/in-memory/evaluation/evaluation_datasource_in_memory.dart';
import 'package:vally_app/data/datasources/remote/evaluation/evaluation_datasource_remote.dart';

/// Enum to define the available data source types
enum EvaluationDataSourceType {
  inMemory,
  remote,
}

/// Implementation wrapper that uses the data source pattern
/// This maintains backward compatibility while allowing easy switching between data sources
class EvaluationRepositoryImpl implements EvaluationRepository {
  late final EvaluationDataSource _dataSource;

  EvaluationRepositoryImpl({
    EvaluationDataSourceType dataSourceType = EvaluationDataSourceType.inMemory,
  }) {
    _dataSource = _createDataSource(dataSourceType);
  }

  /// Factory method to create data source instances
  static EvaluationDataSource _createDataSource(
      EvaluationDataSourceType dataSourceType) {
    switch (dataSourceType) {
      case EvaluationDataSourceType.inMemory:
        return EvaluationDataSourceInMemory();
      case EvaluationDataSourceType.remote:
        return EvaluationDataSourceRemote();
    }
  }

  /// Creates an in-memory evaluation repository instance
  static EvaluationRepositoryImpl createInMemory() {
    return EvaluationRepositoryImpl(
        dataSourceType: EvaluationDataSourceType.inMemory);
  }

  /// Creates a remote evaluation repository instance
  static EvaluationRepositoryImpl createRemote() {
    return EvaluationRepositoryImpl(
        dataSourceType: EvaluationDataSourceType.remote);
  }

  /// Creates an evaluation repository with the specified data source type
  static EvaluationRepositoryImpl create({
    EvaluationDataSourceType dataSourceType = EvaluationDataSourceType.inMemory,
  }) {
    return EvaluationRepositoryImpl(dataSourceType: dataSourceType);
  }

  @override
  Future<void> createEvaluation(Evaluation evaluation) async {
    return _dataSource.createEvaluation(evaluation);
  }

  @override
  List<Evaluation> getEvaluationsByActivity(String activityId) {
    return _dataSource.getEvaluationsByActivity(activityId);
  }

  @override
  List<Evaluation> getEvaluationsByEvaluator(String evaluatorId) {
    return _dataSource.getEvaluationsByEvaluator(evaluatorId);
  }

  @override
  List<Evaluation> getEvaluationsForStudent(String studentId) {
    return _dataSource.getEvaluationsForStudent(studentId);
  }

  @override
  Evaluation? getEvaluationById(String evaluationId) {
    return _dataSource.getEvaluationById(evaluationId);
  }

  @override
  Future<void> updateEvaluation(Evaluation evaluation) async {
    return _dataSource.updateEvaluation(evaluation);
  }

  @override
  Future<void> deleteEvaluation(String evaluationId) async {
    return _dataSource.deleteEvaluation(evaluationId);
  }

  @override
  bool hasEvaluated(String activityId, String evaluatorId, String evaluatedId) {
    return _dataSource.hasEvaluated(activityId, evaluatorId, evaluatedId);
  }

  @override
  double getAverageRatingForStudent(String activityId, String studentId) {
    return _dataSource.getAverageRatingForStudent(activityId, studentId);
  }

  @override
  Map<String, dynamic> getActivityEvaluationStats(String activityId) {
    return _dataSource.getActivityEvaluationStats(activityId);
  }
}

/// Configuration class for evaluation repository
/// This can be used to store configuration and easily switch data sources
class EvaluationRepositoryConfig {
  static EvaluationDataSourceType _dataSourceType =
      EvaluationDataSourceType.inMemory;

  /// Get the current data source type
  static EvaluationDataSourceType get dataSourceType => _dataSourceType;

  /// Set the data source type
  static void setDataSourceType(EvaluationDataSourceType type) {
    _dataSourceType = type;
  }

  /// Create an evaluation repository with the current configuration
  static EvaluationRepositoryImpl createRepository() {
    return EvaluationRepositoryImpl(dataSourceType: _dataSourceType);
  }

  /// Switch to in-memory data source
  static void useInMemory() {
    setDataSourceType(EvaluationDataSourceType.inMemory);
  }

  /// Switch to remote data source
  static void useRemote() {
    setDataSourceType(EvaluationDataSourceType.remote);
  }
}
