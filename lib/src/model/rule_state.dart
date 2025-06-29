import 'data_store.dart';
import 'fuzzy_boolean.dart';

class RhapsodyRuleState {
  final KiwiWatermelonDataStore states;
  final String prefix;
  RhapsodyRuleState({required this.states, this.prefix = "rule"});

  RhapsodicBool? get(String ruleName) {
    final value = states.get("$prefix:$ruleName");
    if (value == null) {
      return null;
    }
    final boolValue = RhapsodicBool.fromChar(value);
    return boolValue;
  }

  void set(String ruleName, RhapsodicBool value) {
    states.set("$prefix:$ruleName", value.toChar());
  }

  clear() {
    states.clear();
  }
}
