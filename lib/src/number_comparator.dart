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
  String get name => 'greater than equals';

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
  String get name => 'less than equals';

  @override
  bool compare(num value, num threshold) {
    return value <= threshold;
  }
}

/// Comparator for checking if a value is equal to a threshold.
class RhapsodyEqualToComparator extends RhapsodyNumberComparator {
  @override
  String get name => 'equals';

  @override
  bool compare(num value, num threshold) {
    return value == threshold;
  }
}

/// Comparator for checking if a value is not equal to a threshold.
class RhapsodyNotEqualToComparator extends RhapsodyNumberComparator {
  @override
  String get name => 'not equals';

  @override
  bool compare(num value, num threshold) {
    return value != threshold;
  }
}

/// A static class providing access to common numeric comparators.
///
/// These comparators are used to evaluate relationships between numeric values,
/// such as greater than, less than, or equality checks.
class RhapsodyNumberComparators {
  /// Comparator that checks if the first number is greater than the second.
  static final RhapsodyNumberComparator greaterThan =
      RhapsodyGreaterThanComparator();

  /// Comparator that checks if the first number is greater than or equal to the second.
  static final RhapsodyNumberComparator greaterThanOrEqual =
      RhapsodyGreaterThanOrEqualComparator();

  /// Comparator that checks if the first number is less than the second.
  static final RhapsodyNumberComparator lessThan = RhapsodyLessThanComparator();

  /// Comparator that checks if the first number is less than or equal to the second.
  static final RhapsodyNumberComparator lessThanOrEqual =
      RhapsodyLessThanOrEqualComparator();

  /// Comparator that checks if two numbers are equal.
  static final RhapsodyNumberComparator equalTo = RhapsodyEqualToComparator();

  /// Comparator that checks if two numbers are not equal.
  static final RhapsodyNumberComparator notEqualTo =
      RhapsodyNotEqualToComparator();
}
