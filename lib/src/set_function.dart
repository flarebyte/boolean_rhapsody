import '../boolean_rhapsody.dart';
import 'rule_function.dart';

/// A function that evaluates a boolean condition based on set operations.
///
/// This function compares two sets derived from string values using the
/// provided [RhapsodySetComparator].
class SetRhapsodyFunction extends BooleanRhapsodyFunction {
  /// Comparator used to evaluate the relationship between the two sets.
  final RhapsodySetComparator setComparator;

  /// References to the values used for evaluation.
  ///
  /// Expected format:
  /// - `refs[0]`: String value to be converted into a set.
  /// - `refs[1]`: String threshold to be converted into a set.
  /// - `refs[2]` (optional): String separator used to split values (default: "\n").
  final List<String> refs;

  /// Creates an instance of [SetRhapsodyFunction].
  ///
  /// Validates that [refs] contains between 2 and 3 elements.
  SetRhapsodyFunction({required this.setComparator, required this.refs}) {
    basicValidateParams(
        refs: refs, minSize: 2, maxSize: 3, name: setComparator.name);
  }

  @override

  /// Evaluates the boolean condition based on set comparison.
  ///
  /// - Extracts string values from the evaluation [context] using [refs].
  /// - Converts the values into sets using the specified separator.
  /// - Applies [setComparator] to determine the result.
  /// - Returns a [RhapsodicBool] representing the evaluation outcome.
  RhapsodicBool isTrue(RhapsodyEvaluationContext context) {
    final value = context.getRefValue(refs[0]);
    final threshold = context.getRefValue(refs[1]);
    final separator =
        refs.length > 2 ? context.getRefValueAsString(refs[2], "\n") : "\n";

    if (value is! String || threshold is! String) {
      return RhapsodicBool.untruthy();
    }

    final setValue = _parseAsSet(value, separator);
    final setThreshold = _parseAsSet(threshold, separator);

    return RhapsodicBool.fromBool(
        setComparator.compare(setValue, setThreshold));
  }

  /// Converts a delimited string into a set of strings.
  ///
  /// - [value]: The string to be split.
  /// - [separator]: The delimiter used for splitting.
  /// - Returns a [Set] of unique elements.
  Set<String> _parseAsSet(String value, String separator) {
    return Set.from(value.split(separator));
  }
}
