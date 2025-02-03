import 'package:boolean_rhapsody/boolean_rhapsody.dart';
import 'package:test/test.dart';

void main() {
  group('RhapsodicParserOptions', () {
    // Test setup: valid prefixes and functions.
    final prefixes = ['foo', 'bar'];
    final functions = ['sum', 'multiply'];

    // A simple variable validator that accepts only alphabetic characters.
    bool variableValidator(String varName) =>
        RegExp(r'^[a-zA-Z]+$').hasMatch(varName);

    final parserOptions = RhapsodyParserOptions(
      prefixes: prefixes,
      functions: functions,
      variableValidator: variableValidator,
    );

    test('isVariable returns true for valid variable names', () {
      // Valid because the prefix is supported and the variable part is alphabetic.
      expect(parserOptions.isVariable('foo:hello'), isTrue);
      expect(parserOptions.isVariable('bar:World'), isTrue);
    });

    test('isVariable returns false for unsupported prefix', () {
      // "baz" is not in the list of valid prefixes.
      expect(parserOptions.isVariable('baz:hello'), isFalse);
    });

    test('isVariable returns false when colon is missing', () {
      // Missing colon between prefix and variable name.
      expect(parserOptions.isVariable('foohello'), isFalse);
    });

    test('isVariable returns false for empty variable part', () {
      // There is a colon but nothing after it.
      expect(parserOptions.isVariable('foo:'), isFalse);
    });

    test('isVariable returns false when variable part fails validation', () {
      // The variable part contains a digit, but our validator only allows letters.
      expect(parserOptions.isVariable('foo:hello123'), isFalse);
    });

    test('isFunction returns true for recognized functions', () {
      expect(parserOptions.isFunction('sum'), isTrue);
      expect(parserOptions.isFunction('multiply'), isTrue);
    });

    test('isFunction returns false for unrecognized functions', () {
      expect(parserOptions.isFunction('divide'), isFalse);
    });
  });
}
