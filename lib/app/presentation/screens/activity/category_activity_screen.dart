import 'package:flutter/material.dart';
import '../../../domain/entities/course.dart';
import '../../widgets/course/course_card.dart';

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
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Grupo A
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ExpansionTile(
            tilePadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
            shape: const RoundedRectangleBorder(
              side: BorderSide(color: Colors.transparent),
            ),
            collapsedShape: const RoundedRectangleBorder(
              side: BorderSide(color: Colors.transparent),
            ),
            leading: const Icon(Icons.group),
            title: const Text("Grupo A"),
            subtitle: const Text("Integrantes: 3/3"),
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text("Juan Pérez Gómez"),
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text("Ana María Rodríguez"),
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text("Pedro Antonio Ramírez"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 12),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isInGroup = true;
                      showActivities = true;
                    });
                  },
                  child: const Text("Unirme"),
                ),
              )
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Grupo B
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ExpansionTile(
            tilePadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
            shape: const RoundedRectangleBorder(
              side: BorderSide(color: Colors.transparent),
            ),
            collapsedShape: const RoundedRectangleBorder(
              side: BorderSide(color: Colors.transparent),
            ),
            leading: const Icon(Icons.group),
            title: const Text("Grupo B"),
            subtitle: const Text("Integrantes: 2/3"),
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text("Luis Fernando Herrera"),
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text("María José Castillo"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 12),
                child: Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 150, // puedes ajustar el valor
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isInGroup = true;
                          showActivities = true;
                        });
                      },
                      child: const Text("Unirme"),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
