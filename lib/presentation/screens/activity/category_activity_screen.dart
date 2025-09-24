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

    if (widget.category.groupingMethod == 'self-assigned') {
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
      'gabriela@example.com': 'gabriela',
      'b@a.com': 'betty',
      'c@a.com': 'camila',
      'daniela@example.com': 'daniela',
      'eliana@example.com': 'eliana',
      'fernanda@example.com': 'fernanda',
    };

    return nameMappings[email.toLowerCase()] ?? email;
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
    if (widget.category.groupingMethod == 'self-assigned') {
      if (groupController?.currentGroup == null) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.group_off,
                size: 64,
                color: Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                "Debes unirte a un grupo para ver las actividades.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }
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
    if (widget.category.groupingMethod != 'self-assigned') {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.info_outline,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'Esta categoría usa método "${widget.category.groupingMethod}".\nLos grupos no están disponibles para auto-asignación.',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
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
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.group_off,
                size: 64,
                color: Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                'No hay grupos disponibles para esta categoría.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: groupController!.groups.length,
        itemBuilder: (context, index) {
          final group = groupController!.groups[index];
          final canJoin = groupController!.canJoinGroup(group);

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
      );
    });
  }
}
