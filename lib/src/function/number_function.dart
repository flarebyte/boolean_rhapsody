import '../evaluation_context.dart';
import '../fuzzy_boolean.dart';
import '../number_comparator.dart';
import 'rule_function.dart';

/// A Boolean function that compares two numeric references within a given context.
/// The comparison is determined by the provided [RhapsodyNumberComparator].
///
/// This function requires exactly two references, which are expected to be
/// numeric strings. If either reference cannot be parsed as a number,
/// the function returns untruthy.
///
/// Example:
/// ```dart
/// final function = NumberRhapsodyFunction(
///   numberComparator: GreaterThanComparator(),
///   refs: ['value1', 'threshold']
/// );
/// final result = function.isTrue(context); // Returns RhapsodicBool based on comparison
/// ```
class NumberRhapsodyFunction extends BooleanRhapsodyFunction {
  /// Comparator used to evaluate the numeric relationship between references.
  final RhapsodyNumberComparator numberComparator;

  /// References to the numeric values in the context that will be compared.
  /// Must contain exactly two elements.
  final List<String> refs;

  /// Creates a [NumberRhapsodyFunction] with a specified [numberComparator] and [refs].
  ///
  /// Throws [ArgumentError] if [refs] does not contain exactly two elements.
  NumberRhapsodyFunction({
    required this.numberComparator,
    required this.refs,
  }) {
    basicValidateParams(
        refs: refs,
        minSize: 2,
        maxSize: 2,
        name: "number_${numberComparator.name.replaceAll(' ', '_')}");
  }

  /// Evaluates the function within the given [context].
  ///
  /// Retrieves the values of the references from the context and compares them
  /// using the [numberComparator]. Returns [RhapsodicBool.untruthy] if the values
  /// are not valid numeric strings.
  ///
  /// - Returns: [RhapsodicBool.truthy] or [RhapsodicBool.untruthy] based on the comparison.
  @override
  RhapsodicBool isTrue(RhapsodyEvaluationContext context) {
    final value = context.getRefValue(refs[0]);
    final threshold = context.getRefValue(refs[1]);

    if (value is! String || threshold is! String) {
      return RhapsodicBool.untruthy();
    }
    final numValue = num.tryParse(value);
    final numThreshold = num.tryParse(threshold);

    if (numValue == null || numThreshold == null) {
      return RhapsodicBool.untruthy();
    }

    return RhapsodicBool.fromBool(
        numberComparator.compare(numValue, numThreshold));
  }
}
