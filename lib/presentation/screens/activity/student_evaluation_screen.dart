import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/entities/course.dart';
import '../../../domain/services/email_mapping_service.dart';
import '../../controllers/activity/student_activity_controller.dart';
import '../../controllers/group/group_controller.dart';
import '../../widgets/course/course_detail_header.dart';
import '../../widgets/dialogs/evaluation_dialogs.dart';
import 'evaluation_form_screen.dart';

class StudentEvaluationScreen extends StatefulWidget {
  final Course course;
  final Category category;
  final Activity activity;
  final String studentEmail;

  const StudentEvaluationScreen({
    super.key,
    required this.course,
    required this.category,
    required this.activity,
    required this.studentEmail,
  });

  @override
  State<StudentEvaluationScreen> createState() =>
      _StudentEvaluationScreenState();
}

class _StudentEvaluationScreenState extends State<StudentEvaluationScreen> {
  late StudentActivityController activityController;
  late GroupController groupController;
  late String controllerTag;

  @override
  void initState() {
    super.initState();

    // Mapear el email del usuario autenticado al nombre usado en los grupos
    final mappedStudentEmail =
        EmailMappingService.mapUserEmailToGroupEmail(widget.studentEmail);

    controllerTag =
        'student_activity_${widget.category.id}_$mappedStudentEmail';
    activityController = Get.put(
      StudentActivityController(
        categoryId: widget.category.id,
        courseId: widget.course.id,
        studentEmail: mappedStudentEmail,
      ),
      tag: controllerTag,
    );

    // Controller para obtener compañeros de grupo
    final groupControllerTag =
        '${widget.course.id}_${widget.category.id}_$mappedStudentEmail';

    // Verificar si el controlador existe antes de intentar obtenerlo
    if (Get.isRegistered<GroupController>(tag: groupControllerTag)) {
      groupController = Get.find<GroupController>(tag: groupControllerTag);
    } else {
      // Crear el controlador si no existe
      groupController = Get.put(
        GroupController(
          courseId: widget.course.id,
          categoryId: widget.category.id,
          studentEmail: mappedStudentEmail,
        ),
        tag: groupControllerTag,
      );
    }

    // Cargar grupos después de inicializar el controlador
    WidgetsBinding.instance.addPostFrameCallback((_) {
      groupController.loadGroups();
    });
  }

  @override
  void dispose() {
    Get.delete<StudentActivityController>(tag: controllerTag);
    // No eliminamos el GroupController aquí porque puede estar siendo usado por otras pantallas
    super.dispose();
  }

  // Método para actualizar la pantalla cuando regrese de una evaluación
  void _refreshEvaluations() {
    activityController.loadMyEvaluations();
    setState(() {}); // Forzar rebuild de la UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CourseDetailHeader(
            course: widget.course,
            screenTitle: 'Evaluar Compañeros',
          ),
          // Activity Info Card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
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
                      child: const Icon(
                        Icons.assignment,
                        color: Color(0xFF00A4BD),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.activity.name,
                            style: const TextStyle(
                              fontSize: 18,
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
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: activityController
                        .getDueDateColor(widget.activity.dueDate)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: activityController
                          .getDueDateColor(widget.activity.dueDate),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    activityController.formatDueDate(widget.activity.dueDate),
                    style: TextStyle(
                      color: activityController
                          .getDueDateColor(widget.activity.dueDate),
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Instructions
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue[600], size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Evalúa a tus compañeros de grupo usando las 5 métricas. Cada métrica se califica de 0 a 5 estrellas.',
                    style: TextStyle(
                      color: Colors.blue[800],
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Compañeros de Grupo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Obx(() {
              if (groupController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final currentGroup = groupController.currentGroup;
              if (currentGroup == null) {
                return const Center(
                  child: Text(
                    'No perteneces a ningún grupo en esta categoría.',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              final groupMembers = currentGroup.members
                  .where((member) => member != widget.studentEmail)
                  .toList();

              if (groupMembers.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.group_off, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No hay otros compañeros en tu grupo para evaluar.',
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              // Preload eligibility once members are known
              activityController.preloadEligibility(
                  widget.activity.id, groupMembers);

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: groupMembers.length,
                itemBuilder: (context, index) {
                  final memberEmail = groupMembers[index];
                  final hasEvaluated = activityController.hasEvaluated(
                      widget.activity.id, memberEmail);
                  final canEvaluate =
                      activityController.eligibilityByMember[memberEmail] ==
                          true;
                  final isChecking =
                      activityController.isEligibilityLoading(memberEmail) ||
                          !activityController.isEligibilityKnown(memberEmail);
                  final isExpired = activityController
                      .isActivityExpired(widget.activity.dueDate);

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(
                        backgroundColor:
                            const Color(0xFF00A4BD).withOpacity(0.1),
                        child: Text(
                          memberEmail.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            color: Color(0xFF00A4BD),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        memberEmail,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          if (hasEvaluated)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Ya evaluado',
                                style: TextStyle(
                                  color: Colors.green[700],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          else if (isExpired)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.red[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Tiempo vencido',
                                style: TextStyle(
                                  color: Colors.red[700],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          else if (isChecking)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Comprobando...',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          else if (!canEvaluate)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.orange[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'No disponible',
                                style: TextStyle(
                                  color: Colors.orange[700],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          else
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.blue[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Pendiente de evaluar',
                                style: TextStyle(
                                  color: Colors.blue[700],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                      trailing: !hasEvaluated &&
                              !isExpired &&
                              !isChecking &&
                              canEvaluate
                          ? ElevatedButton(
                              onPressed: () =>
                                  _showEvaluationDialog(memberEmail),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF00A4BD),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('Evaluar'),
                            )
                          : null,
                      onTap: hasEvaluated
                          ? () => _showEvaluationDetails(memberEmail)
                          : null,
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showEvaluationDialog(String evaluatedEmail) async {
    await Get.to(() => EvaluationFormScreen(
          course: widget.course,
          category: widget.category,
          activity: widget.activity,
          evaluatedEmail: evaluatedEmail,
          studentEmail: widget.studentEmail,
        ));

    // Cuando regrese de la pantalla de evaluación, actualizar la lista
    _refreshEvaluations();
  }

  void _showEvaluationDetails(String evaluatedEmail) {
    final evaluation = activityController.myEvaluations.firstWhere(
      (eval) =>
          eval.activityId == widget.activity.id &&
          eval.evaluatedId == evaluatedEmail,
    );

    EvaluationDialogs.showEvaluationDetails(
        context, evaluation, evaluatedEmail);
  }
}
