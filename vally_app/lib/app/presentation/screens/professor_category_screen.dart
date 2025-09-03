import 'package:flutter/material.dart';
import '../../domain/entities/course.dart';
import '../../domain/entities/category.dart';
import '../widgets/course_card.dart';
import '../../data/repositories/category_repository_imp.dart';

class ProfessorCategoryScreen extends StatelessWidget {
  final Course course;

  const ProfessorCategoryScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
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
              itemCount: categories.length + 1,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                if (index < categories.length) {
                  final category = categories[index];
                  return ListTile(
                    title: Text(category.name),
                    subtitle: Text(
                      'Método: ${category.groupingMethod} | Grupos: ${category.groupCount} | Estudiantes/grupo: ${category.studentsPerGroup}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            // Implementar edición
                            print('Editar ${category.name}');
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            // Implementar eliminación
                            print('Eliminar ${category.name}');
                          },
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
                    onTap: () {
                      // Navegar a actividades (futuro)
                    },
                  );
                } else {
                  // Botón para agregar categoría
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Center(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text('Agregar categoría'),
                        onPressed: () {
                          // Implementar agregar
                          print('Agregar categoría');
                        },
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
