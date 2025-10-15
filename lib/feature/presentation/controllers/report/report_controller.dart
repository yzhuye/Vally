import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vally_app/feature/domain/entities/report.dart';
import 'package:vally_app/feature/domain/repositories/report_repository.dart';
import 'package:vally_app/feature/data/repositories/report/report_repository_impl.dart';
import 'package:vally_app/feature/domain/usecases/report/get_activity_average_report.dart';
import 'package:vally_app/feature/domain/usecases/report/get_group_average_reports.dart';
import 'package:vally_app/feature/domain/usecases/report/get_student_average_reports.dart';

class ReportController extends GetxController {
  final String courseId;
  final String categoryId;
  final String categoryName;

  late final GetActivityAverageReportUseCase _getActivityAverageReportUseCase;
  late final GetGroupAverageReportsUseCase _getGroupAverageReportsUseCase;
  late final GetStudentAverageReportsUseCase _getStudentAverageReportsUseCase;

  var reportData = Rxn<ReportData>();
  var activityAverage = Rxn<ActivityAverageReport>();
  var groupAverages = <GroupAverageReport>[].obs;
  var studentAverages = <StudentAverageReport>[].obs;
  var isLoading = false.obs;
  var selectedTabIndex = 0.obs;

  ReportController({
    required this.courseId,
    required this.categoryId,
    required this.categoryName,
  }) {
    final ReportRepository repository = ReportRepositoryImpl();
    _getActivityAverageReportUseCase =
        GetActivityAverageReportUseCase(repository);
    _getGroupAverageReportsUseCase = GetGroupAverageReportsUseCase(repository);
    _getStudentAverageReportsUseCase =
        GetStudentAverageReportsUseCase(repository);
  }

  @override
  void onInit() {
    super.onInit();
    loadAllReports();
  }

  Future<void> loadAllReports() async {
    isLoading(true);
    try {
      await Future.wait([
        loadActivityAverageReport(),
        loadGroupAverageReports(),
        loadStudentAverageReports(),
      ]);
    } finally {
      isLoading(false);
    }
  }

  Future<void> loadActivityAverageReport() async {
    try {
      final result = await _getActivityAverageReportUseCase(
          courseId: courseId, categoryId: categoryId);
      if (result.isSuccess && result.activityAverage != null) {
        activityAverage.value = result.activityAverage;
      } else {
        Get.snackbar(
          'Error',
          result.message,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error al cargar el reporte de promedio de actividades',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> loadGroupAverageReports() async {
    try {
      final result = await _getGroupAverageReportsUseCase(
          courseId: courseId, categoryId: categoryId);
      if (result.isSuccess) {
        groupAverages.value = result.groupAverages;
      } else {
        Get.snackbar(
          'Error',
          result.message,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error al cargar los reportes de promedio por grupo',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> loadStudentAverageReports() async {
    try {
      final result = await _getStudentAverageReportsUseCase(
          courseId: courseId, categoryId: categoryId);
      if (result.isSuccess) {
        studentAverages.value = result.studentAverages;
      } else {
        Get.snackbar(
          'Error',
          result.message,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error al cargar los reportes de promedio por estudiante',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }

  String getScoreColor(double score) {
    if (score >= 4.0) return '4CAF50'; // Green
    if (score >= 3.0) return 'FF9800'; // Orange
    if (score >= 2.0) return 'FF5722'; // Red-Orange
    return 'F44336'; // Red
  }

  String formatScore(double score) {
    return score.toStringAsFixed(1);
  }

  String getScoreLabel(double score) {
    if (score >= 4.5) return 'Excelente';
    if (score >= 4.0) return 'Muy Bueno';
    if (score >= 3.0) return 'Bueno';
    if (score >= 2.0) return 'Regular';
    return 'Necesita Mejora';
  }

  Future<void> refreshReports() async {
    await loadAllReports();
    Get.snackbar(
      'Éxito',
      'Reportes actualizados',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}
