import '../../../domain/repositories/evaluation_repository.dart';
import '../../../domain/repositories/activity_repository.dart';
import '../../../domain/repositories/group_repository.dart';

class CheckEvaluationEligibilityUseCase {
  final EvaluationRepository _evaluationRepository;
  final ActivityRepository _activityRepository;
  final GroupRepository _groupRepository;

  CheckEvaluationEligibilityUseCase(
    this._evaluationRepository,
    this._activityRepository,
    this._groupRepository,
  );

  CheckEvaluationEligibilityResult call({
    required String activityId,
    required String courseId,
    required String evaluatorId,
    required String evaluatedId,
  }) {
    try {
      // Verificar que no sea auto-evaluación
      if (evaluatorId == evaluatedId) {
        return CheckEvaluationEligibilityResult.notEligible(
            'No puedes evaluarte a ti mismo.');
      }

      // Verificar que la actividad existe
      final activity = _activityRepository.getActivityById(activityId);
      if (activity == null) {
        return CheckEvaluationEligibilityResult.notEligible(
            'Actividad no encontrada.');
      }

      // Verificar que la actividad no ha vencido
      if (activity.dueDate.isBefore(DateTime.now())) {
        return CheckEvaluationEligibilityResult.notEligible(
            'La fecha límite para evaluar ha pasado.');
      }

      // Verificar que no haya evaluado antes
      if (_evaluationRepository.hasEvaluated(
          activityId, evaluatorId, evaluatedId)) {
        return CheckEvaluationEligibilityResult.notEligible(
            'Ya has evaluado a este compañero en esta actividad.');
      }

      // Verificar que ambos estudiantes estén en el mismo grupo de la categoría
      final groups =
          _groupRepository.getGroupsByCategory(courseId, activity.categoryId);

      // Convertir emails a nombres para comparar con los miembros
      final evaluatorName = _getNameForEmail(evaluatorId);
      final evaluatedName = _getNameForEmail(evaluatedId);

      // Debug: Print eligibility check
      print(
          '🔍 DEBUG Eligibility - Evaluator email: $evaluatorId, name: $evaluatorName');
      print(
          '🔍 DEBUG Eligibility - Evaluated email: $evaluatedId, name: $evaluatedName');

      String? evaluatorGroupId;
      String? evaluatedGroupId;

      for (final group in groups) {
        print(
            '🔍 DEBUG Eligibility - Group "${group.name}" members: ${group.members}');

        // Buscar tanto por email como por nombre
        final evaluatorInGroup = group.members.contains(evaluatorId) ||
            group.members.contains(evaluatorName);
        final evaluatedInGroup = group.members.contains(evaluatedId) ||
            group.members.contains(evaluatedName);

        print('🔍 DEBUG Eligibility - Evaluator in group? $evaluatorInGroup');
        print('🔍 DEBUG Eligibility - Evaluated in group? $evaluatedInGroup');

        if (evaluatorInGroup) {
          evaluatorGroupId = group.id;
        }
        if (evaluatedInGroup) {
          evaluatedGroupId = group.id;
        }
      }

      if (evaluatorGroupId == null) {
        return CheckEvaluationEligibilityResult.notEligible(
            'No perteneces a ningún grupo en esta categoría.');
      }

      if (evaluatedGroupId == null) {
        return CheckEvaluationEligibilityResult.notEligible(
            'El estudiante a evaluar no pertenece a ningún grupo.');
      }

      if (evaluatorGroupId != evaluatedGroupId) {
        return CheckEvaluationEligibilityResult.notEligible(
            'Solo puedes evaluar a compañeros de tu mismo grupo.');
      }

      return CheckEvaluationEligibilityResult.eligible(
          'Puedes evaluar a este compañero.');
    } catch (e) {
      return CheckEvaluationEligibilityResult.notEligible(
          'Error al verificar elegibilidad: $e');
    }
  }
}

class CheckEvaluationEligibilityResult {
  final bool isEligible;
  final String message;

  const CheckEvaluationEligibilityResult._({
    required this.isEligible,
    required this.message,
  });

  factory CheckEvaluationEligibilityResult.eligible(String message) =>
      CheckEvaluationEligibilityResult._(isEligible: true, message: message);

  factory CheckEvaluationEligibilityResult.notEligible(String message) =>
      CheckEvaluationEligibilityResult._(isEligible: false, message: message);
}

// Helper method to convert emails to names
String _getNameForEmail(String email) {
  final nameMappings = {
    'gabriela@example.com': 'gabriela',
    'b@a.com': 'betty',
    'c@a.com': 'camila',
    'daniela@example.com': 'daniela',
    'eliana@example.com': 'eliana',
    'fernanda@example.com': 'fernanda',
  };
  return nameMappings[email.toLowerCase()] ?? email;
}
