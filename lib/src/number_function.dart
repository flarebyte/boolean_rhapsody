import '../boolean_rhapsody.dart';
import 'rule_function.dart';

class NumberGreaterThanRhapsodyFunction extends BooleanRhapsodyFunction {
  final List<String> refs;

  NumberGreaterThanRhapsodyFunction({required this.refs}) {
    basicValidateParams(
        refs: refs, minSize: 2, maxSize: 2, name: 'number_greater_than');
  }

  @override
  bool isTrue(RhapsodyEvaluationContext context) {
    final value = context.getRefValue(refs[0]);
    final threshold = context.getRefValue(refs[1]);

    if (value is! String || threshold is! String) {
      return false;
    }
    final numValue = num.tryParse(value);
    final numThreshold = num.tryParse(threshold);

    if (numValue == null || numThreshold == null) {
      return false;
    }

    return numValue > numThreshold;
  }
}
