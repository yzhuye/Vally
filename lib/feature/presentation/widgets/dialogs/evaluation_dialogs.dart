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
    final formKey = GlobalKey<FormState>();
    
    // Métricas de evaluación
    int punctuality = 3; // Puntualidad
    int contributions = 3; // Contribuciones
    int commitment = 3; // Compromiso
    int attitude = 3; // Actitud

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
                  // Métrica 1: Puntualidad
                  _buildMetricRating(
                    'Puntualidad',
                    'Cumplimiento de plazos y horarios',
                    punctuality,
                    (value) => setState(() => punctuality = value),
                  ),
                  const SizedBox(height: 16),
                  
                  // Métrica 2: Contribuciones
                  _buildMetricRating(
                    'Contribuciones',
                    'Calidad y cantidad de aportes al equipo',
                    contributions,
                    (value) => setState(() => contributions = value),
                  ),
                  const SizedBox(height: 16),
                  
                  // Métrica 3: Compromiso
                  _buildMetricRating(
                    'Compromiso',
                    'Dedicación y responsabilidad con las tareas',
                    commitment,
                    (value) => setState(() => commitment = value),
                  ),
                  const SizedBox(height: 16),
                  
                  // Métrica 4: Actitud
                  _buildMetricRating(
                    'Actitud',
                    'Disposición positiva y colaborativa',
                    attitude,
                    (value) => setState(() => attitude = value),
                  ),
                  const SizedBox(height: 16),
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
                  punctuality: punctuality,
                  contributions: contributions,
                  commitment: commitment,
                  attitude: attitude,
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
              _buildMetricDisplay('Puntualidad', evaluation.punctuality),
              const SizedBox(height: 12),
              _buildMetricDisplay('Contribuciones', evaluation.contributions),
              const SizedBox(height: 12),
              _buildMetricDisplay('Compromiso', evaluation.commitment),
              const SizedBox(height: 12),
              _buildMetricDisplay('Actitud', evaluation.attitude),
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
