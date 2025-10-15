import '../../entities/report.dart';
import '../../repositories/report_repository.dart';

class GetDetailedResultReportsUseCase {
  final ReportRepository _repository;

  GetDetailedResultReportsUseCase(this._repository);

  Future<GetDetailedResultReportsResult> call({
    required String courseId,
    required String categoryId,
  }) async {
    try {
      final detailedResults = await _repository.getDetailedResultReports(
        courseId: courseId,
        categoryId: categoryId,
      );

      return GetDetailedResultReportsResult(
        isSuccess: true,
        message: 'Reportes detallados obtenidos exitosamente',
        detailedResults: detailedResults,
      );
    } catch (e) {
      return GetDetailedResultReportsResult(
        isSuccess: false,
        message: 'Error al obtener los reportes detallados: ${e.toString()}',
        detailedResults: [],
      );
    }
  }
}

class GetDetailedResultReportsResult {
  final bool isSuccess;
  final String message;
  final List<DetailedResultReport> detailedResults;

  GetDetailedResultReportsResult({
    required this.isSuccess,
    required this.message,
    required this.detailedResults,
  });
}
