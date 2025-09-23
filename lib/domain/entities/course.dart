class Course {
  final String id;
  final String title;
  final String description;
  final List<String> enrolledStudents;
  final List<Category> categories;
  final List<Group> groups;
  final String invitationCode;
  final String? imageUrl; // Mantener compatibilidad con la versión anterior
  final String createdBy; // Email del usuario que creó el curso

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.enrolledStudents,
    this.categories = const [],
    this.groups = const [],
    required this.invitationCode,
    this.imageUrl,
    required this.createdBy,
  });
}

class Category {
  final String id;
  String name;
  String groupingMethod; // "random" | "self-assigned" | "manual"
  int groupCount;
  int studentsPerGroup;
  final List<Activity> activities;

  Category(
      {required this.id,
      required this.name,
      required this.groupingMethod,
      required this.groupCount,
      required this.studentsPerGroup,
      this.activities = const []});
}

class Activity {
  final String id;
  final String name;
  final String description;
  final DateTime dueDate;
  final String categoryId;
  final List<Evaluation> evaluations;

  Activity({
    required this.id,
    required this.name,
    required this.description,
    required this.dueDate,
    required this.categoryId,
    this.evaluations = const [],
  });
}

class Evaluation {
  final String id;
  final String activityId;
  final String evaluatorId; // ID del estudiante que evalúa
  final String evaluatedId; // ID del estudiante evaluado
  final int metric1; // 0-5 estrellas
  final int metric2; // 0-5 estrellas
  final int metric3; // 0-5 estrellas
  final int metric4; // 0-5 estrellas
  final int metric5; // 0-5 estrellas
  final String? comments; // Comentarios opcionales
  final DateTime createdAt;

  Evaluation({
    required this.id,
    required this.activityId,
    required this.evaluatorId,
    required this.evaluatedId,
    required this.metric1,
    required this.metric2,
    required this.metric3,
    required this.metric4,
    required this.metric5,
    this.comments,
    required this.createdAt,
  });

  // Validar que las métricas estén en el rango correcto
  bool get isValid =>
      _isValidMetric(metric1) &&
      _isValidMetric(metric2) &&
      _isValidMetric(metric3) &&
      _isValidMetric(metric4) &&
      _isValidMetric(metric5);

  bool _isValidMetric(int metric) => metric >= 0 && metric <= 5;

  // Calcular promedio de las métricas
  double get averageRating =>
      (metric1 + metric2 + metric3 + metric4 + metric5) / 5.0;
}

class Group {
  final String id;
  final String name;
  final int maxCapacity;
  final List<String> members;
  final String categoryId;

  Group({
    required this.id,
    required this.name,
    required this.maxCapacity,
    this.members = const [],
    required this.categoryId,
  });

  bool get isFull => members.length >= maxCapacity;
  String get status => isFull ? 'Full' : 'Join';
  String get capacityText => '${members.length}/$maxCapacity';
}

class Student {
  final String id;
  final String name;
  final String email;

  Student({required this.id, required this.name, required this.email});
}

class InvitationRequest {
  final String name;
  final String email;
  final String code;

  InvitationRequest({
    required this.name,
    required this.email,
    required this.code,
  });
}
