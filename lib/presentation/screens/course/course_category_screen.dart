import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/entities/course.dart';
import '../../widgets/course/course_detail_header.dart';
import '../../../presentation/controllers/category/category_controller.dart';
import '../activity/category_activity_screen.dart';

class CourseCategoryScreen extends StatelessWidget {
  final Course course;

  const CourseCategoryScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    // Initialize the CategoryController with the course ID
    final controller = Get.put(CategoryController(courseId: course.id));

    return Scaffold(
      appBar: null,
      body: Column(
        children: [
          CourseDetailHeader(
            course: course,
            screenTitle: 'Categorías del Curso',
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Categorías',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.categories.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.info_outline,
                          size: 48, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text(
                        'No hay categorías para este curso.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Contacta al profesor para agregar categorías.',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: controller.categories.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final category = controller.categories[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: Icon(
                        category.groupingMethod == 'self-assigned'
                            ? Icons.group_add
                            : Icons.assignment,
                        color: const Color(0xFF00A4BD),
                      ),
                      title: Text(category.name),
                      subtitle: Text(
                        category.groupingMethod == 'self-assigned'
                            ? 'Auto-asignación de grupos'
                            : 'Actividades y tareas',
                        style: const TextStyle(fontSize: 12),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryActivityScreen(
                                course: course, category: category),
                          ),
                        );
                      },
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
}
