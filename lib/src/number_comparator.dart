/// An abstract class defining the interface for number comparison.
abstract class RhapsodyNumberComparator {
  /// The name of the comparator.
  String get name;

  /// Compares the given [value] against a [threshold].
  ///
  /// Returns `true` if the comparison meets the criteria, otherwise `false`.
  bool compare(num value, num threshold);
}


/// Comparator for checking if a value is greater than a threshold.
class RhapsodyGreaterThanComparator extends RhapsodyNumberComparator {
  @override
  String get name => 'greater than';

  @override
  bool compare(num value, num threshold) {
    return value > threshold;
  }
}

/// Comparator for checking if a value is greater than or equal to a threshold.
class RhapsodyGreaterThanOrEqualComparator extends RhapsodyNumberComparator {
  @override
  String get name => 'greater than or equal';

  @override
  bool compare(num value, num threshold) {
    return value >= threshold;
  }
}

/// Comparator for checking if a value is less than a threshold.
class RhapsodyLessThanComparator extends RhapsodyNumberComparator {
  @override
  String get name => 'less than';

  @override
  bool compare(num value, num threshold) {
    return value < threshold;
  }
}

/// Comparator for checking if a value is less than or equal to a threshold.
class RhapsodyLessThanOrEqualComparator extends RhapsodyNumberComparator {
  @override
  String get name => 'less than or equal';

  @override
  bool compare(num value, num threshold) {
    return value <= threshold;
  }
}

/// Comparator for checking if a value is equal to a threshold.
class RhapsodyEqualToComparator extends RhapsodyNumberComparator {
  @override
  String get name => 'equal to';

  @override
  bool compare(num value, num threshold) {
    return value == threshold;
  }
}

/// Comparator for checking if a value is not equal to a threshold.
class RhapsodyNotEqualToComparator extends RhapsodyNumberComparator {
  @override
  String get name => 'not equal to';

  @override
  bool compare(num value, num threshold) {
    return value != threshold;
  }
}

/// A static class providing access to various number comparators.
class RhapsodyNumberComparators {
  static final RhapsodyNumberComparator greaterThan = RhapsodyGreaterThanComparator();
  static final RhapsodyNumberComparator greaterThanOrEqual =
      RhapsodyGreaterThanOrEqualComparator();
  static final RhapsodyNumberComparator lessThan = RhapsodyLessThanComparator();
  static final RhapsodyNumberComparator lessThanOrEqual =
      RhapsodyLessThanOrEqualComparator();
  static final RhapsodyNumberComparator equalTo = RhapsodyEqualToComparator();
  static final RhapsodyNumberComparator notEqualTo = RhapsodyNotEqualToComparator();
}