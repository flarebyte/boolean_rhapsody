import 'package:boolean_rhapsody/boolean_rhapsody.dart';
import 'package:boolean_rhapsody/src/function/rule_function.dart';
import 'package:boolean_rhapsody/src/rule_expression.dart';
import 'package:boolean_rhapsody/src/model/rule_definition.dart';
import 'package:boolean_rhapsody/src/model/analysis_failure.dart';
import 'package:boolean_rhapsody/src/rule_orchestrator.dart';
import 'package:test/test.dart';

class _AlwaysTrueFn extends BooleanRhapsodyFunction {
  @override
  RhapsodicBool isTrue(RhapsodyEvaluationContext context) =>
      RhapsodicBool.truth();
}

RhapsodyRuleDefinition _dummyRule(String name) {
  return RhapsodyRuleDefinition(
    ruleName: name,
    requiredRules: <String>{},
    requiredVariables: <String>{},
    expression: RhapsodyFunctionExpression(_AlwaysTrueFn()),
    startIndex: 0,
    endIndex: 0,
    startPosition: RhapsodyPosition(row: 1, column: 1),
    endPosition: RhapsodyPosition(row: 1, column: 1),
    text: name,
  );
}

void main() {
  group('RhapsodyInterpreter invalid analysis', () {
    test('throws when analysis has failure', () {
      final failure = RhapsodyAnalysisFailure(
        position: RhapsodyPosition(row: 1, column: 1),
        index: 0,
        errorType: 'err',
        message: 'bad',
        contextCode: '',
        expected: '',
        suggestion: '',
      );
      final analysis = RhapsodySemanticAnalysis(
        failure: failure,
        ruleDefinitions: {},
        orchestrator: null,
      );
      expect(() => RhapsodyInterpreter(analysis), throwsA(isA<Exception>()));
    });

    test('throws when orchestrator detects cycle', () {
      final orchestrator = BooleanRhapsodyRuleOrchestrator({
        'A': ['B'],
        'B': ['A'],
      });
      final analysis = RhapsodySemanticAnalysis(
        ruleDefinitions: {
          'A': _dummyRule('A'),
          'B': _dummyRule('B'),
        },
        orchestrator: orchestrator,
      );
      expect(orchestrator.hasCycle, isTrue);
      expect(() => RhapsodyInterpreter(analysis), throwsA(isA<Exception>()));
    });
  });
}
