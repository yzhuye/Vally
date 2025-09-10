// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GroupHiveModelAdapter extends TypeAdapter<GroupHiveModel> {
  @override
  final int typeId = 3;

  @override
  GroupHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GroupHiveModel(
      id: fields[0] as String,
      name: fields[1] as String,
      maxCapacity: fields[2] as int,
      members: (fields[3] as List).cast<String>(),
      categoryId: fields[4] as String,
      courseId: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, GroupHiveModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.maxCapacity)
      ..writeByte(3)
      ..write(obj.members)
      ..writeByte(4)
      ..write(obj.categoryId)
      ..writeByte(5)
      ..write(obj.courseId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GroupHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
