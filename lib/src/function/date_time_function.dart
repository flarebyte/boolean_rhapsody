import 'package:boolean_rhapsody/src/comparator/date_time_comparator.dart';
import '../evaluation_context.dart';
import '../fuzzy_boolean.dart';
import 'rule_function.dart';

/// A specialized [BooleanRhapsodyFunction] that evaluates whether a condition
/// involving two DateTime values holds true, based on the provided comparator.
///
/// This class is part of a rhapsodic boolean logic framework, where evaluations
/// are performed based on provided context and specific conditions.
///
/// Use [isTrue] to perform the evaluation within a given context.
class DateTimeRhapsodyFunction extends BooleanRhapsodyFunction {
  /// Comparator that defines the condition for evaluating DateTime values.
  final RhapsodyDateTimeComparator dateTimeComparator;

  /// References to the DateTime values in the evaluation context.
  ///
  /// [refs] must contain exactly two strings:
  /// - The first reference corresponds to the value being evaluated.
  /// - The second reference corresponds to the threshold value for comparison.
  final List<String> refs;

  /// Creates a [DateTimeRhapsodyFunction] with a required comparator and references.
  ///
  /// - [dateTimeComparator]: The condition used to compare the DateTime values.
  /// - [refs]: A list of exactly two references to be resolved in the evaluation context.
  ///
  /// Throws an [ArgumentError] if [refs] does not contain exactly two elements.
  DateTimeRhapsodyFunction({
    required this.dateTimeComparator,
    required this.refs,
  }) {
    basicValidateParams(
      refs: refs,
      minSize: 2,
      maxSize: 2,
      name: "date_time_${dateTimeComparator.name.replaceAll(' ', '_')}",
    );
  }

  /// Evaluates whether the comparator condition holds for the resolved DateTime values.
  ///
  /// - [context]: The evaluation context providing values for the specified [refs].
  ///
  /// Returns:
  /// - [RhapsodicBool.truthy] if the condition defined by [dateTimeComparator] holds true.
  /// - [RhapsodicBool.untruthy] otherwise, including cases where the references cannot
  ///   be resolved as valid DateTime strings.
  ///
  /// Notes:
  /// - If either referenced value is not a valid `DateTime` string, the result is untruthy.
  /// - The comparator logic is delegated to [dateTimeComparator.compare].
  @override
  RhapsodicBool isTrue(RhapsodyEvaluationContext context) {
    final value = context.getRefValue(refs[0]);
    final threshold = context.getRefValue(refs[1]);

    if (value is! String || threshold is! String) {
      return RhapsodicBool.untruthy();
    }
    final dtValue = DateTime.tryParse(value);
    final dtThreshold = DateTime.tryParse(threshold);

    if (dtValue == null || dtThreshold == null) {
      return RhapsodicBool.untruthy();
    }

    return RhapsodicBool.fromBool(
        dateTimeComparator.compare(dtValue, dtThreshold));
  }
}
