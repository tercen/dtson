part of tson;

class _StreamDeserializer {
  late utils.ChunkedStreamIterator<int> reader;
  dynamic object;

  _StreamDeserializer(Stream<List<int>> stream) {
    reader = utils.ChunkedStreamIterator(stream);
  }

  Future<td.Uint8List> read(int size) async {
    var bytes = await reader.readBytes(size);
    if (bytes.length < size) throw 'EOF';
    return bytes;
  }

  Future<dynamic> toObject() async {
    var version = await _readObject();
    if (version != TsonSpec.VERSION) {
      throw TsonError(500, "version.mismatch",
          "TSON version mismatch, found : $version , expected : ${TsonSpec.VERSION}");
    }
    var object = await _readObject();
    await reader.cancel();
    return object;
  }

  Future<int> _readObjectType() async {
    var type = await read(1);
    return type.first;
  }

  Future<dynamic> _readObject() async {
    var type = await _readObjectType();
    if (type == TsonSpec.NULL_TYPE) {
      return null;
    } else if (type == TsonSpec.MAP_TYPE) {
      return _readMap();
    } else if (type == TsonSpec.STRING_TYPE) {
      return _readString();
    } else if (type == TsonSpec.INTEGER_TYPE) {
      return _readInteger();
    } else if (type == TsonSpec.DOUBLE_TYPE) {
      return _readDouble();
    } else if (type == TsonSpec.BOOL_TYPE) {
      return _readBool();
    } else if (type == TsonSpec.LIST_STRING_TYPE) {
      return _readCStringList();
    } else if (type == TsonSpec.LIST_TYPE) {
      return _readList();
    } else {
      return _readTypedData(type);
    }
  }

  Future<String> _readString() async {
    var buffer = tb.Uint8Buffer();
    int byte;

    while ((byte = (await read(1)).first) > 0) {
      buffer.add(byte);
    }
    return utf8.decode(buffer);
  }

  Future<Map> _readMap() async {
    final len = await _readLength();
    var answer = {};
    for (int i = 0; i < len; i++) {
      var key = await _readObject();
      if (key is! String) {
        throw TsonError(
            500, "wrong.map.key.format", "Map key must be a String");
      }

      answer[key] = await _readObject();
    }
    return answer;
  }

  Future<int> _readLength() => _readUint32();

  Future<int> _readUint32() async {
    var bytes = await read(4);
    return bytes.buffer.asByteData().getUint32(0, td.Endian.little);
  }

  Future<int> _readInteger() async {
    var bytes = await read(4);
    return bytes.buffer.asByteData().getInt32(0, td.Endian.little);
  }

  Future<double> _readDouble() async {
    var bytes = await read(8);
    return bytes.buffer.asByteData().getFloat64(0, td.Endian.little);
  }

  Future<bool> _readBool() async {
    var bytes = await read(1);
    return bytes.first > 0;
  }

  Future<List> _readList() async {
    final len = await _readLength();
    var answer = [];
    for (int i = 0; i < len; i++) {
      answer.add(await _readObject());
    }
    return answer;
  }

  Future<CStringList> _readCStringList() async {
    var lengthInBytes = await _readLength();
    return CStringList.fromBytes(await read(lengthInBytes));
  }

  int _elementSizeFromType(int type) {
    if (type == TsonSpec.LIST_UINT8_TYPE) {
      return 1;
    } else if (type == TsonSpec.LIST_UINT16_TYPE) {
      return 2;
    } else if (type == TsonSpec.LIST_UINT32_TYPE) {
      return 4;
    } else if (type == TsonSpec.LIST_INT8_TYPE) {
      return 1;
    } else if (type == TsonSpec.LIST_INT16_TYPE) {
      return 2;
    } else if (type == TsonSpec.LIST_INT32_TYPE) {
      return 4;
    } else if (type == TsonSpec.LIST_INT64_TYPE) {
      return 8;
    } else if (type == TsonSpec.LIST_FLOAT32_TYPE) {
      return 4;
    } else if (type == TsonSpec.LIST_FLOAT64_TYPE) {
      return 8;
    } else if (type == TsonSpec.LIST_UINT64_TYPE) {
      return 8;
    } else {
      throw TsonError(
          404, "unknown.typed.data", "Unknown typed data $type");
    }
  }

  Future<td.TypedData> _readTypedData(int type) async {
    final len = await _readLength();
    final elementSize = _elementSizeFromType(type);
    var answer = await read(elementSize * len);
    // var answer = td.Uint8List(elementSize * len);
    // var nRead = 0;
    // while (nRead < answer.length) {
    //   var bufSize = min(8 * 1024 * 1024, answer.length - nRead);
    //   var buf = await read(bufSize);
    //   answer.setRange(nRead, nRead + buf.length, buf);
    //   nRead += buf.length;
    // }

    if (type == TsonSpec.LIST_UINT8_TYPE) {
      return answer;
    } else if (type == TsonSpec.LIST_UINT16_TYPE) {
      return td.Uint16List.view(answer.buffer, answer.offsetInBytes, len);
    } else if (type == TsonSpec.LIST_UINT32_TYPE) {
      return td.Uint32List.view(answer.buffer, answer.offsetInBytes, len);
    } else if (type == TsonSpec.LIST_INT8_TYPE) {
      return td.Int8List.view(answer.buffer, answer.offsetInBytes, len);
    } else if (type == TsonSpec.LIST_INT16_TYPE) {
      return td.Int16List.view(answer.buffer, answer.offsetInBytes, len);
    } else if (type == TsonSpec.LIST_INT32_TYPE) {
      return td.Int32List.view(answer.buffer, answer.offsetInBytes, len);
    } else if (type == TsonSpec.LIST_INT64_TYPE) {
      return td.Int64List.view(answer.buffer, answer.offsetInBytes, len);
    } else if (type == TsonSpec.LIST_FLOAT32_TYPE) {
      return td.Float32List.view(answer.buffer, answer.offsetInBytes, len);
    } else if (type == TsonSpec.LIST_FLOAT64_TYPE) {
      return td.Float64List.view(answer.buffer, answer.offsetInBytes, len);
    } else if (type == TsonSpec.LIST_UINT64_TYPE) {
      return td.Uint64List.view(answer.buffer, answer.offsetInBytes, len);
    } else {
      throw TsonError(404, "unknown.typed.data", "Unknown typed data");
    }
  }
}
