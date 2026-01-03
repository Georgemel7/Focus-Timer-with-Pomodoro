import 'package:hive_flutter/adapters.dart'
    show TypeAdapter, BinaryReader, BinaryWriter;

import '../models/focus_state.dart';

class FocusStateAdapter extends TypeAdapter<FocusState> {
  @override
  final int typeId = 3;

  @override
  FocusState read(BinaryReader reader) {
    return FocusState.values[reader.readInt()];
  }

  @override
  void write(BinaryWriter writer, FocusState obj) {
    writer.writeInt(obj.index);
  }
}
