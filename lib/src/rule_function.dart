import 'evaluation_context.dart';
import 'fuzzy_boolean.dart';

/// An abstract class that defines a boolean function in the Rhapsody framework.
/// Implementing classes are expected to evaluate whether a condition is true
/// within the given [RhapsodyEvaluationContext].
abstract class BooleanRhapsodyFunction {
  /// Evaluates whether the boolean condition represented by this function is true.
  ///
  /// This method must be implemented by subclasses.
  ///
  /// [context] - The evaluation context that provides necessary data and state
  /// for the evaluation.
  ///
  /// Returns `true` if the condition is satisfied, otherwise `false`.
  RhapsodicBool isTrue(RhapsodyEvaluationContext context);

  /// Validates the parameters passed to a function to ensure they meet
  /// predefined size and formatting constraints.
  ///
  /// Throws an [Exception] if the validation fails.
  ///
  /// [refs] - A list of parameter references that the function operates on.
  /// [minSize] - The minimum number of references required.
  /// [maxSize] - The maximum number of references allowed.
  /// [name] - The name of the function, used for error reporting.
  ///
  /// **Validation checks performed:**
  /// 1. Ensures the number of parameters falls within the allowed range
  ///    (between [minSize] and [maxSize]).
  /// 2. Ensures all parameter references start with the prefixes `'v:'` (variable)
  ///    or `'c:'` (constant).
  ///
  /// Throws:
  /// - [Exception] if the number of parameters is less than [minSize].
  /// - [Exception] if the number of parameters exceeds [maxSize].
  /// - [Exception] if any parameter reference does not start with `'v:'` or `'c:'`.
  void basicValidateParams({
    required List<String> refs,
    required int minSize,
    required int maxSize,
    required String name,
  }) {
    final size = refs.length;
    if (size < minSize) {
      throw Exception(
          "The number of parameters for the function $name was $size but was expecting a minimum of $minSize for $refs");
    }
    if (size > maxSize) {
      throw Exception(
          "The number of parameters for the function $name was $size but was expecting a maximum of $maxSize for $refs");
    }
    final hasUnsupportedPrefix = refs
        .where((param) => !(param.startsWith('v:') || (param.startsWith('c:'))))
        .isNotEmpty;
    if (hasUnsupportedPrefix) {
      throw Exception(
          "The references for the function $name should all start with v: or c: for $refs");
    }
  }
}
