import 'package:boolean_rhapsody/boolean_rhapsody.dart';
import 'package:test/test.dart';

const defaultPrefixes = ["c", "v", "p", "d"];
void main() {
  final emptyContext =
      RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes).build();

  group('BooleanRhapsodyFunctionFactory Tests', () {
    test('is_absent function works correctly', () {
      final function =
          BooleanRhapsodyFunctionFactory.create('is_absent', ['v:example']);

      expect(function.isTrue(emptyContext), RhapsodicBool.truth());

      expect(
          function.isTrue(
              RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes)
                  .setRefValue('v:example', 'value')
                  .build()),
          RhapsodicBool.untruth());
    });

    test('is_present function works correctly', () {
      final function =
          BooleanRhapsodyFunctionFactory.create('is_present', ['v:example']);

      expect(
          function.isTrue(
              RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes)
                  .setRefValue('v:example', 'value')
                  .build()),
          RhapsodicBool.truth());

      expect(function.isTrue(emptyContext), RhapsodicBool.untruth());
    });

    test('is_empty_string function works correctly', () {
      final function = BooleanRhapsodyFunctionFactory.create(
          'is_empty_string', ['v:example']);

      expect(
          function.isTrue(
              RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes)
                  .setRefValue('v:example', '')
                  .build()),
          RhapsodicBool.truth());

      expect(
          function.isTrue(
              RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes)
                  .setRefValue('v:example', 'not empty')
                  .build()),
          RhapsodicBool.untruth());
    });

    test('is_multiple_lines function works correctly', () {
      final function = BooleanRhapsodyFunctionFactory.create(
          'is_multiple_lines', ['v:example']);

      expect(
          function.isTrue(
              RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes)
                  .setRefValue('v:example', 'line1\nline2')
                  .build()),
          RhapsodicBool.truth());

      expect(
          function.isTrue(
              RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes)
                  .setRefValue('v:example', 'single line')
                  .build()),
          RhapsodicBool.untruth());
    });

    test('is_single_line function works correctly', () {
      final function = BooleanRhapsodyFunctionFactory.create(
          'is_single_line', ['v:example']);

      expect(
          function.isTrue(
              RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes)
                  .setRefValue('v:example', 'single line')
                  .build()),
          RhapsodicBool.truth());

      expect(
          function.isTrue(
              RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes)
                  .setRefValue('v:example', 'line1\nline2')
                  .build()),
          RhapsodicBool.untruth());
    });

    test('is_trimmable_string function works correctly', () {
      final function =
          BooleanRhapsodyFunctionFactory.create('is_trimmable_string', ['v:x']);

      expect(
          function.isTrue(
              RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes)
                  .setRefValue('v:x', '  trim  ')
                  .build()),
          RhapsodicBool.truth());

      expect(
          function.isTrue(
              RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes)
                  .setRefValue('v:x', 'nospaces')
                  .build()),
          RhapsodicBool.untruth());
    });

    test('is_complex_unicode and is_simple_unicode work correctly', () {
      final complex = BooleanRhapsodyFunctionFactory.create(
          'is_complex_unicode', ['v:emoji']);
      final simple = BooleanRhapsodyFunctionFactory.create(
          'is_simple_unicode', ['v:plain']);

      // Emoji typically spans multiple UTF-16 code units
      expect(
          complex.isTrue(
              RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes)
                  .setRefValue('v:emoji', '👍')
                  .build()),
          RhapsodicBool.truth());

      expect(
          simple.isTrue(
              RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes)
                  .setRefValue('v:plain', 'abc')
                  .build()),
          RhapsodicBool.truth());

      // Simple should be false for complex code points
      expect(
          simple.isTrue(
              RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes)
                  .setRefValue('v:plain', '👍')
                  .build()),
          RhapsodicBool.untruth());
    });

    test('is_allowed_chars respects provided allowed set and defaults', () {
      final function = BooleanRhapsodyFunctionFactory.create(
          'is_allowed_chars', ['v:val', 'c:allowed']);

      // All chars allowed
      expect(
          function.isTrue(
              RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes)
                  .setRefValue('c:allowed', 'abcXYZ123_-')
                  .setRefValue('v:val', 'aZ3_')
                  .build()),
          RhapsodicBool.truth());

      // Contains a disallowed char
      expect(
          function.isTrue(
              RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes)
                  .setRefValue('c:allowed', 'abc')
                  .setRefValue('v:val', 'abd!')
                  .build()),
          RhapsodicBool.untruth());

      // Null value => untruth
      expect(function.isTrue(emptyContext), RhapsodicBool.untruth());
    });

    test('is_numeric and is_integer behave correctly', () {
      final isNumeric =
          BooleanRhapsodyFunctionFactory.create('is_numeric', ['v:num']);
      final isInteger =
          BooleanRhapsodyFunctionFactory.create('is_integer', ['v:int']);

      expect(
          isNumeric.isTrue(
              RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes)
                  .setRefValue('v:num', '12.34')
                  .build()),
          RhapsodicBool.truth());
      expect(
          isNumeric.isTrue(
              RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes)
                  .setRefValue('v:num', '12a')
                  .build()),
          RhapsodicBool.untruth());

      expect(
          isInteger.isTrue(
              RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes)
                  .setRefValue('v:int', '42')
                  .build()),
          RhapsodicBool.truth());
      expect(
          isInteger.isTrue(
              RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes)
                  .setRefValue('v:int', '42.0')
                  .build()),
          RhapsodicBool.untruth());

      // Null value cases
      expect(isNumeric.isTrue(emptyContext), RhapsodicBool.untruth());
      expect(isInteger.isTrue(emptyContext), RhapsodicBool.untruth());
    });

    test('is_date_time validates ISO-8601 strings', () {
      final function =
          BooleanRhapsodyFunctionFactory.create('is_date_time', ['v:dt']);

      expect(
          function.isTrue(
              RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes)
                  .setRefValue('v:dt', '2024-01-02T03:04:05Z')
                  .build()),
          RhapsodicBool.truth());
      expect(
          function.isTrue(
              RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes)
                  .setRefValue('v:dt', 'not-a-date')
                  .build()),
          RhapsodicBool.untruth());

      // Null value case
      expect(function.isTrue(emptyContext), RhapsodicBool.untruth());
    });

    group('is_url function', () {
      test('basic http/https validation', () {
        final fn = BooleanRhapsodyFunctionFactory.create(
            'is_url', ['v:url', 'c:flags', 'c:domains']);

        expect(
            fn.isTrue(
                RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes)
                    .setRefValue('c:flags', '')
                    .setRefValue('c:domains', '')
                    .setRefValue('v:url', 'https://example.com')
                    .build()),
            RhapsodicBool.truth());

        expect(
            fn.isTrue(
                RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes)
                    .setRefValue('c:flags', '')
                    .setRefValue('c:domains', '')
                    .setRefValue('v:url', 'ftp://example.com')
                    .build()),
            RhapsodicBool.untruth());
      });

      test('null and invalid URL handling', () {
        final fn = BooleanRhapsodyFunctionFactory.create(
            'is_url', ['v:url', 'c:flags', 'c:domains']);

        // Null value
        expect(fn.isTrue(emptyContext), RhapsodicBool.untruth());

        // Invalid URL string
        expect(
            fn.isTrue(
                RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes)
                    .setRefValue('c:flags', '')
                    .setRefValue('c:domains', '')
                    .setRefValue('v:url', '::not a url::')
                    .build()),
            RhapsodicBool.untruth());
      });

      test('https flag enforcement', () {
        final fn = BooleanRhapsodyFunctionFactory.create(
            'is_url', ['v:url', 'c:flags', 'c:domains']);

        expect(
            fn.isTrue(
                RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes)
                    .setRefValue('c:flags', 'https')
                    .setRefValue('c:domains', '')
                    .setRefValue('v:url', 'http://example.com')
                    .build()),
            RhapsodicBool.untruth());

        expect(
            fn.isTrue(
                RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes)
                    .setRefValue('c:flags', 'https')
                    .setRefValue('c:domains', '')
                    .setRefValue('v:url', 'https://example.com')
                    .build()),
            RhapsodicBool.truth());
      });

      test('port, fragment, query flags', () {
        final fn = BooleanRhapsodyFunctionFactory.create(
            'is_url', ['v:url', 'c:flags', 'c:domains']);

        // Port without permission => untruth
        expect(
            fn.isTrue(
                RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes)
                    .setRefValue('c:flags', '')
                    .setRefValue('c:domains', '')
                    .setRefValue('v:url', 'https://example.com:8080')
                    .build()),
            RhapsodicBool.untruth());

        // Allow port
        expect(
            fn.isTrue(
                RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes)
                    .setRefValue('c:flags', 'port')
                    .setRefValue('c:domains', '')
                    .setRefValue('v:url', 'https://example.com:8080')
                    .build()),
            RhapsodicBool.truth());

        // Disallow fragment by default
        expect(
            fn.isTrue(
                RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes)
                    .setRefValue('c:flags', '')
                    .setRefValue('c:domains', '')
                    .setRefValue('v:url', 'https://example.com/#frag')
                    .build()),
            RhapsodicBool.untruth());

        // Disallow query by default
        expect(
            fn.isTrue(
                RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes)
                    .setRefValue('c:flags', '')
                    .setRefValue('c:domains', '')
                    .setRefValue('v:url', 'https://example.com/?a=1')
                    .build()),
            RhapsodicBool.untruth());

        // Allow fragment and query
        expect(
            fn.isTrue(
                RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes)
                    .setRefValue('c:flags', 'fragment query')
                    .setRefValue('c:domains', '')
                    .setRefValue('v:url', 'https://example.com/path?a=1#frag')
                    .build()),
            RhapsodicBool.truth());
      });

      test('allowed domains and IP handling', () {
        final fn = BooleanRhapsodyFunctionFactory.create(
            'is_url', ['v:url', 'c:flags', 'c:domains']);

        // Domain must be in allowed list if provided
        expect(
            fn.isTrue(
                RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes)
                    .setRefValue('c:domains', 'example.com,foo.org')
                    .setRefValue('v:url', 'https://example.com')
                    .build()),
            RhapsodicBool.truth());

        expect(
            fn.isTrue(
                RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes)
                    .setRefValue('c:domains', 'allowed.org')
                    .setRefValue('v:url', 'https://example.com')
                    .build()),
            RhapsodicBool.untruth());

        // IP requires explicit flag
        expect(
            fn.isTrue(
                RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes)
                    .setRefValue('v:url', 'http://127.0.0.1')
                    .build()),
            RhapsodicBool.untruth());

        expect(
            fn.isTrue(
                RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes)
                    .setRefValue('c:flags', 'IP')
                    .setRefValue('v:url', 'http://127.0.0.1')
                    .build()),
            RhapsodicBool.truth());

        // IPv6 also requires IP flag
        expect(
            fn.isTrue(
                RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes)
                    .setRefValue('c:flags', '')
                    .setRefValue('v:url', 'http://[::1]')
                    .build()),
            RhapsodicBool.untruth());
        expect(
            fn.isTrue(
                RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes)
                    .setRefValue('c:flags', 'IP')
                    .setRefValue('v:url', 'http://[::1]')
                    .build()),
            RhapsodicBool.truth());

        // User info not allowed
        expect(
            fn.isTrue(
                RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes)
                    .setRefValue('c:flags', '')
                    .setRefValue('c:domains', '')
                    .setRefValue('v:url', 'https://user:pass@example.com')
                    .build()),
            RhapsodicBool.untruth());
      });
    });

    test('contains_substring function works correctly', () {
      final function = BooleanRhapsodyFunctionFactory.create(
          'contains_substring', ['v:text', 'v:term']);

      expect(
          function.isTrue(
              RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes)
                  .setRefValue('v:text', 'Hello, world!')
                  .setRefValue('v:term', 'world')
                  .build()),
          RhapsodicBool.truth());

      expect(
          function.isTrue(
              RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes)
                  .setRefValue('v:term', 'absent')
                  .build()),
          RhapsodicBool.untruthy());
    });

    test('contains_substring function works correctly while ignoring case', () {
      final function = BooleanRhapsodyFunctionFactory.create(
          'contains_substring', ['v:text', 'v:term', 'c:ignoreCase']);

      expect(
          function.isTrue(
              RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes)
                  .setRefValue('v:text', 'Hello, world!')
                  .setRefValue('v:term', 'World')
                  .setRefValue('c:ignoreCase', 'true')
                  .build()),
          RhapsodicBool.truth());

      expect(
          function.isTrue(
              RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes)
                  .setRefValue('v:term', 'absent')
                  .build()),
          RhapsodicBool.untruthy());
    });

    test('starts_with_prefix function works correctly', () {
      final function = BooleanRhapsodyFunctionFactory.create(
          'starts_with_prefix', ['v:text', 'v:prefix']);

      expect(
          function.isTrue(
              RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes)
                  .setRefValue('v:text', 'Hello, world!')
                  .setRefValue('v:prefix', 'Hello')
                  .build()),
          RhapsodicBool.truth());

      expect(
          function.isTrue(
              RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes)
                  .setRefValue('v:prefix', 'world')
                  .build()),
          RhapsodicBool.untruthy());
    });

    test('ends_with_suffix function works correctly', () {
      final function = BooleanRhapsodyFunctionFactory.create(
          'ends_with_suffix', ['v:text', 'v:suffix']);

      expect(
          function.isTrue(
              RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes)
                  .setRefValue('v:text', 'Hello, world!')
                  .setRefValue('v:suffix', 'world!')
                  .build()),
          RhapsodicBool.truth());
      expect(
          function.isTrue(
              RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes)
                  .setRefValue('v:suffix', 'Hello')
                  .build()),
          RhapsodicBool.untruthy());
    });

    test('equals function works correctly', () {
      final function = BooleanRhapsodyFunctionFactory.create(
          'string_equals', ['v:text1', 'v:text2']);

      expect(
          function.isTrue(
              RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes)
                  .setRefValue('v:text1', 'Hello, world!')
                  .setRefValue('v:text2', 'Hello, world!')
                  .build()),
          RhapsodicBool.truth());

      expect(
          function.isTrue(
              RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes)
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
