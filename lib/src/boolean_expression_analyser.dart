import 'function_factory.dart';
import 'parser_options.dart';
import 'rule_expession.dart';
import 'token.dart';
import 'token_stream.dart';
import 'tokeniser.dart';

class RhapsodyBooleanExpressionAnalyser {
  final RhapsodyAnalyserOptions options;
  final Map<String, RhapsodyBooleanExpression> ruleDefinitions;

  /// Instantiates the analyser with custom options.
  RhapsodyBooleanExpressionAnalyser(
      {required this.options, required this.ruleDefinitions});

  /// Parses the tokens forming a boolean expression and extracts external rule references.
  RhapsodyExpressionAnalyserResult analyse(List<RhapsodyToken> tokens) {
    final tokenStream = RhapsodyTokenStream(tokens);
    final ast = _parseOrExpression(tokenStream);
    if (!tokenStream.isAtEnd) {
      throw Exception(
          "Unexpected tokens after parsing: ${tokenStream.remainingTokens}");
    }
    return ast;
  }

  RhapsodyExpressionAnalyserResult _parseOrExpression(
      RhapsodyTokenStream tokens) {
    final result = _parseAndTerm(tokens);
    if (tokens.matchType(TokenTypes.operatorType) && tokens.matchText('or')) {
      tokens.consume();
      final nextOrExpression = _parseOrExpression(tokens);
      final orExpression =
          RhapsodyOrOperator(result.expression, nextOrExpression.expression);
      return RhapsodyExpressionAnalyserResult(
          expression: orExpression,
          requiredRules: nextOrExpression.requiredRules);
    }
    return result;
  }

  RhapsodyExpressionAnalyserResult _parseAndTerm(RhapsodyTokenStream tokens) {
    final result = _parseFactor(tokens);
    if (tokens.matchType(TokenTypes.operatorType) && tokens.matchText('and')) {
      tokens.consume();
      final nextAndExpression = _parseAndTerm(tokens);
      final andExpression =
          RhapsodyAndOperator(result.expression, nextAndExpression.expression);
      return RhapsodyExpressionAnalyserResult(
          expression: andExpression,
          requiredRules: nextAndExpression.requiredRules);
    }
    return result;
  }

  RhapsodyExpressionAnalyserResult _parseFactor(RhapsodyTokenStream tokens) {
    if (tokens.isAtEnd) {
      throw Exception("Unexpected end of expression.");
    }

    final token = tokens.consume();

    if (tokens.matchType(TokenTypes.operatorType) && tokens.matchText('not')) {
      final next = _parseFactor(tokens);
      final notExpression = RhapsodyNotOperator(next.expression);
      return RhapsodyExpressionAnalyserResult(
          expression: notExpression, requiredRules: next.requiredRules);
    } else if (tokens.matchType(TokenTypes.lparen)) {
      final expr = _parseOrExpression(tokens);
      if (!tokens.matchType(TokenTypes.rparen)) {
        throw Exception("Missing closing parenthesis.");
      }
      tokens.consume();
      return expr;
    } else if (token.text.startsWith('r:')) {
      final ruleRef =
          RhapsodyRuleReference(token.text.substring(2), this.ruleDefinitions);
      return RhapsodyExpressionAnalyserResult(
          expression: ruleRef, requiredRules: []);
    } else if (token.text.contains('(')) {
      final funcCall = _parseFunctionCall(token.text, tokens);
      return RhapsodyExpressionAnalyserResult(
          expression: funcCall.expression,
          requiredRules: funcCall.requiredRules);
    }

    throw Exception("Unexpected token: $token");
  }

  RhapsodyExpressionAnalyserResult _parseFunctionCall(
      String functionToken, RhapsodyTokenStream tokens) {
    final nameEnd = functionToken.indexOf('(');
    final functionName = functionToken.substring(0, nameEnd);
    final params = <String>[];

    var token = functionToken.substring(nameEnd + 1);
    while (!token.endsWith(')')) {
      params.add(token);
      token = tokens.consume().text;
    }
    params.add(token.substring(0, token.length - 1));

    final fn = BooleanRhapsodyFunctionFactory.create(functionName, params);
    final fnExpression = RhapsodyFunctionExpression(fn);
    return RhapsodyExpressionAnalyserResult(
        expression: fnExpression, requiredRules: []);
  }
}

/// Helper class to encapsulate the result of parsing a boolean expression.
class RhapsodyExpressionAnalyserResult {
  final RhapsodyBooleanExpression expression;
  final List<String> requiredRules;

  @override
  String toString() {
    return 'RhapsodyExpressionAnalyserResult{expression: $expression, requiredRules: $requiredRules}';
  }

  RhapsodyExpressionAnalyserResult({
    required this.expression,
    required this.requiredRules,
  });
}
