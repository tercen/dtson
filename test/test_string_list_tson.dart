library tson.test;

import 'package:test/test.dart';

import 'package:tson/tson.dart' as TSON;
import 'dart:typed_data' as td;

main() {

  group('string list', () {


    test('Simple string list', () {
      var bytes = TSON.encode( <String>["42.0", null]);
      TSON.decode(bytes);

      bytes = TSON.encode([null]);
      TSON.decode(bytes);
    });

  });
}
