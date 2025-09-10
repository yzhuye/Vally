import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vally_app/app/presentation/controllers/home/home_controller.dart';

class CourseDialogs {
  CourseDialogs._();

  static void showCreateCourse(
      BuildContext context, HomeController controller) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white,
        title: Row(
          children: const [
            Icon(Icons.add_circle_outline, color: Color(0xFF00A4BD)),
            SizedBox(width: 8),
            Text(
              'Crear Nuevo Curso',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF00A4BD),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Ingresa la información del nuevo curso:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Título del curso',
                prefixIcon: const Icon(Icons.title),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Descripción',
                alignLabelWithHint: true,
                prefixIcon: const Icon(Icons.description),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Color(0xFF757575)),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              if (titleController.text.isNotEmpty &&
                  descriptionController.text.isNotEmpty) {
                controller.createCourse(
                  titleController.text,
                  descriptionController.text,
                );
                Get.back();
              } else {
                Get.snackbar(
                  'Error',
                  'Por favor completa todos los campos',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.BOTTOM,
                  margin: const EdgeInsets.all(12),
                  borderRadius: 12,
                );
              }
            },
            icon: const Icon(Icons.check),
            label: const Text(
              'Crear',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF00A4BD),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }

  static void showJoinCourse(BuildContext context, HomeController controller) {
    final codeController = TextEditingController();

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white,
        title: Row(
          children: const [
            Icon(Icons.school, color: Color(0xFF00A4BD)),
            SizedBox(width: 8),
            Text(
              'Unirse a Curso',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF00A4BD),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Ingresa el código de invitación del curso:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: codeController,
              decoration: InputDecoration(
                labelText: 'Código de invitación',
                hintText: 'Ej: ABC123',
                prefixIcon: const Icon(Icons.vpn_key),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              textCapitalization: TextCapitalization.characters,
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Color(0xFF757575)),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              if (codeController.text.isNotEmpty) {
                controller
                    .joinCourseWithCode(codeController.text.toUpperCase());
                Get.back();
              } else {
                Get.snackbar(
                  'Error',
                  'Por favor ingresa un código de invitación',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.BOTTOM,
                  margin: const EdgeInsets.all(12),
                  borderRadius: 12,
                );
              }
            },
            icon: const Icon(Icons.check),
            label: const Text('Unirse'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF00A4BD),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }
}
