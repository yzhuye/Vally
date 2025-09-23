import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/entities/course.dart';
import '../../controllers/professor/professor_group_controller.dart';
import '../../widgets/course/course_detail_header.dart';

class StudentManagementScreen extends StatefulWidget {
  final Course course;
  final Category category;

  const StudentManagementScreen({
    super.key,
    required this.course,
    required this.category,
  });

  @override
  State<StudentManagementScreen> createState() =>
      _StudentManagementScreenState();
}

class _StudentManagementScreenState extends State<StudentManagementScreen> {
  late ProfessorGroupController controller;
  String selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    controller = Get.find<ProfessorGroupController>(
      tag: 'professor_groups_${widget.course.id}_${widget.category.id}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Column(
        children: [
          CourseDetailHeader(
            course: widget.course,
            screenTitle: 'Gestión de Estudiantes - ${widget.category.name}',
          ),

          // Estadísticas
          _buildStatsCard(),

          // Filtros
          _buildFilterChips(),

          // Lista de estudiantes
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final filteredStudents = _getFilteredStudents();

              if (filteredStudents.isEmpty) {
                return _buildEmptyState();
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: filteredStudents.length,
                itemBuilder: (context, index) {
                  final studentEmail = filteredStudents[index];
                  return _buildStudentCard(studentEmail);
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
                'Total Estudiantes',
                '${controller.students.length}',
                Icons.people,
              ),
              _buildStatItem(
                'En Grupos',
                '${controller.students.length - controller.getStudentsNotInAnyGroup().length}',
                Icons.group,
              ),
              _buildStatItem(
                'Sin Grupo',
                '${controller.getStudentsNotInAnyGroup().length}',
                Icons.person_off,
              ),
              _buildStatItem(
                'Total Grupos',
                '${controller.totalGroups}',
                Icons.folder,
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
                _buildFilterChip('assigned', 'En Grupos', Icons.group),
                _buildFilterChip('unassigned', 'Sin Grupo', Icons.person_off),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              controller.loadStudents();
              controller.loadGroups();
            },
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar',
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
            Icons.people_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            selectedFilter == 'unassigned'
                ? 'Todos los estudiantes están asignados a grupos'
                : 'No hay estudiantes en este curso',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentCard(String studentEmail) {
    final currentGroup = controller.findStudentGroup(studentEmail);
    final isAssigned = currentGroup != null;

    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isAssigned ? Colors.green : Colors.orange,
          child: Icon(
            isAssigned ? Icons.group : Icons.person,
            color: Colors.white,
          ),
        ),
        title: Text(
          studentEmail,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isAssigned) ...[
              Text('Grupo: ${currentGroup.name}'),
              Text(
                  'Capacidad: ${currentGroup.members.length}/${currentGroup.maxCapacity}'),
            ] else ...[
              const Text('Sin grupo asignado',
                  style: TextStyle(color: Colors.orange)),
            ],
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (action) =>
              _handleStudentAction(action, studentEmail, currentGroup),
          itemBuilder: (context) => [
            if (isAssigned) ...[
              const PopupMenuItem(
                value: 'move',
                child: Row(
                  children: [
                    Icon(Icons.swap_horiz),
                    SizedBox(width: 8),
                    Text('Cambiar de grupo'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'remove',
                child: Row(
                  children: [
                    Icon(Icons.person_remove),
                    SizedBox(width: 8),
                    Text('Quitar del grupo'),
                  ],
                ),
              ),
            ] else ...[
              const PopupMenuItem(
                value: 'assign',
                child: Row(
                  children: [
                    Icon(Icons.person_add),
                    SizedBox(width: 8),
                    Text('Asignar a grupo'),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _handleStudentAction(
      String action, String studentEmail, Group? currentGroup) {
    switch (action) {
      case 'assign':
        _showAssignToGroupDialog(studentEmail);
        break;
      case 'move':
        if (currentGroup != null) {
          _showMoveToGroupDialog(studentEmail, currentGroup);
        }
        break;
      case 'remove':
        if (currentGroup != null) {
          _removeFromGroup(studentEmail, currentGroup);
        }
        break;
    }
  }

  void _showAssignToGroupDialog(String studentEmail) {
    final availableGroups = controller.groupsWithSpace;

    if (availableGroups.isEmpty) {
      Get.snackbar(
        'Sin grupos disponibles',
        'No hay grupos con espacio disponible',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Asignar $studentEmail'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: availableGroups.map((group) {
            final stats = controller.getGroupStats(group);
            return ListTile(
              title: Text(group.name),
              subtitle: Text(
                  '${stats['membersCount']}/${stats['maxCapacity']} estudiantes'),
              trailing: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  controller.assignStudentToGroup(studentEmail, group.id);
                },
                child: const Text('Asignar'),
              ),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void _showMoveToGroupDialog(String studentEmail, Group currentGroup) {
    final availableGroups = controller.groupsWithSpace
        .where((group) => group.id != currentGroup.id)
        .toList();

    if (availableGroups.isEmpty) {
      Get.snackbar(
        'Sin grupos disponibles',
        'No hay otros grupos con espacio disponible',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Mover $studentEmail'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: availableGroups.map((group) {
            final stats = controller.getGroupStats(group);
            return ListTile(
              title: Text(group.name),
              subtitle: Text(
                  '${stats['membersCount']}/${stats['maxCapacity']} estudiantes'),
              trailing: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  controller.moveStudentToGroup(
                      studentEmail, currentGroup.id, group.id);
                },
                child: const Text('Mover'),
              ),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void _removeFromGroup(String studentEmail, Group group) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar'),
        content: Text(
            '¿Está seguro de que desea quitar a $studentEmail del ${group.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();

              // Simulamos la remoción creando un grupo temporal sin el estudiante
              final updatedGroup = Group(
                id: group.id,
                name: group.name,
                maxCapacity: group.maxCapacity,
                members: group.members
                    .where((member) => member != studentEmail)
                    .toList(),
                categoryId: group.categoryId,
              );

              // Actualizar el grupo en el repositorio
              final repository = controller.groupRepository;
              repository.updateGroup(widget.course.id, updatedGroup);

              // Recargar datos
              controller.loadGroups();

              Get.snackbar(
                'Éxito',
                'Estudiante removido del grupo',
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Quitar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  List<String> _getFilteredStudents() {
    switch (selectedFilter) {
      case 'assigned':
        return controller.students
            .where((student) => controller.findStudentGroup(student) != null)
            .toList();
      case 'unassigned':
        return controller.getStudentsNotInAnyGroup();
      default:
        return controller.students;
    }
  }
}
