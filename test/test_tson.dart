library tson.test;

import 'package:test/test.dart';

import 'package:tson/tson.dart' as TSON;
import 'dart:typed_data' as td;

main() {

  group('binary_serializer', () {
    test('Empty list', () {
      var bytes = TSON.encode([]);
      print(bytes);
    });

    test('Empty map', () {
      var bytes = TSON.encode({});
      print(bytes);
    });

    test('Simple list with null', () {
      var bytes = TSON.encode([null]);
      print(bytes);
    });

    test('Simple list with one', () {
      var bytes = TSON.encode([1]);
      print(bytes);
    });

    test('Simple list', () {
      var bytes = TSON.encode(["a", true, false, 42, 42.0]);
      print(bytes);
    });

    test('Simple int32 list', () {
      var bytes = TSON.encode(td.Int32List.fromList([42, 42]));
      print(bytes);
    });

    test('Simple cstring list', () {
      var bytes = TSON.encode(TSON.CStringList.fromList(["42.0", "42"]));
      print(bytes);
    });


    test('Simple map 2', () {
      var bytes = TSON.encode({"a": "a", "d": 42.0});
      print(bytes);
    });

    test('Simple map2', () {
      var bytes = TSON.encode({"a": "a", "i": 42, "d": 42.0});
      print(bytes);
    });

    test('Simple map of int32, float32 and float64 list', () {
      var bytes = TSON.encode({
        "i": td.Int32List.fromList([42]),
        "f": td.Float32List.fromList([42.0]),
        "d": td.Float64List.fromList([42.0])
      });
      print(bytes);
    });

    test('factor', () {
      var map = {
        "type": "factor",
        "dictionary": TSON.CStringList.fromList(["sample1", "sample2"]),
        "data": [0,0,1,1,0,1,1,1,1,0,0,0,0,1]
      };

      var bytes = TSON.encode(map);
      print(bytes);
      var tson_map = TSON.decode(bytes);
      print(tson_map);
      expect(map, equals(tson_map));
    });

    test('all types', () {
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

      var tson_map = TSON.decode(TSON.encode(map));
      print(tson_map);
      expect(map, equals(tson_map));
    });
  });
}
