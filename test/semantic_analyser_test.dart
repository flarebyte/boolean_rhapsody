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
      expect(analyzed.ruleDefinitions['rule11']?.expression, isNotNull);
      expect(analyzed.ruleDefinitions['rule11']?.startIndex, isPositive);
      expect(analyzed.ruleDefinitions['rule11']?.endIndex, isPositive);
      expect(analyzed.ruleDefinitions['rule11']?.requiredRules,
          contains('rule42'));
      expect(analyzed.ruleDefinitions['rule11']?.requiredVariables,
          contains('env:variable1'));
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
      expect(analyzed.ruleDefinitions['rule11']?.expression, isNotNull);
      expect(analyzed.ruleDefinitions['rule11']?.requiredRules,
          contains('rule42'));
      expect(analyzed.ruleDefinitions['rule11']?.requiredVariables,
          contains('env:variable1'));
      expect(analyzed.ruleDefinitions['rule12']?.expression, isNotNull);
      expect(analyzed.ruleDefinitions['rule12']?.requiredRules,
          contains('rule43'));
      expect(analyzed.ruleDefinitions['rule12']?.requiredVariables,
          contains('env:variable4'));
    });

    test('should return a failure if missing the keyword rule', () {
      // func1(env:variable1) and rule42;
      final t = MockTokenCreator();
      final List<RhapsodyToken> tokens = [
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
      expect(analyzed.failure, isNotNull);
      expect(analyzed.failure?.message, equals('Expected \'rule\' keyword'));
    });

    test('should return a failure if missing rule name after keyword', () {
      final t = MockTokenCreator();
      final tokens = [
        t.token("rule", TokenTypes.identifier),
        t.token("=", TokenTypes.equal),
        t.token("rule42", TokenTypes.identifier),
        t.token(";", TokenTypes.semicolon),
      ];
      final analyser = RhapsodySemanticAnalyser(fixtureMockOptions);
      final result = analyser.analyse(tokens);
      expect(result.failure, isNotNull);
      expect(result.failure?.message,
          equals("Expected an identifier for the rule name"));
    });

    test('should return a failure if rule name is not an identifier', () {
      final t = MockTokenCreator();
      final tokens = [
        t.token("rule", TokenTypes.identifier),
        t.token("=", TokenTypes.equal),
        t.token("rule42", TokenTypes.identifier),
        t.token(";", TokenTypes.semicolon),
      ];
      // Replace rule name token with an invalid type
      tokens.insert(1, t.token("42", TokenTypes.number));
      final analyser = RhapsodySemanticAnalyser(fixtureMockOptions);
      final result = analyser.analyse(tokens);
      expect(result.failure, isNotNull);
      expect(result.failure?.message,
          equals("Expected an identifier for the rule name"));
    });
    test('should return a failure if missing "=" after rule name', () {
      final t = MockTokenCreator();
      final tokens = [
        t.token("rule", TokenTypes.identifier),
        t.token("rule11", TokenTypes.identifier),
        t.token("func1", TokenTypes.identifier),
        t.token(";", TokenTypes.semicolon),
      ];
      final analyser = RhapsodySemanticAnalyser(fixtureMockOptions);
      final result = analyser.analyse(tokens);
      expect(result.failure, isNotNull);
      expect(
          result.failure?.message, equals("Expected '=' after the rule name"));
    });
    test('should return a failure if token after rule name is not "="', () {
      final t = MockTokenCreator();
      final tokens = [
        t.token("rule", TokenTypes.identifier),
        t.token("rule11", TokenTypes.identifier),
        t.token(":", TokenTypes.colon), // Invalid here
        t.token("func1", TokenTypes.identifier),
        t.token(";", TokenTypes.semicolon),
      ];
      final analyser = RhapsodySemanticAnalyser(fixtureMockOptions);
      final result = analyser.analyse(tokens);
      expect(result.failure, isNotNull);
      expect(
          result.failure?.message, equals("Expected '=' after the rule name"));
    });

    test('should return a failure if missing semicolon at end of rule', () {
      final t = MockTokenCreator();
      final tokens = [
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
        // Missing semicolon
      ];
      final analyser = RhapsodySemanticAnalyser(fixtureMockOptions);
      final result = analyser.analyse(tokens);
      expect(result.failure, isNotNull);
      expect(result.failure?.message,
          equals("Expected ';' at the end of the rule definition"));
    });
  });
}
