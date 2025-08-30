import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../widgets/course_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.arrow_back_ios, color: Color(0xFF757575)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Color(0xFF757575)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined, color: Color(0xFF757575)),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hola,\nDaniel A',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Obx(() => Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => controller.selectUserType('Estudiante'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: controller.selectedUserType.value == 'Estudiante'
                              ? Colors.blue
                              : Colors.grey[200],
                          foregroundColor: controller.selectedUserType.value == 'Estudiante'
                              ? Colors.white
                              : Color(0xFF757575),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        child: const Text('Estudiante'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => controller.selectUserType('Profesor'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: controller.selectedUserType.value == 'Profesor'
                              ? Colors.blue
                              : Colors.grey[200],
                          foregroundColor: controller.selectedUserType.value == 'Profesor'
                              ? Colors.white
                              : Color(0xFF757575),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        child: const Text('Profesor'),
                      ),
                    ),
                  ],
                )),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: 'Buscar..',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  itemCount: controller.courses.length,
                  itemBuilder: (context, index) {
                    final course = controller.courses[index];
                    return CourseCard(course: course);
                  },
                );
              }),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, color: Colors.blue),
              label: const Text('Add Course', style: TextStyle(color: Colors.blue)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.withAlpha(30),
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 0,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}