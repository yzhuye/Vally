import 'package:flutter/material.dart';
import '../../../domain/entities/course.dart';
import '../../controllers/activity/student_activity_controller.dart';

class EvaluationDialogs {
  static void showCreateEvaluation(
    BuildContext context,
    Activity activity,
    String evaluatedEmail,
    StudentActivityController controller,
  ) {
    final commentsController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    
    // Métricas de evaluación
    int metric1 = 3; // Comunicación
    int metric2 = 3; // Colaboración
    int metric3 = 3; // Responsabilidad
    int metric4 = 3; // Calidad del trabajo
    int metric5 = 3; // Puntualidad

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Evaluar Compañero',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                evaluatedEmail,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Métrica 1: Comunicación
                  _buildMetricRating(
                    'Comunicación',
                    'Claridad y efectividad en la comunicación',
                    metric1,
                    (value) => setState(() => metric1 = value),
                  ),
                  const SizedBox(height: 16),
                  
                  // Métrica 2: Colaboración
                  _buildMetricRating(
                    'Colaboración',
                    'Trabajo en equipo y apoyo a compañeros',
                    metric2,
                    (value) => setState(() => metric2 = value),
                  ),
                  const SizedBox(height: 16),
                  
                  // Métrica 3: Responsabilidad
                  _buildMetricRating(
                    'Responsabilidad',
                    'Cumplimiento de tareas y compromisos',
                    metric3,
                    (value) => setState(() => metric3 = value),
                  ),
                  const SizedBox(height: 16),
                  
                  // Métrica 4: Calidad del trabajo
                  _buildMetricRating(
                    'Calidad del Trabajo',
                    'Nivel de calidad en las entregas',
                    metric4,
                    (value) => setState(() => metric4 = value),
                  ),
                  const SizedBox(height: 16),
                  
                  // Métrica 5: Puntualidad
                  _buildMetricRating(
                    'Puntualidad',
                    'Cumplimiento de plazos y horarios',
                    metric5,
                    (value) => setState(() => metric5 = value),
                  ),
                  const SizedBox(height: 16),
                  
                  // Comentarios opcionales
                  TextFormField(
                    controller: commentsController,
                    decoration: const InputDecoration(
                      labelText: 'Comentarios (opcional)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.comment),
                      hintText: 'Agrega comentarios adicionales...',
                    ),
                    maxLines: 3,
                    maxLength: 500,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await controller.createEvaluation(
                  activityId: activity.id,
                  evaluatedId: evaluatedEmail,
                  metric1: metric1,
                  metric2: metric2,
                  metric3: metric3,
                  metric4: metric4,
                  metric5: metric5,
                  comments: commentsController.text.trim().isEmpty 
                      ? null 
                      : commentsController.text.trim(),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00A4BD),
                foregroundColor: Colors.white,
              ),
              child: const Text('Enviar Evaluación'),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildMetricRating(
    String title,
    String description,
    int currentValue,
    Function(int) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('0', style: TextStyle(fontSize: 12, color: Colors.grey)),
            Row(
              children: List.generate(6, (index) {
                return GestureDetector(
                  onTap: () => onChanged(index),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Icon(
                      index <= currentValue ? Icons.star : Icons.star_border,
                      color: index <= currentValue 
                          ? Colors.amber 
                          : Colors.grey[400],
                      size: 24,
                    ),
                  ),
                );
              }),
            ),
            const Text('5', style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 4),
        Center(
          child: Text(
            '$currentValue/5 estrellas',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  static void showEvaluationDetails(
    BuildContext context,
    Evaluation evaluation,
    String evaluatedEmail,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Evaluación Enviada',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              evaluatedEmail,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMetricDisplay('Comunicación', evaluation.metric1),
              const SizedBox(height: 12),
              _buildMetricDisplay('Colaboración', evaluation.metric2),
              const SizedBox(height: 12),
              _buildMetricDisplay('Responsabilidad', evaluation.metric3),
              const SizedBox(height: 12),
              _buildMetricDisplay('Calidad del Trabajo', evaluation.metric4),
              const SizedBox(height: 12),
              _buildMetricDisplay('Puntualidad', evaluation.metric5),
              const SizedBox(height: 16),
              
              // Promedio
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calculate, color: Colors.blue[600], size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Promedio: ${evaluation.averageRating.toStringAsFixed(1)}/5.0',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                  ],
                ),
              ),
              
              if (evaluation.comments != null && evaluation.comments!.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text(
                  'Comentarios:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(evaluation.comments!),
                ),
              ],
              
              const SizedBox(height: 16),
              Text(
                'Enviado: ${evaluation.createdAt.day}/${evaluation.createdAt.month}/${evaluation.createdAt.year} ${evaluation.createdAt.hour.toString().padLeft(2, '0')}:${evaluation.createdAt.minute.toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  static Widget _buildMetricDisplay(String title, int value) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          flex: 3,
          child: Row(
            children: [
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < value ? Icons.star : Icons.star_border,
                    color: index < value ? Colors.amber : Colors.grey[400],
                    size: 16,
                  );
                }),
              ),
              const SizedBox(width: 8),
              Text(
                '$value/5',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
