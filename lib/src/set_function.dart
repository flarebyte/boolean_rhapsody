import '../boolean_rhapsody.dart';
import 'rule_function.dart';
import 'set_comparator.dart';

class SetRhapsodyFunction extends BooleanRhapsodyFunction {
  final RhapsodySetComparator setComparator;
  final List<String> refs;

  SetRhapsodyFunction({required this.setComparator, required this.refs}) {
    basicValidateParams(
        refs: refs, minSize: 2, maxSize: 3, name: setComparator.name);
  }

  Set<String> _parseAsSet(String value, String separator) {
      return Set.from(value.split(separator));
  }
  @override
  RhapsodicBool isTrue(RhapsodyEvaluationContext context) {
    final value = context.getRefValue(refs[0]);
    final threshold = context.getRefValue(refs[1]);
    final separator = context.getRefValueAsString(refs[2], "\n");

    if (value is! String || threshold is! String) {
      return RhapsodicBool.untruthy();
    }
    
    final setValue = _parseAsSet(value, separator);
    final setThreshold = _parseAsSet(threshold, separator);

    return RhapsodicBool.fromBool(
        setComparator.compare(setValue, setThreshold));
  }
}
