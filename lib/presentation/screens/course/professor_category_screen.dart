import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vally_app/domain/entities/course.dart';
import 'package:vally_app/presentation/widgets/dialogs/category_dialogs.dart'; 
import '../../controllers/category/category_controller.dart';
import '../professor/professor_groups_screen.dart';
import '../activity/activity_management_screen.dart';
import '../../widgets/course/course_detail_header.dart'; 

class ProfessorCategoryScreen extends StatefulWidget {
  final Course course;

  const ProfessorCategoryScreen({super.key, required this.course});

  @override
  State<ProfessorCategoryScreen> createState() =>
      _ProfessorCategoryScreenState();
}

class _ProfessorCategoryScreenState extends State<ProfessorCategoryScreen> {
  late CategoryController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(
      CategoryController(courseId: widget.course.id),
      tag: 'category_${widget.course.id}',
    );
  }

  @override
  void dispose() {
    Get.delete<CategoryController>(tag: 'category_${widget.course.id}');
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
            screenTitle: 'Categorías del Curso',
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
            child: Text(
              'Categorías',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.categories.isEmpty) {
                return const Center(
                  child: Text('Aún no hay categorías. ¡Agrega una!'),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: controller.categories.length,
                itemBuilder: (context, index) {
                  final category = controller.categories[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: Icon(
                        controller.getMethodIcon(category.groupingMethod),
                        color: const Color(0xFF00A4BD),
                      ),
                      title: Text(category.name,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        'Método: ${controller.getMethodDisplayName(category.groupingMethod)}',
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => _showCategoryOptions(context, category),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => CategoryDialogs.showAddCategory(context, controller),
        icon: const Icon(Icons.add),
        label: const Text('Nueva Categoría'),
        backgroundColor: const Color(0xFF00A4BD),
        foregroundColor: Colors.white,
      ),
    );
  }

  void _showCategoryOptions(BuildContext context, Category category) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.assignment, color: Color(0xFF00A4BD)),
              title: const Text('Ver Actividades'),
              onTap: () {
                Get.back(); // Cierra el bottom sheet
                Get.to(() => ActivityManagementScreen(
                      course: widget.course,
                      category: category,
                    ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.group, color: Colors.green),
              title: const Text('Ver Grupos'),
              onTap: () {
                Get.back(); // Cierra el bottom sheet
                Get.to(() => ProfessorGroupsScreen(
                      course: widget.course,
                      category: category,
                    ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.blue),
              title: const Text('Editar Categoría'),
              onTap: () {
                Get.back();
                CategoryDialogs.showEditCategory(context, category, controller);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Eliminar Categoría'),
              onTap: () {
                Get.back();
                CategoryDialogs.showDeleteCategory(
                    context, category, controller);
              },
            ),
          ],
        );
      },
    );
  }
}