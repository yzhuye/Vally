import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vally_app/feature/domain/entities/course.dart';
import 'package:vally_app/feature/presentation/controllers/report/report_controller.dart';
import 'package:vally_app/feature/presentation/widgets/course/course_detail_header.dart';
import 'package:vally_app/feature/presentation/widgets/report/activity_average_widget.dart';
import 'package:vally_app/feature/presentation/widgets/report/group_average_widget.dart';
import 'package:vally_app/feature/presentation/widgets/report/student_average_widget.dart';

class ReportScreen extends StatelessWidget {
  final Course course;
  final String categoryId;
  final String categoryName;

  const ReportScreen({
    super.key,
    required this.course,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      ReportController(
        courseId: course.id,
        categoryId: categoryId,
        categoryName: categoryName,
      ),
      tag: 'report_${course.id}_$categoryId',
    );

    return Scaffold(
      appBar: null,
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CourseDetailHeader(
            course: course,
            screenTitle: 'Reportes - $categoryName',
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF00A4BD)),
                  ),
                );
              }

              return DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: const TabBar(
                        labelColor: Color(0xFF00A4BD),
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Color(0xFF00A4BD),
                        tabs: [
                          Tab(
                            icon: Icon(Icons.analytics),
                            text: 'General',
                          ),
                          Tab(
                            icon: Icon(Icons.groups),
                            text: 'Grupos',
                          ),
                          Tab(
                            icon: Icon(Icons.person),
                            text: 'Estudiantes',
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          ActivityAverageWidget(controller: controller),
                          GroupAverageWidget(controller: controller),
                          StudentAverageWidget(controller: controller),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.delete<ReportController>(tag: 'report_${course.id}_$categoryId');
          controller.refreshReports();
        },
        backgroundColor: const Color(0xFF00A4BD),
        foregroundColor: Colors.white,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
