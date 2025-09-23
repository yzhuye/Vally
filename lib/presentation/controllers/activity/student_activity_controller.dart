import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/entities/course.dart';
import '../../../domain/usecases/activity/get_activities_by_category.dart';
import '../../../domain/usecases/evaluation/create_evaluation.dart';
import '../../../domain/usecases/evaluation/get_evaluations_by_evaluator.dart';
import '../../../domain/usecases/evaluation/check_evaluation_eligibility.dart';
import '../../../data/repositories/activity/activity_repository_impl.dart';
import '../../../data/repositories/evaluation/evaluation_repository_impl.dart';
import '../../../data/repositories/group/group_repository_impl.dart';
import '../../../domain/repositories/activity_repository.dart';
import '../../../domain/repositories/evaluation_repository.dart';
import '../../../domain/repositories/group_repository.dart';

class StudentActivityController extends GetxController {
  final String categoryId;
  final String courseId;
  final String studentEmail;

  late final GetActivitiesByCategoryUseCase _getActivitiesUseCase;
  late final CreateEvaluationUseCase _createEvaluationUseCase;
  late final GetEvaluationsByEvaluatorUseCase _getEvaluationsByEvaluatorUseCase;
  late final CheckEvaluationEligibilityUseCase _checkEligibilityUseCase;

  var activities = <Activity>[].obs;
  var myEvaluations = <Evaluation>[].obs;
  var isLoading = false.obs;

  StudentActivityController({
    required this.categoryId,
    required this.courseId,
    required this.studentEmail,
  }) {
    final ActivityRepository activityRepository = ActivityRepositoryImpl();
    final EvaluationRepository evaluationRepository = EvaluationRepositoryImpl();
    final GroupRepository groupRepository = GroupRepositoryImpl();

    _getActivitiesUseCase = GetActivitiesByCategoryUseCase(activityRepository);
    _createEvaluationUseCase = CreateEvaluationUseCase(evaluationRepository, activityRepository);
    _getEvaluationsByEvaluatorUseCase = GetEvaluationsByEvaluatorUseCase(evaluationRepository);
    _checkEligibilityUseCase = CheckEvaluationEligibilityUseCase(
      evaluationRepository,
      activityRepository,
      groupRepository,
    );
  }

  @override
  void onInit() {
    super.onInit();
    loadActivities();
    loadMyEvaluations();
  }

  void loadActivities() {
    isLoading(true);
    try {
      final result = _getActivitiesUseCase(categoryId: categoryId);
      if (result.isSuccess) {
        activities.value = result.activities;
      }
    } finally {
      isLoading(false);
    }
  }

  void loadMyEvaluations() {
    try {
      final result = _getEvaluationsByEvaluatorUseCase(evaluatorId: studentEmail);
      if (result.isSuccess) {
        myEvaluations.value = result.evaluations;
      }
    } catch (e) {
      // Handle silently for now
    }
  }

  Future<bool> createEvaluation({
    required String activityId,
    required String evaluatedId,
    required int metric1,
    required int metric2,
    required int metric3,
    required int metric4,
    required int metric5,
    String? comments,
  }) async {
    isLoading(true);

    try {
      print('🚀 Creating evaluation...');
      print('   Activity ID: $activityId');
      print('   Evaluator: $studentEmail');
      print('   Evaluated: $evaluatedId');
      print('   Metrics: [$metric1, $metric2, $metric3, $metric4, $metric5]');
      
      final result = await _createEvaluationUseCase(
        activityId: activityId,
        evaluatorId: studentEmail,
        evaluatedId: evaluatedId,
        metric1: metric1,
        metric2: metric2,
        metric3: metric3,
        metric4: metric4,
        metric5: metric5,
        comments: comments,
      );

      print('📊 Evaluation result: ${result.isSuccess}');
      print('📝 Message: ${result.message}');

      if (result.isSuccess) {
        loadMyEvaluations();
        Get.snackbar(
          'Éxito',
          result.message,
          backgroundColor: const Color(0xFF4FC3F7),
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle, color: Colors.white),
          duration: const Duration(seconds: 2),
        );
        return true;
      } else {
        Get.snackbar(
          'Error',
          result.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
        return false;
      }
    } catch (e) {
      print('💥 Exception creating evaluation: $e');
      Get.snackbar(
        'Error',
        'Error inesperado: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
      return false;
    } finally {
      isLoading(false);
    }
  }

  bool canEvaluateStudent(String activityId, String evaluatedId) {
    final result = _checkEligibilityUseCase(
      activityId: activityId,
      courseId: courseId,
      evaluatorId: studentEmail,
      evaluatedId: evaluatedId,
    );
    return result.isEligible;
  }

  String getEligibilityMessage(String activityId, String evaluatedId) {
    final result = _checkEligibilityUseCase(
      activityId: activityId,
      courseId: courseId,
      evaluatorId: studentEmail,
      evaluatedId: evaluatedId,
    );
    return result.message;
  }

  bool hasEvaluated(String activityId, String evaluatedId) {
    return myEvaluations.any((eval) =>
        eval.activityId == activityId && eval.evaluatedId == evaluatedId);
  }

  List<Evaluation> getEvaluationsForActivity(String activityId) {
    return myEvaluations.where((eval) => eval.activityId == activityId).toList();
  }

  int getEvaluationCountForActivity(String activityId) {
    return getEvaluationsForActivity(activityId).length;
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

  bool isActivityExpired(DateTime dueDate) {
    return dueDate.isBefore(DateTime.now());
  }
}
