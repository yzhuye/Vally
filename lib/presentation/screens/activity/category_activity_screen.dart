import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/entities/course.dart';
import '../../widgets/course/course_detail_header.dart';
import '../../widgets/group/group_card.dart';
import '../../controllers/group/group_controller.dart';
import '../../controllers/home/home_controller.dart';

class CategoryActivityScreen extends StatefulWidget {
  final Course course;
  final Category category;

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
  GroupController? groupController;
  late String studentEmail;
  late String controllerTag;

  @override
  void initState() {
    super.initState();

    final homeController = Get.find<HomeController>();
    studentEmail = homeController.currentUser.value?.email ?? '';

    if (widget.category.groupingMethod == 'self-assigned') {
      controllerTag = '${widget.course.id}_${widget.category.id}_$studentEmail';

      if (Get.isRegistered<GroupController>(tag: controllerTag)) {
        Get.delete<GroupController>(tag: controllerTag);
      }

      groupController = Get.put(
        GroupController(
          courseId: widget.course.id,
          categoryId: widget.category.id,
          studentEmail: studentEmail,
        ),
        tag: controllerTag,
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (groupController != null) {
      groupController!.loadGroups();
    }
  }

  @override
  void dispose() {
    if (groupController != null &&
        Get.isRegistered<GroupController>(tag: controllerTag)) {
      Get.delete<GroupController>(tag: controllerTag);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Column(
        children: [
          CourseDetailHeader(
            course: widget.course,
            screenTitle: widget.category.name,
          ),
          if (widget.category.groupingMethod == 'self-assigned')
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      if (groupController != null) {
                        groupController!.loadGroups();
                      }
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Actualizar grupos'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00A4BD),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Actividades"),
                        if (widget.category.groupingMethod ==
                            'self-assigned') ...[
                          const SizedBox(width: 4),
                          Obx(() => groupController?.currentGroup != null
                              ? const Icon(Icons.check_circle, size: 16)
                              : const SizedBox.shrink()),
                        ],
                      ],
                    ),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Grupos"),
                        if (widget.category.groupingMethod ==
                            'self-assigned') ...[
                          const SizedBox(width: 4),
                          Obx(() => Icon(
                                groupController?.currentGroup != null
                                    ? Icons.group
                                    : Icons.group_outlined,
                                size: 16,
                              )),
                        ],
                      ],
                    ),
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
    if (widget.category.groupingMethod == 'self-assigned') {
      if (groupController?.currentGroup == null) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.group_off,
                size: 64,
                color: Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                "Debes unirte a un grupo para ver las actividades.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }
    }

    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            "Todavía no hay actividades disponibles.",
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGroupsView() {
    if (widget.category.groupingMethod != 'self-assigned') {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.info_outline,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'Esta categoría usa método "${widget.category.groupingMethod}".\nLos grupos no están disponibles para auto-asignación.',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (groupController == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Obx(() {
      if (groupController!.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (groupController!.groups.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.group_off,
                size: 64,
                color: Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                'No hay grupos disponibles para esta categoría.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: groupController!.groups.length,
        itemBuilder: (context, index) {
          final group = groupController!.groups[index];
          final isCurrentGroup = groupController!.currentGroup?.id == group.id;
          final canJoin = groupController!.canJoinGroup(group);

          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: GroupCard(
              group: group,
              currentUserEmail: studentEmail,
              canJoin: canJoin,
              onJoin: () async {
                if (isCurrentGroup) {
                  await groupController!.leaveGroup(group.id);
                } else if (canJoin) {
                  await groupController!.joinGroup(group.id);
                }
              },
            ),
          );
        },
      );
    });
  }
}
