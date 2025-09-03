class Course {
  final String id;
  final String title;
  final String description;
  final List<String> enrolledStudents;
  final List<Category> categories;
  final List<Group> groups;
  final String invitationCode;
  final String? imageUrl; // Mantener compatibilidad con la versión anterior

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.enrolledStudents,
    this.categories = const [],
    this.groups = const [],
    required this.invitationCode,
    this.imageUrl,
  });
}

class Category {
  final String id;
  final String name;
  final List<Activity> activities;

  Category({required this.id, required this.name, this.activities = const []});
}

class Activity {
  final String id;
  final String name;
  final String description;
  final DateTime dueDate;

  Activity({
    required this.id,
    required this.name,
    required this.description,
    required this.dueDate,
  });
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