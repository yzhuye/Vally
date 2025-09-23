import 'package:vally_app/domain/entities/course.dart';
import '../../../domain/repositories/group_repository.dart';
import 'package:hive/hive.dart';
import '../../models/group_hive_model.dart';

class GroupRepositoryImpl implements GroupRepository {
  static const _boxName = 'groups';
  late final Box<GroupHiveModel> _box;

  GroupRepositoryImpl() {
    _box = Hive.box<GroupHiveModel>(_boxName);
  }

  @override
  List<Group> getGroupsByCategory(String courseId, String categoryId) {
    return _box.values
        .where((g) => g.courseId == courseId && g.categoryId == categoryId)
        .map((g) => g.toGroup())
        .toList();
  }

  @override
  List<Group> getGroupsByCourse(String courseId) {
    return _box.values
        .where((g) => g.courseId == courseId)
        .map((g) => g.toGroup())
        .toList();
  }

  @override
  Future<void> addGroup(String courseId, Group group) async {
    final groupHive = GroupHiveModel.fromGroup(group, courseId);
    await _box.put(group.id, groupHive);
  }

  @override
  void updateGroup(String courseId, Group group) async {
    final groupHive = GroupHiveModel.fromGroup(group, courseId);
    await _box.put(group.id, groupHive);
  }

  @override
  void deleteGroup(String courseId, String groupId) async {
    await _box.delete(groupId);
  }

  @override
  bool joinGroup(String courseId, String groupId, String studentEmail) {
    final groupHive = _box.get(groupId);
    if (groupHive == null) return false;

    if (groupHive.members.contains(studentEmail)) return false;

    if (groupHive.members.length >= groupHive.maxCapacity) return false;

    groupHive.members.add(studentEmail);
    groupHive.save();

    return true;
  }

  @override
  bool leaveGroup(String courseId, String groupId, String studentEmail) {
    final groupHive = _box.get(groupId);
    if (groupHive == null) return false;

    final removed = groupHive.members.remove(studentEmail);
    if (removed) {
      groupHive.save();
    }

    return removed;
  }

  @override
  Future<void> createGroupsForCategory(
      String courseId, String categoryId, int groupCount, int studentsPerGroup,
      {String? categoryName}) async {
    for (int i = 1; i <= groupCount; i++) {
      final group = Group(
        id: '${categoryId}_group_$i',
        name: categoryName != null ? '$categoryName - Grupo $i' : 'Grupo $i',
        maxCapacity: studentsPerGroup,
        members: [],
        categoryId: categoryId,
      );

      await addGroup(courseId, group);
    }
  }

  @override
  bool assignStudentToGroup(String courseId, String groupId, String studentEmail) {
    final groupHive = _box.get(groupId);
    if (groupHive == null) return false;

    // Verificar que el grupo no esté lleno
    if (groupHive.members.length >= groupHive.maxCapacity) return false;

    // Verificar que el estudiante no esté ya en el grupo
    if (groupHive.members.contains(studentEmail)) return false;

    // Remover el estudiante de cualquier otro grupo en la misma categoría
    final allGroups = _box.values.where((g) => 
        g.courseId == courseId && g.categoryId == groupHive.categoryId).toList();
    
    for (final otherGroup in allGroups) {
      if (otherGroup.id != groupId && otherGroup.members.contains(studentEmail)) {
        otherGroup.members.remove(studentEmail);
        otherGroup.save();
      }
    }

    // Agregar el estudiante al grupo
    groupHive.members.add(studentEmail);
    groupHive.save();

    return true;
  }

  @override
  bool moveStudentToGroup(String courseId, String fromGroupId, String toGroupId, String studentEmail) {
    // Primero remover del grupo origen
    final fromGroupHive = _box.get(fromGroupId);
    if (fromGroupHive == null || !fromGroupHive.members.contains(studentEmail)) {
      return false;
    }

    // Verificar que el grupo destino no esté lleno
    final toGroupHive = _box.get(toGroupId);
    if (toGroupHive == null || toGroupHive.members.length >= toGroupHive.maxCapacity) {
      return false;
    }

    // Remover del grupo origen
    fromGroupHive.members.remove(studentEmail);
    fromGroupHive.save();

    // Agregar al grupo destino
    toGroupHive.members.add(studentEmail);
    toGroupHive.save();

    return true;
  }

  @override
  Group? findStudentGroup(String courseId, String categoryId, String studentEmail) {
    final groupHive = _box.values.firstWhere(
      (g) => g.courseId == courseId && 
             g.categoryId == categoryId && 
             g.members.contains(studentEmail),
      orElse: () => throw StateError('No group found'),
    );
    
    try {
      return groupHive.toGroup();
    } catch (e) {
      return null;
    }
  }
}
