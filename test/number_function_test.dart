import 'package:boolean_rhapsody/boolean_rhapsody.dart';
import 'package:boolean_rhapsody/src/number_comparator.dart';
import 'package:boolean_rhapsody/src/number_function.dart';
import 'package:test/test.dart';

void main() {
  group('NumberRhapsodyFunction', () {
    const defaultPrefixes = ["c", "v", "p", "d"];

    RhapsodyEvaluationContext buildContext(
        {String? value1, String? threshold}) {
      final builder =
          RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes);

      if (value1 != null) {
        builder.setRefValue('v:value1', value1);
      }
      if (threshold != null) {
        builder.setRefValue('v:threshold', threshold);
      }

      return builder.build();
    }

    test('Returns true for valid greater than comparison', () {
      final context = buildContext(value1: '10', threshold: '5');

      final function = NumberRhapsodyFunction(
        numberComparator: RhapsodyNumberComparators.greaterThan,
        refs: ['v:value1', 'v:threshold'],
      );

      expect(function.isTrue(context).isTrue(), isTrue);
    });

    test('Returns false for invalid greater than comparison', () {
      final context = buildContext(value1: '3', threshold: '5');

      final function = NumberRhapsodyFunction(
        numberComparator: RhapsodyNumberComparators.greaterThan,
        refs: ['v:value1', 'v:threshold'],
      );

      expect(function.isTrue(context).isFalse(), isTrue);
    });

    test('Returns true for valid equal comparison', () {
      final context = buildContext(value1: '7', threshold: '7');

      final function = NumberRhapsodyFunction(
        numberComparator: RhapsodyNumberComparators.equalTo,
        refs: ['v:value1', 'v:threshold'],
      );

      expect(function.isTrue(context).isTrue(), isTrue);
    });

    test('Returns untruthy when one reference is missing', () {
      final context = buildContext(value1: '10'); // No threshold value

      final function = NumberRhapsodyFunction(
        numberComparator: RhapsodyNumberComparators.lessThan,
        refs: ['v:value1', 'v:threshold'], // 'v:threshold' is missing
      );

      expect(function.isTrue(context).isUntruthy(), isTrue);
    });

    test('Returns untruthy when values are non-numeric', () {
      final context = buildContext(value1: 'abc', threshold: '10');

      final function = NumberRhapsodyFunction(
        numberComparator: RhapsodyNumberComparators.lessThan,
        refs: ['v:value1', 'v:threshold'],
      );

      expect(function.isTrue(context).isUntruthy(), isTrue);
    });

    test('Returns true for lessThanOrEqual with equal values', () {
      final context = buildContext(value1: '5', threshold: '5');

      final function = NumberRhapsodyFunction(
        numberComparator: RhapsodyNumberComparators.lessThanOrEqual,
        refs: ['v:value1', 'v:threshold'],
      );

      expect(function.isTrue(context).isTrue(), isTrue);
    });

    test('Returns true for notEqualTo when values differ', () {
      final context = buildContext(value1: '10', threshold: '20');

      final function = NumberRhapsodyFunction(
        numberComparator: RhapsodyNumberComparators.notEqualTo,
        refs: ['v:value1', 'v:threshold'],
      );

      expect(function.isTrue(context).isTrue(), isTrue);
    });

    test('Returns false for notEqualTo when values are same', () {
      final context = buildContext(value1: '10', threshold: '10');

      final function = NumberRhapsodyFunction(
        numberComparator: RhapsodyNumberComparators.notEqualTo,
        refs: ['v:value1', 'v:threshold'],
      );

      expect(function.isTrue(context).isFalse(), isTrue);
    });

    test('Returns untruthy when numeric values are null', () {
      final context = buildContext(value1: null, threshold: '10');

      final function = NumberRhapsodyFunction(
        numberComparator: RhapsodyNumberComparators.greaterThan,
        refs: ['v:value1', 'v:threshold'],
      );

      expect(function.isTrue(context).isUntruthy(), isTrue);
    });
  });
}
