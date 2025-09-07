import 'package:boolean_rhapsody/boolean_rhapsody.dart';
import 'package:boolean_rhapsody/src/model/data_store.dart';
import 'package:boolean_rhapsody/src/model/rule_state.dart';
import 'package:test/test.dart';

void main() {
  group('RhapsodyRuleState', () {
    test('get returns null when rule not set', () {
      final store = RhapsodyDataStore();
      final state = RhapsodyRuleState(states: store);
      expect(state.get('missing'), isNull);
    });

    test('set then get returns stored RhapsodicBool value', () {
      final store = RhapsodyDataStore();
      final state = RhapsodyRuleState(states: store);
      state.set('r1', RhapsodicBool.truth());
      expect(state.get('r1'), equals(RhapsodicBool.truth()));
      state.set('r1', RhapsodicBool.untruth());
      expect(state.get('r1'), equals(RhapsodicBool.untruth()));
    });

    test('clear removes all stored states', () {
      final store = RhapsodyDataStore();
      final state = RhapsodyRuleState(states: store);
      state.set('r1', RhapsodicBool.truth());
      expect(state.get('r1'), isNotNull);
      state.clear();
      expect(state.get('r1'), isNull);
    });
  });
}

