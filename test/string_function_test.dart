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

      expect(function.isTrue(emptyContext), RhapsodicBool.truth());

      expect(
          function.isTrue(RhapsodyEvaluationContextBuilder()
              .setRefValue('v:example', 'value')
              .build()),
          RhapsodicBool.untruth());
    });

    test('is_present function works correctly', () {
      final function =
          BooleanRhapsodyFunctionFactory.create('is_present', ['v:example']);

      expect(
          function.isTrue(RhapsodyEvaluationContextBuilder()
              .setRefValue('v:example', 'value')
              .build()),
          RhapsodicBool.truth());

      expect(function.isTrue(emptyContext), RhapsodicBool.untruth());
    });

    test('is_empty_string function works correctly', () {
      final function = BooleanRhapsodyFunctionFactory.create(
          'is_empty_string', ['v:example']);

      expect(
          function.isTrue(RhapsodyEvaluationContextBuilder()
              .setRefValue('v:example', '')
              .build()),
          RhapsodicBool.truth());

      expect(
          function.isTrue(RhapsodyEvaluationContextBuilder()
              .setRefValue('v:example', 'not empty')
              .build()),
          RhapsodicBool.untruth());
    });

    test('is_multiple_lines function works correctly', () {
      final function = BooleanRhapsodyFunctionFactory.create(
          'is_multiple_lines', ['v:example']);

      expect(
          function.isTrue(RhapsodyEvaluationContextBuilder()
              .setRefValue('v:example', 'line1\nline2')
              .build()),
          RhapsodicBool.truth());

      expect(
          function.isTrue(RhapsodyEvaluationContextBuilder()
              .setRefValue('v:example', 'single line')
              .build()),
          RhapsodicBool.untruth());
    });

    test('is_single_line function works correctly', () {
      final function = BooleanRhapsodyFunctionFactory.create(
          'is_single_line', ['v:example']);

      expect(
          function.isTrue(RhapsodyEvaluationContextBuilder()
              .setRefValue('v:example', 'single line')
              .build()),
          RhapsodicBool.truth());

      expect(
          function.isTrue(RhapsodyEvaluationContextBuilder()
              .setRefValue('v:example', 'line1\nline2')
              .build()),
          RhapsodicBool.untruth());
    });

    test('contains_substring function works correctly', () {
      final function = BooleanRhapsodyFunctionFactory.create(
          'contains_substring', ['v:text', 'v:term']);

      expect(
          function.isTrue(RhapsodyEvaluationContextBuilder()
              .setRefValue('v:text', 'Hello, world!')
              .setRefValue('v:term', 'world')
              .build()),
          RhapsodicBool.truth());

      expect(
          function.isTrue(RhapsodyEvaluationContextBuilder()
              .setRefValue('v:term', 'absent')
              .build()),
          RhapsodicBool.untruthy());
    });

    test('contains_substring function works correctly while ignoring case', () {
      final function = BooleanRhapsodyFunctionFactory.create(
          'contains_substring', ['v:text', 'v:term', 'c:ignoreCase']);

      expect(
          function.isTrue(RhapsodyEvaluationContextBuilder()
              .setRefValue('v:text', 'Hello, world!')
              .setRefValue('v:term', 'World')
              .setRefValue('c:ignoreCase', 'true')
              .build()),
          RhapsodicBool.truth());

      expect(
          function.isTrue(RhapsodyEvaluationContextBuilder()
              .setRefValue('v:term', 'absent')
              .build()),
          RhapsodicBool.untruthy());
    });

    test('starts_with_prefix function works correctly', () {
      final function = BooleanRhapsodyFunctionFactory.create(
          'starts_with_prefix', ['v:text', 'v:prefix']);

      expect(
          function.isTrue(RhapsodyEvaluationContextBuilder()
              .setRefValue('v:text', 'Hello, world!')
              .setRefValue('v:prefix', 'Hello')
              .build()),
          RhapsodicBool.truth());

      expect(
          function.isTrue(RhapsodyEvaluationContextBuilder()
              .setRefValue('v:prefix', 'world')
              .build()),
          RhapsodicBool.untruthy());
    });

    test('ends_with_suffix function works correctly', () {
      final function = BooleanRhapsodyFunctionFactory.create(
          'ends_with_suffix', ['v:text', 'v:suffix']);

      expect(
          function.isTrue(setContextTwoKeyValue(
              'v:text', 'Hello, world!', 'v:suffix', 'world!')),
          RhapsodicBool.truth());
      expect(
          function.isTrue(RhapsodyEvaluationContextBuilder()
              .setRefValue('v:suffix', 'Hello')
              .build()),
          RhapsodicBool.untruthy());
    });

    test('equals function works correctly', () {
      final function = BooleanRhapsodyFunctionFactory.create(
          'string_equals', ['v:text1', 'v:text2']);

      expect(
          function.isTrue(RhapsodyEvaluationContextBuilder()
              .setRefValue('v:text1', 'Hello, world!')
              .setRefValue('v:text2', 'Hello, world!')
              .build()),
          RhapsodicBool.truth());

      expect(
          function.isTrue(RhapsodyEvaluationContextBuilder()
              .setRefValue('v:text2', 'Goodbye, world!')
              .build()),
          RhapsodicBool.untruthy());
    });

    test('Unknown function throws exception', () {
      expect(() => BooleanRhapsodyFunctionFactory.create('unknown', []),
          throwsA(isA<Exception>()));
    });
  });
}
