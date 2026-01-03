import 'package:focus_timer/models/weekday.dart';
import 'package:hive_flutter/adapters.dart'
    show TypeAdapter, BinaryReader, BinaryWriter;

import '../models/focus_state.dart';

class WeekdayAdapter extends TypeAdapter<Weekday> {
  @override
  final int typeId = 4;

  @override
  Weekday read(BinaryReader reader) {
    return Weekday.values[reader.readInt()];
  }

  @override
  void write(BinaryWriter writer, Weekday obj) {
    writer.writeInt(obj.index);
  }
}
