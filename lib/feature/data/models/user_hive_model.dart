import 'package:hive/hive.dart';
import 'package:vally_app/feature/domain/entities/user.dart';

part 'user_hive_model.g.dart';

@HiveType(typeId: 2) // ⚠️ Asegúrate de que no se repita con otros modelos
class UserHiveModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String email;

  @HiveField(2)
  String? username;

  @HiveField(3)
  List<String> teacherCourses;

  @HiveField(4)
  List<String> studentCourses;

  UserHiveModel({
    required this.id,
    required this.email,
    this.username,
    this.teacherCourses = const [],
    this.studentCourses = const [],
  });

  factory UserHiveModel.fromUser(User user) {
    return UserHiveModel(
      id: user.id,
      email: user.email,
      username: user.username,
      teacherCourses: user.teacherCourses,
      studentCourses: user.studentCourses,
    );
  }

  User toUser() {
    return User(
      id: id,
      email: email,
      username: username,
      teacherCourses: teacherCourses,
      studentCourses: studentCourses,
    );
  }
}
