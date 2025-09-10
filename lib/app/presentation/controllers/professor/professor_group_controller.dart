import 'package:get/get.dart';
import '../../../domain/entities/course.dart';
import '../../../domain/usecases/group/get_groups_by_category.dart';
import '../../../data/repositories/group/group_repository_impl.dart';
import '../../../domain/repositories/group_repository.dart';

class ProfessorGroupController extends GetxController {
  final String courseId;
  final String categoryId;

  late final GetGroupsByCategoryUseCase _getGroupsUseCase;

  var groups = <Group>[].obs;
  var isLoading = false.obs;
  var selectedCategory = Rxn<Category>();

  ProfessorGroupController({
    required this.courseId,
    required this.categoryId,
  }) {
    final GroupRepository repository = GroupRepositoryImpl();
    _getGroupsUseCase = GetGroupsByCategoryUseCase(repository);
  }

  @override
  void onInit() {
    super.onInit();
    loadGroups();
  }

  void loadGroups() {
    isLoading(true);
    try {
      groups.value = _getGroupsUseCase(
        courseId: courseId,
        categoryId: categoryId,
      );
    } finally {
      isLoading(false);
    }
  }

  void setCategory(Category category) {
    selectedCategory.value = category;
    loadGroups();
  }

  int get totalGroups => groups.length;
  int get totalStudents =>
      groups.fold(0, (sum, group) => sum + group.members.length);
  int get totalCapacity =>
      groups.fold(0, (sum, group) => sum + group.maxCapacity);
  double get occupancyRate =>
      totalCapacity > 0 ? (totalStudents / totalCapacity) * 100 : 0.0;

  List<Group> get groupsWithSpace =>
      groups.where((group) => !group.isFull).toList();

  List<Group> get fullGroups => groups.where((group) => group.isFull).toList();

  List<Group> getGroupsByStatus(String status) {
    switch (status) {
      case 'available':
        return groupsWithSpace;
      case 'full':
        return fullGroups;
      default:
        return groups;
    }
  }

  Map<String, dynamic> getGroupStats(Group group) {
    return {
      'membersCount': group.members.length,
      'maxCapacity': group.maxCapacity,
      'occupancyRate': (group.members.length / group.maxCapacity) * 100,
      'isFull': group.isFull,
      'hasSpace': !group.isFull,
    };
  }
}
