import 'package:test/test.dart';
import 'dart:async';
import 'package:tson/tson.dart' as TSON;
import 'dart:typed_data' as td;

main() {
  encode_decode(object) async {
    var bytes = TSON.encode(object);
    var result = await TSON.deserializeStream(Stream.fromIterable([bytes]));
    expect(result, equals(object));
  }


  test('encode_decode', () async {
    await encode_decode([]);
    await encode_decode({});
    await encode_decode([null]);
    await encode_decode([1]);
    await encode_decode(["a", true, false, 42, 42.0]);
    await encode_decode(td.Int32List.fromList([42, 42]));
    await encode_decode(TSON.CStringList.fromList(["42.0", "42"]));
    await encode_decode({"a": "a", "d": 42.0});
  });

  test('all types', () async {
    var map = {
      "null": null,
      "string": "hello",
      "integer": 42,
      "float": 42.0,
      "bool_t": true,
      "bool_f": false,
      "map": {"string": "42"},
      "list": [
        42,
        "42",
        {"string": "42"},
        ["42", 42]
      ],
      "uint8": td.Uint8List.fromList([42, 42]),
      "uint16": td.Uint16List.fromList([42, 42]),
      "uint32": td.Uint32List.fromList([42, 42]),
      "int8": td.Int8List.fromList([-42, 42]),
      "int16": td.Int16List.fromList([42, 42]),
      "int32": td.Int32List.fromList([42, 42]),
      "int64": td.Int64List.fromList([42, 42]),
      "float32": td.Float32List.fromList([42.0, 42.0]),
      "float64": td.Float64List.fromList([42.0, 42.0]),
      "cstringlist": TSON.CStringList.fromList(["42.0", "42"])
    };

    encode_decode(map);
  });
}
