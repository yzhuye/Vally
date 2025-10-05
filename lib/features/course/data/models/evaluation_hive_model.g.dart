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
      punctuality: fields[4] as int,
      contributions: fields[5] as int,
      commitment: fields[6] as int,
      attitude: fields[7] as int,
      createdAt: fields[8] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, EvaluationHiveModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.activityId)
      ..writeByte(2)
      ..write(obj.evaluatorId)
      ..writeByte(3)
      ..write(obj.evaluatedId)
      ..writeByte(4)
      ..write(obj.punctuality)
      ..writeByte(5)
      ..write(obj.contributions)
      ..writeByte(6)
      ..write(obj.commitment)
      ..writeByte(7)
      ..write(obj.attitude)
      ..writeByte(8)
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
