import 'package:flutter/material.dart';
import '../../../domain/entities/course.dart';
import '../../widgets/course/course_card.dart';
import '../../widgets/group/group_card.dart';

class CategoryActivityScreen extends StatefulWidget {
  final Course course;
  final String category;

  const CategoryActivityScreen({
    super.key,
    required this.course,
    required this.category,
  });

  @override
  State<CategoryActivityScreen> createState() => _CategoryActivityScreenState();
}

class _CategoryActivityScreenState extends State<CategoryActivityScreen> {
  bool showActivities = true;
  bool isInGroup = false;

  List<Group> groups = [
    Group(
      id: 'a',
      name: 'Grupo A',
      maxCapacity: 3,
      members: [
        'Juan Pérez Gómez',
        'Ana María Rodríguez',
        'Pedro Antonio Ramírez'
      ],
      categoryId: 'cat1',
    ),
    Group(
      id: 'b',
      name: 'Grupo B',
      maxCapacity: 3,
      members: ['Luis Fernando Herrera', 'María José Castillo'],
      categoryId: 'cat1',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CourseCard(course: widget.course),
          ),

          // 🔹 Selector de vista con botones grandes
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showActivities = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: showActivities
                          ? const Color(0xFF00A4BD)
                          : Colors.grey[200],
                      foregroundColor: showActivities
                          ? Colors.white
                          : const Color(0xFF757575),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: const Text("Actividades"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showActivities = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !showActivities
                          ? const Color(0xFF00A4BD)
                          : Colors.grey[200],
                      foregroundColor: !showActivities
                          ? Colors.white
                          : const Color(0xFF757575),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: const Text("Grupos"),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: showActivities ? _buildActivitiesView() : _buildGroupsView(),
          ),
        ],
      ),
    );
  }

  Widget _buildActivitiesView() {
    if (!isInGroup) {
      return const Center(
        child: Text(
          "Debes unirte a un grupo para ver las actividades.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      );
    } else {
      return const Center(
        child: Text(
          "Todavía no hay actividades disponibles.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  Widget _buildGroupsView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final group = groups[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: GroupCard(
            group: group,
            onJoin: () {
              setState(() {
                // Aquí agregas lógica para unirte al grupo
                isInGroup = true;
                showActivities = true;

                // Ejemplo: agregamos un miembro (puedes reemplazar con usuario real)
                if (!group.isFull) {
                  group.members.add('Mi Nombre');
                }
              });
            },
          ),
        );
      },
    );
  }
}
