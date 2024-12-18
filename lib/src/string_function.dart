import '../boolean_rhapsody.dart';
import 'rule_function.dart';

/// A boolean function that checks if a specified reference is absent (null)
/// in the given [RhapsodyEvaluationContext].
///
/// This class extends [BooleanRhapsodyFunction] and performs a single
/// validation during instantiation to ensure the provided parameters meet
/// the function's requirements.
class IsAbsentRhapsodyFunction extends BooleanRhapsodyFunction {
  /// A list of parameter references that the function evaluates.
  ///
  /// This function expects exactly one reference in the list.
  final List<String> refs;

  /// Creates an instance of [IsAbsentRhapsodyFunction].
  ///
  /// [refs] - A list of references to be evaluated. The list must contain
  /// exactly one reference, and the reference must begin with either `'v:'`
  /// (variable) or `'c:'` (constant).
  ///
  /// Throws:
  /// - [Exception] if [refs] does not contain exactly one reference.
  /// - [Exception] if the reference does not begin with `'v:'` or `'c:'`.
  IsAbsentRhapsodyFunction({required this.refs}) {
    basicValidateParams(refs: refs, minSize: 1, maxSize: 1, name: 'isAbsent');
  }

  /// Evaluates whether the reference specified in [refs] is absent (null)
  /// in the provided [RhapsodyEvaluationContext].
  ///
  /// [context] - The evaluation context that provides data for the function.
  ///
  /// Returns `true` if the value of the reference is `null`, otherwise `false`.
  @override
  bool isTrue(RhapsodyEvaluationContext context) {
    final value = context.getRefValue(refs[0]);
    return value == null;
  }
}
