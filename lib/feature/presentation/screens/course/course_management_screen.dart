import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vally_app/feature/presentation/controllers/course/course_management_controller.dart';
import 'package:vally_app/feature/domain/entities/course.dart';
import 'package:vally_app/feature/presentation/widgets/course/course_detail_header.dart';
import 'professor_category_screen.dart';

// Paleta de colores consistente
const Color primaryColor = Color(0xFF00BCD4);
const Color secondaryTextColor = Color(0xFF757575);
const Color primaryTextColor = Color(0xFF212121);
const Color backgroundColor = Color(0xFFF5F7FA);
const Color cardBackgroundColor = Colors.white;

class CourseManagementScreen extends StatelessWidget {
  final Course course;

  const CourseManagementScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    // Usamos Get.put() para asegurar que el controlador esté disponible.
    // Si ya existe, Get se encargará de no crear uno nuevo.
    final CourseManagementController controller =
        Get.put(CourseManagementController(course));

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: null,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CourseDetailHeader(
              course: course,
              screenTitle: 'Gestión del Curso',
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

              // Sección de Estadísticas
              Obx(() => _buildStatsSection(controller)),
              const SizedBox(height: 24),

              // Código de invitación
              Obx(() => _buildInvitationCodeSection(controller)),
              const SizedBox(height: 24),

              // Botón de Administrar Categorías
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.category, color: Colors.white),
                  label: const Text('Administrar Categorías'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  onPressed: () {
                    Get.to(() => ProfessorCategoryScreen(
                        course: controller.course.value));
                  },
                ),
              ),

              // Contenedor animado que muestra u oculta la lista de estudiantes
              Obx(
                () => AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: controller.isStudentListVisible.value
                      ? _buildStudentsSection(controller)
                      : const SizedBox(width: double.infinity),
                ),
              ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildStatsSection(CourseManagementController controller) {
    bool isListVisible = controller.isStudentListVisible.value;

    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              // Llama al método del controlador para cambiar la visibilidad
              controller.toggleStudentListVisibility();
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: isListVisible ? primaryColor.withOpacity(0.1) : cardBackgroundColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isListVisible ? primaryColor : Colors.grey.shade200,
                  width: 1.5,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    isListVisible ? Icons.people : Icons.people_outline,
                    color: primaryColor,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${controller.course.value.enrolledStudents.length}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: primaryTextColor,
                    ),
                  ),
                  const Text(
                    'Estudiantes',
                    style: TextStyle(color: secondaryTextColor),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Tarjeta de Categorías
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: cardBackgroundColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                const Icon(Icons.category_outlined,
                    color: primaryColor, size: 32),
                const SizedBox(height: 8),
                Text(
                  '${controller.course.value.categories.length}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor,
                  ),
                ),
                const Text(
                  'Categorías',
                  style: TextStyle(color: secondaryTextColor),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInvitationCodeSection(CourseManagementController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.qr_code, color: primaryColor),
              SizedBox(width: 8),
              Text(
                'Código de Invitación',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: cardBackgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: primaryColor, width: 1),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    controller.course.value.invitationCode,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: primaryTextColor,
                      letterSpacing: 3,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(
                        text: controller.course.value.invitationCode));
                    Get.snackbar(
                      'Copiado',
                      'Código copiado al portapapeles',
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                      duration: const Duration(seconds: 2),
                    );
                  },
                  icon: const Icon(Icons.copy, color: primaryColor),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => controller.generateNewInvitationCode(),
              icon: const Icon(Icons.refresh),
              label: const Text('Generar Nuevo Código'),
              style: OutlinedButton.styleFrom(
                foregroundColor: primaryColor,
                side: const BorderSide(color: primaryColor),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentsSection(CourseManagementController controller) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Icon(Icons.people, color: primaryTextColor),
                SizedBox(width: 8),
                Text(
                  'Estudiantes Inscritos',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          controller.course.value.enrolledStudents.isEmpty
              ? Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardBackgroundColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Column(
                      children: [
                        Icon(Icons.person_off, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No hay estudiantes inscritos aún',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.separated(
                  itemCount: controller.course.value.enrolledStudents.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final student =
                        controller.course.value.enrolledStudents[index];
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: cardBackgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: primaryColor,
                            child: Text(
                              student[0].toUpperCase(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              student,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: primaryTextColor,
                              ),
                            ),
                          ),
                          const Icon(Icons.check_circle, color: Colors.green),
                        ],
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
