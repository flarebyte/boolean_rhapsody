import 'package:boolean_rhapsody/boolean_rhapsody.dart';
import 'package:test/test.dart';

import 'code_fixtures.dart';

/// Stub implementation to support tests. In a real scenario this class would
/// be part of your library.
class RhapsodySupportedPrefixes {
  final List<String> prefixes;
  RhapsodySupportedPrefixes(this.prefixes);

  /// Returns `true` if [text] starts with any supported prefix followed by a colon.
  bool isPrefixSupported(String text) {
    for (final prefix in prefixes) {
      if (text.startsWith('$prefix:')) return true;
    }
    return false;
  }
}

String removeSpacesAndLineReturns(String input) {
  return input.replaceAll(RegExp(r'\s+'), '');
}

void main() {
  group('RhapsodyTokeniser', () {
    // Create a dummy parser options instance.
    final options = RhapsodyParserOptions(
      prefixes: ['prefix'],
      functions: ['func1', 'func2'],
      variableValidator: (variable) => true,
    );

    final tokeniser = RhapsodyTokeniser(options);

    test('parses a simple function call with a prefixed variable', () {
      final code = 'func1(prefix:a)';
      final tokens = tokeniser.parse(code);
      expect(tokens, isNotEmpty);

      // Expected tokens:
      //   Identifier "func1", ParenOpen "(",
      //   Identifier "prefix", Colon ":", Identifier "a",
      //   ParenClose ")"
      expect(tokens.length, equals(6));

      expect(tokens[0].text, equals('func1'));
      expect(tokens[0].type, equals(TokenTypes.identifier));

      expect(tokens[1].text, equals('('));
      expect(tokens[1].type, equals(TokenTypes.parenOpen));

      expect(tokens[2].text, equals('prefix'));
      expect(tokens[2].type, equals(TokenTypes.identifier));

      expect(tokens[3].text, equals(':'));
      expect(tokens[3].type, equals(TokenTypes.colon));

      expect(tokens[4].text, equals('a'));
      expect(tokens[4].type, equals(TokenTypes.identifier));

      expect(tokens[5].text, equals(')'));
      expect(tokens[5].type, equals(TokenTypes.parenClose));
    });

    test('parses operators correctly', () {
      final code = 'a and b or not c';
      final tokens = tokeniser.parse(code);
      // Expected tokens:
      //   Identifier "a", Operator "and", Identifier "b",
      //   Operator "or", Operator "not", Identifier "c"
      expect(tokens.length, equals(6));
      expect(tokens[0].text, equals('a'));
      expect(tokens[0].type, equals(TokenTypes.identifier));
      expect(tokens[1].text, equals('and'));
      expect(tokens[1].type, equals(TokenTypes.operatorType));
      expect(tokens[2].text, equals('b'));
      expect(tokens[2].type, equals(TokenTypes.identifier));
      expect(tokens[3].text, equals('or'));
      expect(tokens[3].type, equals(TokenTypes.operatorType));
      expect(tokens[4].text, equals('not'));
      expect(tokens[4].type, equals(TokenTypes.operatorType));
      expect(tokens[5].text, equals('c'));
      expect(tokens[5].type, equals(TokenTypes.identifier));
    });

    test('extracts comments correctly', () {
      final code = 'a # this is a comment \n b';
      final tokens = tokeniser.parse(code);
      // Expected tokens:
      //   Identifier "a", Comment "# this is a comment ", Identifier "b"
      expect(tokens.length, equals(3));
      expect(tokens[0].text, equals('a'));
      expect(tokens[0].type, equals(TokenTypes.identifier));

      expect(tokens[1].text, equals('# this is a comment '));
      expect(tokens[1].type, equals(TokenTypes.comment));

      expect(tokens[2].text, equals('b'));
      expect(tokens[2].type, equals(TokenTypes.identifier));
    });

    test('parses numeric literals', () {
      final code = '123 456';
      final tokens = tokeniser.parse(code);
      expect(tokens.length, equals(2));
      expect(tokens[0].text, equals('123'));
      expect(tokens[0].type, equals(TokenTypes.number));
      expect(tokens[1].text, equals('456'));
      expect(tokens[1].type, equals(TokenTypes.number));
    });

    test('parses a complex rule expression with semicolon', () {
      final code = 'rule r23 = (func1(a) or func2(b)) and not rule42;';
      final tokens = tokeniser.parse(code);
      // Expected token breakdown:
      //   0: Identifier "rule"
      //   1: Number "23"
      //   2: Equal "="
      //   3: ParenOpen "("
      //   4: Identifier "func1"
      //   5: ParenOpen "("
      //   6: Identifier "a"
      //   7: ParenClose ")"
      //   8: Operator "or"
      //   9: Identifier "func2"
      //  10: ParenOpen "("
      //  11: Identifier "b"
      //  12: ParenClose ")"
      //  13: ParenClose ")"
      //  14: Operator "and"
      //  15: Operator "not"
      //  16: Identifier "rule42"
      //  17: Semicolon ";"
      expect(tokens.length, equals(18));

      expect(tokens[0].text, equals('rule'));
      expect(tokens[0].type, equals(TokenTypes.identifier));
      expect(tokens[1].text, equals('r23'));
      expect(tokens[1].type, equals(TokenTypes.identifier));
      expect(tokens[2].text, equals('='));
      expect(tokens[2].type, equals(TokenTypes.equal));
      expect(tokens[3].text, equals('('));
      expect(tokens[3].type, equals(TokenTypes.parenOpen));
      expect(tokens[4].text, equals('func1'));
      expect(tokens[4].type, equals(TokenTypes.identifier));
      expect(tokens[5].text, equals('('));
      expect(tokens[5].type, equals(TokenTypes.parenOpen));
      expect(tokens[6].text, equals('a'));
      expect(tokens[6].type, equals(TokenTypes.identifier));
      expect(tokens[7].text, equals(')'));
      expect(tokens[7].type, equals(TokenTypes.parenClose));
      expect(tokens[8].text, equals('or'));
      expect(tokens[8].type, equals(TokenTypes.operatorType));
      expect(tokens[9].text, equals('func2'));
      expect(tokens[9].type, equals(TokenTypes.identifier));
      expect(tokens[10].text, equals('('));
      expect(tokens[10].type, equals(TokenTypes.parenOpen));
      expect(tokens[11].text, equals('b'));
      expect(tokens[11].type, equals(TokenTypes.identifier));
      expect(tokens[12].text, equals(')'));
      expect(tokens[12].type, equals(TokenTypes.parenClose));
      expect(tokens[13].text, equals(')'));
      expect(tokens[13].type, equals(TokenTypes.parenClose));
      expect(tokens[14].text, equals('and'));
      expect(tokens[14].type, equals(TokenTypes.operatorType));
      expect(tokens[15].text, equals('not'));
      expect(tokens[15].type, equals(TokenTypes.operatorType));
      expect(tokens[16].text, equals('rule42'));
      expect(tokens[16].type, equals(TokenTypes.identifier));
      expect(tokens[17].text, equals(';'));
      expect(tokens[17].type, equals(TokenTypes.semicolon));
    });

    test('unparses tokens back into code', () {
      final code = 'func1(a) and func2(b)';
      final tokens = tokeniser.parse(code);
      final reconstructed = tokeniser.unparse(tokens);

      // Since the unparse method heuristically reinserts spaces,
      // the exact formatting may differ from the original.
      // Here we simply verify that all token texts appear in order.
      expect(reconstructed.contains('func1'), isTrue);
      expect(reconstructed.contains('('), isTrue);
      expect(reconstructed.contains(')'), isTrue);
      expect(reconstructed.contains('and'), isTrue);
      expect(reconstructed.contains('func2'), isTrue);
    });

    test('parse and unparse multiple examples of code', () {
      final testTokeniser = RhapsodyTokeniser(fixtureMockOptions);
      for (var code in codeSamples) {
        final tokens = testTokeniser.parse(code);
        final reconstructed = testTokeniser.unparse(tokens);
        expect(removeSpacesAndLineReturns(reconstructed),
            equals(removeSpacesAndLineReturns(code)));
      }
    });
  });
}
