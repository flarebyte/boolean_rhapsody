import 'package:boolean_rhapsody/src/number_comparator.dart';
import 'package:test/test.dart';

void main() {
  group('RhapsodyNumberComparators', () {
    const num base = 10;
    const num smaller = 5;
    const num larger = 15;
    const num same = 10;
    const num negative = -5;
    const num zero = 0;
    const num decimal = 10.5;

    test('greaterThan should return true when value is greater than threshold',
        () {
      expect(
          RhapsodyNumberComparators.greaterThan.compare(larger, base), isTrue);
    });

    test(
        'greaterThan should return false when value is less than or equal to threshold',
        () {
      expect(RhapsodyNumberComparators.greaterThan.compare(smaller, base),
          isFalse);
      expect(
          RhapsodyNumberComparators.greaterThan.compare(same, base), isFalse);
    });

    test(
        'greaterThanOrEqual should return true when value is greater than or equal to threshold',
        () {
      expect(RhapsodyNumberComparators.greaterThanOrEqual.compare(larger, base),
          isTrue);
      expect(RhapsodyNumberComparators.greaterThanOrEqual.compare(same, base),
          isTrue);
    });

    test(
        'greaterThanOrEqual should return false when value is less than threshold',
        () {
      expect(
          RhapsodyNumberComparators.greaterThanOrEqual.compare(smaller, base),
          isFalse);
    });

    test('lessThan should return true when value is less than threshold', () {
      expect(RhapsodyNumberComparators.lessThan.compare(smaller, base), isTrue);
      expect(
          RhapsodyNumberComparators.lessThan.compare(negative, base), isTrue);
      expect(RhapsodyNumberComparators.lessThan.compare(zero, base), isTrue);
    });

    test(
        'lessThan should return false when value is greater than or equal to threshold',
        () {
      expect(RhapsodyNumberComparators.lessThan.compare(larger, base), isFalse);
      expect(RhapsodyNumberComparators.lessThan.compare(same, base), isFalse);
    });

    test(
        'lessThanOrEqual should return true when value is less than or equal to threshold',
        () {
      expect(RhapsodyNumberComparators.lessThanOrEqual.compare(smaller, base),
          isTrue);
      expect(RhapsodyNumberComparators.lessThanOrEqual.compare(same, base),
          isTrue);
    });

    test(
        'lessThanOrEqual should return false when value is greater than threshold',
        () {
      expect(RhapsodyNumberComparators.lessThanOrEqual.compare(larger, base),
          isFalse);
    });

    test('equalTo should return true when value is equal to threshold', () {
      expect(RhapsodyNumberComparators.equalTo.compare(same, base), isTrue);
      expect(RhapsodyNumberComparators.equalTo.compare(decimal, 10.5), isTrue);
    });

    test('equalTo should return false when value is different from threshold',
        () {
      expect(RhapsodyNumberComparators.equalTo.compare(smaller, base), isFalse);
      expect(RhapsodyNumberComparators.equalTo.compare(larger, base), isFalse);
    });

    test('notEqualTo should return true when value is different from threshold',
        () {
      expect(
          RhapsodyNumberComparators.notEqualTo.compare(smaller, base), isTrue);
      expect(
          RhapsodyNumberComparators.notEqualTo.compare(larger, base), isTrue);
    });

    test('notEqualTo should return false when value is equal to threshold', () {
      expect(RhapsodyNumberComparators.notEqualTo.compare(same, base), isFalse);
    });
  });
}
