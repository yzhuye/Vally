class CourseDto {
  final String id;
  final String title;
  final String description;
  final List<String> enrolledStudents;
  final List<CategoryDto> categories;
  final List<GroupDto> groups;
  final String invitationCode;
  final String? imageUrl;
  final String createdBy;

  CourseDto({
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

  factory CourseDto.fromJson(Map<String, dynamic> json) {
    try {
      return CourseDto(
        id: json['_id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        enrolledStudents: List<String>.from(json['enrolledStudents'] ?? []),
        categories: (json['categories'] as List<dynamic>? ?? [])
            .map((e) => CategoryDto(
                  id: e['_id'] as String,
                  name: e['name'] as String,
                  groupingMethod: e['groupingMethod'] as String,
                  groupCount: e['groupCount'] as int,
                  studentsPerGroup: e['studentsPerGroup'] as int,
                  activities: (e['activities'] as List<dynamic>? ?? [])
                      .map((a) => ActivityDto(
                            id: a['_id'] as String,
                            name: a['name'] as String,
                            description: a['description'] as String,
                            dueDate: DateTime.parse(a['dueDate'] as String),
                            categoryId: a['categoryId'] as String,
                          ))
                      .toList(),
                ))
            .toList(),
        groups: (json['groups'] as List<dynamic>? ?? [])
            .map((g) => GroupDto(
                  id: g['_id'] as String,
                  name: g['name'] as String,
                  maxCapacity: g['maxCapacity'] as int,
                  members: List<String>.from(g['members'] ?? []),
                  categoryId: g['categoryId'] as String,
                ))
            .toList(),
        invitationCode: json['invitationCode'] as String,
        imageUrl: json['imageUrl'] as String?,
        createdBy: json['createdBy'] as String,
      );
    } catch (e) {
      throw Exception('Error parsing Course JSON: $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'enrolledStudents': enrolledStudents,
      'categories': categories.map((c) => c.toJson()).toList(),
      'groups': groups.map((g) => g.toJson()).toList(),
      'invitationCode': invitationCode,
      'imageUrl': imageUrl,
      'createdBy': createdBy,
    };
  }
}

class CategoryDto {
  final String id;
  final String name;
  final String groupingMethod;
  final int groupCount;
  final int studentsPerGroup;
  final List<ActivityDto> activities;

  CategoryDto({
    required this.id,
    required this.name,
    required this.groupingMethod,
    required this.groupCount,
    required this.studentsPerGroup,
    this.activities = const [],
  });

  factory CategoryDto.fromJson(Map<String, dynamic> json) {
    return CategoryDto(
      id: json['_id'] as String,
      name: json['name'] as String,
      groupingMethod: json['groupingMethod'] as String,
      groupCount: json['groupCount'] as int,
      studentsPerGroup: json['studentsPerGroup'] as int,
      activities: (json['activities'] as List<dynamic>? ?? [])
          .map((a) => ActivityDto(
                id: a['_id'] as String,
                name: a['name'] as String,
                description: a['description'] as String,
                dueDate: DateTime.parse(a['dueDate'] as String),
                categoryId: a['categoryId'] as String,
              ))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'groupingMethod': groupingMethod,
      'groupCount': groupCount,
      'studentsPerGroup': studentsPerGroup,
      'activities': activities.map((a) => a.toJson()).toList(),
    };
  }
}

class ActivityDto {
  final String id;
  final String name;
  final String description;
  final DateTime dueDate;
  final String categoryId;
  final List<EvaluationDto> evaluations;

  ActivityDto({
    required this.id,
    required this.name,
    required this.description,
    required this.dueDate,
    required this.categoryId,
    this.evaluations = const [],
  });

  factory ActivityDto.fromJson(Map<String, dynamic> json) {
    return ActivityDto(
      id: json['_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      dueDate: DateTime.parse(json['dueDate'] as String),
      categoryId: json['categoryId'] as String,
      evaluations: (json['evaluations'] as List<dynamic>? ?? [])
          .map((e) => EvaluationDto(
                id: e['_id'] as String,
                activityId: e['activityId'] as String,
                evaluatorId: e['evaluatorId'] as String,
                evaluatedId: e['evaluatedId'] as String,
                punctuality: e['punctuality'] as int,
                contributions: e['contributions'] as int,
                commitment: e['commitment'] as int,
                attitude: e['attitude'] as int,
                createdAt: DateTime.parse(e['createdAt'] as String),
              ))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'categoryId': categoryId,
      'evaluations': evaluations.map((e) => e.toJson()).toList(),
    };
  }
}

class EvaluationDto {
  final String id;
  final String activityId;
  final String evaluatorId;
  final String evaluatedId;
  final int punctuality;
  final int contributions;
  final int commitment;
  final int attitude;
  final DateTime createdAt;

  EvaluationDto({
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

  factory EvaluationDto.fromJson(Map<String, dynamic> json) {
    return EvaluationDto(
      id: json['_id'] as String,
      activityId: json['activityId'] as String,
      evaluatorId: json['evaluatorId'] as String,
      evaluatedId: json['evaluatedId'] as String,
      punctuality: json['punctuality'] as int,
      contributions: json['contributions'] as int,
      commitment: json['commitment'] as int,
      attitude: json['attitude'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'activityId': activityId,
      'evaluatorId': evaluatorId,
      'evaluatedId': evaluatedId,
      'punctuality': punctuality,
      'contributions': contributions,
      'commitment': commitment,
      'attitude': attitude,
      'createdAt': createdAt.toIso8601String(),
    };
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

class GroupDto {
  final String id;
  final String name;
  final int maxCapacity;
  final List<String> members;
  final String categoryId;

  GroupDto({
    required this.id,
    required this.name,
    required this.maxCapacity,
    this.members = const [],
    required this.categoryId,
  });

  factory GroupDto.fromJson(Map<String, dynamic> json) {
    return GroupDto(
      id: json['_id'] as String,
      name: json['name'] as String,
      maxCapacity: json['maxCapacity'] as int,
      members: List<String>.from(json['members'] ?? []),
      categoryId: json['categoryId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'maxCapacity': maxCapacity,
      'members': members,
      'categoryId': categoryId,
    };
  }

  bool get isFull => members.length >= maxCapacity;
  String get status => isFull ? 'Full' : 'Join';
  String get capacityText => '${members.length}/$maxCapacity';
}

class StudentDto {
  final String id;
  final String name;
  final String email;

  StudentDto({
    required this.id,
    required this.name,
    required this.email,
  });

  factory StudentDto.fromJson(Map<String, dynamic> json) {
    return StudentDto(
      id: json['_id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
    };
  }
}

class InvitationRequestDto {
  final String name;
  final String email;
  final String code;

  InvitationRequestDto({
    required this.name,
    required this.email,
    required this.code,
  });

  factory InvitationRequestDto.fromJson(Map<String, dynamic> json) {
    return InvitationRequestDto(
      name: json['name'] as String,
      email: json['email'] as String,
      code: json['code'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'code': code,
    };
  }
}
