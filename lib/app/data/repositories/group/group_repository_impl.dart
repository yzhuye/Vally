import '../../../domain/entities/course.dart';
import '../../../domain/services/group_repository.dart';
// import '../datasources/group_local_datasource.dart';

// class GroupRepositoryImpl implements GroupRepository {
//   final GroupLocalDataSource localDataSource;

//   GroupRepositoryImpl(this.localDataSource);

//   @override
//   Future<List<Group>> getGroupsByCategory(String categoryId) {
//     return localDataSource.getGroupsByCategory(categoryId);
//   }

//   @override
//   Future<void> joinGroup(String groupId, String studentName) async {
//     final groups = await localDataSource.getGroupsByCategory(groupId);
//     final groupIndex = groups.indexWhere((g) => g.id == groupId);
//     if (groupIndex != -1 && !groups[groupIndex].isFull) {
//       groups[groupIndex].members.add(studentName);
//       await localDataSource.saveGroups(groups[groupIndex].categoryId, groups);
//     }
//   }
// }
