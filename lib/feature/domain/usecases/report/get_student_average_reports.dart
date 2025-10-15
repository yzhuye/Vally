import '../../entities/report.dart';
import '../../repositories/report_repository.dart';

class GetStudentAverageReportsUseCase {
  final ReportRepository _repository;

  GetStudentAverageReportsUseCase(this._repository);

  Future<GetStudentAverageReportsResult> call({
    required String courseId,
    required String categoryId,
  }) async {
    try {
      final studentAverages = await _repository.getStudentAverageReports(
        courseId: courseId,
        categoryId: categoryId,
      );

      return GetStudentAverageReportsResult(
        isSuccess: true,
        message: 'Reportes de promedio por estudiante obtenidos exitosamente',
        studentAverages: studentAverages,
      );
    } catch (e) {
      return GetStudentAverageReportsResult(
        isSuccess: false,
        message:
            'Error al obtener los reportes de promedio por estudiante: ${e.toString()}',
        studentAverages: [],
      );
    }
  }
}

class GetStudentAverageReportsResult {
  final bool isSuccess;
  final String message;
  final List<StudentAverageReport> studentAverages;

  GetStudentAverageReportsResult({
    required this.isSuccess,
    required this.message,
    required this.studentAverages,
  });
}
