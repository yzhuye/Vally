// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'evaluation_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EvaluationHiveModelAdapter extends TypeAdapter<EvaluationHiveModel> {
  @override
  final int typeId = 5;

  @override
  EvaluationHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EvaluationHiveModel(
      id: fields[0] as String,
      activityId: fields[1] as String,
      evaluatorId: fields[2] as String,
      evaluatedId: fields[3] as String,
      metric1: fields[4] as int,
      metric2: fields[5] as int,
      metric3: fields[6] as int,
      metric4: fields[7] as int,
      metric5: fields[8] as int,
      comments: fields[9] as String?,
      createdAt: fields[10] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, EvaluationHiveModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.activityId)
      ..writeByte(2)
      ..write(obj.evaluatorId)
      ..writeByte(3)
      ..write(obj.evaluatedId)
      ..writeByte(4)
      ..write(obj.metric1)
      ..writeByte(5)
      ..write(obj.metric2)
      ..writeByte(6)
      ..write(obj.metric3)
      ..writeByte(7)
      ..write(obj.metric4)
      ..writeByte(8)
      ..write(obj.metric5)
      ..writeByte(9)
      ..write(obj.comments)
      ..writeByte(10)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EvaluationHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
