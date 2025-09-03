import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/course.dart';
import '../../domain/entities/category.dart';
import '../widgets/course_card.dart';
import '../../data/repositories/category_repository_imp.dart';

class CourseCategoryScreen extends StatelessWidget {
  final Course course;

  const CourseCategoryScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    // Obtener categorías desde el repositorio
    final categories = CategoryRepositoryImpl().getAll();

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
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: categories.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final category = categories[index];
                return ListTile(
                  title: Text(category.name),
                  subtitle: Text(
                    'Método: ${category.groupingMethod} | Grupos: ${category.groupCount} | Estudiantes/grupo: ${category.studentsPerGroup}',
                  ),
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
