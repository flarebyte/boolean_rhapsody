import 'package:boolean_rhapsody/boolean_rhapsody.dart';
import 'package:test/test.dart';

const defaultPrefixes = ["c", "v", "p", "d"];
void main() {
  group('DateTimeRhapsodyFunction', () {
    final RhapsodyDateTimeComparator lessThanComparator =
        RhapsodyLessThanComparator();

    test('should evaluate as truthy when comparator condition is satisfied',
        () {
      final function = DateTimeRhapsodyFunction(
        dateTimeComparator: lessThanComparator,
        refs: ['v:date1', 'v:date2'],
      );

      final result = function.isTrue(
          RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes)
              .setRefValue('v:date1', '2025-01-01')
              .setRefValue('v:date2', '2025-12-31')
              .build());

      expect(result.isTruthy, isTrue);
    });

    test(
        'should evaluate as untruthy when comparator condition is not satisfied',
        () {
      final function = DateTimeRhapsodyFunction(
        dateTimeComparator: lessThanComparator,
        refs: ['v:date1', 'v:date2'],
      );

      final result = function.isTrue(
          RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes)
              .setRefValue('v:date1', '2025-12-31')
              .setRefValue('v:date2', '2025-01-01')
              .build());

      expect(result.isTruthy, isFalse);
    });

    test(
        'should evaluate as untruthy when values are not valid DateTime strings',
        () {
      final function = DateTimeRhapsodyFunction(
        dateTimeComparator: lessThanComparator,
        refs: ['v:date1', 'v:date2'],
      );

      final result = function.isTrue(
          RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes)
              .setRefValue('v:date1', 'invalid-date')
              .setRefValue('v:date2', '2025-01-01')
              .build());

      expect(result.isTruthy, isFalse);
    });

    test(
        'should evaluate as untruthy when references are missing in the context',
        () {
      final function = DateTimeRhapsodyFunction(
        dateTimeComparator: lessThanComparator,
        refs: ['v:date1', 'v:date2'],
      );

      final result = function.isTrue(
          RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes).build());

      expect(result.isTruthy, isFalse);
    });

    test('should throw an error if refs do not contain exactly two elements',
        () {
      expect(
        () => DateTimeRhapsodyFunction(
          dateTimeComparator: lessThanComparator,
          refs: ['v:only_one_ref'],
        ),
        throwsArgumentError,
      );
    });
  });
}
