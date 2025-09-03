import 'package:flutter/material.dart';
import '../../domain/entities/course.dart';
import '../widgets/course_card.dart';
import '../../data/repositories/category_repository_imp.dart';

class CourseCategoryScreen extends StatelessWidget {
  final Course course;

  const CourseCategoryScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final categories =
        CategoryRepositoryImpl().getCategoriesForCourse(course.id);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorías del Curso'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CourseCard(course: course),
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
            child: categories.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.info_outline,
                            size: 48, color: Colors.grey),
                        const SizedBox(height: 16),
                        const Text(
                          'No hay categorías para este curso.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Contacta al profesor para agregar categorías.',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: categories.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return ListTile(
                        title: Text(category.name),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {},
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
