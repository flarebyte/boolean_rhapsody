import '../evaluation_context.dart';
import '../model/fuzzy_boolean.dart';
import '../comparator/number_comparator.dart';
import 'rule_function.dart';

/// A function that evaluates whether the size of a list derived from a string
/// meets a specified numerical condition.
///
/// This function takes a string, splits it into a list using a separator, and
/// compares its length to a threshold using the provided [RhapsodyNumberComparator].
///
/// The function requires at least two references:
/// - The first reference should resolve to the string to be split.
/// - The second reference should resolve to the numerical threshold.
/// - An optional third reference specifies the separator (defaults to "\n").
class ListSizeRhapsodyFunction extends BooleanRhapsodyFunction {
  /// Comparator used to evaluate the list size against the threshold.
  final RhapsodyNumberComparator numberComparator;

  /// List of references used to fetch values from the evaluation context.
  /// - `refs[0]`: String to be split into a list.
  /// - `refs[1]`: Threshold for comparison.
  /// - `refs[2]` (optional): Separator (default is "\n").
  final List<String> refs;

  /// Constructs a [ListSizeRhapsodyFunction] with the required comparator and references.
  ///
  /// Throws an error if the number of references is not between 2 and 3.
  ListSizeRhapsodyFunction({
    required this.numberComparator,
    required this.refs,
  }) {
    basicValidateParams(
      refs: refs,
      minSize: 2,
      maxSize: 3,
      name: "list_size_${numberComparator.name.replaceAll(' ', '_')}",
    );
  }

  /// Evaluates whether the size of the list derived from a string
  /// satisfies the specified numerical condition.
  ///
  /// - Retrieves the string and threshold from the [context] using `refs[0]` and `refs[1]`.
  /// - Optionally retrieves the separator from `refs[2]`, defaulting to "\n".
  /// - If the threshold is not a valid number, returns `RhapsodicBool.untruthy()`.
  /// - Otherwise, splits the string, computes its length, and applies the comparator.
  @override
  RhapsodicBool isTrue(RhapsodyEvaluationContext context) {
    final value = context.getRefValue(refs[0]);
    final threshold = context.getRefValue(refs[1]);
    final separator =
        refs.length > 2 ? context.getRefValueAsString(refs[2], "\n") : "\n";

    if (value is! String || threshold is! String) {
      return RhapsodicBool.untruthy();
    }
    final numThreshold = num.tryParse(threshold);
    if (numThreshold == null) {
      return RhapsodicBool.untruthy();
    }

    final size = value.split(separator).length;
    return RhapsodicBool.fromBool(numberComparator.compare(size, numThreshold));
  }
}
