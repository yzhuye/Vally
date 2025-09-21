import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/entities/course.dart';
import '../../controllers/professor/professor_group_controller.dart';
import '../../widgets/course/course_detail_header.dart';

class ProfessorGroupsScreen extends StatefulWidget {
  final Course course;
  final Category category;

  const ProfessorGroupsScreen({
    super.key,
    required this.course,
    required this.category,
  });

  @override
  State<ProfessorGroupsScreen> createState() => _ProfessorGroupsScreenState();
}

class _ProfessorGroupsScreenState extends State<ProfessorGroupsScreen> {
  late ProfessorGroupController controller;
  String selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    controller = Get.put(
      ProfessorGroupController(
        courseId: widget.course.id,
        categoryId: widget.category.id,
      ),
      tag: 'professor_groups_${widget.course.id}_${widget.category.id}',
    );
  }

  @override
  void dispose() {
    Get.delete<ProfessorGroupController>(
      tag: 'professor_groups_${widget.course.id}_${widget.category.id}',
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null, // Eliminamos la AppBar
      body: Column(
        children: [
          // Usamos el nuevo CourseDetailHeader
          CourseDetailHeader(
            course: widget.course,
            screenTitle: 'Grupos - ${widget.category.name}',
          ),

          // Estadísticas generales
          _buildStatsCard(),

          // Filtros
          _buildFilterChips(),

          // Lista de grupos
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.groups.isEmpty) {
                return _buildEmptyState();
              }

              final filteredGroups = _getFilteredGroups();

              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: filteredGroups.length,
                itemBuilder: (context, index) {
                  final group = filteredGroups[index];
                  return _buildGroupCard(group);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF00A4BD).withAlpha(25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF00A4BD).withAlpha(76)),
      ),
      child: Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                'Total Grupos',
                '${controller.totalGroups}',
                Icons.group,
              ),
              _buildStatItem(
                'Estudiantes',
                '${controller.totalStudents}',
                Icons.people,
              ),
              _buildStatItem(
                'Capacidad',
                '${controller.totalCapacity}',
                Icons.event_seat,
              ),
              _buildStatItem(
                'Ocupación',
                '${controller.occupancyRate.toStringAsFixed(1)}%',
                Icons.pie_chart,
              ),
            ],
          )),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF00A4BD), size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF00A4BD),
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildFilterChip('all', 'Todos', Icons.list),
                _buildFilterChip('available', 'Con Espacio', Icons.person_add),
                _buildFilterChip('full', 'Llenos', Icons.check_circle),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Botón de actualizar
          IconButton(
            onPressed: () => controller.loadGroups(),
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar grupos',
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFF00A4BD),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String value, String label, IconData icon) {
    final isSelected = selectedFilter == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            selectedFilter = value;
          });
        },
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16),
            const SizedBox(width: 4),
            Text(label),
          ],
        ),
        selectedColor: const Color(0xFF00A4BD).withAlpha(51),
        checkmarkColor: const Color(0xFF00A4BD),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.group_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No hay grupos en esta categoría',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Los grupos se crearán automáticamente cuando se agregue la categoría',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGroupCard(Group group) {
    final stats = controller.getGroupStats(group);

    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
        leading: CircleAvatar(
          backgroundColor:
              stats['isFull'] ? Colors.green : const Color(0xFF00A4BD),
          child: Text(
            '${stats['membersCount']}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          group.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Capacidad: ${stats['membersCount']}/${stats['maxCapacity']}'),
            LinearProgressIndicator(
              value: stats['occupancyRate'] / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                stats['isFull'] ? Colors.green : const Color(0xFF00A4BD),
              ),
            ),
          ],
        ),
        trailing: Icon(
          stats['isFull'] ? Icons.check_circle : Icons.person_add,
          color: stats['isFull'] ? Colors.green : const Color(0xFF00A4BD),
        ),
        children: [
          if (group.members.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Integrantes:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            ...group.members.map((member) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.person,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          member,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                )),
          ] else ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'No hay integrantes en este grupo',
                style: TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  List<Group> _getFilteredGroups() {
    switch (selectedFilter) {
      case 'available':
        return controller.groupsWithSpace;
      case 'full':
        return controller.fullGroups;
      default:
        return controller.groups;
    }
  }
}
