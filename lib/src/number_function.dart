import 'evaluation_context.dart';
import 'fuzzy_boolean.dart';
import 'number_comparator.dart';
import 'rule_function.dart';

class NumberRhapsodyFunction extends BooleanRhapsodyFunction {
  final RhapsodyNumberComparator numberComparator;
  final List<String> refs;

  NumberRhapsodyFunction({required this.numberComparator, required this.refs}) {
    basicValidateParams(
        refs: refs,
        minSize: 2,
        maxSize: 2,
        name: "number_${numberComparator.name.replaceAll(' ', '_')}");
  }

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
