import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/entities/course.dart';
import '../../widgets/course/course_detail_header.dart';
import '../../widgets/group/group_card.dart';
import '../../controllers/group/group_controller.dart';
import '../../controllers/home/home_controller.dart';
import '../../controllers/activity/student_activity_controller.dart';
import 'student_evaluation_screen.dart';

class CategoryActivityScreen extends StatefulWidget {
  final Course course;
  final Category category;

  const CategoryActivityScreen({
    super.key,
    required this.course,
    required this.category,
  });

  @override
  State<CategoryActivityScreen> createState() => _CategoryActivityScreenState();
}

class _CategoryActivityScreenState extends State<CategoryActivityScreen> {
  bool showActivities = true;
  GroupController? groupController;
  StudentActivityController? activityController;
  late String studentEmail;
  late String controllerTag;
  late String activityControllerTag;

  @override
  void initState() {
    super.initState();

    final homeController = Get.find<HomeController>();
    studentEmail = homeController.currentUser.value?.email ?? '';

    // Initialize activity controller
    activityControllerTag =
        'student_activity_${widget.category.id}_$studentEmail';
    activityController = Get.put(
      StudentActivityController(
        categoryId: widget.category.id,
        courseId: widget.course.id,
        studentEmail: studentEmail,
      ),
      tag: activityControllerTag,
    );

    // Inicializar GroupController para todos los métodos
    controllerTag = '${widget.course.id}_${widget.category.id}_$studentEmail';

    if (Get.isRegistered<GroupController>(tag: controllerTag)) {
      Get.delete<GroupController>(tag: controllerTag);
    }

    groupController = Get.put(
      GroupController(
        courseId: widget.course.id,
        categoryId: widget.category.id,
        studentEmail: studentEmail,
      ),
      tag: controllerTag,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (groupController != null) {
      groupController!.loadGroups();
    }
  }

  @override
  void dispose() {
    if (groupController != null &&
        Get.isRegistered<GroupController>(tag: controllerTag)) {
      Get.delete<GroupController>(tag: controllerTag);
    }
    if (Get.isRegistered<StudentActivityController>(
        tag: activityControllerTag)) {
      Get.delete<StudentActivityController>(tag: activityControllerTag);
    }
    super.dispose();
  }

  // Helper method to map emails to student names
  String _getNameForEmail(String email) {
    // Reverse mapping from emails to names
    final nameMappings = {
      'a@a.com': 'gabriela', // Usar email real
      'b@a.com': 'betty',
      'c@a.com': 'camila',
      'd@a.com': 'daniela', // Usar email real
      'e@a.com': 'eliana', // Usar email real
      'f@a.com': 'fernanda', // Usar email real
    };

    // Si está en el mapeo, usar el nombre
    if (nameMappings.containsKey(email.toLowerCase())) {
      return nameMappings[email.toLowerCase()]!;
    }

    // Si no está en el mapeo, extraer nombre del email (antes del @)
    final emailParts = email.toLowerCase().split('@');
    if (emailParts.isNotEmpty) {
      return emailParts[0];
    }

    return email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Column(
        children: [
          CourseDetailHeader(
            course: widget.course,
            screenTitle: widget.category.name,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showActivities = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: showActivities
                          ? const Color(0xFF00A4BD)
                          : Colors.grey[200],
                      foregroundColor: showActivities
                          ? Colors.white
                          : const Color(0xFF757575),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Actividades"),
                        if (widget.category.groupingMethod ==
                            'self-assigned') ...[
                          const SizedBox(width: 4),
                          Obx(() => groupController?.currentGroup != null
                              ? const Icon(Icons.check_circle, size: 16)
                              : const SizedBox.shrink()),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showActivities = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !showActivities
                          ? const Color(0xFF00A4BD)
                          : Colors.grey[200],
                      foregroundColor: !showActivities
                          ? Colors.white
                          : const Color(0xFF757575),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Grupos"),
                        if (widget.category.groupingMethod ==
                            'self-assigned') ...[
                          const SizedBox(width: 4),
                          Obx(() => Icon(
                                groupController?.currentGroup != null
                                    ? Icons.group
                                    : Icons.group_outlined,
                                size: 16,
                              )),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: showActivities ? _buildActivitiesView() : _buildGroupsView(),
          ),
        ],
      ),
    );
  }

  Widget _buildActivitiesView() {
    // Verificar si el estudiante está en un grupo para todos los métodos
    bool isInGroup = false;

    print('🔍 DEBUG CategoryActivityScreen - Building activities view');
    print('🔍 DEBUG CategoryActivityScreen - Student email: $studentEmail');
    print(
        '🔍 DEBUG CategoryActivityScreen - GroupController exists: ${groupController != null}');

    if (groupController != null) {
      isInGroup = groupController!.currentGroup != null;
      print(
          '🔍 DEBUG CategoryActivityScreen - Current group: ${groupController!.currentGroup?.name ?? "None"}');
    } else {
      // Si no hay groupController, inicializarlo para verificar
      controllerTag = '${widget.course.id}_${widget.category.id}_$studentEmail';
      if (!Get.isRegistered<GroupController>(tag: controllerTag)) {
        groupController = Get.put(
          GroupController(
            courseId: widget.course.id,
            categoryId: widget.category.id,
            studentEmail: studentEmail,
          ),
          tag: controllerTag,
        );
        groupController!.loadGroups();
      }
      isInGroup = groupController?.currentGroup != null;
      print(
          '🔍 DEBUG CategoryActivityScreen - Current group after init: ${groupController?.currentGroup?.name ?? "None"}');
    }

    print('🔍 DEBUG CategoryActivityScreen - Is in group: $isInGroup');

    // Si no está en un grupo, mostrar mensaje según el método
    if (!isInGroup) {
      String message;
      IconData icon;

      switch (widget.category.groupingMethod) {
        case 'self-assigned':
          message = "Debes unirte a un grupo para ver las actividades.";
          icon = Icons.group_add;
          break;
        case 'manual':
          message =
              "Aún no has sido asignado a un grupo. Contacta al profesor.";
          icon = Icons.person_add_disabled;
          break;
        default:
          message = "Debes estar en un grupo para ver las actividades.";
          icon = Icons.group_off;
      }

      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Obx(() {
      if (activityController!.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (activityController!.activities.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.assignment_outlined,
                size: 64,
                color: Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                "Todavía no hay actividades disponibles.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: activityController!.activities.length,
        itemBuilder: (context, index) {
          final activity = activityController!.activities[index];
          final evaluationCount =
              activityController!.getEvaluationCountForActivity(activity.id);
          final isExpired =
              activityController!.isActivityExpired(activity.dueDate);

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF00A4BD).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.assignment,
                  color: Color(0xFF00A4BD),
                ),
              ),
              title: Text(
                activity.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    activity.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: activityController!
                                .getDueDateColor(activity.dueDate)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: activityController!
                                  .getDueDateColor(activity.dueDate),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            activityController!.formatDueDate(activity.dueDate),
                            style: TextStyle(
                              color: activityController!
                                  .getDueDateColor(activity.dueDate),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (evaluationCount > 0)
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '$evaluationCount evaluaciones',
                              style: TextStyle(
                                color: Colors.green[700],
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              trailing: !isExpired
                  ? ElevatedButton(
                      onPressed: () => _navigateToEvaluation(activity),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00A4BD),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Evaluar'),
                    )
                  : Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.red[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Vencida',
                        style: TextStyle(
                          color: Colors.red[700],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
              onTap: () => _navigateToEvaluation(activity),
            ),
          );
        },
      );
    });
  }

  void _navigateToEvaluation(Activity activity) {
    Get.to(() => StudentEvaluationScreen(
          course: widget.course,
          category: widget.category,
          activity: activity,
          studentEmail: studentEmail,
        ));
  }

  Widget _buildGroupsView() {
    // Inicializar el groupController si no existe (para métodos que no son self-assigned)
    if (groupController == null) {
      controllerTag = '${widget.course.id}_${widget.category.id}_$studentEmail';

      if (Get.isRegistered<GroupController>(tag: controllerTag)) {
        Get.delete<GroupController>(tag: controllerTag);
      }

      groupController = Get.put(
        GroupController(
          courseId: widget.course.id,
          categoryId: widget.category.id,
          studentEmail: studentEmail,
        ),
        tag: controllerTag,
      );
    }

    if (groupController == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Obx(() {
      if (groupController!.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (groupController!.groups.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.group_off,
                size: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              Text(
                widget.category.groupingMethod == 'self-assigned'
                    ? 'No hay grupos disponibles para esta categoría.'
                    : 'No hay grupos creados para esta categoría.\nLos grupos se crean automáticamente por el profesor.',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }

      return Column(
        children: [
          // Mensaje informativo para métodos que no son self-assigned
          if (widget.category.groupingMethod != 'self-assigned') ...[
            Container(
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Esta categoría usa método "${widget.category.groupingMethod}". '
                      'Puedes ver tu grupo asignado pero no cambiarlo.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          // Lista de grupos
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: groupController!.groups.length,
              itemBuilder: (context, index) {
                final group = groupController!.groups[index];
                // Solo permitir unirse si el método es 'self-assigned'
                final canJoin =
                    widget.category.groupingMethod == 'self-assigned'
                        ? groupController!.canJoinGroup(group)
                        : false;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: GroupCard(
                    group: group,
                    currentUserEmail: studentEmail,
                    canJoin: canJoin,
                    nameMapper: (email) => _getNameForEmail(email),
                    onJoin: () async {
                      if (canJoin) {
                        await groupController!.joinGroup(group.id);
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}
