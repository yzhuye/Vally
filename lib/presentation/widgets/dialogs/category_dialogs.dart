import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vally_app/domain/entities/course.dart';
import 'package:vally_app/presentation/controllers/category/category_controller.dart';

class CategoryDialogs {
  CategoryDialogs._();

  static const Color _primaryColor = Color(0xFF00A4BD);

  /// Muestra el diálogo para agregar una nueva categoría.
  static void showAddCategory(
      BuildContext context, CategoryController controller) {
    final nameController = TextEditingController();
    final groupCountController = TextEditingController();
    final studentsPerGroupController = TextEditingController();

    final List<String> methods = ['self-assigned', 'manual'];
    String selectedMethod = methods[0];

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.white,
            title: Row(
              children: const [
                Icon(Icons.add_circle_outline, color: _primaryColor),
                SizedBox(width: 8),
                Text(
                  'Agregar Categoría',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _primaryColor,
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ingresa la información de la nueva categoría:',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: nameController,
                    labelText: 'Nombre de la categoría',
                    icon: Icons.title,
                  ),
                  const SizedBox(height: 16),
                  _buildDropdownField(
                    value: selectedMethod,
                    items: methods,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => selectedMethod = value);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: groupCountController,
                    labelText: 'Cantidad de grupos',
                    icon: Icons.format_list_numbered,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: studentsPerGroupController,
                    labelText: 'Estudiantes por grupo',
                    icon: Icons.groups,
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
            actionsPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            actions: [
              _buildCancelButton(),
              _buildActionButton(
                label: 'Agregar',
                icon: Icons.add,
                onPressed: () {
                  final name = nameController.text.trim();
                  final groupCount =
                      int.tryParse(groupCountController.text.trim()) ?? 1;
                  final studentsPerGroup =
                      int.tryParse(studentsPerGroupController.text.trim()) ?? 1;

                  if (name.isNotEmpty) {
                    // Solo llamamos al controlador. Él se encargará del resto.
                    controller.addCategory(
                      name: name,
                      groupingMethod: selectedMethod,
                      groupCount: groupCount,
                      studentsPerGroup: studentsPerGroup,
                    );
                  } else {
                    _showErrorSnackbar('Por favor, completa todos los campos');
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }

  /// Muestra el diálogo para editar una categoría existente.
  static void showEditCategory(
      BuildContext context, Category category, CategoryController controller) {
    final nameController = TextEditingController(text: category.name);
    final groupCountController =
        TextEditingController(text: category.groupCount.toString());
    final studentsPerGroupController =
        TextEditingController(text: category.studentsPerGroup.toString());

    final List<String> methods = ['self-assigned', 'manual'];
    String selectedMethod = category.groupingMethod;

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: Colors.white,
            title: Row(
              children: const [
                Icon(Icons.edit, color: _primaryColor),
                SizedBox(width: 8),
                Text(
                  'Editar Categoría',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: _primaryColor),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(
                    controller: nameController,
                    labelText: 'Nombre de la categoría',
                    icon: Icons.title,
                  ),
                  const SizedBox(height: 16),
                  _buildDropdownField(
                    value: selectedMethod,
                    items: methods,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => selectedMethod = value);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: groupCountController,
                    labelText: 'Cantidad de grupos',
                    icon: Icons.format_list_numbered,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: studentsPerGroupController,
                    labelText: 'Estudiantes por grupo',
                    icon: Icons.groups,
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
            actionsPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            actions: [
              _buildCancelButton(),
              _buildActionButton(
                label: 'Guardar',
                icon: Icons.save,
                onPressed: () {
                  final name = nameController.text.trim();
                  final groupCount =
                      int.tryParse(groupCountController.text.trim()) ?? 1;
                  final studentsPerGroup =
                      int.tryParse(studentsPerGroupController.text.trim()) ?? 1;

                  if (name.isNotEmpty) {
                    // Solo llamamos al controlador.
                    controller.updateCategory(
                      Category(
                        id: category.id,
                        name: name,
                        groupingMethod: selectedMethod,
                        groupCount: groupCount,
                        studentsPerGroup: studentsPerGroup,
                      ),
                    );
                  } else {
                    _showErrorSnackbar('Por favor, completa todos los campos');
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }

  /// Muestra el diálogo para confirmar la eliminación de una categoría.
  static void showDeleteCategory(
      BuildContext context, Category category, CategoryController controller) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        title: Row(
          children: const [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text(
              'Eliminar Categoría',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
            ),
          ],
        ),
        content: const Text(
          '¿Estás seguro de que deseas eliminar esta categoría? Esta acción no se puede deshacer.',
          style: TextStyle(fontSize: 16),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        actions: [
          _buildCancelButton(),
          ElevatedButton.icon(
            icon: const Icon(Icons.delete_forever),
            label: const Text('Eliminar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            ),
            onPressed: () {
              // Solo llamamos al controlador.
              controller.deleteCategory(category.id);
            },
          ),
        ],
      ),
    );
  }

  static Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: _primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primaryColor, width: 2),
        ),
      ),
    );
  }

  static Widget _buildDropdownField({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: 'Método de agrupación',
        prefixIcon: const Icon(Icons.shuffle, color: _primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primaryColor, width: 2),
        ),
      ),
      items: items
          .map((method) => DropdownMenuItem(
                value: method,
                child: Text(method),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }

  static Widget _buildCancelButton() {
    return TextButton(
      onPressed: () => Get.back(),
      child: const Text(
        'Cancelar',
        style: TextStyle(color: Color(0xFF757575)),
      ),
    );
  }

  static Widget _buildActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      ),
    );
  }

  static void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
    );
  }
}
