import 'dart:typed_data' as td;
import 'dart:convert';
import 'string_list.dart';

class CStringListImpl extends CStringList {
  late td.Uint8List _bytes;
  td.Uint64List? _starts;

  CStringListImpl.fromBytes(this._bytes);
  CStringListImpl.fromList(List<String> list) {
    var lengthInBytes = list.fold(0, (dynamic len, str) {
      return len + utf8.encode(str).length + 1;
    });
    _bytes = td.Uint8List(lengthInBytes);
    var offset = 0;
    for (var str in list) {
      var bytes = utf8.encode(str);
      _bytes.setRange(offset, offset + bytes.length, bytes);
      offset += bytes.length + 1;
    }
    _buildStarts();
  }

  @override
  td.Uint8List toBytes() => _bytes;
  @override
  int get lengthInBytes => _bytes.length;

  td.Uint64List _buildStarts() {
    var len = 0;
    for (int i = 0; i < _bytes.length; i++) {
      if (_bytes[i] == 0) len++;
    }
    _starts = td.Uint64List(len + 1);
    _starts![0] = 0;
    var offset = 0;

    for (int i = 0; i < len; i++) {
      var start = offset;
      while (_bytes[offset] != 0) {
        offset++;
      }
      offset += 1;
      _starts![i + 1] = _starts![i] + (offset - start);
    }
    return _starts!;
  }

  @override
  td.Uint64List get starts => _starts == null ? _buildStarts() : _starts!;

  @override
  int get length => starts.length - 1;

  @override
  set length(int newLength) => throw "list is read only";

  @override
  operator [](int i) {
    var start = starts[i];
    var end = starts[i + 1];
    return utf8.decode(_bytes.sublist(start, end - 1));
  }

  @override
  operator []=(int i, String value) => throw "list is read only";
}
