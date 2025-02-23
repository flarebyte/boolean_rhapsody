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

    // Existing tests (kept as-is)
    test('isAtEnd should be false initially', () {
      expect(stream.isAtEnd, isFalse);
    });

    test('current should return first token without consuming', () {
      expect(stream.current, equals(tokens[0]));
      expect(stream.isAtEnd, isFalse);
    });

    test('consume should return tokens in order', () {
      expect(stream.consume(), equals(tokens[0]));
      expect(stream.consume(), equals(tokens[1]));
      expect(stream.consume(), equals(tokens[2]));
      expect(stream.isAtEnd, isTrue);
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
      stream.consume();
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

    // 🔥 New tests for uncovered methods and edge cases

    test('isNextAtEnd should correctly handle lookahead', () {
      expect(stream.isNextAtEnd(lookahead: 2), isFalse);
      expect(stream.isNextAtEnd(lookahead: 3), isTrue); // Exact length
      expect(stream.isNextAtEnd(lookahead: 5), isTrue); // Beyond length
    });

    test('peekMatchesType should validate lookahead token type', () {
      expect(
          stream.peekMatchesType('OPERATOR'), isTrue); // Default lookahead = 1
      expect(stream.peekMatchesType('IDENTIFIER', lookahead: 2), isTrue);
      expect(stream.peekMatchesType('OPERATOR', lookahead: 5),
          isFalse); // Out of range
    });

    test('matchText should correctly check token text', () {
      expect(stream.matchText('foo'), isTrue);
      expect(stream.matchText('bar'), isFalse);
      stream.consume();
      expect(stream.matchText('and'), isTrue);
    });

    test('peekMatchesText should validate lookahead token text', () {
      expect(stream.peekMatchesText('and'), isTrue); // Next token text
      expect(stream.peekMatchesText('bar', lookahead: 2), isTrue);
      expect(stream.peekMatchesText('baz', lookahead: 1), isFalse);
    });

    test('peekMatchesText should return false if lookahead exceeds length', () {
      expect(stream.peekMatchesText('foo', lookahead: 5), isFalse);
    });

    group('consumeAndValidate', () {
      test('should consume and validate token type and text successfully', () {
        final token = stream.consumeAndValidate('IDENTIFIER', 'foo');
        expect(token, equals(tokens[0]));
      });

      test('should throw if type does not match', () {
        expect(() => stream.consumeAndValidate('OPERATOR', 'foo'),
            throwsA(isA<SemanticException>()));
      });

      test('should throw if text does not match', () {
        expect(() => stream.consumeAndValidate('IDENTIFIER', 'bar'),
            throwsA(isA<SemanticException>()));
      });

      test('should handle null text parameter (type-only validation)', () {
        final token = stream.consumeAndValidate('IDENTIFIER', null);
        expect(token, equals(tokens[0]));
      });

      test('should consume and validate multiple tokens correctly', () {
        expect(
            stream.consumeAndValidate('IDENTIFIER', 'foo'), equals(tokens[0]));
        expect(stream.consumeAndValidate('OPERATOR', 'and'), equals(tokens[1]));
        expect(
            stream.consumeAndValidate('IDENTIFIER', 'bar'), equals(tokens[2]));
        expect(stream.isAtEnd, isTrue);
      });

      test('should throw if validate is called at end of stream', () {
        stream.consume();
        stream.consume();
        stream.consume();
        expect(() => stream.consumeAndValidate('IDENTIFIER', 'baz'),
            throwsA(isA<SemanticException>()));
      });
    });
  });
}
