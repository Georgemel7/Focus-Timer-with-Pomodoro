import 'dart:ui';

import 'package:hive_flutter/adapters.dart'
    show TypeAdapter, BinaryReader, BinaryWriter;


class ColorAdapter extends TypeAdapter<Color> {
  @override
  final int typeId = 2;

  @override
  Color read(BinaryReader reader) {
    return Color(reader.readInt());
  }

  @override
  void write(BinaryWriter writer, Color obj) {
    writer.writeInt(obj.value);
  }
}
