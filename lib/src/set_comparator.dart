abstract class RhapsodySetComparator {
  /// The name of the comparator.
  String get name;

  /// Compares the given [value] against a [threshold].
  ///
  /// Returns `true` if the comparison meets the criteria, otherwise `false`.
  bool compare(Set<String> value, Set<String> threshold);
}

// Comparator for checking if a value is equal to a threshold.
class RhapsodySetEqualsToComparator extends RhapsodySetComparator {
  @override
  String get name => 'equals';

  @override
  bool compare(Set<String> value, Set<String> threshold) {
    return value == threshold;
  }
}

// Comparator for checking if a value is equal to a threshold.
class RhapsodyIsSubsetOfComparator extends RhapsodySetComparator {
  @override
  String get name => 'is_subset_of';

  @override
  bool compare(Set<String> value, Set<String> threshold) {
    return value.every(threshold.contains);
  }
}

// Comparator for checking if a value is equal to a threshold.
class RhapsodyIsSupersetOfComparator extends RhapsodySetComparator {
  @override
  String get name => 'is_superset_of';

  @override
  bool compare(Set<String> value, Set<String> threshold) {
    return threshold.every(value.contains);
  }
}

// Comparator for checking if a value is equal to a threshold.
class RhapsodySetIsDisjointToComparator extends RhapsodySetComparator {
  @override
  String get name => 'is_disjoint';

  @override
  bool compare(Set<String> value, Set<String> threshold) {
    return value.intersection(threshold).isEmpty;
  }
}

/// A static class providing access to various number comparators.
class RhapsodySetComparators {
  static final RhapsodySetComparator equals = RhapsodySetEqualsToComparator();
  static final RhapsodySetComparator isSubset = RhapsodyIsSubsetOfComparator();
  static final RhapsodySetComparator isSuperset =
      RhapsodyIsSupersetOfComparator();
  static final RhapsodySetComparator isDisjoint =
      RhapsodySetIsDisjointToComparator();
}
