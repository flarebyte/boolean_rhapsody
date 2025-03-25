import 'package:boolean_rhapsody/boolean_rhapsody.dart';
import 'package:test/test.dart';

import 'code_fixtures.dart';

void main() {
  group('RhapsodySemanticAnalyser', () {
    test('should evaluate a single rule', () {
      // func1(env:variable1) and rule42;
      final t = MockTokenCreator();
      final List<RhapsodyToken> tokens = [
        t.token("rule", TokenTypes.identifier),
        t.token("rule11", TokenTypes.identifier),
        t.token("=", TokenTypes.equal),
        t.token("func1", TokenTypes.identifier),
        t.token("(", TokenTypes.lparen),
        t.token("env", TokenTypes.identifier),
        t.token(":", TokenTypes.colon),
        t.token("variable1", TokenTypes.identifier),
        t.token(")", TokenTypes.rparen),
        t.token("and", TokenTypes.operatorType),
        t.token("rule42", TokenTypes.identifier),
        t.token(";", TokenTypes.semicolon),
      ];
      final RhapsodySemanticAnalyser analyser =
          RhapsodySemanticAnalyser(fixtureMockOptions);
      final analyzed = analyser.analyse(tokens);
      expect(analyzed.failure, null);
      expect(analyzed.ruleDefinitions, hasLength(1));
      expect(analyzed.ruleDefinitions.keys, contains('rule11'));
      expect(analyser.singleRuleEval.ruleExpressions.keys, contains('rule11'));
    });
    test('should evaluate two rules', () {
      // func1(env:variable1) and rule42;
      final t = MockTokenCreator();
      final List<RhapsodyToken> tokens = [
        t.token("rule", TokenTypes.identifier),
        t.token("rule11", TokenTypes.identifier),
        t.token("=", TokenTypes.equal),
        t.token("func1", TokenTypes.identifier),
        t.token("(", TokenTypes.lparen),
        t.token("env", TokenTypes.identifier),
        t.token(":", TokenTypes.colon),
        t.token("variable1", TokenTypes.identifier),
        t.token(")", TokenTypes.rparen),
        t.token("and", TokenTypes.operatorType),
        t.token("rule42", TokenTypes.identifier),
        t.token(";", TokenTypes.semicolon),
        // second rule
        t.token("rule", TokenTypes.identifier),
        t.token("rule12", TokenTypes.identifier),
        t.token("=", TokenTypes.equal),
        t.token("func2", TokenTypes.identifier),
        t.token("(", TokenTypes.lparen),
        t.token("env", TokenTypes.identifier),
        t.token(":", TokenTypes.colon),
        t.token("variable4", TokenTypes.identifier),
        t.token(")", TokenTypes.rparen),
        t.token("and", TokenTypes.operatorType),
        t.token("rule43", TokenTypes.identifier),
        t.token(";", TokenTypes.semicolon),
      ];
      final RhapsodySemanticAnalyser analyser =
          RhapsodySemanticAnalyser(fixtureMockOptions);
      final analyzed = analyser.analyse(tokens);
      expect(analyzed.failure, null);
      expect(analyzed.ruleDefinitions, hasLength(2));
      expect(analyzed.ruleDefinitions.keys, contains('rule11'));
      expect(analyzed.ruleDefinitions.keys, contains('rule12'));
      expect(analyser.singleRuleEval.ruleExpressions.keys, contains('rule11'));
      expect(analyser.singleRuleEval.ruleExpressions.keys, contains('rule12'));
    });
  });
}
