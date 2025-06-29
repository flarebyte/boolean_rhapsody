import 'package:boolean_rhapsody/boolean_rhapsody.dart';
import 'package:boolean_rhapsody/src/comparator/date_time_comparator.dart';
import 'package:boolean_rhapsody/src/function/date_time_function.dart';
import 'package:test/test.dart';

const defaultPrefixes = ["c", "v", "p", "d"];
const threshold = 'v:threshold';
void main() {
  group('DateTimeRhapsodyFunction', () {
    final RhapsodyDateTimeComparator lessThanComparator =
        RhapsodyDateTimeComparators.lessThan;

    test('should evaluate as truthy when comparator condition is satisfied',
        () {
      final function = DateTimeRhapsodyFunction(
        dateTimeComparator: lessThanComparator,
        refs: ['v:date1', threshold],
      );

      final result = function.isTrue(
          RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes)
              .setRefValue('v:date1', '2025-01-01T06:12:33Z')
              .setRefValue(threshold, '2025-12-31T06:12:33Z')
              .build());

      expect(result.isTrue(), isTrue);
    });

    test(
        'should evaluate as untruthy when comparator condition is not satisfied',
        () {
      final function = DateTimeRhapsodyFunction(
        dateTimeComparator: lessThanComparator,
        refs: ['v:date1', threshold],
      );

      final result = function.isTrue(
          RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes)
              .setRefValue('v:date1', '2025-12-31T06:12:33Z')
              .setRefValue(threshold, '2025-01-01T06:12:33Z')
              .build());

      expect(result.isFalse(), isTrue);
    });

    test(
        'should evaluate as untruthy when values are not valid DateTime strings',
        () {
      final function = DateTimeRhapsodyFunction(
        dateTimeComparator: lessThanComparator,
        refs: ['v:date1', threshold],
      );

      final result = function.isTrue(
          RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes)
              .setRefValue('v:date1', 'invalid-date')
              .setRefValue(threshold, '2025-01-01T06:12:33Z')
              .build());

      expect(result.isUntruthy(), isTrue);
    });

    test(
        'should evaluate as untruthy when references are missing in the context',
        () {
      final function = DateTimeRhapsodyFunction(
        dateTimeComparator: lessThanComparator,
        refs: ['v:date1', threshold],
      );

      final result = function.isTrue(
          RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes).build());

      expect(result.isUntruthy(), isTrue);
    });

    test('should throw an error if refs do not contain exactly two elements',
        () {
      expect(
          () => DateTimeRhapsodyFunction(
                dateTimeComparator: lessThanComparator,
                refs: ['v:only_one_ref'],
              ),
          throwsA(isA<Exception>()));
    });
  });
}
