import 'evaluation_context.dart';
import 'fuzzy_boolean.dart';
import 'rule_function.dart';
import 'string_comparator.dart';

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
  RhapsodicBool isTrue(RhapsodyEvaluationContext context) {
    final value = context.getRefValue(refs[0]);
    return RhapsodicBool.fromBool(value == null);
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
  RhapsodicBool isTrue(RhapsodyEvaluationContext context) {
    final value = context.getRefValue(refs[0]);
    return RhapsodicBool.fromBool(value != null);
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
    basicValidateParams(
        refs: refs, minSize: 1, maxSize: 1, name: 'is_empty_string');
  }

  /// Evaluates whether the reference specified in [refs] is an empty string
  /// in the provided [RhapsodyEvaluationContext].
  ///
  /// [context] - The evaluation context that provides data for the function.
  ///
  /// Returns `true` if the value of the reference is an empty string (`""`),
  /// otherwise `false`.
  @override
  RhapsodicBool isTrue(RhapsodyEvaluationContext context) {
    final value = context.getRefValue(refs[0]);
    return RhapsodicBool.fromBool(value is String && value.isEmpty);
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
    basicValidateParams(
        refs: refs, minSize: 1, maxSize: 1, name: 'is_multiple_lines');
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
  RhapsodicBool isTrue(RhapsodyEvaluationContext context) {
    final value = context.getRefValue(refs[0]);
    return RhapsodicBool.fromBool(
        value is String && value.contains(RegExp(r'\r?\n')));
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
    basicValidateParams(
        refs: refs, minSize: 1, maxSize: 1, name: 'is_single_line');
  }

  /// Evaluates whether the reference specified in [refs] contains a single line
  /// in the provided [RhapsodyEvaluationContext].
  ///
  /// [context] - The evaluation context that provides data for the function.
  ///
  /// Returns `true` if the value of the reference is a string that does not
  /// contain newline characters (`\n` or `\r\n`), otherwise `false`.
  @override
  RhapsodicBool isTrue(RhapsodyEvaluationContext context) {
    final value = context.getRefValue(refs[0]);
    return RhapsodicBool.fromBool(
        value is String && !value.contains(RegExp(r'\r?\n')));
  }
}

/// A boolean function that checks if a specified term satisfies a string comparison for
/// a given text in the [RhapsodyEvaluationContext].
///
/// This class extends [BooleanRhapsodyFunction] and performs validation
/// during instantiation to ensure the provided parameters meet the function's
/// requirements.
class CheckStringRhapsodyFunction extends BooleanRhapsodyFunction {
  /// A list of parameter references that the function evaluates.
  ///
  /// This function expects exactly two references: the first being the text
  /// and the second being the term to check for containment.
  final RhapsodyStringComparator stringComparator;
  final List<String> refs;

  /// Creates an instance of [ContainsSubstringRhapsodyFunction].
  ///
  /// [refs] - A list of references to be evaluated. The list must contain
  /// exactly two references, and each reference must begin with either `'v:'`
  /// (variable) or `'c:'` (constant).
  ///
  /// Throws:
  /// - [Exception] if [refs] does not contain exactly two references.
  /// - [Exception] if any reference does not begin with `'v:'` or `'c:'`.
  CheckStringRhapsodyFunction(
      {required this.refs, required this.stringComparator}) {
    basicValidateParams(
        refs: refs, minSize: 2, maxSize: 3, name: stringComparator.name);
  }

  /// Evaluates whether the term specified in the second reference is contained
  /// within the text specified in the first reference.
  ///
  /// [context] - The evaluation context that provides data for the function.
  ///
  /// Returns `true` if the term is found within the text, otherwise `false`.
  @override
  RhapsodicBool isTrue(RhapsodyEvaluationContext context) {
    final text = context.getRefValue(refs[0]);
    final term = context.getRefValue(refs[1]);
    final ignoreCase =
        context.getRefValueAsBool(refs.length > 2 ? refs[2] : null, false);

    if (text is! String || term is! String) {
      return RhapsodicBool.untruthy(); // Both text and term must be strings.
    }

    return RhapsodicBool.fromBool(
        stringComparator.compare(text, term, ignoreCase));
  }
}
