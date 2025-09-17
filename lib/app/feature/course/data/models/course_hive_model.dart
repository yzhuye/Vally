import 'package:hive/hive.dart';
import '../../domain/entities/course.dart';
part 'course_hive_model.g.dart';

@HiveType(typeId: 0)
class CourseHiveModel extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String description;
  @HiveField(3)
  List<String> enrolledStudents;
  @HiveField(4)
  String invitationCode;
  @HiveField(5)
  String imageUrl;
  @HiveField(6)
  String? createdBy;

  CourseHiveModel({
    required this.id,
    required this.title,
    required this.description,
    required this.enrolledStudents,
    required this.invitationCode,
    required this.imageUrl,
    this.createdBy,
  });

  factory CourseHiveModel.fromCourse(Course course) => CourseHiveModel(
        id: course.id,
        title: course.title,
        description: course.description,
        enrolledStudents: List<String>.from(course.enrolledStudents),
        invitationCode: course.invitationCode,
        imageUrl: course.imageUrl ?? '',
        createdBy: course.createdBy,
      );

  Course toCourse() => Course(
        id: id,
        title: title,
        description: description,
        enrolledStudents: List<String>.from(enrolledStudents),
        invitationCode: invitationCode,
        imageUrl: imageUrl.isEmpty ? null : imageUrl,
        createdBy: createdBy ?? 'unknown',
      );
}
