import 'package:boolean_rhapsody/boolean_rhapsody.dart';
import 'package:test/test.dart';

void main() {
  group('RhapsodyEvaluationContext value helpers', () {
    final prefixes = ["c", "v", "p", "d", "rule"];

    test('getRefValueAsBool handles null ref and true/false strings', () {
      final ctx = RhapsodyEvaluationContextBuilder(prefixes: prefixes)
          .setRefValue('v:t', 'true')
          .setRefValue('v:f', 'false')
          .build();

      // Null ref returns default
      expect(ctx.getRefValueAsBool(null, true), isTrue);
      expect(ctx.getRefValueAsBool(null, false), isFalse);

      // Only exact 'true' yields true; 'false' falls back to default
      expect(ctx.getRefValueAsBool('v:t', false), isTrue);
      expect(ctx.getRefValueAsBool('v:f', false), isFalse);
      expect(ctx.getRefValueAsBool('v:f', true), isTrue);
    });

    test('getRefValueAsString returns default on null/missing', () {
      final ctx = RhapsodyEvaluationContextBuilder(prefixes: prefixes)
          .setRefValue('v:name', 'Alice')
          .build();

      expect(ctx.getRefValueAsString(null, 'def'), equals('def'));
      expect(ctx.getRefValueAsString('v:missing', 'def'), equals('def'));
      expect(ctx.getRefValueAsString('v:name', 'def'), equals('Alice'));
    });

    test('getRefValueAsStringList splits and trims; supports custom separator', () {
      final ctx = RhapsodyEvaluationContextBuilder(prefixes: prefixes)
          .setRefValue('v:items', 'a, b ,c')
          .setRefValue('v:pipes', ' x | y |z ')
          .build();

      expect(ctx.getRefValueAsStringList(null, ['d']), equals(['d']));
      expect(ctx.getRefValueAsStringList('v:items', []), equals(['a', 'b', 'c']));
      expect(ctx.getRefValueAsStringList('v:pipes', [], '|'), equals(['x', 'y', 'z']));
    });
  });

  group('RhapsodyEvaluationContext rule state', () {
    final prefixes = ["c", "v", "p", "d", "rule"];

    test('clearRuleState clears recorded rule outcomes (and underlying store)', () {
      final ctx = RhapsodyEvaluationContextBuilder(prefixes: prefixes)
          .setRefValue('v:x', '1')
          .build();

      // Record a rule outcome
      ctx.ruleState.set('r1', RhapsodicBool.truth());
      expect(ctx.ruleState.get('r1'), equals(RhapsodicBool.truth()));
      expect(ctx.getRefValue('v:x'), equals('1'));

      // Clearing rule state clears the underlying store
      ctx.clearRuleState();
      expect(ctx.ruleState.get('r1'), isNull);
      expect(ctx.getRefValue('v:x'), isNull);
    });
  });
}

