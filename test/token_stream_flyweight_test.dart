import 'package:boolean_rhapsody/boolean_rhapsody.dart';
import 'package:boolean_rhapsody/src/token_stream_flyweight.dart';
import 'package:test/test.dart';

import 'code_fixtures.dart';

void main() {
  group('RhapsodyTokenStreamFlyweight.consumeIdentifier', () {
    late MockTokenCreator t;
    late RhapsodyTokenStream tokenStream;

    setUp(() {
      t = MockTokenCreator();
    });

    test('consumes identifier when token matches', () {
      tokenStream =
          RhapsodyTokenStream([t.token("func1", TokenTypes.identifier)]);

      final result =
          RhapsodyTokenStreamFlyweight.consumeIdentifier(tokenStream);

      expect(result.text, equals("func1"));
      expect(result.type, equals(TokenTypes.identifier));
    });

    test('throws SemanticException when token is not identifier', () {
      tokenStream = RhapsodyTokenStream([t.token("(", TokenTypes.lparen)]);

      expect(() => RhapsodyTokenStreamFlyweight.consumeIdentifier(tokenStream),
          throwsA(isA<SemanticException>()));
    });
    group('RhapsodyTokenStreamFlyweight.peekIsRightParenthesis', () {
      late MockTokenCreator t;

      setUp(() {
        t = MockTokenCreator();
      });

      test('returns true when next token is rparen', () {
        final tokenStream =
            RhapsodyTokenStream([t.token(")", TokenTypes.rparen)]);

        final result =
            RhapsodyTokenStreamFlyweight.peekIsRightParenthesis(tokenStream);
        expect(result, isTrue);
      });

      test('returns false when next token is not rparen', () {
        final tokenStream =
            RhapsodyTokenStream([t.token("(", TokenTypes.lparen)]);

        final result =
            RhapsodyTokenStreamFlyweight.peekIsRightParenthesis(tokenStream);
        expect(result, isFalse);
      });
    });
  });

  group('RhapsodyTokenStreamFlyweight.consumeLeftParenthesis', () {
    late MockTokenCreator t;

    setUp(() {
      t = MockTokenCreator();
    });

    test('consumes left parenthesis successfully', () {
      final tokenStream =
          RhapsodyTokenStream([t.token("(", TokenTypes.lparen)]);

      RhapsodyTokenStreamFlyweight.consumeLeftParenthesis(tokenStream);

      expect(tokenStream.isAtEnd, isTrue); // Ensure token was consumed
    });

    test('throws SemanticException if next token is not lparen', () {
      final tokenStream =
          RhapsodyTokenStream([t.token("func1", TokenTypes.identifier)]);

      expect(
          () =>
              RhapsodyTokenStreamFlyweight.consumeLeftParenthesis(tokenStream),
          throwsA(isA<SemanticException>()));
    });
  });
  group('RhapsodyTokenStreamFlyweight.consumeOrOperator', () {
    late MockTokenCreator t;

    setUp(() {
      t = MockTokenCreator();
    });

    test('consumes "or" operator successfully', () {
      final tokenStream =
          RhapsodyTokenStream([t.token("or", TokenTypes.operatorType)]);

      RhapsodyTokenStreamFlyweight.consumeOrOperator(tokenStream);

      expect(tokenStream.isAtEnd, isTrue); // Token consumed
    });

    test('throws SemanticException if next token is not "or"', () {
      final tokenStream =
          RhapsodyTokenStream([t.token("and", TokenTypes.operatorType)]);

      expect(() => RhapsodyTokenStreamFlyweight.consumeOrOperator(tokenStream),
          throwsA(isA<SemanticException>()));
    });
  });
  group('RhapsodyTokenStreamFlyweight.peekIsAndOperator', () {
    late MockTokenCreator t;

    setUp(() {
      t = MockTokenCreator();
    });

    test('returns true when next token is "and" operator', () {
      final tokenStream =
          RhapsodyTokenStream([t.token("and", TokenTypes.operatorType)]);

      final result =
          RhapsodyTokenStreamFlyweight.peekIsAndOperator(tokenStream);
      expect(result, isTrue);
    });

    test('returns false when next token is not "and" operator', () {
      final tokenStream =
          RhapsodyTokenStream([t.token("or", TokenTypes.operatorType)]);

      final result =
          RhapsodyTokenStreamFlyweight.peekIsAndOperator(tokenStream);
      expect(result, isFalse);
    });
  });
}
