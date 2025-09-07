import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../widgets/course_card.dart';
import '../widgets/dialogs/course_dialogs.dart';

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
            icon:
                const Icon(Icons.notifications_none, color: Color(0xFF757575)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined,
                color: Color(0xFF757575)),
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
                        onPressed: () =>
                            controller.selectUserType('Estudiante'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              controller.selectedUserType.value == 'Estudiante'
                                  ? Colors.blue
                                  : Colors.grey[200],
                          foregroundColor:
                              controller.selectedUserType.value == 'Estudiante'
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
                          backgroundColor:
                              controller.selectedUserType.value == 'Profesor'
                                  ? Colors.blue
                                  : Colors.grey[200],
                          foregroundColor:
                              controller.selectedUserType.value == 'Profesor'
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
              onChanged: (value) => controller.updateSearchText(value),
              decoration: InputDecoration(
                hintText: 'Buscar...',
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

                final filteredCourses = controller.filteredCourses;

                if (filteredCourses.isEmpty) {
                  return Center(
                    child: Text(
                      controller.selectedUserType.value == 'Profesor'
                          ? 'No hay cursos creados. Crea tu primer curso.'
                          : 'No estás inscrito en ningún curso. Únete a un curso usando el código de invitación.',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: filteredCourses.length,
                  itemBuilder: (context, index) {
                    final course = filteredCourses[index];
                    return CourseCard(course: course);
                  },
                );
              }),
            ),
            const SizedBox(height: 10),
            Obx(() => ElevatedButton.icon(
                  onPressed: () {
                    if (controller.selectedUserType.value == 'Profesor') {
                      CourseDialogs.showCreateCourse(context, controller);
                    } else {
                      CourseDialogs.showJoinCourse(context, controller);
                    }
                  },
                  icon: Icon(
                      controller.selectedUserType.value == 'Profesor'
                          ? Icons.add
                          : Icons.group_add,
                      color: Colors.blue),
                  label: Text(
                      controller.selectedUserType.value == 'Profesor'
                          ? 'Crear Curso'
                          : 'Unirse a Curso',
                      style: const TextStyle(color: Colors.blue)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[50],
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 0,
                  ),
                )),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  
}
