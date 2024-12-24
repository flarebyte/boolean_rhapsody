import 'package:boolean_rhapsody/src/date_time_comparator.dart';
import 'fuzzy_boolean.dart';
import 'rule_function.dart';

class DateTimeRhapsodyFunction extends BooleanRhapsodyFunction {
  final RhapsodyDateTimeComparator dateTimeComparator;
  final List<String> refs;

  DateTimeRhapsodyFunction(
      {required this.dateTimeComparator, required this.refs}) {
    basicValidateParams(
        refs: refs,
        minSize: 2,
        maxSize: 2,
        name: "date_time_${dateTimeComparator.name.replaceAll(' ', '_')}");
  }

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
