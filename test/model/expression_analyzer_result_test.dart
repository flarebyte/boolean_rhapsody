import 'package:boolean_rhapsody/boolean_rhapsody.dart';
import 'package:boolean_rhapsody/src/function/rule_function.dart';
import 'package:boolean_rhapsody/src/model/expression_analyzer_result.dart';
import 'package:boolean_rhapsody/src/rule_expression.dart';
import 'package:test/test.dart';

class _TruthFn extends BooleanRhapsodyFunction {
  @override
  RhapsodicBool isTrue(RhapsodyEvaluationContext context) =>
      RhapsodicBool.truth();
}

void main() {
  group('RhapsodyExpressionResultGatherer', () {
    test('addRule/addVariable collect unique entries and toString sorts', () {
      final g = RhapsodyExpressionResultGatherer();
      g.addRule('B');
      g.addRule('A');
      g.addRule('A'); // duplicate
      g.addVariable('x');
      g.addVariable('y');
      g.addVariable('x'); // duplicate

      expect(g.requiredRules, containsAll(<String>['A', 'B']));
      expect(g.requiredRules.length, equals(2));
      expect(g.requiredVariables, containsAll(<String>['x', 'y']));
      expect(g.requiredVariables.length, equals(2));

      final s = g.toString();
      // Sorted order in string representation
      expect(s, contains("rules: [A, B]"));
      expect(s, contains("vars: [x, y]"));
    });

    test('merge combines multiple gatherers and throws on empty input', () {
      final g1 = RhapsodyExpressionResultGatherer()
        ..addRule('R1')
        ..addVariable('v1');
      final g2 = RhapsodyExpressionResultGatherer()
        ..addRule('R2')
        ..addVariable('v2')
        ..addVariable('v1'); // duplicate across gatherers

      final merged = RhapsodyExpressionResultGatherer.merge([g1, g2]);
      expect(merged.requiredRules, containsAll(<String>['R1', 'R2']));
      expect(merged.requiredVariables, containsAll(<String>['v1', 'v2']));
      expect(merged.requiredVariables.length, equals(2));

      expect(() => RhapsodyExpressionResultGatherer.merge([]),
          throwsA(isA<ArgumentError>()));
    });
  });

  group('RhapsodyExpressionAnalyserResult', () {
    test('toString includes expression and gatherer', () {
      final expr = RhapsodyFunctionExpression(_TruthFn());
      final g = RhapsodyExpressionResultGatherer()
        ..addRule('RuleX')
        ..addVariable('varY');
      final res =
          RhapsodyExpressionAnalyserResult(expression: expr, gathering: g);

      final s = res.toString();
      expect(s, contains('R.E.A.Result'));
      expect(s, contains('FUNC'));
      expect(s, contains('RuleX'));
      expect(s, contains('varY'));
    });
  });
}
