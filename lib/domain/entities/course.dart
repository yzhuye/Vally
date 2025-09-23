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
  final int punctuality; // 0-5 estrellas - Puntualidad
  final int contributions; // 0-5 estrellas - Contribuciones
  final int commitment; // 0-5 estrellas - Compromiso
  final int attitude; // 0-5 estrellas - Actitud
  final DateTime createdAt;

  Evaluation({
    required this.id,
    required this.activityId,
    required this.evaluatorId,
    required this.evaluatedId,
    required this.punctuality,
    required this.contributions,
    required this.commitment,
    required this.attitude,
    required this.createdAt,
  });

  bool get isValid =>
      _isValidMetric(punctuality) &&
      _isValidMetric(contributions) &&
      _isValidMetric(commitment) &&
      _isValidMetric(attitude);

  bool _isValidMetric(int metric) => metric >= 0 && metric <= 5;

  double get averageRating =>
      (punctuality + contributions + commitment + attitude) / 4.0;
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
