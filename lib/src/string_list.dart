import 'dart:collection';
import 'dart:typed_data' as td;

import 'string_list_32.dart' if (dart.library.io) 'string_list_64.dart';

abstract class CStringList extends ListBase<String> implements List<String> {
  CStringList();

  factory CStringList.fromBytes(td.Uint8List bytes) {
    return CStringListImpl.fromBytes(bytes);
  }
  factory CStringList.fromList(List<String> list) {
    return CStringListImpl.fromList(list);
  }

  td.Uint8List toBytes();
  int get lengthInBytes;

  List<int> get starts;

  int get length;

  void set length(int newLength);

  operator [](int i);
  operator []=(int i, String value);
}
