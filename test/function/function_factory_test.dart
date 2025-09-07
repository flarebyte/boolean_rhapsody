import 'package:boolean_rhapsody/boolean_rhapsody.dart';
import 'package:test/test.dart';

void main() {
  group('BooleanRhapsodyFunctionFactory.create coverage', () {
    final singleArg = <String>{
      'is_absent',
      'is_present',
      'is_empty_string',
      'is_trimmable_string',
      'is_complex_unicode',
      'is_simple_unicode',
      'is_multiple_lines',
      'is_single_line',
      'is_numeric',
      'is_integer',
      'is_date_time',
    };

    final twoArgs = <String>{
      // String compare
      'contains_substring',
      'starts_with_prefix',
      'ends_with_suffix',
      'string_equals',
      // Numbers
      'number_equals',
      'number_not_equals',
      'number_greater_than',
      'number_greater_than_equals',
      'number_less_than',
      'number_less_than_equals',
      // Date-time comparators
      'date_time_equals',
      'date_time_not_equals',
      'date_time_greater_than',
      'date_time_greater_than_equals',
      'date_time_less_than',
      'date_time_less_than_equals',
      // List size
      'list_size_equals',
      'list_size_not_equals',
      'list_size_greater_than',
      'list_size_greater_than_equals',
      'list_size_less_than',
      'list_size_less_than_equals',
      // Set operations
      'set_equals',
      'is_subset_of',
      'is_superset_of',
      'is_disjoint',
    };

    test('covers all switch branches', () {
      // Build a minimal context to satisfy prefix validation when needed.
      final context =
          RhapsodyEvaluationContextBuilder(prefixes: ['v', 'c']).build();

      // Single-arg functions
      for (final name in singleArg) {
        final fn = BooleanRhapsodyFunctionFactory.create(name, ['v:a']);
        expect(fn, isNotNull);
        // Exercise isTrue lightly where safe
        expect(() => fn.isTrue(context), returnsNormally);
      }

      // is_url accepts up to 3 parameters; pass all three to be safe
      final urlFn = BooleanRhapsodyFunctionFactory.create(
          'is_url', ['v:url', 'c:flags', 'c:domains']);
      expect(urlFn, isNotNull);

      // Two-arg functions
      for (final name in twoArgs) {
        final fn =
            BooleanRhapsodyFunctionFactory.create(name, ['v:left', 'v:right']);
        expect(fn, isNotNull);
        // Do not evaluate set/list/number without values; just creation covers switch
      }
    });
  });
}
