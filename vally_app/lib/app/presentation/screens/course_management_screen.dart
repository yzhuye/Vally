import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/course_management_controller.dart';
import '../../domain/entities/course.dart';

class CourseManagementScreen extends StatelessWidget {
  final Course course;

  const CourseManagementScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final CourseManagementController controller =
        Get.put(CourseManagementController(course));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF757575)),
          onPressed: () => Get.back(),
        ),
      ),
        body: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
<<<<<<< HEAD
                // Header del curso
                Obx(() => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.course.value.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          controller.course.value.description,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    )),
                const SizedBox(height: 24),

                // Estadísticas
                Obx(() => _buildStatsSection(controller)),
                const SizedBox(height: 24),

                // Código de invitación
                Obx(() => _buildInvitationCodeSection(controller)),
                const SizedBox(height: 24),

                // Lista de estudiantes
                Obx(() => _buildStudentsSection(controller)),
=======
                                 // Header del curso
                 Obx(() => Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text(
                       controller.course.value.title,
                       style: const TextStyle(
                         fontSize: 24,
                         fontWeight: FontWeight.bold,
                         color: Colors.black,
                       ),
                     ),
                     const SizedBox(height: 8),
                     Text(
                       controller.course.value.description,
                       style: const TextStyle(
                         fontSize: 16,
                         color: Colors.grey,
                       ),
                     ),
                   ],
                 )),
                 const SizedBox(height: 24),
  
                 // Estadísticas
                 Obx(() => _buildStatsSection(controller)),
                 const SizedBox(height: 24),
  
                 // Código de invitación
                 Obx(() => _buildInvitationCodeSection(controller)),
                 const SizedBox(height: 24),
  
                 // Lista de estudiantes
                 Obx(() => _buildStudentsSection(controller)),
>>>>>>> main
              ],
            ),
          ),
        
      ),
    );
  }

  Widget _buildStatsSection(CourseManagementController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3E5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                const Icon(Icons.people, color: Color(0xFF7B1FA2), size: 32),
                const SizedBox(height: 8),
                Text(
                  '${controller.course.value.enrolledStudents.length}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7B1FA2),
                  ),
                ),
                const Text(
                  'Estudiantes',
                  style: TextStyle(color: Color(0xFF7B1FA2)),
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: 60,
            color: Colors.grey[300],
          ),
          Expanded(
            child: Column(
              children: [
                const Icon(Icons.code, color: Color(0xFF1976D2), size: 32),
                const SizedBox(height: 8),
                const Text(
                  '1',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1976D2),
                  ),
                ),
                const Text(
                  'Código Activo',
                  style: TextStyle(color: Color(0xFF1976D2)),
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: 60,
            color: Colors.grey[300],
          ),
          Expanded(
            child: Column(
              children: [
                const Icon(Icons.category, color: Color(0xFFFF6F00), size: 32),
                const SizedBox(height: 8),
                Text(
                  '${controller.course.value.categories.length}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF6F00),
                  ),
                ),
                const Text(
                  'Categorías',
                  style: TextStyle(color: Color(0xFFFF6F00)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvitationCodeSection(CourseManagementController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.qr_code, color: Color(0xFF1976D2)),
              const SizedBox(width: 8),
              const Text(
                'Código de Invitación',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1976D2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF1976D2), width: 2),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    controller.course.value.invitationCode,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1976D2),
                      letterSpacing: 2,
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
                  icon: const Icon(Icons.copy, color: Color(0xFF1976D2)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => controller.generateNewInvitationCode(),
              icon: const Icon(Icons.refresh),
              label: const Text('Generar Nuevo Código'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1976D2),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentsSection(CourseManagementController controller) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.people, color: Color(0xFF2E7D32)),
              const SizedBox(width: 8),
              const Text(
                'Estudiantes Inscritos',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: controller.course.value.enrolledStudents.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_off,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No hay estudiantes inscritos aún',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Comparte el código de invitación para que se unan',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: controller.course.value.enrolledStudents.length,
                    itemBuilder: (context, index) {
                      final student =
                          controller.course.value.enrolledStudents[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F8E9),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: const Color(0xFF8BC34A), width: 1),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: const Color(0xFF8BC34A),
                              child: Text(
                                student[0].toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                student,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.check_circle,
                              color: const Color(0xFF8BC34A),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
