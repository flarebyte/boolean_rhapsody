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
        final first = t.token("first", TokenTypes.identifier);
        final tokenStream =
            RhapsodyTokenStream([first, t.token(")", TokenTypes.rparen)]);

        final result =
            RhapsodyTokenStreamFlyweight.peekIsRightParenthesis(tokenStream);
        expect(result, isTrue);
      });

      test('returns false when next token is not rparen', () {
        final first = t.token("first", TokenTypes.identifier);
        final tokenStream =
            RhapsodyTokenStream([first, t.token("(", TokenTypes.lparen)]);

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
      final first = t.token("first", TokenTypes.identifier);
      final tokenStream =
          RhapsodyTokenStream([first, t.token("and", TokenTypes.operatorType)]);

      final result =
          RhapsodyTokenStreamFlyweight.peekIsAndOperator(tokenStream);
      expect(result, isTrue);
    });

    test('returns false when next token is not "and" operator', () {
      final first = t.token("first", TokenTypes.identifier);
      final tokenStream =
          RhapsodyTokenStream([first, t.token("or", TokenTypes.operatorType)]);

      final result =
          RhapsodyTokenStreamFlyweight.peekIsAndOperator(tokenStream);
      expect(result, isFalse);
    });
  });
  group('Parenthesis Methods', () {
    late MockTokenCreator t;

    setUp(() {
      t = MockTokenCreator();
    });

    test('peekIsLeftParenthesis returns true for lparen', () {
      final first = t.token("first", TokenTypes.identifier);
      final tokens =
          RhapsodyTokenStream([first, t.token("(", TokenTypes.lparen)]);
      expect(
          RhapsodyTokenStreamFlyweight.peekIsLeftParenthesis(tokens), isTrue);
    });

    test('peekIsLeftParenthesis returns false for non-lparen', () {
      final first = t.token("first", TokenTypes.identifier);
      final tokens =
          RhapsodyTokenStream([first, t.token(")", TokenTypes.rparen)]);
      expect(
          RhapsodyTokenStreamFlyweight.peekIsLeftParenthesis(tokens), isFalse);
    });

    test('consumeRightParenthesis consumes rparen successfully', () {
      final tokens = RhapsodyTokenStream([t.token(")", TokenTypes.rparen)]);
      RhapsodyTokenStreamFlyweight.consumeRightParenthesis(tokens);
      expect(tokens.isAtEnd, isTrue);
    });

    test('consumeRightParenthesis throws if not rparen', () {
      final tokens = RhapsodyTokenStream([t.token("(", TokenTypes.lparen)]);
      expect(() => RhapsodyTokenStreamFlyweight.consumeRightParenthesis(tokens),
          throwsA(isA<SemanticException>()));
    });
  });

  group('Operator Methods', () {
    late MockTokenCreator t;

    setUp(() {
      t = MockTokenCreator();
    });

    test('peekIsNotOperator returns true for "not"', () {
      final first = t.token("first", TokenTypes.identifier);
      final tokens =
          RhapsodyTokenStream([first, t.token("not", TokenTypes.operatorType)]);
      expect(RhapsodyTokenStreamFlyweight.peekIsNotOperator(tokens), isTrue);
    });

    test('peekIsNotOperator returns false for non-"not"', () {
      final first = t.token("first", TokenTypes.identifier);
      final tokens =
          RhapsodyTokenStream([first, t.token("and", TokenTypes.operatorType)]);
      expect(RhapsodyTokenStreamFlyweight.peekIsNotOperator(tokens), isFalse);
    });

    test('consumeNotOperator consumes "not" successfully', () {
      final tokens =
          RhapsodyTokenStream([t.token("not", TokenTypes.operatorType)]);
      RhapsodyTokenStreamFlyweight.consumeNotOperator(tokens);
      expect(tokens.isAtEnd, isTrue);
    });

    test('consumeNotOperator throws if not "not"', () {
      final tokens =
          RhapsodyTokenStream([t.token("or", TokenTypes.operatorType)]);
      expect(() => RhapsodyTokenStreamFlyweight.consumeNotOperator(tokens),
          throwsA(isA<SemanticException>()));
    });
  });

  group('Equal Methods', () {
    late MockTokenCreator t;

    setUp(() {
      t = MockTokenCreator();
    });

    test('peekIsEqual returns true for equal token', () {
      final first = t.token("first", TokenTypes.identifier);
      final tokens =
          RhapsodyTokenStream([first, t.token("=", TokenTypes.equal)]);
      expect(RhapsodyTokenStreamFlyweight.peekIsEqual(tokens), isTrue);
    });

    test('peekIsEqual returns false for non-equal token', () {
      final first = t.token("first", TokenTypes.identifier);
      final tokens =
          RhapsodyTokenStream([first, t.token("(", TokenTypes.lparen)]);
      expect(RhapsodyTokenStreamFlyweight.peekIsEqual(tokens), isFalse);
    });

    test('consumeEqual consumes "=" successfully', () {
      final tokens = RhapsodyTokenStream([t.token("=", TokenTypes.equal)]);
      RhapsodyTokenStreamFlyweight.consumeEqual(tokens);
      expect(tokens.isAtEnd, isTrue);
    });

    test('consumeEqual throws if not "="', () {
      final tokens = RhapsodyTokenStream([t.token(",", TokenTypes.comma)]);
      expect(() => RhapsodyTokenStreamFlyweight.consumeEqual(tokens),
          throwsA(isA<SemanticException>()));
    });
  });

  group('Comma Methods', () {
    late MockTokenCreator t;

    setUp(() {
      t = MockTokenCreator();
    });

    test('peekIsComma returns true for comma', () {
      final first = t.token("first", TokenTypes.identifier);
      final tokens =
          RhapsodyTokenStream([first, t.token(",", TokenTypes.comma)]);
      expect(RhapsodyTokenStreamFlyweight.peekIsComma(tokens), isTrue);
    });

    test('peekIsComma returns false for non-comma', () {
      final first = t.token("first", TokenTypes.identifier);
      final tokens =
          RhapsodyTokenStream([first, t.token(";", TokenTypes.semicolon)]);
      expect(RhapsodyTokenStreamFlyweight.peekIsComma(tokens), isFalse);
    });

    test('consumeComma consumes comma successfully', () {
      final tokens = RhapsodyTokenStream([t.token(",", TokenTypes.comma)]);
      RhapsodyTokenStreamFlyweight.consumeComma(tokens);
      expect(tokens.isAtEnd, isTrue);
    });

    test('consumeComma throws if not comma', () {
      final tokens = RhapsodyTokenStream([t.token(":", TokenTypes.colon)]);
      expect(() => RhapsodyTokenStreamFlyweight.consumeComma(tokens),
          throwsA(isA<SemanticException>()));
    });
  });

  group('Semicolon Methods', () {
    late MockTokenCreator t;

    setUp(() {
      t = MockTokenCreator();
    });

    test('peekIsSemicolon returns true for semicolon', () {
      final first = t.token("first", TokenTypes.identifier);
      final tokens =
          RhapsodyTokenStream([first, t.token(";", TokenTypes.semicolon)]);
      expect(RhapsodyTokenStreamFlyweight.peekIsSemicolon(tokens), isTrue);
    });

    test('peekIsSemicolon returns false for non-semicolon', () {
      final first = t.token("first", TokenTypes.identifier);
      final tokens =
          RhapsodyTokenStream([first, t.token(",", TokenTypes.comma)]);
      expect(RhapsodyTokenStreamFlyweight.peekIsSemicolon(tokens), isFalse);
    });

    test('consumeSemicolon consumes semicolon successfully', () {
      final tokens = RhapsodyTokenStream([t.token(";", TokenTypes.semicolon)]);
      RhapsodyTokenStreamFlyweight.consumeSemicolon(tokens);
      expect(tokens.isAtEnd, isTrue);
    });

    test('consumeSemicolon throws if not semicolon', () {
      final tokens = RhapsodyTokenStream([t.token(":", TokenTypes.colon)]);
      expect(() => RhapsodyTokenStreamFlyweight.consumeSemicolon(tokens),
          throwsA(isA<SemanticException>()));
    });
  });

  group('Colon Methods', () {
    late MockTokenCreator t;

    setUp(() {
      t = MockTokenCreator();
    });

    test('peekIsColon returns true for colon', () {
      final first = t.token("first", TokenTypes.identifier);
      final tokens =
          RhapsodyTokenStream([first, t.token(":", TokenTypes.colon)]);
      expect(RhapsodyTokenStreamFlyweight.peekIsColon(tokens), isTrue);
    });

    test('peekIsColon returns false for non-colon', () {
      final first = t.token("first", TokenTypes.identifier);
      final tokens =
          RhapsodyTokenStream([first, t.token(";", TokenTypes.semicolon)]);
      expect(RhapsodyTokenStreamFlyweight.peekIsColon(tokens), isFalse);
    });

    test('consumeColon consumes colon successfully', () {
      final tokens = RhapsodyTokenStream([t.token(":", TokenTypes.colon)]);
      RhapsodyTokenStreamFlyweight.consumeColon(tokens);
      expect(tokens.isAtEnd, isTrue);
    });

    test('consumeColon throws if not colon', () {
      final tokens = RhapsodyTokenStream([t.token(",", TokenTypes.comma)]);
      expect(() => RhapsodyTokenStreamFlyweight.consumeColon(tokens),
          throwsA(isA<SemanticException>()));
    });
  });
}
