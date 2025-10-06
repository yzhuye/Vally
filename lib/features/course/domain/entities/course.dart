import 'package:vally_app/features/course/application/dto/course.dto.dart';

class Course {
  final String id;
  final String title;
  final String description;
  final List<String> enrolledStudents;
  final List<Category> categories;
  final List<Group> groups;
  final String invitationCode;
  final String? imageUrl;
  final String createdBy;

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

  factory Course.fromJson(Map<String, dynamic> json) {
    try {
      final dto = CourseDto.fromJson(json);
      return Course.fromDto(dto);
    } catch (e) {
      throw Exception('Error parsing Course JSON: $e');
    }
  }

  factory Course.fromDto(CourseDto dto) {
    return Course(
      id: dto.id,
      title: dto.title,
      description: dto.description,
      enrolledStudents: dto.enrolledStudents,
      categories: dto.categories.map((c) => Category.fromDto(c)).toList(),
      groups: dto.groups.map((g) => Group.fromDto(g)).toList(),
      invitationCode: dto.invitationCode,
      imageUrl: dto.imageUrl,
      createdBy: dto.createdBy,
    );
  }
}

class Category {
  final String id;
  String name;
  String groupingMethod; // "self-assigned" | "manual"
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

  factory Category.fromDto(CategoryDto dto) {
    return Category(
      id: dto.id,
      name: dto.name,
      groupingMethod: dto.groupingMethod,
      groupCount: dto.groupCount,
      studentsPerGroup: dto.studentsPerGroup,
      activities: dto.activities.map((a) => Activity.fromDto(a)).toList(),
    );
  }
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

  factory Activity.fromDto(ActivityDto dto) {
    return Activity(
      id: dto.id,
      name: dto.name,
      description: dto.description,
      dueDate: dto.dueDate,
      categoryId: dto.categoryId,
      evaluations: dto.evaluations.map((e) => Evaluation.fromDto(e)).toList(),
    );
  }
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

  factory Evaluation.fromDto(EvaluationDto dto) {
    return Evaluation(
      id: dto.id,
      activityId: dto.activityId,
      evaluatorId: dto.evaluatorId,
      evaluatedId: dto.evaluatedId,
      punctuality: dto.punctuality,
      contributions: dto.contributions,
      commitment: dto.commitment,
      attitude: dto.attitude,
      createdAt: dto.createdAt,
    );
  }

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

  factory Group.fromDto(GroupDto dto) {
    return Group(
      id: dto.id,
      name: dto.name,
      maxCapacity: dto.maxCapacity,
      members: dto.members,
      categoryId: dto.categoryId,
    );
  }

  bool get isFull => members.length >= maxCapacity;
  String get status => isFull ? 'Full' : 'Join';
  String get capacityText => '${members.length}/$maxCapacity';
}

class Student {
  final String id;
  final String name;
  final String email;

  Student({required this.id, required this.name, required this.email});

  factory Student.fromDto(StudentDto dto) {
    return Student(
      id: dto.id,
      name: dto.name,
      email: dto.email,
    );
  }
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

  factory InvitationRequest.fromDto(InvitationRequestDto dto) {
    return InvitationRequest(
      name: dto.name,
      email: dto.email,
      code: dto.code,
    );
  }
}
