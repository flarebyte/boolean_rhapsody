import 'package:boolean_rhapsody/boolean_rhapsody.dart';
import 'package:test/test.dart';

import 'code_fixtures.dart';

void main() {
  group('RhapsodyBooleanExpressionAnalyser', () {
    test('should evaluate func1(env:variable1:blue) and rule42;', () {
      // func1(env:variable1) and rule42;
      final t = MockTokenCreator();
      final List<RhapsodyToken> tokens = [
        t.token("func1", TokenTypes.identifier),
        t.token("(", TokenTypes.lparen),
        t.token("env", TokenTypes.identifier),
        t.token(":", TokenTypes.colon),
        t.token("variable1", TokenTypes.identifier),
        t.token(":", TokenTypes.colon),
        t.token("blue", TokenTypes.identifier),
        t.token(")", TokenTypes.rparen),
        t.token("and", TokenTypes.operatorType),
        t.token("rule42", TokenTypes.identifier),
        t.token(";", TokenTypes.semicolon),
      ];
      final RhapsodyBooleanExpressionAnalyser analyser =
          RhapsodyBooleanExpressionAnalyser(options: fixtureMockOptions);
      final analyzed = analyser.analyse(tokens);
      expect(
          analyzed.expression.toString(),
          equals(
              'AND {left: FUNC {function: MockFunction(name: func1, params: [env:variable1:blue])}, right: RULE_REF {ruleName: rule42}}'));
      expect(analyzed.gathering.requiredRules, hasLength(1),
          reason: 'requiredRules');
      expect(analyzed.gathering.requiredRules, contains('rule42'));
      expect(analyzed.gathering.requiredVariables, hasLength(1),
          reason: 'requiredVariables');
      expect(
          analyzed.gathering.requiredVariables, contains('env:variable1:blue'));
    });
    test('should evaluate as truthy when comparator condition is satisfied',
        () {
      // (func1(env:variable1) or func2(config:variable2)) and not rule42;
      final t = MockTokenCreator();
      final List<RhapsodyToken> tokens = [
        t.token("(", TokenTypes.lparen),
        t.token("func1", TokenTypes.identifier),
        t.token("(", TokenTypes.lparen),
        t.token("env", TokenTypes.identifier),
        t.token(":", TokenTypes.colon),
        t.token("variable1", TokenTypes.identifier),
        t.token(")", TokenTypes.rparen),
        t.token("or", TokenTypes.operatorType),
        t.token("func2", TokenTypes.identifier),
        t.token("(", TokenTypes.lparen),
        t.token("config", TokenTypes.identifier),
        t.token(":", TokenTypes.colon),
        t.token("variable2", TokenTypes.identifier),
        t.token(")", TokenTypes.rparen),
        t.token(")", TokenTypes.rparen),
        t.token("and", TokenTypes.operatorType),
        t.token("rule41", TokenTypes.identifier),
        t.token("and", TokenTypes.operatorType),
        t.token("not", TokenTypes.operatorType),
        t.token("rule42", TokenTypes.identifier),
        t.token(";", TokenTypes.semicolon),
      ];
      final RhapsodyBooleanExpressionAnalyser analyser =
          RhapsodyBooleanExpressionAnalyser(options: fixtureMockOptions);
      final analyzed = analyser.analyse(tokens);
      expect(
          analyzed.expression.toString(),
          equals(
              'AND {left: AND {left: OR {left: FUNC {function: MockFunction(name: func1, params: [env:variable1])}, right: FUNC {function: MockFunction(name: func2, params: [config:variable2])}}, right: RULE_REF {ruleName: rule41}}, right: NOT {operand: RULE_REF {ruleName: rule42}}}'));
      expect(analyzed.gathering.requiredRules, hasLength(2));
      expect(analyzed.gathering.requiredRules, contains('rule41'));
      expect(analyzed.gathering.requiredRules, contains('rule42'));
      expect(analyzed.gathering.requiredVariables, hasLength(2));
      expect(analyzed.gathering.requiredVariables, contains('env:variable1'));
      expect(
          analyzed.gathering.requiredVariables, contains('config:variable2'));
    });
  });
}
