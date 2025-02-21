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
  group('parseFunctionCall - failure cases', () {
    final RhapsodyAnalyserFunctionHelper analyser =
        RhapsodyAnalyserFunctionHelper(options: fixtureMockOptions);
    final t = MockTokenCreator();

    test('should throw if function name is not an identifier', () {
      final tokens = [
        t.token("123func", TokenTypes.number), // Invalid function name
        t.token("(", TokenTypes.lparen),
        t.token("env", TokenTypes.identifier),
        t.token(":", TokenTypes.colon),
        t.token("variable1", TokenTypes.identifier),
        t.token(")", TokenTypes.rparen),
      ];
      expect(
        () => analyser.parseFunctionCall(RhapsodyTokenStream(tokens)),
        throwsA(isA<SemanticException>().having((e) => e.message, 'message',
            contains('Expecting call to function'))),
      );
    });

    test('should throw if function is unknown', () {
      final tokens = [
        t.token("unknownFunc", TokenTypes.identifier), // Not registered
        t.token("(", TokenTypes.lparen),
        t.token("env", TokenTypes.identifier),
        t.token(":", TokenTypes.colon),
        t.token("variable1", TokenTypes.identifier),
        t.token(")", TokenTypes.rparen),
      ];
      expect(
        () => analyser.parseFunctionCall(RhapsodyTokenStream(tokens)),
        throwsA(isA<SemanticException>().having(
            (e) => e.message, 'message', contains('Call to unknown function'))),
      );
    });

    test('should throw if left parenthesis is missing', () {
      final tokens = [
        t.token("func1", TokenTypes.identifier),
        // Missing '('
        t.token("env", TokenTypes.identifier),
        t.token(":", TokenTypes.colon),
        t.token("variable1", TokenTypes.identifier),
      ];
      expect(
        () => analyser.parseFunctionCall(RhapsodyTokenStream(tokens)),
        throwsA(isA<SemanticException>().having((e) => e.message, 'message',
            contains('Expecting left parenthesis'))),
      );
    });

    test('should throw if right parenthesis is missing', () {
      final tokens = [
        t.token("func1", TokenTypes.identifier),
        t.token("(", TokenTypes.lparen),
        t.token("env", TokenTypes.identifier),
        t.token(":", TokenTypes.colon),
        t.token("variable1", TokenTypes.identifier),
        // Missing ')'
      ];
      expect(
        () => analyser.parseFunctionCall(RhapsodyTokenStream(tokens)),
        throwsA(isA<SemanticException>().having(
            (e) => e.message, 'message', contains('Expecting comma but got'))),
      );
    });

    test('should throw if comma is missing between parameters', () {
      final tokens = [
        t.token("func1", TokenTypes.identifier),
        t.token("(", TokenTypes.lparen),
        t.token("env", TokenTypes.identifier),
        t.token(":", TokenTypes.colon),
        t.token("variable1", TokenTypes.identifier),
        // Missing comma
        t.token("config", TokenTypes.identifier),
        t.token(":", TokenTypes.colon),
        t.token("variable2", TokenTypes.identifier),
        t.token(")", TokenTypes.rparen),
      ];
      expect(
        () => analyser.parseFunctionCall(RhapsodyTokenStream(tokens)),
        throwsA(isA<SemanticException>().having(
            (e) => e.message, 'message', contains('Expecting comma but got'))),
      );
    });

    test('should throw if scope identifier is invalid', () {
      final tokens = [
        t.token("func1", TokenTypes.identifier),
        t.token("(", TokenTypes.lparen),
        t.token("123env", TokenTypes.number), // Invalid scope
        t.token(":", TokenTypes.colon),
        t.token("variable1", TokenTypes.identifier),
        t.token(")", TokenTypes.rparen),
      ];
      expect(
        () => analyser.parseFunctionCall(RhapsodyTokenStream(tokens)),
        throwsA(isA<SemanticException>().having((e) => e.message, 'message',
            contains('Expecting a scope identifier'))),
      );
    });

    test('should throw if colon is missing between scope and variable', () {
      final tokens = [
        t.token("func1", TokenTypes.identifier),
        t.token("(", TokenTypes.lparen),
        t.token("env", TokenTypes.identifier),
        // Missing ':'
        t.token("variable1", TokenTypes.identifier),
        t.token(")", TokenTypes.rparen),
      ];
      expect(
        () => analyser.parseFunctionCall(RhapsodyTokenStream(tokens)),
        throwsA(isA<SemanticException>().having(
            (e) => e.message, 'message', contains('Expecting a colon'))),
      );
    });

    test('should throw if variable identifier is invalid', () {
      final tokens = [
        t.token("func1", TokenTypes.identifier),
        t.token("(", TokenTypes.lparen),
        t.token("env", TokenTypes.identifier),
        t.token(":", TokenTypes.colon),
        t.token("123variable", TokenTypes.number), // Invalid variable
        t.token(")", TokenTypes.rparen),
      ];
      expect(
        () => analyser.parseFunctionCall(RhapsodyTokenStream(tokens)),
        throwsA(isA<SemanticException>().having((e) => e.message, 'message',
            contains('Expecting a variable identifier'))),
      );
    });

    test('should throw if variable is not registered', () {
      final tokens = [
        t.token("func1", TokenTypes.identifier),
        t.token("(", TokenTypes.lparen),
        t.token("unknownScope", TokenTypes.identifier),
        t.token(":", TokenTypes.colon),
        t.token("unknownVar", TokenTypes.identifier), // Unregistered variable
        t.token(")", TokenTypes.rparen),
      ];
      expect(
        () => analyser.parseFunctionCall(RhapsodyTokenStream(tokens)),
        throwsA(isA<SemanticException>().having((e) => e.message, 'message',
            contains('Expecting a valid variable format with a scope'))),
      );
    });
  });
}
