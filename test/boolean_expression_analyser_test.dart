import 'package:boolean_rhapsody/boolean_rhapsody.dart';
import 'package:test/test.dart';

import 'code_fixtures.dart';

void main() {
  group('RhapsodyBooleanExpressionAnalyser', () {
    test('should evaluate func1(env:variable1) and rule42;', () {
      final Map<String, RhapsodyBooleanExpression> ruleDefinitions = {};
      // func1(env:variable1) and rule42;
      final t = MockTokenCreator();
      final List<RhapsodyToken> tokens = [
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
      final RhapsodyBooleanExpressionAnalyser analyser =
          RhapsodyBooleanExpressionAnalyser(
              options: fixtureMockOptions, ruleDefinitions: ruleDefinitions);
      final analyzed = analyser.analyse(tokens);
      expect(analyzed.expression.toString(), equals(''));
      expect(analyzed.gathering.requiredRules, hasLength(1));
      expect(analyzed.gathering.requiredRules, contains('rule42'));
      expect(analyzed.gathering.requiredVariables, hasLength(1));
      expect(analyzed.gathering.requiredVariables, contains('env:variable1'));
    });
    test('should evaluate as truthy when comparator condition is satisfied',
        () {
      final Map<String, RhapsodyBooleanExpression> ruleDefinitions = {};
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
        t.token("not", TokenTypes.operatorType),
        t.token("rule42", TokenTypes.identifier),
        t.token(";", TokenTypes.semicolon),
      ];
      final RhapsodyBooleanExpressionAnalyser analyser =
          RhapsodyBooleanExpressionAnalyser(
              options: fixtureMockOptions, ruleDefinitions: ruleDefinitions);
      final analyzed = analyser.analyse(tokens);
      expect(analyzed.expression.toString(), equals(''));
      expect(analyzed.gathering.requiredRules, hasLength(1));
      expect(analyzed.gathering.requiredRules, contains('rule42'));
      expect(analyzed.gathering.requiredVariables, hasLength(1));
      expect(analyzed.gathering.requiredVariables, contains('env:variable1'));
    });
  });
}
