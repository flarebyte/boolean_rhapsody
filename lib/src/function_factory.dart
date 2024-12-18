import 'rule_function.dart';
import 'string_function.dart';

class BooleanRhapsodyFunctionFactory {
  static BooleanRhapsodyFunction create(String name, List<String> params) {
    switch (name) {
      case 'is_absent':
        return IsAbsentRhapsodyFunction(refs: params);
      default:
        throw Exception("The boolean function $name is unknown");
    }
  }
}
