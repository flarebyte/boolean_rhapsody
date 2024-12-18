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
    basicValidateParams(refs: refs, minSize: 1, maxSize: 1, name: 'is_absent');
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

/// A boolean function that checks if a specified reference is present (not null)
/// in the given [RhapsodyEvaluationContext].
///
/// This class extends [BooleanRhapsodyFunction] and performs a single
/// validation during instantiation to ensure the provided parameters meet
/// the function's requirements.
class IsPresentRhapsodyFunction extends BooleanRhapsodyFunction {
  /// A list of parameter references that the function evaluates.
  ///
  /// This function expects exactly one reference in the list.
  final List<String> refs;

  /// Creates an instance of [IsPresentRhapsodyFunction].
  ///
  /// [refs] - A list of references to be evaluated. The list must contain
  /// exactly one reference, and the reference must begin with either `'v:'`
  /// (variable) or `'c:'` (constant).
  ///
  /// Throws:
  /// - [Exception] if [refs] does not contain exactly one reference.
  /// - [Exception] if the reference does not begin with `'v:'` or `'c:'`.
  IsPresentRhapsodyFunction({required this.refs}) {
    basicValidateParams(refs: refs, minSize: 1, maxSize: 1, name: 'is_present');
  }

  /// Evaluates whether the reference specified in [refs] is present (not null)
  /// in the provided [RhapsodyEvaluationContext].
  ///
  /// [context] - The evaluation context that provides data for the function.
  ///
  /// Returns `true` if the value of the reference is not `null`, otherwise `false`.
  @override
  bool isTrue(RhapsodyEvaluationContext context) {
    final value = context.getRefValue(refs[0]);
    return value != null;
  }
}

/// A boolean function that checks if a specified reference is an empty string
/// in the given [RhapsodyEvaluationContext].
///
/// This class extends [BooleanRhapsodyFunction] and performs validation
/// during instantiation to ensure the provided parameters meet the function's
/// requirements.
class IsEmptyStringRhapsodyFunction extends BooleanRhapsodyFunction {
  /// A list of parameter references that the function evaluates.
  ///
  /// This function expects exactly one reference in the list.
  final List<String> refs;

  /// Creates an instance of [IsEmptyStringRhapsodyFunction].
  ///
  /// [refs] - A list of references to be evaluated. The list must contain
  /// exactly one reference, and the reference must begin with either `'v:'`
  /// (variable) or `'c:'` (constant).
  ///
  /// Throws:
  /// - [Exception] if [refs] does not contain exactly one reference.
  /// - [Exception] if the reference does not begin with `'v:'` or `'c:'`.
  IsEmptyStringRhapsodyFunction({required this.refs}) {
    basicValidateParams(refs: refs, minSize: 1, maxSize: 1, name: 'is_empty_string');
  }

  /// Evaluates whether the reference specified in [refs] is an empty string
  /// in the provided [RhapsodyEvaluationContext].
  ///
  /// [context] - The evaluation context that provides data for the function.
  ///
  /// Returns `true` if the value of the reference is an empty string (`""`),
  /// otherwise `false`.
  @override
  bool isTrue(RhapsodyEvaluationContext context) {
    final value = context.getRefValue(refs[0]);
    return value is String && value.isEmpty;
  }
}

/// A boolean function that checks if a specified reference contains multiple lines
/// in the given [RhapsodyEvaluationContext].
///
/// This class extends [BooleanRhapsodyFunction] and performs validation
/// during instantiation to ensure the provided parameters meet the function's
/// requirements.
class IsMultipleLinesRhapsodyFunction extends BooleanRhapsodyFunction {
  /// A list of parameter references that the function evaluates.
  ///
  /// This function expects exactly one reference in the list.
  final List<String> refs;

  /// Creates an instance of [IsMultipleLinesRhapsodyFunction].
  ///
  /// [refs] - A list of references to be evaluated. The list must contain
  /// exactly one reference, and the reference must begin with either `'v:'`
  /// (variable) or `'c:'` (constant).
  ///
  /// Throws:
  /// - [Exception] if [refs] does not contain exactly one reference.
  /// - [Exception] if the reference does not begin with `'v:'` or `'c:'`.
  IsMultipleLinesRhapsodyFunction({required this.refs}) {
    basicValidateParams(refs: refs, minSize: 1, maxSize: 1, name: 'is_multiple_lines');
  }

  /// Evaluates whether the reference specified in [refs] contains multiple lines
  /// in the provided [RhapsodyEvaluationContext].
  ///
  /// [context] - The evaluation context that provides data for the function.
  ///
  /// Returns `true` if the value of the reference is a string containing
  /// more than one line (i.e., has newline characters `\n` or `\r\n`),
  /// otherwise `false`.
  @override
  bool isTrue(RhapsodyEvaluationContext context) {
    final value = context.getRefValue(refs[0]);
    return value is String && value.contains(RegExp(r'\r?\n'));
  }
}

/// A boolean function that checks if a specified reference contains a single line
/// in the given [RhapsodyEvaluationContext].
///
/// This class extends [BooleanRhapsodyFunction] and performs validation
/// during instantiation to ensure the provided parameters meet the function's
/// requirements.
class IsSingleLineRhapsodyFunction extends BooleanRhapsodyFunction {
  /// A list of parameter references that the function evaluates.
  ///
  /// This function expects exactly one reference in the list.
  final List<String> refs;

  /// Creates an instance of [IsSingleLineRhapsodyFunction].
  ///
  /// [refs] - A list of references to be evaluated. The list must contain
  /// exactly one reference, and the reference must begin with either `'v:'`
  /// (variable) or `'c:'` (constant).
  ///
  /// Throws:
  /// - [Exception] if [refs] does not contain exactly one reference.
  /// - [Exception] if the reference does not begin with `'v:'` or `'c:'`.
  IsSingleLineRhapsodyFunction({required this.refs}) {
    basicValidateParams(refs: refs, minSize: 1, maxSize: 1, name: 'is_single_line');
  }

  /// Evaluates whether the reference specified in [refs] contains a single line
  /// in the provided [RhapsodyEvaluationContext].
  ///
  /// [context] - The evaluation context that provides data for the function.
  ///
  /// Returns `true` if the value of the reference is a string that does not
  /// contain newline characters (`\n` or `\r\n`), otherwise `false`.
  @override
  bool isTrue(RhapsodyEvaluationContext context) {
    final value = context.getRefValue(refs[0]);
    return value is String && !value.contains(RegExp(r'\r?\n'));
  }
}


