import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vally_app/features/course/presentation/controllers/report/report_controller.dart';

class ActivityAverageWidget extends StatelessWidget {
  final ReportController controller;

  const ActivityAverageWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final activityAverage = controller.activityAverage.value;

      if (activityAverage == null) {
        return const Center(
          child: Text(
            'No hay datos de actividades disponibles',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        );
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(activityAverage),
            const SizedBox(height: 16),
            _buildCriteriaCards(activityAverage),
            const SizedBox(height: 16),
            _buildSummaryCard(activityAverage),
          ],
        ),
      );
    });
  }

  Widget _buildHeaderCard(activityAverage) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: [Color(0xFF00A4BD), Color(0xFF008B9F)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.analytics,
              size: 48,
              color: Colors.white,
            ),
            const SizedBox(height: 12),
            const Text(
              'Promedio General de Actividades',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              controller.formatScore(activityAverage.overallAverage),
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              controller.getScoreLabel(activityAverage.overallAverage),
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCriteriaCards(activityAverage) {
    final criteria = [
      {
        'title': 'Puntualidad',
        'score': activityAverage.punctualityAverage,
        'icon': Icons.schedule,
        'color': const Color(0xFF4CAF50),
      },
      {
        'title': 'Contribuciones',
        'score': activityAverage.contributionsAverage,
        'icon': Icons.work,
        'color': const Color(0xFF2196F3),
      },
      {
        'title': 'Compromiso',
        'score': activityAverage.commitmentAverage,
        'icon': Icons.favorite,
        'color': const Color(0xFF9C27B0),
      },
      {
        'title': 'Actitud',
        'score': activityAverage.attitudeAverage,
        'icon': Icons.sentiment_very_satisfied,
        'color': const Color(0xFFFF9800),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: criteria.length,
      itemBuilder: (context, index) {
        final item = criteria[index];
        return Card(
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: item['color'] as Color,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item['icon'] as IconData,
                  size: 32,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                Text(
                  item['title'] as String,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  controller.formatScore(item['score'] as double),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryCard(activityAverage) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resumen de Datos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00A4BD),
              ),
            ),
            const SizedBox(height: 16),
            _buildSummaryRow(
              'Total de Actividades',
              activityAverage.totalActivities.toString(),
              Icons.assignment,
            ),
            _buildSummaryRow(
              'Total de Evaluaciones',
              activityAverage.totalEvaluations.toString(),
              Icons.rate_review,
            ),
            _buildSummaryRow(
              'Promedio General',
              controller.formatScore(activityAverage.overallAverage),
              Icons.trending_up,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue.shade700),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Estas métricas representan el promedio de todas las evaluaciones realizadas en las actividades de esta categoría.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF00A4BD), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00A4BD),
            ),
          ),
        ],
      ),
    );
  }
}
