// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../models/activity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActivityAdapter extends TypeAdapter<Activity> {
  @override
  final int typeId = 0;

  @override
  Activity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Activity(
      seedColor: fields[1] as Color,
      label: fields[2] as String,
      timeGoal: fields[3] as int,
      activeDays: (fields[4] as List).cast<Weekday>(),
      id: fields[0] as String,
      createdAt: fields[6] as DateTime,
    )..deletedAt = fields[5] as DateTime?;
  }

  @override
  void write(BinaryWriter writer, Activity obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.seedColor)
      ..writeByte(2)
      ..write(obj.label)
      ..writeByte(3)
      ..write(obj.timeGoal)
      ..writeByte(4)
      ..write(obj.activeDays)
      ..writeByte(5)
      ..write(obj.deletedAt)
      ..writeByte(6)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
