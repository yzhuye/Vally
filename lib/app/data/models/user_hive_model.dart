import 'package:hive/hive.dart';
import 'package:vally_app/app/domain/entities/user.dart';

part 'user_hive_model.g.dart';

@HiveType(typeId: 2) // ⚠️ Asegúrate de que no se repita con otros modelos
class UserHiveModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String email;

  @HiveField(2)
  String password;

  @HiveField(3)
  String? username;

  @HiveField(4)
  bool isTeacher;

  @HiveField(5)
  List<String> courseIds;

  UserHiveModel({
    required this.id,
    required this.email,
    required this.password,
    this.username,
    this.isTeacher = false,
    this.courseIds = const [],
  });

  factory UserHiveModel.fromUser(User user) {
    return UserHiveModel(
      id: user.id,
      email: user.email,
      password: user.password,
      username: user.username,
      isTeacher: user.isTeacher,
      courseIds: List<String>.from(user.courseIds),
    );
  }

  User toUser() {
    return User(
      id: id,
      email: email,
      password: password,
      username: username,
      isTeacher: isTeacher,
      courseIds: List<String>.from(courseIds),
    );
  }
}
