import 'package:hive/hive.dart';
import 'package:vally_app/app/domain/entities/course.dart';
import 'package:vally_app/app/domain/entities/user.dart';
import 'package:vally_app/app/data/models/user_hive_model.dart';
import 'package:vally_app/app/data/models/course_hive_model.dart';

Future<void> preloadData() async {
  final userBox = Hive.box<UserHiveModel>('users');
  final courseBox = Hive.box<CourseHiveModel>('courses');

  await userBox.clear();
  await courseBox.clear();

  final course1 = Course(
    id: 'c1',
    title: 'curso1',
    description: 'Curso de prueba',
    enrolledStudents: ['b@a.com'],
    invitationCode: 'INV123',
    imageUrl: null,
    createdBy: 'a@a.com',
  );
  await courseBox.put(course1.id, CourseHiveModel.fromCourse(course1));

  // 🔹 Usuario A (profesor)
  final userA = User(
    id: '1',
    email: 'a@a.com',
    password: '123456',
    isTeacher: true,
    courseIds: [course1.id],
  );
  await userBox.put(userA.id, UserHiveModel.fromUser(userA));

  // 🔹 Usuario B (estudiante)
  final userB = User(
    id: '2',
    email: 'b@a.com',
    password: '123456',
    isTeacher: false,
    courseIds: [course1.id],
  );
  await userBox.put(userB.id, UserHiveModel.fromUser(userB));

  // 🔹 Usuario C (sin cursos)
  final userC = User(
    id: '3',
    email: 'c@a.com',
    password: '123456',
    isTeacher: false,
    courseIds: [],
  );
  await userBox.put(userC.id, UserHiveModel.fromUser(userC));
}
