// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../models/activity_session.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActivitySessionAdapter extends TypeAdapter<ActivitySession> {
  @override
  final int typeId = 1;

  @override
  ActivitySession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ActivitySession(
      activityId: fields[0] as String,
      day: fields[1] as DateTime,
      done: fields[3] as bool,
      currentFocusState: fields[2] as FocusState,
      totalFocusTime: fields[6] as int,
      totalBreakTime: fields[7] as int,
    )
      ..breakStartedAt = fields[4] as DateTime?
      ..focusStartedAt = fields[5] as DateTime?;
  }

  @override
  void write(BinaryWriter writer, ActivitySession obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.activityId)
      ..writeByte(1)
      ..write(obj.day)
      ..writeByte(2)
      ..write(obj.currentFocusState)
      ..writeByte(3)
      ..write(obj.done)
      ..writeByte(4)
      ..write(obj.breakStartedAt)
      ..writeByte(5)
      ..write(obj.focusStartedAt)
      ..writeByte(6)
      ..write(obj.totalFocusTime)
      ..writeByte(7)
      ..write(obj.totalBreakTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivitySessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
