/// An abstract class defining the interface for string comparison.
abstract class RhapsodyStringComparator {
  /// The name of the comparator.
  String get name;

  /// Compares the given [text] against a [term].
  ///
  /// Returns `true` if the comparison meets the criteria, otherwise `false`.
  bool compare(String text, String term, [bool ignoreCase = false]);
}

/// Comparator for checking if a term is contained in some text optionally ignoring the case
class RhapsodyStringContainsComparator extends RhapsodyStringComparator {
  @override
  String get name => 'contains substring';

  @override
  bool compare(String text, String term, [bool ignoreCase = false]) {
    return ignoreCase
        ? text.toLowerCase().contains(term.toLowerCase())
        : text.contains(term);
  }
}

/// Comparator for checking if some text starts with a given prefix optionally ignoring the case
class RhapsodyStringStartsWithComparator extends RhapsodyStringComparator {
  @override
  String get name => 'starts with prefix';

  @override
  bool compare(String text, String term, [bool ignoreCase = false]) {
    return ignoreCase
        ? text.toLowerCase().startsWith(term.toLowerCase())
        : text.startsWith(term);
  }
}

/// Comparator for checking if some text ends with a given prefix optionally ignoring the case
class RhapsodyStringEndsWithComparator extends RhapsodyStringComparator {
  @override
  String get name => 'ends with suffix';

  @override
  bool compare(String text, String term, [bool ignoreCase = false]) {
    return ignoreCase
        ? text.toLowerCase().endsWith(term.toLowerCase())
        : text.endsWith(term);
  }
}

/// Comparator for checking if some text ends with a given prefix optionally ignoring the case
class RhapsodyStringEqualsComparator extends RhapsodyStringComparator {
  @override
  String get name => 'string equals';

  @override
  bool compare(String text, String term, [bool ignoreCase = false]) {
    return ignoreCase
        ? text.toLowerCase() == (term.toLowerCase())
        : text == term;
  }
}

/// A static class providing access to common string comparators.
///
/// These comparators evaluate relationships between strings, such as containment,
/// prefix, suffix, and equality checks.
class RhapsodyStringComparators {
  /// Comparator that checks if a string contains a specified substring.
  static final RhapsodyStringComparator contains =
      RhapsodyStringContainsComparator();

  /// Comparator that checks if a string starts with a specified prefix.
  static final RhapsodyStringComparator startsWith =
      RhapsodyStringStartsWithComparator();

  /// Comparator that checks if a string ends with a specified suffix.
  static final RhapsodyStringComparator endsWith =
      RhapsodyStringEndsWithComparator();

  /// Comparator that checks if two strings are equal.
  static final RhapsodyStringComparator equals =
      RhapsodyStringEqualsComparator();
}
