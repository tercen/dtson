library tson.test;

import 'package:test/test.dart';
import 'dart:async';
import 'package:tson/tson.dart' as tson;

main() {
  group('binary_serializer', () {
    test('Tson stream', () async {
      var list = List.generate(10, (i) => {'hello': i});
      var stream = Stream<dynamic>.fromIterable(list)
          .transform(tson.TsonStreamEncoderTransformer())
          .transform(tson.TsonStreamDecoderTransformer());

      var result = await stream.toList();

      expect(result, equals(list));
    });
  });
}
