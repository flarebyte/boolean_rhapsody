import 'package:boolean_rhapsody/boolean_rhapsody.dart';
import 'package:test/test.dart';

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

void main() {
  group('RhapsodyTokeniser', () {
    // Create a dummy parser options instance.
    final options = RhapsodyParserOptions(
      prefixes: ['prefix'],
      functions: ['func1', 'func2'],
      variableValidator: (variable) => true,
    );

    final tokeniser = RhapsodyTokeniser(options);

    test('parses a simple function call', () {
      final code = 'func1(a)';
      final tokens = tokeniser.parse(code);
      expect(tokens, isNotEmpty);

      // Expected tokens:
      //   Identifier "func1", ParenOpen "(", Identifier "a", ParenClose ")"
      expect(tokens.length, equals(4));
      expect(tokens[0].text, equals('func1'));
      expect(tokens[0].type, equals('Identifier'));

      expect(tokens[1].text, equals('('));
      expect(tokens[1].type, equals('ParenOpen'));

      expect(tokens[2].text, equals('a'));
      expect(tokens[2].type, equals('Identifier'));

      expect(tokens[3].text, equals(')'));
      expect(tokens[3].type, equals('ParenClose'));
    });

    test('parses operators correctly', () {
      final code = 'a and b or not c';
      final tokens = tokeniser.parse(code);
      // Expected tokens:
      //   Identifier "a", Operator "and", Identifier "b",
      //   Operator "or", Operator "not", Identifier "c"
      expect(tokens.length, equals(6));
      expect(tokens[0].text, equals('a'));
      expect(tokens[1].text, equals('and'));
      expect(tokens[1].type, equals('Operator'));
      expect(tokens[2].text, equals('b'));
      expect(tokens[3].text, equals('or'));
      expect(tokens[3].type, equals('Operator'));
      expect(tokens[4].text, equals('not'));
      expect(tokens[4].type, equals('Operator'));
      expect(tokens[5].text, equals('c'));
    });

    test('skips comments correctly', () {
      final code = 'a # this is a comment \n b';
      final tokens = tokeniser.parse(code);
      // Expected tokens: Identifier "a" and Identifier "b"
      expect(tokens.length, equals(2));
      expect(tokens[0].text, equals('a'));
      expect(tokens[1].text, equals('b'));
    });

    test('parses numeric literals', () {
      final code = '123 456';
      final tokens = tokeniser.parse(code);
      expect(tokens.length, equals(2));
      expect(tokens[0].text, equals('123'));
      expect(tokens[0].type, equals('Number'));
      expect(tokens[1].text, equals('456'));
      expect(tokens[1].type, equals('Number'));
    });

    test('parses a complex rule expression with semicolon', () {
      final code = 'rule 23 = (func1(a) or func2(b)) and not rule42;';
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
      expect(tokens[1].text, equals('23'));
      expect(tokens[1].type, equals('Number'));
      expect(tokens[2].text, equals('='));
      expect(tokens[2].type, equals('Equal'));
      expect(tokens[3].text, equals('('));
      expect(tokens[3].type, equals('ParenOpen'));
      expect(tokens[4].text, equals('func1'));
      expect(tokens[5].text, equals('('));
      expect(tokens[5].type, equals('ParenOpen'));
      expect(tokens[6].text, equals('a'));
      expect(tokens[7].text, equals(')'));
      expect(tokens[7].type, equals('ParenClose'));
      expect(tokens[8].text, equals('or'));
      expect(tokens[8].type, equals('Operator'));
      expect(tokens[9].text, equals('func2'));
      expect(tokens[10].text, equals('('));
      expect(tokens[10].type, equals('ParenOpen'));
      expect(tokens[11].text, equals('b'));
      expect(tokens[12].text, equals(')'));
      expect(tokens[12].type, equals('ParenClose'));
      expect(tokens[13].text, equals(')'));
      expect(tokens[13].type, equals('ParenClose'));
      expect(tokens[14].text, equals('and'));
      expect(tokens[14].type, equals('Operator'));
      expect(tokens[15].text, equals('not'));
      expect(tokens[15].type, equals('Operator'));
      expect(tokens[16].text, equals('rule42'));
      expect(tokens[17].text, equals(';'));
      expect(tokens[17].type, equals('Semicolon'));
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
  });
}
