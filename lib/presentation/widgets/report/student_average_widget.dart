import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vally_app/presentation/controllers/report/report_controller.dart';

class StudentAverageWidget extends StatelessWidget {
  final ReportController controller;

  const StudentAverageWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final studentAverages = controller.studentAverages;

      if (studentAverages.isEmpty) {
        return const Center(
          child: Text(
            'No hay datos de estudiantes disponibles',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        );
      }

      // Group students by group
      final studentsByGroup = <String, List>{};
      for (final student in studentAverages) {
        if (!studentsByGroup.containsKey(student.groupId)) {
          studentsByGroup[student.groupId] = [];
        }
        studentsByGroup[student.groupId]!.add(student);
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(studentAverages),
            const SizedBox(height: 16),
            ...studentsByGroup.entries
                .map((entry) => _buildGroupSection(entry.key, entry.value)),
          ],
        ),
      );
    });
  }

  Widget _buildHeaderCard(List studentAverages) {
    final totalStudents = studentAverages.length;
    final overallAverage = studentAverages.isNotEmpty
        ? studentAverages.fold<double>(
                0, (sum, student) => sum + student.overallAverage) /
            totalStudents
        : 0.0;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.person,
              size: 48,
              color: Colors.white,
            ),
            const SizedBox(height: 12),
            const Text(
              'Promedio por Estudiantes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              controller.formatScore(overallAverage),
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'Promedio general de $totalStudents estudiantes',
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

  Widget _buildGroupSection(String groupId, List students) {
    final firstStudent = students.first;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF2196F3),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.groups,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    firstStudent.groupName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '${students.length} estudiantes',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ...students.map((student) => _buildStudentCard(student)),
        ],
      ),
    );
  }

  Widget _buildStudentCard(student) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFF2196F3),
                radius: 20,
                child: Text(
                  student.studentName.substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.studentName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '${student.totalEvaluations} evaluaciones',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getScoreColor(student.overallAverage),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  controller.formatScore(student.overallAverage),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildMiniScoreCard(
                    'Puntualidad', student.punctualityAverage, Icons.schedule),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMiniScoreCard(
                    'Contribuciones', student.contributionsAverage, Icons.work),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildMiniScoreCard(
                    'Compromiso', student.commitmentAverage, Icons.favorite),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMiniScoreCard('Actitud', student.attitudeAverage,
                    Icons.sentiment_very_satisfied),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniScoreCard(String label, double score, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade600),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            controller.formatScore(score),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2196F3),
            ),
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 4.0) return const Color(0xFF4CAF50); // Green
    if (score >= 3.0) return const Color(0xFFFF9800); // Orange
    if (score >= 2.0) return const Color(0xFFFF5722); // Red-Orange
    return const Color(0xFFF44336); // Red
  }
}
