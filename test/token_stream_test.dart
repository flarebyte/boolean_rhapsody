import 'package:boolean_rhapsody/boolean_rhapsody.dart';
import 'package:test/test.dart';

void main() {
  group('RhapsodyTokenStream', () {
    late List<RhapsodyToken> tokens;
    late RhapsodyTokenStream stream;

    setUp(() {
      tokens = [
        RhapsodyToken(
            type: 'IDENTIFIER',
            text: 'foo',
            startIndex: 0,
            endIndex: 10,
            startPosition: RhapsodyPosition(row: 1, column: 10),
            endPosition: RhapsodyPosition(row: 2, column: 15)),
        RhapsodyToken(
            type: 'OPERATOR',
            text: 'and',
            startIndex: 0,
            endIndex: 10,
            startPosition: RhapsodyPosition(row: 1, column: 10),
            endPosition: RhapsodyPosition(row: 2, column: 15)),
        RhapsodyToken(
            type: 'IDENTIFIER',
            text: 'bar',
            startIndex: 0,
            endIndex: 10,
            startPosition: RhapsodyPosition(row: 1, column: 10),
            endPosition: RhapsodyPosition(row: 2, column: 15)),
      ];
      stream = RhapsodyTokenStream(tokens);
    });

    test('isAtEnd should be false initially', () {
      expect(stream.isAtEnd, isFalse);
    });

    test('current should return first token without consuming', () {
      expect(stream.current, equals(tokens[0]));
      expect(stream.isAtEnd, isFalse); // Should still not be at end
    });

    test('consume should return tokens in order', () {
      expect(stream.consume(), equals(tokens[0]));
      expect(stream.consume(), equals(tokens[1]));
      expect(stream.consume(), equals(tokens[2]));
      expect(stream.isAtEnd, isTrue); // Should be at end now
    });

    test('consume should throw when at end', () {
      stream.consume();
      stream.consume();
      stream.consume();
      expect(() => stream.consume(), throwsA(isA<SemanticException>()));
    });

    test('matchType should correctly check token type', () {
      expect(stream.matchType('IDENTIFIER'), isTrue);
      expect(stream.matchType('OPERATOR'), isFalse);
      stream.consume(); // Move to second token
      expect(stream.matchType('OPERATOR'), isTrue);
    });

    test('remainingTokens should return unconsumed tokens', () {
      expect(stream.remainingTokens, equals(tokens));
      stream.consume();
      expect(stream.remainingTokens, equals(tokens.sublist(1)));
    });

    test('current should throw when at end', () {
      stream.consume();
      stream.consume();
      stream.consume();
      expect(() => stream.current, throwsA(isA<SemanticException>()));
    });
  });
}
