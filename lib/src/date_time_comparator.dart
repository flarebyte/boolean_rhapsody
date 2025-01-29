/// An abstract class defining the interface for DateTime comparison.
abstract class RhapsodyDateTimeComparator {
  /// The name of the comparator.
  String get name;

  /// Compares the given [value] against a [threshold].
  ///
  /// Returns `true` if the comparison meets the criteria, otherwise `false`.
  bool compare(DateTime value, DateTime threshold);
}

/// Comparator for checking if a value is greater than a threshold.
class RhapsodyDateTimeGreaterThanComparator extends RhapsodyDateTimeComparator {
  @override
  String get name => 'greater than';

  @override
  bool compare(DateTime value, DateTime threshold) {
    return value.isAfter(threshold);
  }
}

/// Comparator for checking if a value is greater than or equal to a threshold.
class RhapsodyDateTimeGreaterThanOrEqualComparator
    extends RhapsodyDateTimeComparator {
  @override
  String get name => 'greater than equals';

  @override
  bool compare(DateTime value, DateTime threshold) {
    return value.isAfter(threshold) || value.isAtSameMomentAs(threshold);
  }
}

/// Comparator for checking if a value is less than a threshold.
class RhapsodyDateTimeLessThanComparator extends RhapsodyDateTimeComparator {
  @override
  String get name => 'less than';

  @override
  bool compare(DateTime value, DateTime threshold) {
    return value.isBefore(threshold);
  }
}

/// Comparator for checking if a value is less than or equal to a threshold.
class RhapsodyDateTimeLessThanOrEqualComparator
    extends RhapsodyDateTimeComparator {
  @override
  String get name => 'less than equals';

  @override
  bool compare(DateTime value, DateTime threshold) {
    return value.isBefore(threshold) || value.isAtSameMomentAs(threshold);
  }
}

/// Comparator for checking if a value is equal to a threshold.
class RhapsodyDateTimeEqualToComparator extends RhapsodyDateTimeComparator {
  @override
  String get name => 'equals';

  @override
  bool compare(DateTime value, DateTime threshold) {
    return value.isAtSameMomentAs(threshold);
  }
}

/// Comparator for checking if a value is not equal to a threshold.
class RhapsodyDateTimeNotEqualToComparator extends RhapsodyDateTimeComparator {
  @override
  String get name => 'not equals';

  @override
  bool compare(DateTime value, DateTime threshold) {
    return !value.isAtSameMomentAs(threshold);
  }
}

/// A static class providing access to common [DateTime] comparators.
///
/// These comparators evaluate relationships between two [DateTime] values,
/// such as ordering and equality checks.
class RhapsodyDateTimeComparators {
  /// Comparator that checks if the first [DateTime] is later than the second.
  static final RhapsodyDateTimeComparator greaterThan =
      RhapsodyDateTimeGreaterThanComparator();

  /// Comparator that checks if the first [DateTime] is later than or equal to the second.
  static final RhapsodyDateTimeComparator greaterThanOrEqual =
      RhapsodyDateTimeGreaterThanOrEqualComparator();

  /// Comparator that checks if the first [DateTime] is earlier than the second.
  static final RhapsodyDateTimeComparator lessThan =
      RhapsodyDateTimeLessThanComparator();

  /// Comparator that checks if the first [DateTime] is earlier than or equal to the second.
  static final RhapsodyDateTimeComparator lessThanOrEqual =
      RhapsodyDateTimeLessThanOrEqualComparator();

  /// Comparator that checks if two [DateTime] values are equal.
  static final RhapsodyDateTimeComparator equalTo =
      RhapsodyDateTimeEqualToComparator();

  /// Comparator that checks if two [DateTime] values are not equal.
  static final RhapsodyDateTimeComparator notEqualTo =
      RhapsodyDateTimeNotEqualToComparator();
}
