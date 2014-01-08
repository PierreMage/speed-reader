library speedreader;

import 'package:unittest/unittest.dart';

import '../lib/chunks.dart';

main() {
  group('Chunks', () {
    test('should chunk the input text on whitespaces by default', () {
      var chunks = new Chunks('foo bar');
      expect(chunks.length, equals(2));
      expect(chunks.chunkAt(0), equals('foo'));
      expect(chunks.chunkAt(1), equals('bar'));
    });
    
    test('should chunk the input text on the given separator', () {
      var chunks = new Chunks('foo bar', 'b');
      expect(chunks.length, equals(2));
      expect(chunks.chunkAt(0), equals('foo '));
      expect(chunks.chunkAt(1), equals('ar'));
    });
  });
}