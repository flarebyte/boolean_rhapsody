import 'package:boolean_rhapsody/src/comparator/set_comparator.dart';
import 'package:test/test.dart';

void main() {
  group('RhapsodySetComparators', () {
    final Set<String> setA = {'apple', 'banana', 'cherry'};
    final Set<String> setABis = {'apple', 'banana', 'cherry'};
    final Set<String> subset = {'apple', 'banana'};
    final Set<String> disjointSet = {'kiwi', 'mango'};
    final Set<String> emptySet = {};

    test('equals should return true when sets are identical', () {
      expect(RhapsodySetComparators.equals.compare(setA, setABis), isTrue);
      expect(RhapsodySetComparators.equals.compare(setABis, setA), isTrue);
      expect(RhapsodySetComparators.equals.compare({}, {}), isTrue);
    });

    test('equals should return false when sets are different', () {
      expect(RhapsodySetComparators.equals.compare(setA, subset), isFalse);
    });

    test('isSubset should return true when first set is a subset of second',
        () {
      expect(RhapsodySetComparators.isSubset.compare(subset, setA), isTrue);
    });

    test(
        'isSubset should return false when first set is not a subset of second',
        () {
      expect(RhapsodySetComparators.isSubset.compare(setA, subset), isFalse);
      expect(
          RhapsodySetComparators.isSubset.compare(setA, disjointSet), isFalse);
    });

    test('isSuperset should return true when first set is a superset of second',
        () {
      expect(RhapsodySetComparators.isSuperset.compare(setA, subset), isTrue);
    });

    test(
        'isSuperset should return false when first set is not a superset of second',
        () {
      expect(RhapsodySetComparators.isSuperset.compare(subset, setA), isFalse);
      expect(RhapsodySetComparators.isSuperset.compare(setA, disjointSet),
          isFalse);
    });

    test('isDisjoint should return true when sets have no common elements', () {
      expect(
          RhapsodySetComparators.isDisjoint.compare(setA, disjointSet), isTrue);
    });

    test('isDisjoint should return false when sets have common elements', () {
      expect(RhapsodySetComparators.isDisjoint.compare(setA, subset), isFalse);
    });

    test('comparators should handle empty sets correctly', () {
      expect(RhapsodySetComparators.equals.compare(emptySet, emptySet), isTrue);
      expect(RhapsodySetComparators.isSubset.compare(emptySet, setA), isTrue);
      expect(RhapsodySetComparators.isSuperset.compare(setA, emptySet), isTrue);
      expect(RhapsodySetComparators.isDisjoint.compare(setA, emptySet), isTrue);
    });
  });
}
