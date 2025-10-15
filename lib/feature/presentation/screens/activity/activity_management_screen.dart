import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/entities/course.dart';
import '../../controllers/activity/activity_controller.dart';
import '../../widgets/course/course_detail_header.dart';
import '../../widgets/dialogs/activity_dialogs.dart';

class ActivityManagementScreen extends StatefulWidget {
  final Course course;
  final Category category;

  const ActivityManagementScreen({
    super.key,
    required this.course,
    required this.category,
  });

  @override
  State<ActivityManagementScreen> createState() => _ActivityManagementScreenState();
}

class _ActivityManagementScreenState extends State<ActivityManagementScreen> {
  late ActivityController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(
      ActivityController(categoryId: widget.category.id),
      tag: 'activity_${widget.category.id}',
    );
  }

  @override
  void dispose() {
    Get.delete<ActivityController>(tag: 'activity_${widget.category.id}');
    super.dispose();
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
            screenTitle: 'Actividades - ${widget.category.name}',
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
            child: Row(
              children: [
                const Icon(
                  Icons.assignment,
                  color: Color(0xFF00A4BD),
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Actividades de Evaluación',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (controller.activities.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.assignment_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Aún no hay actividades',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Crea la primera actividad de evaluación',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: controller.activities.length,
                itemBuilder: (context, index) {
                  final activity = controller.activities[index];
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
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: controller.getDueDateColor(activity.dueDate).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: controller.getDueDateColor(activity.dueDate),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              controller.formatDueDate(activity.dueDate),
                              style: TextStyle(
                                color: controller.getDueDateColor(activity.dueDate),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) => _handleMenuAction(value, activity),
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: ListTile(
                              leading: Icon(Icons.edit, color: Colors.blue),
                              title: Text('Editar'),
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: ListTile(
                              leading: Icon(Icons.delete, color: Colors.red),
                              title: Text('Eliminar'),
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ],
                      ),
                      onTap: () => _showActivityDetails(activity),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => ActivityDialogs.showCreateActivity(context, controller),
        icon: const Icon(Icons.add),
        label: const Text('Nueva Actividad'),
        backgroundColor: const Color(0xFF00A4BD),
        foregroundColor: Colors.white,
      ),
    );
  }

  void _handleMenuAction(String action, Activity activity) {
    switch (action) {
      case 'edit':
        ActivityDialogs.showEditActivity(context, activity, controller);
        break;
      case 'delete':
        ActivityDialogs.showDeleteActivity(context, activity, controller);
        break;
    }
  }

  void _showActivityDetails(Activity activity) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(activity.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Descripción:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 4),
            Text(activity.description),
            const SizedBox(height: 16),
            Text(
              'Fecha límite:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: controller.getDueDateColor(activity.dueDate).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: controller.getDueDateColor(activity.dueDate),
                  width: 1,
                ),
              ),
              child: Text(
                '${activity.dueDate.day}/${activity.dueDate.month}/${activity.dueDate.year} - ${controller.formatDueDate(activity.dueDate)}',
                style: TextStyle(
                  color: controller.getDueDateColor(activity.dueDate),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
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
}
