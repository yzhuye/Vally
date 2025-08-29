import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/course.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course Creation App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4FC3F7),
          primary: const Color(0xFF4FC3F7),
        ),
        useMaterial3: true,
      ),
      home: const CourseCreationScreen(),
    );
  }
}

class CourseCreationScreen extends StatefulWidget {
  const CourseCreationScreen({super.key});

  @override
  State<CourseCreationScreen> createState() => _CourseCreationScreenState();
}

class _CourseCreationScreenState extends State<CourseCreationScreen> {
  List<Course> allCourses = [];

  List<Course> enrolledCourses = [];
  String selectedRole = 'Estudiante';
  final String currentStudentName =
      'Estudiante Actual'; // Simulated current student

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF81C784),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              _buildHeader(),
              _buildRoleButtons(),
              const SizedBox(height: 20),
              _buildSearchBar(),
              const SizedBox(height: 20),
              _buildCoursesList(),
              if (selectedRole == 'Profesor') _buildAddCourseButton(),
              if (selectedRole == 'Estudiante') _buildJoinCourseButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back)),
          const Expanded(
            child: Text(
              'Course Creation',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.person_outline)),
        ],
      ),
    );
  }

  Widget _buildRoleButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => setState(() => selectedRole = 'Estudiante'),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    selectedRole == 'Estudiante'
                        ? const Color(0xFF4FC3F7)
                        : Colors.grey[300],
                foregroundColor:
                    selectedRole == 'Estudiante' ? Colors.white : Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text('Estudiante'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () => setState(() => selectedRole = 'Profesor'),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    selectedRole == 'Profesor'
                        ? const Color(0xFF4FC3F7)
                        : Colors.grey[300],
                foregroundColor:
                    selectedRole == 'Profesor' ? Colors.white : Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text('Profesor'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Buscar...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
      ),
    );
  }

  Widget _buildCoursesList() {
    List<Course> coursesToShow =
        selectedRole == 'Profesor' ? allCourses : enrolledCourses;

    return Expanded(
      child:
          coursesToShow.isEmpty
              ? Center(
                child: Text(
                  selectedRole == 'Profesor'
                      ? 'No hay cursos creados. Crea tu primer curso.'
                      : 'No estás inscrito en ningún curso. Únete a un curso usando el código de invitación.',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: coursesToShow.length,
                itemBuilder: (context, index) {
                  final course = coursesToShow[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB3E5FC),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.play_circle_outline,
                          color: Color(0xFF4FC3F7),
                        ),
                      ),
                      title: Text(
                        course.title,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(course.description),
                      onTap: () => _navigateToCourseDetail(course),
                    ),
                  );
                },
              ),
    );
  }

  Widget _buildAddCourseButton() {
    final canAddCourse = allCourses.length < 3;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: canAddCourse ? _showAddCourseDialog : null,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                canAddCourse ? const Color(0xFF4FC3F7) : Colors.grey,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add),
              const SizedBox(width: 8),
              Text(canAddCourse ? 'Add Course' : 'Máximo 3 cursos'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJoinCourseButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _showJoinCourseDialog,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4FC3F7),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.group_add),
              SizedBox(width: 8),
              Text('Unirse a Curso'),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToCourseDetail(Course course) {
    if (selectedRole == 'Profesor') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => ProfessorCourseDetailScreen(
                course: course,
                onCourseUpdated: (updatedCourse) {
                  setState(() {
                    final index = allCourses.indexWhere(
                      (c) => c.id == updatedCourse.id,
                    );
                    if (index != -1) allCourses[index] = updatedCourse;
                  });
                },
              ),
        ),
      );
    } else {
      final currentCourse = allCourses.firstWhere(
        (c) => c.id == course.id,
        orElse: () => course,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => StudentCategoriesScreen(
                course: currentCourse,
                onCourseUpdated: (updatedCourse) {
                  setState(() {
                    final index = enrolledCourses.indexWhere(
                      (c) => c.id == updatedCourse.id,
                    );
                    if (index != -1) enrolledCourses[index] = updatedCourse;

                    final allIndex = allCourses.indexWhere(
                      (c) => c.id == updatedCourse.id,
                    );
                    if (allIndex != -1) allCourses[allIndex] = updatedCourse;
                  });
                },
              ),
        ),
      );
    }
  }

  void _showAddCourseDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Agregar Nuevo Curso'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Título del curso',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (titleController.text.isNotEmpty) {
                    final newCourse = Course(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: titleController.text,
                      description: descriptionController.text,
                      enrolledStudents: [],
                      invitationCode: _generateInvitationCode(),
                    );
                    setState(() => allCourses.add(newCourse));
                    Navigator.pop(context);
                  }
                },
                child: const Text('Agregar'),
              ),
            ],
          ),
    );
  }

  void _showJoinCourseDialog() {
    final codeController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Unirse a Curso'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Ingresa el código de invitación del curso:'),
                const SizedBox(height: 16),
                TextField(
                  controller: codeController,
                  decoration: const InputDecoration(
                    labelText: 'Código de invitación',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  final courseIndex = allCourses.indexWhere(
                    (c) => c.invitationCode == codeController.text,
                  );

                  if (courseIndex != -1) {
                    final course = allCourses[courseIndex];
                    if (!enrolledCourses.any((c) => c.id == course.id)) {
                      setState(() {
                        enrolledCourses.add(course);
                        // Update the course in allCourses to include the new student
                        final updatedCourse = Course(
                          id: course.id,
                          title: course.title,
                          description: course.description,
                          enrolledStudents: [
                            ...course.enrolledStudents,
                            currentStudentName,
                          ],
                          categories: course.categories,
                          groups: course.groups,
                          invitationCode: course.invitationCode,
                        );
                        allCourses[courseIndex] = updatedCourse;
                        enrolledCourses[enrolledCourses.length - 1] =
                            updatedCourse;
                      });
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Te has unido al curso: ${course.title}'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Código de invitación inválido'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: const Text('Unirse'),
              ),
            ],
          ),
    );
  }

  String _generateInvitationCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        6,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }
}

// Pantalla de detalle del curso para profesores
class ProfessorCourseDetailScreen extends StatefulWidget {
  final Course course;
  final Function(Course) onCourseUpdated;

  const ProfessorCourseDetailScreen({
    super.key,
    required this.course,
    required this.onCourseUpdated,
  });

  @override
  State<ProfessorCourseDetailScreen> createState() =>
      _ProfessorCourseDetailScreenState();
}

class _ProfessorCourseDetailScreenState
    extends State<ProfessorCourseDetailScreen> {
  late Course course;

  @override
  void initState() {
    super.initState();
    course = widget.course;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF81C784),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCourseInfo(),
                      const SizedBox(height: 20),
                      _buildNavigationButtons(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
          ),
          Expanded(
            child: Text(
              course.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            onPressed: _showEditCourseDialog,
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFB3E5FC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Descripción Asignatura',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(course.description),
          const SizedBox(height: 12),
          Text(
            'Código de invitación: ${course.invitationCode}',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: course.invitationCode));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Código copiado al portapapeles')),
              );
            },
            child: const Text('Copiar Código'),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _navigateToCategories(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text('Ver Categorías'),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _navigateToGroups(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text('Ver Grupos'),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _showEnrolledStudents(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text('Ver Estudiantes Inscritos'),
          ),
        ),
      ],
    );
  }

  void _showEditCourseDialog() {
    final titleController = TextEditingController(text: course.title);
    final descriptionController = TextEditingController(
      text: course.description,
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Editar Curso'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Título del curso',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (titleController.text.isNotEmpty) {
                    final updatedCourse = Course(
                      id: course.id,
                      title: titleController.text,
                      description: descriptionController.text,
                      enrolledStudents: course.enrolledStudents,
                      categories: course.categories,
                      groups: course.groups,
                      invitationCode: course.invitationCode,
                    );
                    setState(() => course = updatedCourse);
                    widget.onCourseUpdated(updatedCourse);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
    );
  }

  void _navigateToCategories() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => CategoriesScreen(
              course: course,
              onCourseUpdated: (updatedCourse) {
                setState(() => course = updatedCourse);
                widget.onCourseUpdated(updatedCourse);
              },
            ),
      ),
    );
  }

  void _navigateToGroups() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => ProfessorGroupsScreen(
              course: course,
              onCourseUpdated: (updatedCourse) {
                setState(() => course = updatedCourse);
                widget.onCourseUpdated(updatedCourse);
              },
            ),
      ),
    );
  }

  void _showEnrolledStudents() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Estudiantes en: ${course.title}'),
            content: SizedBox(
              width: double.maxFinite,
              child:
                  course.enrolledStudents.isEmpty
                      ? const Text('No hay estudiantes inscritos en este curso')
                      : ListView.builder(
                        shrinkWrap: true,
                        itemCount: course.enrolledStudents.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: const Icon(Icons.person),
                            title: Text(course.enrolledStudents[index]),
                          );
                        },
                      ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cerrar'),
              ),
            ],
          ),
    );
  }
}

class StudentCategoriesScreen extends StatefulWidget {
  final Course course;
  final Function(Course) onCourseUpdated;

  const StudentCategoriesScreen({
    super.key,
    required this.course,
    required this.onCourseUpdated,
  });

  @override
  State<StudentCategoriesScreen> createState() =>
      _StudentCategoriesScreenState();
}

class _StudentCategoriesScreenState extends State<StudentCategoriesScreen> {
  late Course course;

  @override
  void initState() {
    super.initState();
    course = widget.course;
    print(
      '[v0] StudentCategoriesScreen - Course: ${course.title}, Categories: ${course.categories.length}',
    );
    for (var category in course.categories) {
      print(
        '[v0] Category: ${category.name}, Activities: ${category.activities.length}',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF81C784),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              _buildHeader(),
              _buildCourseInfo(),
              const SizedBox(height: 20),
              Expanded(child: _buildCategoriesList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
          ),
          const Expanded(
            child: Text(
              'Categorías',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFB3E5FC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.play_circle_outline,
              color: Color(0xFF4FC3F7),
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            course.title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Text(
            'Categorías disponibles: ${course.categories.length}',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesList() {
    print('[v0] Building categories list - Count: ${course.categories.length}');

    return course.categories.isEmpty
        ? const Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.category_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No hay categorías disponibles',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'El profesor debe crear categorías primero para que puedas ver el contenido del curso.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        )
        : ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: course.categories.length,
          itemBuilder: (context, index) {
            final category = course.categories[index];
            print('[v0] Rendering category: ${category.name}');

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${category.activities.length} actividades disponibles',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _navigateToCategoryGroups(category),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Ver Grupos'),
                  ),
                ],
              ),
            );
          },
        );
  }

  void _navigateToCategoryGroups(Category category) {
    print('[v0] Navigating to category groups: ${category.name}');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => StudentCategoryGroupsScreen(
              course: course,
              category: category,
              onCourseUpdated: (updatedCourse) {
                setState(() => course = updatedCourse);
                widget.onCourseUpdated(updatedCourse);
              },
            ),
      ),
    );
  }

  void _navigateToActivities(Category category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => ActivitiesScreen(
              course: course,
              category: category,
              onCourseUpdated: (updatedCourse) {
                setState(() => course = updatedCourse);
                widget.onCourseUpdated(updatedCourse);
              },
              isStudent: true,
            ),
      ),
    );
  }
}

// Pantalla de categorías
class CategoriesScreen extends StatefulWidget {
  final Course course;
  final Function(Course) onCourseUpdated;

  const CategoriesScreen({
    super.key,
    required this.course,
    required this.onCourseUpdated,
  });

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  late Course course;

  @override
  void initState() {
    super.initState();
    course = widget.course;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF81C784),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              _buildHeader(),
              _buildCourseInfo(),
              const SizedBox(height: 20),
              Expanded(child: _buildCategoriesList()),
              _buildAddCategoryButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
          ),
          const Expanded(
            child: Text(
              'Categorías',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFB3E5FC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.play_circle_outline,
              color: Color(0xFF4FC3F7),
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            course.title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: course.categories.length,
      itemBuilder: (context, index) {
        final category = course.categories[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  category.name,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              IconButton(
                onPressed: () => _navigateToActivities(category),
                icon: const Icon(Icons.arrow_forward_ios),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddCategoryButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _showAddCategoryDialog,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4FC3F7),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add),
              SizedBox(width: 8),
              Text('Agregar Categoría'),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddCategoryDialog() {
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Agregar Categoría'),
            content: TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre de la categoría',
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty) {
                    final newCategory = Category(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: nameController.text,
                    );

                    final updatedCourse = Course(
                      id: course.id,
                      title: course.title,
                      description: course.description,
                      enrolledStudents: course.enrolledStudents,
                      categories: [...course.categories, newCategory],
                      groups: course.groups,
                      invitationCode: course.invitationCode,
                    );

                    setState(() => course = updatedCourse);
                    widget.onCourseUpdated(updatedCourse);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Agregar'),
              ),
            ],
          ),
    );
  }

  void _navigateToActivities(Category category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => ActivitiesScreen(
              course: course,
              category: category,
              onCourseUpdated: (updatedCourse) {
                setState(() => course = updatedCourse);
                widget.onCourseUpdated(updatedCourse);
              },
            ),
      ),
    );
  }
}

class ProfessorGroupsScreen extends StatefulWidget {
  final Course course;
  final Function(Course) onCourseUpdated;

  const ProfessorGroupsScreen({
    super.key,
    required this.course,
    required this.onCourseUpdated,
  });

  @override
  State<ProfessorGroupsScreen> createState() => _ProfessorGroupsScreenState();
}

class _ProfessorGroupsScreenState extends State<ProfessorGroupsScreen> {
  late Course course;

  @override
  void initState() {
    super.initState();
    course = widget.course;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF81C784),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              _buildHeader(),
              _buildCourseInfo(),
              const SizedBox(height: 20),
              Expanded(child: _buildGroupsList()),
              _buildAddGroupButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
          ),
          const Expanded(
            child: Text(
              'Grupos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFB3E5FC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.play_circle_outline,
              color: Color(0xFF4FC3F7),
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            course.title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const Text('Categoría 1'),
        ],
      ),
    );
  }

  Widget _buildGroupsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: course.groups.length,
      itemBuilder: (context, index) {
        final group = course.groups[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${group.name} ${group.capacityText}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddGroupButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _showAddGroupDialog,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4FC3F7),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add),
              SizedBox(width: 8),
              Text('Agregar Grupo'),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddGroupDialog() {
    final nameController = TextEditingController();
    final capacityController = TextEditingController();
    String? selectedCategoryId;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Agregar Grupo'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Seleccionar Categoría',
                    border: OutlineInputBorder(),
                  ),
                  value: selectedCategoryId,
                  items:
                      course.categories.map((category) {
                        return DropdownMenuItem<String>(
                          value: category.id,
                          child: Text(category.name),
                        );
                      }).toList(),
                  onChanged: (value) {
                    selectedCategoryId = value;
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del grupo',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: capacityController,
                  decoration: const InputDecoration(
                    labelText: 'Capacidad máxima',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty &&
                      capacityController.text.isNotEmpty &&
                      selectedCategoryId != null) {
                    final newGroup = Group(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: nameController.text,
                      maxCapacity: int.parse(capacityController.text),
                      categoryId: selectedCategoryId!,
                    );

                    final updatedCourse = Course(
                      id: course.id,
                      title: course.title,
                      description: course.description,
                      enrolledStudents: course.enrolledStudents,
                      categories: course.categories,
                      groups: [...course.groups, newGroup],
                      invitationCode: course.invitationCode,
                    );

                    setState(() => course = updatedCourse);
                    widget.onCourseUpdated(updatedCourse);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Agregar'),
              ),
            ],
          ),
    );
  }
}

class StudentCategoryGroupsScreen extends StatefulWidget {
  final Course course;
  final Category category;
  final Function(Course) onCourseUpdated;

  const StudentCategoryGroupsScreen({
    super.key,
    required this.course,
    required this.category,
    required this.onCourseUpdated,
  });

  @override
  State<StudentCategoryGroupsScreen> createState() =>
      _StudentCategoryGroupsScreenState();
}

class _StudentCategoryGroupsScreenState
    extends State<StudentCategoryGroupsScreen> {
  late Course course;
  late Category category;
  final String currentStudentName = 'Estudiante Actual';

  @override
  void initState() {
    super.initState();
    course = widget.course;
    category = widget.category;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF81C784),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              _buildHeader(),
              _buildCourseInfo(),
              const SizedBox(height: 20),
              Expanded(child: _buildGroupsList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
          ),
          Expanded(
            child: Text(
              'Grupos - ${category.name}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFB3E5FC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.play_circle_outline,
              color: Color(0xFF4FC3F7),
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            course.title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Text(category.name),
        ],
      ),
    );
  }

  Widget _buildGroupsList() {
    final categoryGroups =
        course.groups
            .where((group) => group.categoryId == category.id)
            .toList();

    return categoryGroups.isEmpty
        ? const Center(
          child: Text(
            'No hay grupos disponibles en esta categoría. El profesor debe crear grupos primero.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        )
        : ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: categoryGroups.length,
          itemBuilder: (context, index) {
            final group = categoryGroups[index];
            final isAlreadyMember = group.members.contains(currentStudentName);

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${group.name} ${group.capacityText}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  ElevatedButton(
                    onPressed:
                        (group.isFull || isAlreadyMember)
                            ? null
                            : () => _joinGroup(group),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isAlreadyMember
                              ? Colors.green
                              : (group.isFull
                                  ? Colors.grey
                                  : const Color(0xFF4FC3F7)),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(isAlreadyMember ? 'Unido' : group.status),
                  ),
                  if (isAlreadyMember) ...[
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => _navigateToActivities(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('Ver Actividades'),
                    ),
                  ],
                ],
              ),
            );
          },
        );
  }

  void _joinGroup(Group group) {
    final updatedMembers = [...group.members, currentStudentName];
    final updatedGroup = Group(
      id: group.id,
      name: group.name,
      maxCapacity: group.maxCapacity,
      members: updatedMembers,
      categoryId: group.categoryId,
    );

    final updatedGroups =
        course.groups.map((g) {
          return g.id == group.id ? updatedGroup : g;
        }).toList();

    final updatedCourse = Course(
      id: course.id,
      title: course.title,
      description: course.description,
      enrolledStudents: course.enrolledStudents,
      categories: course.categories,
      groups: updatedGroups,
      invitationCode: course.invitationCode,
    );

    setState(() => course = updatedCourse);
    widget.onCourseUpdated(updatedCourse);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Te has unido al ${group.name}')));
  }

  void _navigateToActivities() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => ActivitiesScreen(
              course: course,
              category: category,
              onCourseUpdated: (updatedCourse) {
                setState(() => course = updatedCourse);
                widget.onCourseUpdated(updatedCourse);
              },
              isStudent: true,
            ),
      ),
    );
  }
}

// Pantalla de actividades
class ActivitiesScreen extends StatefulWidget {
  final Course course;
  final Category category;
  final Function(Course) onCourseUpdated;
  final bool isStudent;

  const ActivitiesScreen({
    super.key,
    required this.course,
    required this.category,
    required this.onCourseUpdated,
    this.isStudent = false,
  });

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  late Course course;
  late Category category;
  String selectedTab = 'Actividades';
  final String currentStudentName = 'Estudiante Actual';

  @override
  void initState() {
    super.initState();
    course = widget.course;
    category = widget.category;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isStudent && !_isStudentInCategoryGroup()) {
      return _buildNotInGroupScreen();
    }

    return Scaffold(
      backgroundColor: const Color(0xFF81C784),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              _buildHeader(),
              _buildCourseInfo(),
              const SizedBox(height: 20),
              _buildTabButtons(),
              const SizedBox(height: 20),
              Expanded(child: _buildContent()),
              if (selectedTab == 'Actividades' && !widget.isStudent)
                _buildAddActivityButton(),
            ],
          ),
        ),
      ),
    );
  }

  bool _isStudentInCategoryGroup() {
    return course.groups.any(
      (group) =>
          group.categoryId == category.id &&
          group.members.contains(currentStudentName),
    );
  }

  Widget _buildNotInGroupScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFF81C784),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.group_off, size: 80, color: Colors.grey),
                      const SizedBox(height: 20),
                      const Text(
                        'Debes unirte a un grupo',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Para ver las actividades de ${category.name}, primero debes unirte a un grupo de esta categoría.',
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4FC3F7),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text('Volver a Grupos'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
          ),
          Expanded(
            child: Text(
              category.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFB3E5FC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.play_circle_outline,
              color: Color(0xFF4FC3F7),
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            course.title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Text(category.name),
          const Text('Grupo 1'),
        ],
      ),
    );
  }

  Widget _buildTabButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => setState(() => selectedTab = 'Actividades'),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    selectedTab == 'Actividades'
                        ? const Color(0xFF4FC3F7)
                        : Colors.grey[300],
                foregroundColor:
                    selectedTab == 'Actividades' ? Colors.white : Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text('Actividades'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () => setState(() => selectedTab = 'Personas'),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    selectedTab == 'Personas'
                        ? const Color(0xFF4FC3F7)
                        : Colors.grey[300],
                foregroundColor:
                    selectedTab == 'Personas' ? Colors.white : Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text('Personas'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (selectedTab == 'Actividades') {
      return _buildActivitiesList();
    } else {
      return _buildPersonsList();
    }
  }

  Widget _buildActivitiesList() {
    return category.activities.isEmpty
        ? const Center(
          child: Text(
            'No hay actividades en esta categoría',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        )
        : ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: category.activities.length,
          itemBuilder: (context, index) {
            final activity = category.activities[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      activity.name,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _showActivityDetails(activity),
                    icon: const Icon(Icons.info_outline),
                  ),
                ],
              ),
            );
          },
        );
  }

  Widget _buildPersonsList() {
    return course.enrolledStudents.isEmpty
        ? const Center(
          child: Text(
            'No hay estudiantes inscritos en este curso',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        )
        : ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: course.enrolledStudents.length,
          itemBuilder: (context, index) {
            final student = course.enrolledStudents[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.person, color: Color(0xFF4FC3F7)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(student, style: const TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            );
          },
        );
  }

  Widget _buildAddActivityButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _showAddActivityDialog,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4FC3F7),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add),
              SizedBox(width: 8),
              Text('Agregar Actividad'),
            ],
          ),
        ),
      ),
    );
  }

  void _showActivityDetails(Activity activity) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(activity.name),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Descripción: ${activity.description}'),
                const SizedBox(height: 8),
                Text(
                  'Fecha límite: ${activity.dueDate.day}/${activity.dueDate.month}/${activity.dueDate.year}',
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cerrar'),
              ),
            ],
          ),
    );
  }

  void _showAddActivityDialog() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Agregar Actividad'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre de la actividad',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty) {
                    final newActivity = Activity(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: nameController.text,
                      description: descriptionController.text,
                      dueDate: DateTime.now().add(const Duration(days: 7)),
                    );

                    // Actualizar la categoría con la nueva actividad
                    final updatedCategory = Category(
                      id: category.id,
                      name: category.name,
                      activities: [...category.activities, newActivity],
                    );

                    // Actualizar el curso con la categoría modificada
                    final updatedCategories =
                        course.categories.map((cat) {
                          return cat.id == category.id ? updatedCategory : cat;
                        }).toList();

                    final updatedCourse = Course(
                      id: course.id,
                      title: course.title,
                      description: course.description,
                      enrolledStudents: course.enrolledStudents,
                      categories: updatedCategories,
                      groups: course.groups,
                      invitationCode: course.invitationCode,
                    );

                    setState(() {
                      course = updatedCourse;
                      category = updatedCategory;
                    });
                    widget.onCourseUpdated(updatedCourse);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Agregar'),
              ),
            ],
          ),
    );
  }
}
