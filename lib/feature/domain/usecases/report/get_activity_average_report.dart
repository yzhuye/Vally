import '../../entities/report.dart';
import '../../repositories/report_repository.dart';

class GetActivityAverageReportUseCase {
  final ReportRepository _repository;

  GetActivityAverageReportUseCase(this._repository);

  Future<GetActivityAverageReportResult> call({
    required String courseId,
    required String categoryId,
  }) async {
    try {
      final activityAverage = await _repository.getActivityAverageReport(
        courseId: courseId,
        categoryId: categoryId,
      );

      return GetActivityAverageReportResult(
        isSuccess: true,
        message: 'Reporte de promedio de actividades obtenido exitosamente',
        activityAverage: activityAverage,
      );
    } catch (e) {
      return GetActivityAverageReportResult(
        isSuccess: false,
        message:
            'Error al obtener el reporte de promedio de actividades: ${e.toString()}',
        activityAverage: null,
      );
    }
  }
}

class GetActivityAverageReportResult {
  final bool isSuccess;
  final String message;
  final ActivityAverageReport? activityAverage;

  GetActivityAverageReportResult({
    required this.isSuccess,
    required this.message,
    this.activityAverage,
  });
}
