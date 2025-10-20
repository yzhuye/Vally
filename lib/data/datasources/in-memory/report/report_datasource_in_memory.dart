import 'package:vally_app/domain/entities/report.dart';
import 'package:vally_app/domain/entities/course.dart';
import 'package:vally_app/data/datasources/report/report_datasource.dart';
import 'package:vally_app/data/repositories/activity/activity_repository_impl.dart';
import 'package:vally_app/data/repositories/evaluation/evaluation_repository_impl.dart';
import 'package:vally_app/data/repositories/group/group_repository_impl.dart';
import 'package:vally_app/data/repositories/course/category_repository_imp.dart';

/// In-memory implementation of the report data source
/// Uses local data sources and repositories for data access
class ReportDataSourceInMemory implements ReportDataSource {
  late final ActivityRepositoryImpl _activityRepository;
  late final EvaluationRepositoryImpl _evaluationRepository;
  late final GroupRepositoryImpl _groupRepository;
  late final CategoryRepositoryImpl _categoryRepository;

  ReportDataSourceInMemory() {
    _activityRepository = ActivityRepositoryImpl();
    _evaluationRepository = EvaluationRepositoryImpl();
    _groupRepository = GroupRepositoryImpl();
    _categoryRepository = CategoryRepositoryImpl();
  }

  @override
  Future<ReportData> generateReportData({
    required String courseId,
    required String categoryId,
  }) async {
    // Get category name
    final categories = await getCategoriesByCourse(courseId);
    final category = categories.firstWhere((c) => c.id == categoryId);

    // Generate all report components
    final activityAverage = await getActivityAverageReport(
        courseId: courseId, categoryId: categoryId);
    final groupAverages = await getGroupAverageReports(
        courseId: courseId, categoryId: categoryId);
    final studentAverages = await getStudentAverageReports(
        courseId: courseId, categoryId: categoryId);
    final detailedResults = await getDetailedResultReports(
        courseId: courseId, categoryId: categoryId);

    return ReportData(
      categoryId: categoryId,
      categoryName: category.name,
      activityAverage: activityAverage,
      groupAverages: groupAverages,
      studentAverages: studentAverages,
      detailedResults: detailedResults,
    );
  }

  @override
  Future<ActivityAverageReport> getActivityAverageReport({
    required String courseId,
    required String categoryId,
  }) async {
    final evaluations = await getEvaluationsByCategory(categoryId: categoryId);
    final activities = await getActivitiesByCategory(categoryId: categoryId);

    if (evaluations.isEmpty) {
      return ActivityAverageReport(
        overallAverage: 0.0,
        punctualityAverage: 0.0,
        contributionsAverage: 0.0,
        commitmentAverage: 0.0,
        attitudeAverage: 0.0,
        totalActivities: activities.length,
        totalEvaluations: 0,
      );
    }

    final punctualitySum =
        evaluations.fold<double>(0, (sum, e) => sum + e.punctuality);
    final contributionsSum =
        evaluations.fold<double>(0, (sum, e) => sum + e.contributions);
    final commitmentSum =
        evaluations.fold<double>(0, (sum, e) => sum + e.commitment);
    final attitudeSum =
        evaluations.fold<double>(0, (sum, e) => sum + e.attitude);
    final totalScoreSum =
        punctualitySum + contributionsSum + commitmentSum + attitudeSum;

    final evaluationCount = evaluations.length.toDouble();

    return ActivityAverageReport(
      overallAverage: totalScoreSum / (evaluationCount * 4), // 4 criteria
      punctualityAverage: punctualitySum / evaluationCount,
      contributionsAverage: contributionsSum / evaluationCount,
      commitmentAverage: commitmentSum / evaluationCount,
      attitudeAverage: attitudeSum / evaluationCount,
      totalActivities: activities.length,
      totalEvaluations: evaluations.length,
    );
  }

  @override
  Future<List<GroupAverageReport>> getGroupAverageReports({
    required String courseId,
    required String categoryId,
  }) async {
    final groups =
        await getGroupsByCategory(courseId: courseId, categoryId: categoryId);
    final evaluations = await getEvaluationsByCategory(categoryId: categoryId);

    return groups.map((group) {
      final groupEvaluations = evaluations
          .where((e) => group.members.contains(e.evaluatedId))
          .toList();

      if (groupEvaluations.isEmpty) {
        return GroupAverageReport(
          groupId: group.id,
          groupName: group.name,
          overallAverage: 0.0,
          punctualityAverage: 0.0,
          contributionsAverage: 0.0,
          commitmentAverage: 0.0,
          attitudeAverage: 0.0,
          totalStudents: group.members.length,
          totalEvaluations: 0,
        );
      }

      final punctualitySum =
          groupEvaluations.fold<double>(0, (sum, e) => sum + e.punctuality);
      final contributionsSum =
          groupEvaluations.fold<double>(0, (sum, e) => sum + e.contributions);
      final commitmentSum =
          groupEvaluations.fold<double>(0, (sum, e) => sum + e.commitment);
      final attitudeSum =
          groupEvaluations.fold<double>(0, (sum, e) => sum + e.attitude);
      final totalScoreSum =
          punctualitySum + contributionsSum + commitmentSum + attitudeSum;

      final evaluationCount = groupEvaluations.length.toDouble();

      return GroupAverageReport(
        groupId: group.id,
        groupName: group.name,
        overallAverage: totalScoreSum / (evaluationCount * 4),
        punctualityAverage: punctualitySum / evaluationCount,
        contributionsAverage: contributionsSum / evaluationCount,
        commitmentAverage: commitmentSum / evaluationCount,
        attitudeAverage: attitudeSum / evaluationCount,
        totalStudents: group.members.length,
        totalEvaluations: groupEvaluations.length,
      );
    }).toList();
  }

  @override
  Future<List<StudentAverageReport>> getStudentAverageReports({
    required String courseId,
    required String categoryId,
  }) async {
    final groups =
        await getGroupsByCategory(courseId: courseId, categoryId: categoryId);
    final evaluations = await getEvaluationsByCategory(categoryId: categoryId);

    final studentReports = <StudentAverageReport>[];

    for (final group in groups) {
      for (final studentId in group.members) {
        final studentEvaluations =
            evaluations.where((e) => e.evaluatedId == studentId).toList();

        if (studentEvaluations.isEmpty) continue;

        final punctualitySum =
            studentEvaluations.fold<double>(0, (sum, e) => sum + e.punctuality);
        final contributionsSum = studentEvaluations.fold<double>(
            0, (sum, e) => sum + e.contributions);
        final commitmentSum =
            studentEvaluations.fold<double>(0, (sum, e) => sum + e.commitment);
        final attitudeSum =
            studentEvaluations.fold<double>(0, (sum, e) => sum + e.attitude);
        final totalScoreSum =
            punctualitySum + contributionsSum + commitmentSum + attitudeSum;

        final evaluationCount = studentEvaluations.length.toDouble();

        studentReports.add(StudentAverageReport(
          studentId: studentId,
          studentName: await getStudentName(studentId),
          overallAverage: totalScoreSum / (evaluationCount * 4),
          punctualityAverage: punctualitySum / evaluationCount,
          contributionsAverage: contributionsSum / evaluationCount,
          commitmentAverage: commitmentSum / evaluationCount,
          attitudeAverage: attitudeSum / evaluationCount,
          groupId: group.id,
          groupName: group.name,
          totalEvaluations: studentEvaluations.length,
        ));
      }
    }

    return studentReports;
  }

  @override
  Future<List<DetailedResultReport>> getDetailedResultReports({
    required String courseId,
    required String categoryId,
  }) async {
    final groups =
        await getGroupsByCategory(courseId: courseId, categoryId: categoryId);
    final evaluations = await getEvaluationsByCategory(categoryId: categoryId);
    final activities = await getActivitiesByCategory(categoryId: categoryId);

    return groups.map((group) {
      final students = <StudentDetailedResult>[];

      for (final studentId in group.members) {
        final studentEvaluations =
            evaluations.where((e) => e.evaluatedId == studentId).toList();

        if (studentEvaluations.isEmpty) continue;

        final criteriaScores = [
          _createCriteriaScore('Puntualidad', studentEvaluations,
              (e) => e.punctuality, activities),
          _createCriteriaScore('Contribuciones', studentEvaluations,
              (e) => e.contributions, activities),
          _createCriteriaScore('Compromiso', studentEvaluations,
              (e) => e.commitment, activities),
          _createCriteriaScore(
              'Actitud', studentEvaluations, (e) => e.attitude, activities),
        ];

        final overallAverage =
            criteriaScores.fold<double>(0, (sum, c) => sum + c.averageScore) /
                criteriaScores.length;

        students.add(StudentDetailedResult(
          studentId: studentId,
          studentName: studentId, // Using ID as placeholder for now
          criteriaScores: criteriaScores,
          overallAverage: overallAverage,
        ));
      }

      return DetailedResultReport(
        groupId: group.id,
        groupName: group.name,
        students: students,
      );
    }).toList();
  }

  @override
  Future<List<Evaluation>> getEvaluationsByCategory({
    required String categoryId,
  }) async {
    final activities = await getActivitiesByCategory(categoryId: categoryId);
    final allEvaluations = <Evaluation>[];

    for (final activity in activities) {
      final evaluations =
          _evaluationRepository.getEvaluationsByActivity(activity.id);
      allEvaluations.addAll(evaluations);
    }

    return allEvaluations;
  }

  @override
  Future<List<Activity>> getActivitiesByCategory({
    required String categoryId,
  }) async {
    return _activityRepository.getActivitiesByCategory(categoryId);
  }

  @override
  Future<List<Group>> getGroupsByCategory({
    required String courseId,
    required String categoryId,
  }) async {
    return _groupRepository.getGroupsByCategory(categoryId);
  }

  @override
  Future<List<Category>> getCategoriesByCourse(String courseId) async {
    return _categoryRepository.getCategoriesByCourse(courseId);
  }

  @override
  Future<String> getStudentName(String studentId) async {
    // TODO: Implement student name retrieval from user repository
    // For now, return the student ID as placeholder
    return studentId;
  }

  @override
  Future<String> getEvaluatorName(String evaluatorId) async {
    // TODO: Implement evaluator name retrieval from user repository
    // For now, return the evaluator ID as placeholder
    return evaluatorId;
  }

  /// Helper method to create criteria score with proper name resolution
  CriteriaScore _createCriteriaScore(
    String criteriaName,
    List<Evaluation> evaluations,
    int Function(Evaluation) scoreExtractor,
    List<Activity> activities,
  ) {
    if (evaluations.isEmpty) {
      return CriteriaScore(
        criteriaName: criteriaName,
        averageScore: 0.0,
        totalEvaluations: 0,
        individualEvaluations: [],
      );
    }

    final individualEvaluations = evaluations.map((e) {
      final activity = activities.firstWhere((a) => a.id == e.activityId);
      return IndividualEvaluation(
        evaluatorId: e.evaluatorId,
        evaluatorName: e.evaluatorId, // Using ID as placeholder for now
        score: scoreExtractor(e),
        createdAt: e.createdAt,
        activityId: e.activityId,
        activityName: activity.name,
      );
    }).toList();

    final averageScore =
        individualEvaluations.fold<double>(0, (sum, ie) => sum + ie.score) /
            individualEvaluations.length;

    return CriteriaScore(
      criteriaName: criteriaName,
      averageScore: averageScore,
      totalEvaluations: individualEvaluations.length,
      individualEvaluations: individualEvaluations,
    );
  }
}
