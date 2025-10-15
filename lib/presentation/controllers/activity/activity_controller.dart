import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/entities/course.dart';
import '../../../domain/usecases/activity/create_activity.dart';
import '../../../domain/usecases/activity/get_activities_by_category.dart';
import '../../../domain/usecases/activity/get_activity_by_id.dart';
import '../../../domain/usecases/activity/update_activity.dart';
import '../../../domain/usecases/activity/delete_activity.dart';
import '../../../data/repositories/activity/activity_repository_impl.dart';
import '../../../domain/repositories/activity_repository.dart';

class ActivityController extends GetxController {
  final String categoryId;

  late final CreateActivityUseCase _createActivityUseCase;
  late final GetActivitiesByCategoryUseCase _getActivitiesUseCase;
  late final GetActivityByIdUseCase _getActivityByIdUseCase;
  late final UpdateActivityUseCase _updateActivityUseCase;
  late final DeleteActivityUseCase _deleteActivityUseCase;

  var activities = <Activity>[].obs;
  var isLoading = false.obs;

  ActivityController({required this.categoryId}) {
    final ActivityRepository repository = ActivityRepositoryImpl();
    _createActivityUseCase = CreateActivityUseCase(repository);
    _getActivitiesUseCase = GetActivitiesByCategoryUseCase(repository);
    _getActivityByIdUseCase = GetActivityByIdUseCase(repository);
    _updateActivityUseCase = UpdateActivityUseCase(repository);
    _deleteActivityUseCase = DeleteActivityUseCase(repository);
  }

  @override
  void onInit() {
    super.onInit();
    loadActivities();
  }

  void loadActivities() async {
    isLoading(true);
    try {
      final result = await _getActivitiesUseCase(categoryId: categoryId);
      if (result.isSuccess) {
        activities.value = result.activities;
      } else {
        Get.snackbar(
          'Error',
          result.message ?? 'Error al cargar actividades',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error inesperado: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> createActivity({
    required String name,
    required String description,
    required DateTime dueDate,
  }) async {
    isLoading(true);

    try {
      final result = await _createActivityUseCase(
        name: name,
        description: description,
        dueDate: dueDate,
        categoryId: categoryId,
      );

      if (result.isSuccess) {
        loadActivities();
        Get.snackbar(
          'Éxito',
          result.message,
          backgroundColor: const Color(0xFF4FC3F7),
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle, color: Colors.white),
        );
      } else {
        Get.snackbar(
          'Error',
          result.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error inesperado: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateActivity({
    required String activityId,
    required String name,
    required String description,
    required DateTime dueDate,
  }) async {
    isLoading(true);

    try {
      final result = await _updateActivityUseCase(
        activityId: activityId,
        name: name,
        description: description,
        dueDate: dueDate,
      );

      if (result.isSuccess) {
        loadActivities();
        Get.snackbar(
          'Éxito',
          result.message,
          backgroundColor: const Color(0xFF4FC3F7),
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle, color: Colors.white),
        );
      } else {
        Get.snackbar(
          'Error',
          result.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error inesperado: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteActivity(String activityId) async {
    isLoading(true);

    try {
      final result = await _deleteActivityUseCase(activityId: activityId);

      if (result.isSuccess) {
        loadActivities();
        Get.snackbar(
          'Éxito',
          result.message,
          backgroundColor: const Color(0xFF4FC3F7),
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle, color: Colors.white),
        );
      } else {
        Get.snackbar(
          'Error',
          result.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error inesperado: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<Activity?> getActivityById(String activityId) async {
    final result = await _getActivityByIdUseCase(activityId: activityId);
    return result.isSuccess ? result.activity : null;
  }

  String formatDueDate(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now);

    if (difference.isNegative) {
      return 'Vencida';
    } else if (difference.inDays == 0) {
      return 'Vence hoy';
    } else if (difference.inDays == 1) {
      return 'Vence mañana';
    } else if (difference.inDays < 7) {
      return 'Vence en ${difference.inDays} días';
    } else {
      return 'Vence el ${dueDate.day}/${dueDate.month}/${dueDate.year}';
    }
  }

  Color getDueDateColor(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now);

    if (difference.isNegative) {
      return Colors.red;
    } else if (difference.inDays <= 1) {
      return Colors.orange;
    } else if (difference.inDays <= 3) {
      return Colors.yellow[700]!;
    } else {
      return Colors.green;
    }
  }
}
