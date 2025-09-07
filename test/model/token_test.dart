import 'package:boolean_rhapsody/boolean_rhapsody.dart';
import 'package:boolean_rhapsody/src/model/token.dart';
import 'package:test/test.dart';

void main() {
  group('RhapsodyPosition', () {
    test('toString includes row and column', () {
      const pos = RhapsodyPosition(row: 3, column: 7);
      expect(pos.toString(), equals('Position{row: 3, column: 7}'));
    });
  });

  group('RhapsodyToken', () {
    test('defaults hasError to false', () {
      const token = RhapsodyToken(
        type: 'identifier',
        text: 'foo',
        startIndex: 1,
        endIndex: 4,
        startPosition: RhapsodyPosition(row: 0, column: 1),
        endPosition: RhapsodyPosition(row: 0, column: 4),
      );
      expect(token.hasError, isFalse);
    });

    test('can set hasError to true', () {
      const token = RhapsodyToken(
        type: 'unknown',
        text: '@',
        startIndex: 10,
        endIndex: 11,
        startPosition: RhapsodyPosition(row: 2, column: 5),
        endPosition: RhapsodyPosition(row: 2, column: 6),
        hasError: true,
      );
      expect(token.hasError, isTrue);
    });

    test('toString prints all key fields', () {
      const token = RhapsodyToken(
        type: 'identifier',
        text: 'bar',
        startIndex: 0,
        endIndex: 3,
        startPosition: RhapsodyPosition(row: 1, column: 1),
        endPosition: RhapsodyPosition(row: 1, column: 3),
      );
      final s = token.toString();
      expect(s, contains('type: identifier'));
      expect(s, contains("text: bar"));
      expect(s, contains('startIndex: 0'));
      expect(s, contains('endIndex: 3'));
      expect(s, contains('startPosition'));
      expect(s, contains('endPosition'));
      expect(s, contains('hasError: false'));
    });
  });
}
