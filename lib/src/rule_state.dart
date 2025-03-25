import '../boolean_rhapsody.dart';

class RhapsodyRuleState {
  final Map<String, RhapsodicBool> states = {};
  RhapsodyRuleState();

RhapsodicBool? get(String ruleName) {
    return states[ruleName];
  }

  void set(String ruleName, RhapsodicBool value) {
    states[ruleName] = value;
  }
}
