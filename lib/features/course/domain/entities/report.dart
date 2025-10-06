/// Report data models for teacher analytics
class ReportData {
  final String categoryId;
  final String categoryName;
  final ActivityAverageReport activityAverage;
  final List<GroupAverageReport> groupAverages;
  final List<StudentAverageReport> studentAverages;
  final List<DetailedResultReport> detailedResults;

  ReportData({
    required this.categoryId,
    required this.categoryName,
    required this.activityAverage,
    required this.groupAverages,
    required this.studentAverages,
    required this.detailedResults,
  });
}

class ActivityAverageReport {
  final double overallAverage;
  final double punctualityAverage;
  final double contributionsAverage;
  final double commitmentAverage;
  final double attitudeAverage;
  final int totalActivities;
  final int totalEvaluations;

  ActivityAverageReport({
    required this.overallAverage,
    required this.punctualityAverage,
    required this.contributionsAverage,
    required this.commitmentAverage,
    required this.attitudeAverage,
    required this.totalActivities,
    required this.totalEvaluations,
  });
}

class GroupAverageReport {
  final String groupId;
  final String groupName;
  final double overallAverage;
  final double punctualityAverage;
  final double contributionsAverage;
  final double commitmentAverage;
  final double attitudeAverage;
  final int totalStudents;
  final int totalEvaluations;

  GroupAverageReport({
    required this.groupId,
    required this.groupName,
    required this.overallAverage,
    required this.punctualityAverage,
    required this.contributionsAverage,
    required this.commitmentAverage,
    required this.attitudeAverage,
    required this.totalStudents,
    required this.totalEvaluations,
  });
}

class StudentAverageReport {
  final String studentId;
  final String studentName;
  final double overallAverage;
  final double punctualityAverage;
  final double contributionsAverage;
  final double commitmentAverage;
  final double attitudeAverage;
  final String groupId;
  final String groupName;
  final int totalEvaluations;

  StudentAverageReport({
    required this.studentId,
    required this.studentName,
    required this.overallAverage,
    required this.punctualityAverage,
    required this.contributionsAverage,
    required this.commitmentAverage,
    required this.attitudeAverage,
    required this.groupId,
    required this.groupName,
    required this.totalEvaluations,
  });
}

class DetailedResultReport {
  final String groupId;
  final String groupName;
  final List<StudentDetailedResult> students;

  DetailedResultReport({
    required this.groupId,
    required this.groupName,
    required this.students,
  });
}

class StudentDetailedResult {
  final String studentId;
  final String studentName;
  final List<CriteriaScore> criteriaScores;
  final double overallAverage;

  StudentDetailedResult({
    required this.studentId,
    required this.studentName,
    required this.criteriaScores,
    required this.overallAverage,
  });
}

class CriteriaScore {
  final String criteriaName;
  final double averageScore;
  final int totalEvaluations;
  final List<IndividualEvaluation> individualEvaluations;

  CriteriaScore({
    required this.criteriaName,
    required this.averageScore,
    required this.totalEvaluations,
    required this.individualEvaluations,
  });
}

class IndividualEvaluation {
  final String evaluatorId;
  final String evaluatorName;
  final int score;
  final DateTime createdAt;
  final String activityId;
  final String activityName;

  IndividualEvaluation({
    required this.evaluatorId,
    required this.evaluatorName,
    required this.score,
    required this.createdAt,
    required this.activityId,
    required this.activityName,
  });
}
