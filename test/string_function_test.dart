import 'package:boolean_rhapsody/boolean_rhapsody.dart';
import 'package:test/test.dart';

void main() {
  final emptyContext = RhapsodyEvaluationContext(
    variables: {},
    constants: {},
    parameters: {},
    deviceVars: {},
  );
  setContextKeyValue(String key, String value) {
    return RhapsodyEvaluationContext(
      variables: {key: value},
      constants: {},
      parameters: {},
      deviceVars: {},
    );
  }

  setContextTwoKeyValue(String key1, String value1, String key2, value2) {
    return RhapsodyEvaluationContext(
      variables: {key1: value1, key2: value2},
      constants: {},
      parameters: {},
      deviceVars: {},
    );
  }

  group('BooleanRhapsodyFunctionFactory Tests', () {
    test('is_absent function works correctly', () {
      final function =
          BooleanRhapsodyFunctionFactory.create('is_absent', ['v:example']);

      expect(function.isTrue(emptyContext), isTrue);

      expect(
          function.isTrue(setContextKeyValue('v:example', 'value')), isFalse);
    });

    test('is_present function works correctly', () {
      final function =
          BooleanRhapsodyFunctionFactory.create('is_present', ['v:example']);

      expect(function.isTrue(setContextKeyValue('v:example', 'value')), isTrue);

      expect(function.isTrue(emptyContext), isFalse);
    });

    test('is_empty_string function works correctly', () {
      final function = BooleanRhapsodyFunctionFactory.create(
          'is_empty_string', ['v:example']);

      expect(function.isTrue(setContextKeyValue('v:example', '')), isTrue);

      expect(function.isTrue(setContextKeyValue('v:example', 'not empty')),
          isFalse);
    });

    test('is_multiple_lines function works correctly', () {
      final function = BooleanRhapsodyFunctionFactory.create(
          'is_multiple_lines', ['v:example']);

      expect(function.isTrue(setContextKeyValue('v:example', 'line1\nline2')),
          isTrue);

      expect(function.isTrue(setContextKeyValue('v:example', 'single line')),
          isFalse);
    });

    test('is_single_line function works correctly', () {
      final function = BooleanRhapsodyFunctionFactory.create(
          'is_single_line', ['v:example']);

      expect(function.isTrue(setContextKeyValue('v:example', 'single line')),
          isTrue);

      expect(function.isTrue(setContextKeyValue('v:example', 'line1\nline2')),
          isFalse);
    });

    test('contains_substring function works correctly', () {
      final function = BooleanRhapsodyFunctionFactory.create(
          'contains_substring', ['v:text', 'v:term']);

      expect(
          function.isTrue(setContextTwoKeyValue(
              'v:text', 'Hello, world!', 'v:term', 'world')),
          isTrue);

      expect(function.isTrue(setContextKeyValue('v:term', 'absent')), isFalse);
    });

    test('starts_with_prefix function works correctly', () {
      final function = BooleanRhapsodyFunctionFactory.create(
          'starts_with_prefix', ['v:text', 'v:prefix']);

      expect(
          function.isTrue(setContextTwoKeyValue(
              'v:text', 'Hello, world!', 'v:prefix', 'Hello')),
          isTrue);

      expect(function.isTrue(setContextKeyValue('v:prefix', 'world')), isFalse);
    });

    test('ends_with_suffix function works correctly', () {
      final function = BooleanRhapsodyFunctionFactory.create(
          'ends_with_suffix', ['v:text', 'v:suffix']);

      expect(
          function.isTrue(setContextTwoKeyValue(
              'v:text', 'Hello, world!', 'v:suffix', 'world!')),
          isTrue);
      expect(function.isTrue(setContextKeyValue('v:suffix', 'Hello')), isFalse);
    });

    test('equals function works correctly', () {
      final function = BooleanRhapsodyFunctionFactory.create(
          'equals', ['v:text1', 'v:text2']);

      expect(
          function.isTrue(setContextTwoKeyValue(
              'v:text1', 'Hello, world!', 'v:text2', 'Hello, world!')),
          isTrue);

      expect(function.isTrue(setContextKeyValue('v:text2', 'Goodbye, world!')),
          isFalse);
    });

    test('Unknown function throws exception', () {
      expect(() => BooleanRhapsodyFunctionFactory.create('unknown', []),
          throwsA(isA<Exception>()));
    });
  });
}
