import 'package:hive/hive.dart';
import 'package:vally_app/feature/domain/entities/course.dart';
import 'package:vally_app/feature/domain/entities/user.dart';
import 'package:vally_app/feature/data/models/user_hive_model.dart';
import 'package:vally_app/feature/data/models/course_hive_model.dart';

Future<void> preloadData() async {
  final userBox = Hive.box<UserHiveModel>('users');
  final courseBox = Hive.box<CourseHiveModel>('courses');

  await userBox.clear();
  await courseBox.clear();

  final course1 = Course(
    id: 'c1',
    title: 'curso1',
    description: 'Curso de prueba',
    enrolledStudents: [
      'b@a.com',
      'c@a.com',
      'd@a.com',
      'e@a.com',
      'f@a.com',
      'g@a.com',
    ],
    invitationCode: 'INV123',
    imageUrl: null,
    createdBy: 'a@a.com',
  );
  await courseBox.put(course1.id, CourseHiveModel.fromCourse(course1));

  // 🔹 Usuario A (profesor)
  final userA = User(
    id: '1',
    email: 'a@a.com',
  );
  await userBox.put(userA.id, UserHiveModel.fromUser(userA));

  // 🔹 Usuario B (estudiante)
  final userB = User(
    id: '2',
    email: 'b@a.com',
  );
  await userBox.put(userB.id, UserHiveModel.fromUser(userB));

  // 🔹 Usuario C (sin cursos)
  final userC = User(
    id: '3',
    email: 'c@a.com',
  );
  await userBox.put(userC.id, UserHiveModel.fromUser(userC));

  // 🔹 Usuario D (estudiante)
  final userD = User(
    id: '4',
    email: 'd@a.com',
  );
  await userBox.put(userD.id, UserHiveModel.fromUser(userD));

  // 🔹 Usuario E (estudiante)
  final userE = User(
    id: '5',
    email: 'e@a.com',
  );
  await userBox.put(userE.id, UserHiveModel.fromUser(userE));

  // 🔹 Usuario F (estudiante)
  final userF = User(
    id: '6',
    email: 'f@a.com',
  );
  await userBox.put(userF.id, UserHiveModel.fromUser(userF));

  // 🔹 Usuario G (estudiante)
  final userG = User(
    id: '7',
    email: 'g@a.com',
  );
  await userBox.put(userG.id, UserHiveModel.fromUser(userG));

  // 🔹 Usuarios A-G (@b.com), no inscritos en ningún curso
  final usersB = [
    User(id: '8', email: 'a@b.com'),
    User(id: '9', email: 'b@b.com'),
    User(id: '10', email: 'c@b.com'),
    User(id: '11', email: 'd@b.com'),
    User(id: '12', email: 'e@b.com'),
    User(id: '13', email: 'f@b.com'),
    User(id: '14', email: 'g@b.com'),
  ];
  for (final user in usersB) {
    await userBox.put(user.id, UserHiveModel.fromUser(user));
  }
}
