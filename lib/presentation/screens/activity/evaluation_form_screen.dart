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
  final String studentEmail;

  const EvaluationFormScreen({
    super.key,
    required this.course,
    required this.category,
    required this.activity,
    required this.evaluatedEmail,
    required this.studentEmail,
  });

  @override
  State<EvaluationFormScreen> createState() => _EvaluationFormScreenState();
}

class _EvaluationFormScreenState extends State<EvaluationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _commentsController = TextEditingController();
  
  // Métricas de evaluación
  int metric1 = 3; // Comunicación
  int metric2 = 3; // Colaboración  
  int metric3 = 3; // Responsabilidad
  int metric4 = 3; // Calidad del trabajo
  int metric5 = 3; // Puntualidad

  late StudentActivityController controller;

  @override
  void initState() {
    super.initState();
    final controllerTag = 'student_activity_${widget.category.id}_${widget.studentEmail}';
    controller = Get.find<StudentActivityController>(tag: controllerTag);
  }

  @override
  void dispose() {
    _commentsController.dispose();
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
                            color: Colors.black.withOpacity(0.05),
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
                                  color: const Color(0xFF00A4BD).withOpacity(0.1),
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
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: controller.getDueDateColor(widget.activity.dueDate).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: controller.getDueDateColor(widget.activity.dueDate),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              controller.formatDueDate(widget.activity.dueDate),
                              style: TextStyle(
                                color: controller.getDueDateColor(widget.activity.dueDate),
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
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: const Color(0xFF00A4BD).withOpacity(0.1),
                            child: Text(
                              widget.evaluatedEmail.substring(0, 1).toUpperCase(),
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
                      title: '1. Comunicación',
                      description: 'Claridad y efectividad en la comunicación con el equipo',
                      icon: Icons.chat_bubble_outline,
                      currentValue: metric1,
                      onChanged: (value) => setState(() => metric1 = value),
                    ),
                    
                    _buildMetricCard(
                      title: '2. Colaboración',
                      description: 'Capacidad de trabajo en equipo y apoyo a compañeros',
                      icon: Icons.group_work_outlined,
                      currentValue: metric2,
                      onChanged: (value) => setState(() => metric2 = value),
                    ),
                    
                    _buildMetricCard(
                      title: '3. Responsabilidad',
                      description: 'Cumplimiento de tareas asignadas y compromisos adquiridos',
                      icon: Icons.task_alt_outlined,
                      currentValue: metric3,
                      onChanged: (value) => setState(() => metric3 = value),
                    ),
                    
                    _buildMetricCard(
                      title: '4. Calidad del Trabajo',
                      description: 'Nivel de calidad y atención al detalle en las entregas',
                      icon: Icons.star_outline,
                      currentValue: metric4,
                      onChanged: (value) => setState(() => metric4 = value),
                    ),
                    
                    _buildMetricCard(
                      title: '5. Puntualidad',
                      description: 'Cumplimiento de plazos y horarios establecidos',
                      icon: Icons.schedule_outlined,
                      currentValue: metric5,
                      onChanged: (value) => setState(() => metric5 = value),
                      isLast: true,
                    ),

                    const SizedBox(height: 32),

                    // Comentarios opcionales
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
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
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.comment_outlined,
                                  color: Colors.blue,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Comentarios Adicionales',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Opcional: Agrega comentarios específicos sobre el desempeño de tu compañero',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _commentsController,
                            maxLines: 4,
                            maxLength: 500,
                            decoration: InputDecoration(
                              hintText: 'Escribe tus comentarios aquí...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey[300]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFF00A4BD)),
                              ),
                              filled: true,
                              fillColor: Colors.grey[50],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Resumen de la evaluación
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00A4BD).withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF00A4BD).withOpacity(0.2),
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
                            '${((metric1 + metric2 + metric3 + metric4 + metric5) / 5.0).toStringAsFixed(1)} / 5.0',
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
                              final avgRating = (metric1 + metric2 + metric3 + metric4 + metric5) / 5.0;
                              return Icon(
                                index < avgRating ? Icons.star : Icons.star_border,
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
                  color: Colors.black.withOpacity(0.05),
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
                    onPressed: controller.isLoading.value ? null : _submitEvaluation,
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
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
            color: Colors.black.withOpacity(0.05),
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
                  color: const Color(0xFF00A4BD).withOpacity(0.1),
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
                          index <= currentValue ? Icons.star : Icons.star_border,
                          color: index <= currentValue ? Colors.amber : Colors.grey[400],
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
                color: Colors.amber.withOpacity(0.1),
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
      metric1: metric1,
      metric2: metric2,
      metric3: metric3,
      metric4: metric4,
      metric5: metric5,
      comments: _commentsController.text.trim().isEmpty 
          ? null 
          : _commentsController.text.trim(),
    );
    
    // Solo regresar si la evaluación fue exitosa
    if (success) {
      // Esperar un poco para que el usuario vea el snackbar de éxito
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Regresar a la pantalla anterior (StudentEvaluationScreen) 
      // y actualizar la lista de evaluaciones
      if (Get.isRegistered<StudentActivityController>(tag: 'student_activity_${widget.category.id}_${widget.studentEmail}')) {
        final controller = Get.find<StudentActivityController>(tag: 'student_activity_${widget.category.id}_${widget.studentEmail}');
        controller.loadMyEvaluations();
      }
      
      Get.back();
    }
  }
}
