import 'package:boolean_rhapsody/boolean_rhapsody.dart';
import 'package:boolean_rhapsody/src/analyser_function_helper.dart';
import 'package:test/test.dart';

import 'code_fixtures.dart';

void main() {
  group('RhapsodyAnalyserFunctionHelper', () {
    final RhapsodyAnalyserFunctionHelper analyser =
        RhapsodyAnalyserFunctionHelper(options: fixtureMockOptions);
    test('should parse a function with a single variable', () {
      // "func1(env:variable1)"
      final t = MockTokenCreator();
      final List<RhapsodyToken> func = [
        t.token("func1", TokenTypes.identifier),
        t.token("(", TokenTypes.lparen),
        t.token("env", TokenTypes.identifier),
        t.token(":", TokenTypes.colon),
        t.token("variable1", TokenTypes.identifier),
        t.token(")", TokenTypes.rparen),
      ];
      final analyzed = analyser.parseFunctionCall(RhapsodyTokenStream(func));
      expect(
          analyzed.expression.toString(),
          equals(
              'RhapsodyFunctionExpression{function: MockFunction(name: func1, params: [env:variable1])}'));
      expect(analyzed.gathering.requiredRules, isEmpty);
      expect(analyzed.gathering.requiredVariables, hasLength(1));
      expect(analyzed.gathering.requiredVariables, contains('env:variable1'));
    });

    test('should parse a function with multiple variables', () {
      // "func1(env:variable1,config:variable2)"
      final t = MockTokenCreator();
      final List<RhapsodyToken> func = [
        t.token("func1", TokenTypes.identifier),
        t.token("(", TokenTypes.lparen),
        t.token("env", TokenTypes.identifier),
        t.token(":", TokenTypes.colon),
        t.token("variable1", TokenTypes.identifier),
        t.token(",", TokenTypes.comma),
        t.token("config", TokenTypes.identifier),
        t.token(":", TokenTypes.colon),
        t.token("variable2", TokenTypes.identifier),
        t.token(")", TokenTypes.rparen),
      ];
      final analyzed = analyser.parseFunctionCall(RhapsodyTokenStream(func));
      expect(
          analyzed.expression.toString(),
          equals(
              'RhapsodyFunctionExpression{function: MockFunction(name: func1, params: [env:variable1, config:variable2])}'));
      expect(analyzed.gathering.requiredRules, isEmpty);
      expect(analyzed.gathering.requiredVariables, hasLength(2));
      expect(analyzed.gathering.requiredVariables, contains('env:variable1'));
      expect(
          analyzed.gathering.requiredVariables, contains('config:variable2'));
    });
  });
}
