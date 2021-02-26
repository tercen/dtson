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
    encode_decode([]);
    encode_decode({});
    encode_decode([null]);
    encode_decode([1]);
    encode_decode(["a", true, false, 42, 42.0]);
    encode_decode(td.Int32List.fromList([42, 42]));
    encode_decode(TSON.CStringList.fromList(["42.0", "42"]));
    encode_decode({"a": "a", "d": 42.0});
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
      "uint8": new td.Uint8List.fromList([42, 42]),
      "uint16": new td.Uint16List.fromList([42, 42]),
      "uint32": new td.Uint32List.fromList([42, 42]),
      "int8": new td.Int8List.fromList([-42, 42]),
      "int16": new td.Int16List.fromList([42, 42]),
      "int32": new td.Int32List.fromList([42, 42]),
      "int64": new td.Int64List.fromList([42, 42]),
      "float32": new td.Float32List.fromList([42.0, 42.0]),
      "float64": new td.Float64List.fromList([42.0, 42.0]),
      "cstringlist": new TSON.CStringList.fromList(["42.0", "42"])
    };

    encode_decode(map);
  });
}
