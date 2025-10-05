class User {
  final String id;
  final String email;
  final String? username;
  final List<String> teacherCourses;
  final List<String> studentCourses;

  User({
    required this.id,
    required this.email,
    this.username,
    this.teacherCourses = const [],
    this.studentCourses = const [],
  });

  User copyWith({
    String? id,
    String? email,
    String? username,
    List<String>? teacherCourses,
    List<String>? studentCourses,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      teacherCourses: teacherCourses ?? this.teacherCourses,
      studentCourses: studentCourses ?? this.studentCourses,
    );
  }
}
