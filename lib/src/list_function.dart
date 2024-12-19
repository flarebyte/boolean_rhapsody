import '../boolean_rhapsody.dart';
import 'number_comparator.dart';
import 'rule_function.dart';

class ListSizeRhapsodyFunction extends BooleanRhapsodyFunction {
  final RhapsodyNumberComparator numberComparator;
  final List<String> refs;

  ListSizeRhapsodyFunction(
      {required this.numberComparator, required this.refs}) {
    basicValidateParams(
        refs: refs,
        minSize: 2,
        maxSize: 3,
        name: "list_size_${numberComparator.name.replaceAll(' ', '_')}");
  }

  @override
  bool isTrue(RhapsodyEvaluationContext context) {
    final value = context.getRefValue(refs[0]);
    final threshold = context.getRefValue(refs[1]);
    final separator = context.getRefValue(refs[2]) ?? "\n";

    if (value is! String || threshold is! String) {
      return false;
    }
    final numThreshold = num.tryParse(threshold);

    if (numThreshold == null) {
      return false;
    }
    final size = value.split(separator).length;

    return numberComparator.compare(size, numThreshold);
  }
}
