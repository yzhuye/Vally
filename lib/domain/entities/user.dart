class User {
  final String id;
  final String email;
  final String password;
  final String? username;
  final bool isTeacher;
  final List<String> courseIds;

  User({
    required this.id,
    required this.email,
    required this.password,
    this.username,
    this.isTeacher = false,
    this.courseIds = const [],
  });

  User copyWith({
    String? id,
    String? email,
    String? password,
    String? username,
    bool? isTeacher,
    List<String>? courseIds,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      username: username ?? this.username,
      isTeacher: isTeacher ?? this.isTeacher,
      courseIds: courseIds ?? this.courseIds,
    );
  }
}
