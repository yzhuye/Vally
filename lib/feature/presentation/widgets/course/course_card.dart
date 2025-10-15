import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vally_app/feature/domain/entities/course.dart';
import 'package:vally_app/feature/presentation/controllers/home/home_controller.dart';
import 'package:vally_app/feature/presentation/screens/course/course_management_screen.dart';
import 'package:vally_app/feature/presentation/screens/course/course_category_screen.dart';

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();

    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 2,
      // clipBehavior asegura que el efecto de onda del InkWell respete los bordes redondeados.
      clipBehavior: Clip.antiAlias,
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          if (homeController.selectedUserType.value == 'Profesor') {
            Get.to(() => CourseManagementScreen(course: course));
          } else {
            Get.to(() => CourseCategoryScreen(course: course));
          }
        },
        child: Column(
          children: [
            SizedBox(
              height: 120,
              width: double.infinity,
              child: course.imageUrl != null
                  ? Image.asset(
                      course.imageUrl!,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildPlaceholderImage(),
                    )
                  : _buildPlaceholderImage(),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          course.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      if (homeController.selectedUserType.value == 'Profesor')
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.grey,
                        )
                      else
                        const SizedBox(),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    course.description,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.people, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${course.enrolledStudents.length} estudiantes',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(233, 0, 164, 189),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          course.invitationCode,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      height: 120,
      width: double.infinity,
      color: const Color.fromARGB(255, 122, 234, 251),
      child: const Icon(
        Icons.play_circle_outline,
        color: Color(0xFF00A4BD),
        size: 48,
      ),
    );
  }
}
