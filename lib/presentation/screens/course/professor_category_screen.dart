import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vally_app/domain/entities/course.dart';
import 'package:vally_app/presentation/widgets/course/course_card.dart';
import '../../controllers/category/category_controller.dart';
import '../professor/professor_groups_screen.dart';

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

  void _showAddCategoryDialog(BuildContext context) {
    final nameController = TextEditingController();
    final groupCountController = TextEditingController();
    final studentsPerGroupController = TextEditingController();

    final List<String> methods = ['random', 'self-assigned', 'manual'];
    String selectedMethod = methods[0];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Agregar Categoría'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Nombre'),
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedMethod,
                      decoration: const InputDecoration(
                          labelText: 'Método de agrupación'),
                      items: methods
                          .map((method) => DropdownMenuItem(
                                value: method,
                                child: Text(method),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => selectedMethod = value);
                        }
                      },
                    ),
                    TextField(
                      controller: groupCountController,
                      decoration: const InputDecoration(
                          labelText: 'Cantidad de grupos'),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: studentsPerGroupController,
                      decoration: const InputDecoration(
                          labelText: 'Estudiantes por grupo'),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('Cancelar'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                ElevatedButton(
                  child: const Text('Agregar'),
                  onPressed: () async {
                    final name = nameController.text.trim();
                    final groupCount =
                        int.tryParse(groupCountController.text.trim()) ?? 1;
                    final studentsPerGroup =
                        int.tryParse(studentsPerGroupController.text.trim()) ??
                            1;

                    if (name.isNotEmpty && selectedMethod.isNotEmpty) {
                      await controller.addCategory(
                        name: name,
                        groupingMethod: selectedMethod,
                        groupCount: groupCount,
                        studentsPerGroup: studentsPerGroup,
                      );
                      Navigator.of(context).pop();
                    } else {
                      Get.snackbar(
                        'Error',
                        'Por favor, completa todos los campos',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditCategoryDialog(BuildContext context, Category category) {
    final nameController = TextEditingController(text: category.name);
    final groupCountController =
        TextEditingController(text: category.groupCount.toString());
    final studentsPerGroupController =
        TextEditingController(text: category.studentsPerGroup.toString());

    final List<String> methods = ['random', 'self-assigned', 'manual'];
    String selectedMethod = category.groupingMethod;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Editar Categoría'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Nombre'),
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedMethod,
                      decoration: const InputDecoration(
                          labelText: 'Método de agrupación'),
                      items: methods
                          .map((method) => DropdownMenuItem(
                                value: method,
                                child: Text(method),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => selectedMethod = value);
                        }
                      },
                    ),
                    TextField(
                      controller: groupCountController,
                      decoration: const InputDecoration(
                          labelText: 'Cantidad de grupos'),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: studentsPerGroupController,
                      decoration: const InputDecoration(
                          labelText: 'Estudiantes por grupo'),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('Cancelar'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                ElevatedButton(
                  child: const Text('Guardar'),
                  onPressed: () async {
                    final name = nameController.text.trim();
                    final groupCount =
                        int.tryParse(groupCountController.text.trim()) ?? 1;
                    final studentsPerGroup =
                        int.tryParse(studentsPerGroupController.text.trim()) ??
                            1;

                    if (name.isNotEmpty && selectedMethod.isNotEmpty) {
                      await controller.updateCategory(
                        Category(
                          id: category.id,
                          name: name,
                          groupingMethod: selectedMethod,
                          groupCount: groupCount,
                          studentsPerGroup: studentsPerGroup,
                        ),
                      );
                      Navigator.of(context).pop();
                    } else {
                      Get.snackbar(
                        'Error',
                        'Por favor, completa todos los campos',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmDeleteCategory(BuildContext context, Category category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Categoría'),
        content: const Text(
            '¿Estás seguro de que deseas eliminar esta categoría? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await controller.deleteCategory(category.id);
              Navigator.of(context).pop();
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorías del Curso'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CourseCard(course: widget.course),
          ),
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

              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: controller.categories.length + 1,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  if (index < controller.categories.length) {
                    final category = controller.categories[index];
                    return ListTile(
                      leading: Icon(
                          controller.getMethodIcon(category.groupingMethod)),
                      title: Text(category.name),
                      subtitle: Text(
                        'Método: ${controller.getMethodDisplayName(category.groupingMethod)}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.group, color: Colors.green),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfessorGroupsScreen(
                                    course: widget.course,
                                    category: category,
                                  ),
                                ),
                              );
                            },
                            tooltip: 'Ver grupos',
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              _showEditCategoryDialog(context, category);
                            },
                            tooltip: 'Editar categoría',
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _confirmDeleteCategory(context, category);
                            },
                            tooltip: 'Eliminar categoría',
                          ),
                          const Icon(Icons.arrow_forward_ios, size: 16),
                        ],
                      ),
                      onTap: () {},
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Center(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.add),
                          label: const Text('Agregar categoría'),
                          onPressed: () {
                            _showAddCategoryDialog(context);
                          },
                        ),
                      ),
                    );
                  }
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
