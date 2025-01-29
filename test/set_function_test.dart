import 'package:boolean_rhapsody/boolean_rhapsody.dart';
import 'package:test/test.dart';

const defaultPrefixes = ["c", "v", "p", "d"];
void main() {
  group('SetRhapsodyFunction', () {
    late RhapsodyEvaluationContext context;

    setUp(() {
      context = RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes)
          .setRefValue('v:value', 'monday,tuesday,wednesday')
          .setRefValue('v:threshold', 'monday,tuesday')
          .setRefValue('v:separator', ',')
          .build();
    });

    test('should return true for isSuperset comparator', () {
      final function = SetRhapsodyFunction(
        setComparator: RhapsodySetComparators.isSuperset,
        refs: ['v:value', 'v:threshold', 'v:separator'],
      );

      final result = function.isTrue(context);

      expect(result.isTrue(), isTrue);
    });

    test('should return false for isSubset comparator', () {
      final function = SetRhapsodyFunction(
        setComparator: RhapsodySetComparators.isSubset,
        refs: ['v:value', 'v:threshold', 'v:separator'],
      );

      final result = function.isTrue(context);

      expect(result.isFalse(), isTrue);
    });

    test('should return true for equals comparator when sets match', () {
      context = RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes)
          .setRefValue('v:value', 'monday,tuesday')
          .setRefValue('v:threshold', 'monday,tuesday')
          .setRefValue('v:separator', ',')
          .build();

      final function = SetRhapsodyFunction(
        setComparator: RhapsodySetComparators.equals,
        refs: ['v:value', 'v:threshold', 'v:separator'],
      );

      final result = function.isTrue(context);

      expect(result.isTrue(), isTrue);
    });

    test('should return false for isDisjoint comparator when sets overlap', () {
      final function = SetRhapsodyFunction(
        setComparator: RhapsodySetComparators.isDisjoint,
        refs: ['v:value', 'v:threshold', 'v:separator'],
      );

      final result = function.isTrue(context);

      expect(result.isFalse(), isTrue);
    });

    test('should return untruthy when value is not a string', () {
      context = RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes)
          .setRefValue('v:threshold', 'monday,tuesday')
          .setRefValue('v:separator', ',')
          .build();

      final function = SetRhapsodyFunction(
        setComparator: RhapsodySetComparators.isSuperset,
        refs: ['v:value', 'v:threshold', 'v:separator'],
      );

      final result = function.isTrue(context);

      expect(result.isUntruthy(), isTrue);
    });

    test('should return untruthy when threshold is not a string', () {
      context = RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes)
          .setRefValue('v:value', 'monday,tuesday,wednesday')
          .setRefValue('v:separator', ',')
          .build();

      final function = SetRhapsodyFunction(
        setComparator: RhapsodySetComparators.isSuperset,
        refs: ['v:value', 'v:threshold', 'v:separator'],
      );

      final result = function.isTrue(context);

      expect(result.isUntruthy(), isTrue);
    });

    test('should use default separator when not provided', () {
      context = RhapsodyEvaluationContextBuilder(prefixes: defaultPrefixes)
          .setRefValue('v:value', ['monday', 'wednesday'].join('\n'))
          .setRefValue('v:threshold',
              ['monday', 'tuesday', 'wednesday', 'friday'].join('\n'))
          .build();
      final function = SetRhapsodyFunction(
        setComparator: RhapsodySetComparators.isSubset,
        refs: ['v:value', 'v:threshold'], // No separator provided
      );

      final result = function.isTrue(context);

      expect(result.isTrue(), isTrue);
    });
  });
}
