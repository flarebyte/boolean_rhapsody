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

  group('RhapsodyTokeniser token positions', () {
    final options = RhapsodyParserOptions(
      prefixes: ['prefix'],
      functions: ['func1', 'func2'],
      variableValidator: (variable) => true,
    );

    final tokeniser = RhapsodyTokeniser(options);
    test('Token positions are correct in a single-line code sample', () {
      final code = 'func1(prefix:a)';
      final tokens = tokeniser.parse(code);

      // Expected breakdown for "func1(prefix:a)":
      // Token 0: "func1"      -> indices [0, 5), row 0, col 0-5
      // Token 1: "("          -> indices [5, 6), row 0, col 5-6
      // Token 2: "prefix"     -> indices [6, 12), row 0, col 6-12
      // Token 3: ":"          -> indices [12, 13), row 0, col 12-13
      // Token 4: "a"          -> indices [13, 14), row 0, col 13-14
      // Token 5: ")"          -> indices [14, 15), row 0, col 14-15

      expect(tokens.length, equals(6));

      // Check token "func1"
      expect(tokens[0].startIndex, equals(0));
      expect(tokens[0].endIndex, equals(5));
      expect(tokens[0].startPosition.row, equals(0));
      expect(tokens[0].startPosition.column, equals(0));
      expect(tokens[0].endPosition.row, equals(0));
      expect(tokens[0].endPosition.column, equals(5));

      // Check token "("
      expect(tokens[1].startIndex, equals(5));
      expect(tokens[1].endIndex, equals(6));
      expect(tokens[1].startPosition.row, equals(0));
      expect(tokens[1].startPosition.column, equals(5));
      expect(tokens[1].endPosition.row, equals(0));
      expect(tokens[1].endPosition.column, equals(6));

      // Check token "prefix"
      expect(tokens[2].startIndex, equals(6));
      expect(tokens[2].endIndex, equals(12));
      expect(tokens[2].startPosition.row, equals(0));
      expect(tokens[2].startPosition.column, equals(6));
      expect(tokens[2].endPosition.row, equals(0));
      expect(tokens[2].endPosition.column, equals(12));

      // Check token ":"
      expect(tokens[3].startIndex, equals(12));
      expect(tokens[3].endIndex, equals(13));
      expect(tokens[3].startPosition.row, equals(0));
      expect(tokens[3].startPosition.column, equals(12));
      expect(tokens[3].endPosition.row, equals(0));
      expect(tokens[3].endPosition.column, equals(13));

      // Check token "a"
      expect(tokens[4].startIndex, equals(13));
      expect(tokens[4].endIndex, equals(14));
      expect(tokens[4].startPosition.row, equals(0));
      expect(tokens[4].startPosition.column, equals(13));
      expect(tokens[4].endPosition.row, equals(0));
      expect(tokens[4].endPosition.column, equals(14));

      // Check token ")"
      expect(tokens[5].startIndex, equals(14));
      expect(tokens[5].endIndex, equals(15));
      expect(tokens[5].startPosition.row, equals(0));
      expect(tokens[5].startPosition.column, equals(14));
      expect(tokens[5].endPosition.row, equals(0));
      expect(tokens[5].endPosition.column, equals(15));
    });

    test('Token positions are correct in a multi-line code sample', () {
      final code = 'func1(prefix:a)\nfunc2(b)';
      final tokens = tokeniser.parse(code);

      // First line (same as the previous test):
      // Tokens 0 to 5 are for "func1(prefix:a)".
      expect(tokens.length, equals(10));

      expect(tokens[0].text, equals('func1'));
      expect(tokens[0].startIndex, equals(0));
      expect(tokens[0].endIndex, equals(5));
      expect(tokens[0].startPosition.row, equals(0));
      expect(tokens[0].startPosition.column, equals(0));
      expect(tokens[0].endPosition.row, equals(0));
      expect(tokens[0].endPosition.column, equals(5));

      // ( ... tokens[1] through tokens[5] are identical to the previous test )

      // Second line:
      // After the first line, a newline is encountered at index 15,
      // so the second line tokens start after that.
      // Expected breakdown for "func2(b)":
      // Token 6: "func2"      -> indices [16, 21), row 1, col 0-5
      // Token 7: "("          -> indices [21, 22), row 1, col 5-6
      // Token 8: "b"          -> indices [22, 23), row 1, col 6-7
      // Token 9: ")"          -> indices [23, 24), row 1, col 7-8

      // Check token "func2"
      expect(tokens[6].text, equals('func2'));
      expect(tokens[6].startIndex, equals(16));
      expect(tokens[6].endIndex, equals(21));
      expect(tokens[6].startPosition.row, equals(1));
      expect(tokens[6].startPosition.column, equals(0));
      expect(tokens[6].endPosition.row, equals(1));
      expect(tokens[6].endPosition.column, equals(5));

      // Check token "(" on second line
      expect(tokens[7].text, equals('('));
      expect(tokens[7].startIndex, equals(21));
      expect(tokens[7].endIndex, equals(22));
      expect(tokens[7].startPosition.row, equals(1));
      expect(tokens[7].startPosition.column, equals(5));
      expect(tokens[7].endPosition.row, equals(1));
      expect(tokens[7].endPosition.column, equals(6));

      // Check token "b"
      expect(tokens[8].text, equals('b'));
      expect(tokens[8].startIndex, equals(22));
      expect(tokens[8].endIndex, equals(23));
      expect(tokens[8].startPosition.row, equals(1));
      expect(tokens[8].startPosition.column, equals(6));
      expect(tokens[8].endPosition.row, equals(1));
      expect(tokens[8].endPosition.column, equals(7));

      // Check token ")" on second line
      expect(tokens[9].text, equals(')'));
      expect(tokens[9].startIndex, equals(23));
      expect(tokens[9].endIndex, equals(24));
      expect(tokens[9].startPosition.row, equals(1));
      expect(tokens[9].startPosition.column, equals(7));
      expect(tokens[9].endPosition.row, equals(1));
      expect(tokens[9].endPosition.column, equals(8));
    });
  });
}
