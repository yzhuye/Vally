// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CourseHiveModelAdapter extends TypeAdapter<CourseHiveModel> {
  @override
  final int typeId = 0;

  @override
  CourseHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CourseHiveModel(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      enrolledStudents: (fields[3] as List).cast<String>(),
      invitationCode: fields[4] as String,
      imageUrl: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CourseHiveModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.enrolledStudents)
      ..writeByte(4)
      ..write(obj.invitationCode)
      ..writeByte(5)
      ..write(obj.imageUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CourseHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
