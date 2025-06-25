import 'package:boolean_rhapsody/src/date_time_comparator.dart';
import 'package:test/test.dart';

void main() {
  group('RhapsodyDateTimeComparators', () {
    final now = DateTime(2024, 1, 1, 12, 0, 0);
    final earlier = now.subtract(Duration(days: 1));
    final later = now.add(Duration(days: 1));

    test('greaterThan should return true when value is after threshold', () {
      expect(
          RhapsodyDateTimeComparators.greaterThan.compare(later, now), isTrue);
    });

    test(
        'greaterThan should return false when value is before or equal to threshold',
        () {
      expect(RhapsodyDateTimeComparators.greaterThan.compare(earlier, now),
          isFalse);
      expect(
          RhapsodyDateTimeComparators.greaterThan.compare(now, now), isFalse);
    });

    test(
        'greaterThanOrEqual should return true when value is after or equal to threshold',
        () {
      expect(RhapsodyDateTimeComparators.greaterThanOrEqual.compare(later, now),
          isTrue);
      expect(RhapsodyDateTimeComparators.greaterThanOrEqual.compare(now, now),
          isTrue);
    });

    test(
        'greaterThanOrEqual should return false when value is before threshold',
        () {
      expect(
          RhapsodyDateTimeComparators.greaterThanOrEqual.compare(earlier, now),
          isFalse);
    });

    test('lessThan should return true when value is before threshold', () {
      expect(
          RhapsodyDateTimeComparators.lessThan.compare(earlier, now), isTrue);
    });

    test(
        'lessThan should return false when value is after or equal to threshold',
        () {
      expect(RhapsodyDateTimeComparators.lessThan.compare(later, now), isFalse);
      expect(RhapsodyDateTimeComparators.lessThan.compare(now, now), isFalse);
    });

    test(
        'lessThanOrEqual should return true when value is before or equal to threshold',
        () {
      expect(RhapsodyDateTimeComparators.lessThanOrEqual.compare(earlier, now),
          isTrue);
      expect(RhapsodyDateTimeComparators.lessThanOrEqual.compare(now, now),
          isTrue);
    });

    test('lessThanOrEqual should return false when value is after threshold',
        () {
      expect(RhapsodyDateTimeComparators.lessThanOrEqual.compare(later, now),
          isFalse);
    });

    test('equalTo should return true when value is equal to threshold', () {
      expect(RhapsodyDateTimeComparators.equalTo.compare(now, now), isTrue);
    });

    test('equalTo should return false when value is different from threshold',
        () {
      expect(
          RhapsodyDateTimeComparators.equalTo.compare(earlier, now), isFalse);
      expect(RhapsodyDateTimeComparators.equalTo.compare(later, now), isFalse);
    });

    test('notEqualTo should return true when value is different from threshold',
        () {
      expect(
          RhapsodyDateTimeComparators.notEqualTo.compare(earlier, now), isTrue);
      expect(
          RhapsodyDateTimeComparators.notEqualTo.compare(later, now), isTrue);
    });

    test('notEqualTo should return false when value is equal to threshold', () {
      expect(RhapsodyDateTimeComparators.notEqualTo.compare(now, now), isFalse);
    });
  });
}
