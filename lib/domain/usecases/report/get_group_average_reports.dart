import '../../entities/report.dart';
import '../../repositories/report_repository.dart';

class GetGroupAverageReportsUseCase {
  final ReportRepository _repository;

  GetGroupAverageReportsUseCase(this._repository);

  Future<GetGroupAverageReportsResult> call({
    required String courseId,
    required String categoryId,
  }) async {
    try {
      final groupAverages = await _repository.getGroupAverageReports(
        courseId: courseId,
        categoryId: categoryId,
      );

      return GetGroupAverageReportsResult(
        isSuccess: true,
        message: 'Reportes de promedio por grupo obtenidos exitosamente',
        groupAverages: groupAverages,
      );
    } catch (e) {
      return GetGroupAverageReportsResult(
        isSuccess: false,
        message:
            'Error al obtener los reportes de promedio por grupo: ${e.toString()}',
        groupAverages: [],
      );
    }
  }
}

class GetGroupAverageReportsResult {
  final bool isSuccess;
  final String message;
  final List<GroupAverageReport> groupAverages;

  GetGroupAverageReportsResult({
    required this.isSuccess,
    required this.message,
    required this.groupAverages,
  });
}
