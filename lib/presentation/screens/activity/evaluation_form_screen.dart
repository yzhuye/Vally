import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/entities/course.dart';
import '../../controllers/activity/student_activity_controller.dart';
import '../../widgets/course/course_detail_header.dart';

class EvaluationFormScreen extends StatefulWidget {
  final Course course;
  final Category category;
  final Activity activity;
  final String evaluatedEmail;
  final String studentId;

  const EvaluationFormScreen({
    super.key,
    required this.course,
    required this.category,
    required this.activity,
    required this.evaluatedEmail,
    required this.studentId,
  });

  @override
  State<EvaluationFormScreen> createState() => _EvaluationFormScreenState();
}

class _EvaluationFormScreenState extends State<EvaluationFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Métricas de evaluación
  int punctuality = 3; // Puntualidad
  int contributions = 3; // Contribuciones
  int commitment = 3; // Compromiso
  int attitude = 3; // Actitud

  late StudentActivityController controller;

  @override
  void initState() {
    super.initState();
    final controllerTag =
        'student_activity_${widget.category.id}_${widget.studentId}';
    controller = Get.find<StudentActivityController>(tag: controllerTag);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          CourseDetailHeader(
            course: widget.course,
            screenTitle: 'Evaluar Compañero',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Información de la actividad
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00A4BD)
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.assignment,
                                  color: Color(0xFF00A4BD),
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.activity.name,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      widget.activity.description,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: controller
                                  .getDueDateColor(widget.activity.dueDate)
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: controller
                                    .getDueDateColor(widget.activity.dueDate),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              controller.formatDueDate(widget.activity.dueDate),
                              style: TextStyle(
                                color: controller
                                    .getDueDateColor(widget.activity.dueDate),
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Información del compañero a evaluar
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor:
                                const Color(0xFF00A4BD).withValues(alpha: 0.1),
                            child: Text(
                              widget.evaluatedEmail
                                  .substring(0, 1)
                                  .toUpperCase(),
                              style: const TextStyle(
                                color: Color(0xFF00A4BD),
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Evaluando a:',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.evaluatedEmail,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Título de métricas
                    const Text(
                      'Evaluación por Métricas',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Evalúa a tu compañero en cada una de las siguientes áreas usando una escala de 0 a 5 estrellas.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Métricas de evaluación
                    _buildMetricCard(
                      title: '1. Puntualidad',
                      description:
                          'Cumplimiento de plazos y horarios establecidos',
                      icon: Icons.schedule_outlined,
                      currentValue: punctuality,
                      onChanged: (value) => setState(() => punctuality = value),
                    ),

                    _buildMetricCard(
                      title: '2. Contribuciones',
                      description:
                          'Calidad y cantidad de aportes al trabajo en equipo',
                      icon: Icons.lightbulb_outline,
                      currentValue: contributions,
                      onChanged: (value) =>
                          setState(() => contributions = value),
                    ),

                    _buildMetricCard(
                      title: '3. Compromiso',
                      description:
                          'Dedicación y responsabilidad con las tareas asignadas',
                      icon: Icons.task_alt_outlined,
                      currentValue: commitment,
                      onChanged: (value) => setState(() => commitment = value),
                    ),

                    _buildMetricCard(
                      title: '4. Actitud',
                      description:
                          'Disposición positiva y colaborativa en el equipo',
                      icon: Icons.emoji_emotions_outlined,
                      currentValue: attitude,
                      onChanged: (value) => setState(() => attitude = value),
                      isLast: true,
                    ),

                    const SizedBox(height: 32),

                    // Resumen de la evaluación
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00A4BD).withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF00A4BD).withValues(alpha: 0.2),
                        ),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.calculate,
                            color: Color(0xFF00A4BD),
                            size: 32,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Promedio de Evaluación',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF00A4BD),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${((punctuality + contributions + commitment + attitude) / 4.0).toStringAsFixed(1)} / 5.0',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF00A4BD),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(5, (index) {
                              final avgRating = (punctuality +
                                      contributions +
                                      commitment +
                                      attitude) /
                                  4.0;
                              return Icon(
                                index < avgRating
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.amber,
                                size: 20,
                              );
                            }),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),

          // Botones de acción
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: Obx(() => ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : _submitEvaluation,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00A4BD),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: controller.isLoading.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Text(
                                'Enviar Evaluación',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String description,
    required IconData icon,
    required int currentValue,
    required Function(int) onChanged,
    bool isLast = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF00A4BD).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF00A4BD),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Text(
                '0',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(6, (index) {
                    return GestureDetector(
                      onTap: () => onChanged(index),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          index <= currentValue
                              ? Icons.star
                              : Icons.star_border,
                          color: index <= currentValue
                              ? Colors.amber
                              : Colors.grey[400],
                          size: 28,
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const Text(
                '5',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$currentValue de 5 estrellas',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.amber[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitEvaluation() async {
    final success = await controller.createEvaluation(
      activityId: widget.activity.id,
      evaluatedId: widget.evaluatedEmail,
      punctuality: punctuality,
      contributions: contributions,
      commitment: commitment,
      attitude: attitude,
    );

    if (success) {
      await Future.delayed(const Duration(milliseconds: 800));

      if (Get.isRegistered<StudentActivityController>(
          tag: 'student_activity_${widget.category.id}_${widget.studentId}')) {
        final controller = Get.find<StudentActivityController>(
            tag: 'student_activity_${widget.category.id}_${widget.studentId}');
        controller.loadMyEvaluations();
      }

      Get.back();
    }
  }
}
