import 'package:get/get.dart';
import 'package:vally_app/app/feature/course/data/repositories/course/course_repository_impl.dart';
import 'package:vally_app/app/feature/course/data/repositories/group/group_repository_impl.dart';
import 'package:vally_app/app/feature/course/data/repositories/course/category_repository_imp.dart';
import 'package:vally_app/app/feature/course/domain/repositories/course_repository.dart';
import 'package:vally_app/app/feature/course/domain/repositories/group_repository.dart';
import 'package:vally_app/app/feature/course/domain/repositories/category_repository.dart';
import 'package:vally_app/app/feature/course/domain/usecases/course/get_courses.dart';
import 'package:vally_app/app/feature/course/domain/usecases/course/get_course_by_id.dart';
import 'package:vally_app/app/feature/course/domain/usecases/course/update_invitation_code.dart';
import 'package:vally_app/app/feature/course/domain/usecases/group/get_groups_by_category.dart';
import 'package:vally_app/app/feature/course/domain/usecases/group/get_groups_by_course.dart';
import 'package:vally_app/app/feature/course/domain/usecases/group/add_group.dart';
import 'package:vally_app/app/feature/course/domain/usecases/group/update_group.dart';
import 'package:vally_app/app/feature/course/domain/usecases/group/delete_group.dart';
import 'package:vally_app/app/feature/course/domain/usecases/group/join_group.dart';
import 'package:vally_app/app/feature/course/domain/usecases/group/leave_group.dart';
import 'package:vally_app/app/feature/course/domain/usecases/group/create_groups_for_category.dart';
import 'package:vally_app/app/feature/course/domain/usecases/category/get_categories_by_course.dart';
import 'package:vally_app/app/feature/course/domain/usecases/category/add_category.dart';
import 'package:vally_app/app/feature/course/domain/usecases/category/update_category.dart';
import 'package:vally_app/app/feature/course/domain/usecases/category/delete_category.dart';

class DependencyInjection {
  static void init() {
    print('Initializing dependency injection...');

    // Repositories
    Get.lazyPut<CourseRepository>(() => CourseRepositoryImpl());
    Get.lazyPut<GroupRepository>(() => GroupRepositoryImpl());
    Get.lazyPut<CategoryRepository>(() => CategoryRepositoryImpl());

    // Course Use Cases - Use put instead of lazyPut for critical dependencies
    Get.lazyPut<GetCourses>(() => GetCourses(Get.find<CourseRepository>()));
    Get.put<GetCourseById>(GetCourseById(Get.find<CourseRepository>()),
        permanent: true);
    Get.put<UpdateInvitationCode>(
        UpdateInvitationCode(Get.find<CourseRepository>()),
        permanent: true);

    // Group Use Cases - Use put for critical dependencies
    Get.put<GetGroupsByCategory>(
        GetGroupsByCategory(Get.find<GroupRepository>()),
        permanent: true);
    Get.lazyPut<GetGroupsByCourse>(
        () => GetGroupsByCourse(Get.find<GroupRepository>()));
    Get.lazyPut<AddGroup>(() => AddGroup(Get.find<GroupRepository>()));
    Get.lazyPut<UpdateGroup>(() => UpdateGroup(Get.find<GroupRepository>()));
    Get.lazyPut<DeleteGroup>(() => DeleteGroup(Get.find<GroupRepository>()));
    Get.lazyPut<JoinGroup>(() => JoinGroup(Get.find<GroupRepository>()));
    Get.lazyPut<LeaveGroup>(() => LeaveGroup(Get.find<GroupRepository>()));
    Get.lazyPut<CreateGroupsForCategory>(
        () => CreateGroupsForCategory(Get.find<GroupRepository>()));

    // Category Use Cases - Use put for critical dependencies
    Get.put<GetCategoriesByCourse>(
        GetCategoriesByCourse(Get.find<CategoryRepository>()),
        permanent: true);
    Get.put<AddCategory>(AddCategory(Get.find<CategoryRepository>()),
        permanent: true);
    Get.put<UpdateCategory>(UpdateCategory(Get.find<CategoryRepository>()),
        permanent: true);
    Get.put<DeleteCategory>(DeleteCategory(Get.find<CategoryRepository>()),
        permanent: true);

    print('Dependency injection initialized successfully');
  }
}
