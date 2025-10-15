import '../../entities/report.dart';
import '../../repositories/report_repository.dart';

class GenerateReportDataUseCase {
  final ReportRepository _repository;

  GenerateReportDataUseCase(this._repository);

  Future<GenerateReportDataResult> call({
    required String courseId,
    required String categoryId,
  }) async {
    try {
      final reportData = await _repository.generateReportData(
        courseId: courseId,
        categoryId: categoryId,
      );

      return GenerateReportDataResult(
        isSuccess: true,
        message: 'Reporte generado exitosamente',
        reportData: reportData,
      );
    } catch (e) {
      return GenerateReportDataResult(
        isSuccess: false,
        message: 'Error al generar el reporte: ${e.toString()}',
        reportData: null,
      );
    }
  }
}

class GenerateReportDataResult {
  final bool isSuccess;
  final String message;
  final ReportData? reportData;

  GenerateReportDataResult({
    required this.isSuccess,
    required this.message,
    this.reportData,
  });
}
