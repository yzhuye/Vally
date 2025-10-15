// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActivityHiveModelAdapter extends TypeAdapter<ActivityHiveModel> {
  @override
  final int typeId = 4;

  @override
  ActivityHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ActivityHiveModel(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      dueDate: fields[3] as DateTime,
      categoryId: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ActivityHiveModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.dueDate)
      ..writeByte(4)
      ..write(obj.categoryId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
