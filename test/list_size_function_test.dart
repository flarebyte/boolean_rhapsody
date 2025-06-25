import 'package:boolean_rhapsody/boolean_rhapsody.dart';
import 'package:boolean_rhapsody/src/list_size_function.dart';
import 'package:boolean_rhapsody/src/number_comparator.dart';
import 'package:test/test.dart';

const defaultPrefixes = ["c", "v", "p", "d"];
void main() {
  group('ListSizeRhapsodyFunction', () {
    late RhapsodyEvaluationContextBuilder contextBuilder;

    setUp(() {
      contextBuilder =
          RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes);
    });

    test('returns true when list size is greater than threshold', () {
      final function = ListSizeRhapsodyFunction(
        numberComparator: RhapsodyNumberComparators.greaterThan,
        refs: ['v:value1', 'v:threshold', 'v:separator'],
      );

      final context = contextBuilder
          .setRefValue('v:value1', 'monday,tuesday,wednesday')
          .setRefValue('v:threshold', '2')
          .setRefValue('v:separator', ',')
          .build();

      expect(function.isTrue(context).isTrue(), isTrue);
    });

    test('returns false when list size is not greater than threshold', () {
      final function = ListSizeRhapsodyFunction(
        numberComparator: RhapsodyNumberComparators.greaterThan,
        refs: ['v:value1', 'v:threshold', 'v:separator'],
      );

      final context = contextBuilder
          .setRefValue('v:value1', 'monday,tuesday')
          .setRefValue('v:threshold', '2')
          .setRefValue('v:separator', ',')
          .build();

      expect(function.isTrue(context).isFalse(), isTrue);
    });

    test(
        'returns true when list size equals threshold using equalTo comparator',
        () {
      final function = ListSizeRhapsodyFunction(
        numberComparator: RhapsodyNumberComparators.equalTo,
        refs: ['v:value1', 'v:threshold', 'v:separator'],
      );

      final context = contextBuilder
          .setRefValue('v:value1', 'monday,tuesday')
          .setRefValue('v:threshold', '2')
          .setRefValue('v:separator', ',')
          .build();

      expect(function.isTrue(context).isTrue(), isTrue);
    });

    test('returns false when list size does not equal threshold', () {
      final function = ListSizeRhapsodyFunction(
        numberComparator: RhapsodyNumberComparators.equalTo,
        refs: ['v:value1', 'v:threshold', 'v:separator'],
      );

      final context = contextBuilder
          .setRefValue('v:value1', 'monday,tuesday,wednesday')
          .setRefValue('v:threshold', '2')
          .setRefValue('v:separator', ',')
          .build();

      expect(function.isTrue(context).isFalse(), isTrue);
    });

    test('returns untruthy when threshold is not a number', () {
      final function = ListSizeRhapsodyFunction(
        numberComparator: RhapsodyNumberComparators.greaterThan,
        refs: ['v:value1', 'v:threshold', 'v:separator'],
      );

      final context = contextBuilder
          .setRefValue('v:value1', 'monday,tuesday,wednesday')
          .setRefValue('v:threshold', 'invalid_number')
          .setRefValue('v:separator', ',')
          .build();

      expect(function.isTrue(context).isUntruthy(), isTrue);
    });

    test('returns untruthy when value is not a string', () {
      final function = ListSizeRhapsodyFunction(
        numberComparator: RhapsodyNumberComparators.greaterThan,
        refs: ['v:value1', 'v:threshold', 'v:separator'],
      );

      final context = contextBuilder
          .setRefValue('v:threshold', '2')
          .setRefValue('v:separator', ',')
          .build();

      expect(function.isTrue(context).isUntruthy(), isTrue);
    });

    test('returns untruthy when threshold is missing', () {
      final function = ListSizeRhapsodyFunction(
        numberComparator: RhapsodyNumberComparators.greaterThan,
        refs: ['v:value1', 'v:threshold', 'v:separator'],
      );

      final context = contextBuilder
          .setRefValue('v:value1', 'monday,tuesday,wednesday')
          .setRefValue('v:separator', ',')
          .build();

      expect(function.isTrue(context).isUntruthy(), isTrue);
    });

    test('uses default separator when not provided', () {
      final function = ListSizeRhapsodyFunction(
        numberComparator: RhapsodyNumberComparators.equalTo,
        refs: ['v:value1', 'v:threshold'],
      );

      final context = contextBuilder
          .setRefValue('v:value1', 'monday\ntuesday\nwednesday')
          .setRefValue('v:threshold', '3')
          .build();

      expect(function.isTrue(context).isTrue(), isTrue);
    });

    test('returns false when using lessThan comparator and size is greater',
        () {
      final function = ListSizeRhapsodyFunction(
        numberComparator: RhapsodyNumberComparators.lessThan,
        refs: ['v:value1', 'v:threshold', 'v:separator'],
      );

      final context = contextBuilder
          .setRefValue('v:value1', 'monday,tuesday,wednesday')
          .setRefValue('v:threshold', '2')
          .setRefValue('v:separator', ',')
          .build();

      expect(function.isTrue(context).isFalse(), isTrue);
    });
  });
}
