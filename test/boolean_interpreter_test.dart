import 'package:boolean_rhapsody/boolean_rhapsody.dart';
import 'package:test/test.dart';

import 'code_fixtures.dart';

void main() {
  group('RhapsodyInterpreter', () {
    test('should interpret some script', () {
      final t = MockTokenCreator();
      final List<RhapsodyToken> tokens = [
        t.token("rule", TokenTypes.identifier),
        t.token("rule1", TokenTypes.identifier),
        t.token("=", TokenTypes.equal),
        t.token("func1", TokenTypes.identifier),
        t.token("(", TokenTypes.lparen),
        t.token("env", TokenTypes.identifier),
        t.token(":", TokenTypes.colon),
        t.token("variable1", TokenTypes.identifier),
        t.token(")", TokenTypes.rparen),
        t.token("and", TokenTypes.operatorType),
        t.token("rule2", TokenTypes.identifier),
        t.token(";", TokenTypes.semicolon),
        // second rule
        t.token("rule", TokenTypes.identifier),
        t.token("rule2", TokenTypes.identifier),
        t.token("=", TokenTypes.equal),
        t.token("func2", TokenTypes.identifier),
        t.token("(", TokenTypes.lparen),
        t.token("env", TokenTypes.identifier),
        t.token(":", TokenTypes.colon),
        t.token("variable4", TokenTypes.identifier),
        t.token(")", TokenTypes.rparen),
        t.token(";", TokenTypes.semicolon),
      ];
      final RhapsodySemanticAnalyser analyser =
          RhapsodySemanticAnalyser(fixtureMockOptions);
      final analysis = analyser.analyse(tokens);
      expect(analysis.isValid(), isTrue);
      final interpreter = RhapsodyInterpreter(analysis);
      RhapsodyEvaluationContext context = RhapsodyEvaluationContext(
          prefixes: ['env', 'config'],
          variables: {'env:variable1': 'func1', 'env:variable4': 'func2'});
      interpreter.interpret(context);
      expect(context.ruleState.states['rule1'], equals(RhapsodicBool.truth()));
      expect(context.ruleState.states['rule2'], equals(RhapsodicBool.truth()));
      // ---
      context.variables['env:variable4'] = 'other';
      interpreter.interpret(context);
      expect(
          context.ruleState.states['rule1'], equals(RhapsodicBool.untruth()));
      expect(
          context.ruleState.states['rule2'], equals(RhapsodicBool.untruth()));
    });
  });
}
