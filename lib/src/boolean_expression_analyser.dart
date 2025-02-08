import 'function_factory.dart';
import 'parser_options.dart';
import 'rule_expession.dart';
import 'token.dart';
import 'token_stream.dart';
import 'tokeniser.dart';

class RhapsodyBooleanExpressionAnalyser {

  final RhapsodyAnalyserOptions options;

  /// Instantiates the analyser with custom options.
  RhapsodyBooleanExpressionAnalyser(this.options);


  /// Parses the tokens forming a boolean expression and extracts external rule references.
  ///
  /// This simplified parser does not build a full AST but:
  ///
  /// - Joins the token texts into a string (for use by downstream processing).
  /// - Scans for identifiers that do not belong to function calls,
  ///   variables, or common boolean operators.
  ///
  /// Function calls are assumed to be an identifier immediately followed by a left parenthesis,
  /// and prefixes (like `env` or `config`) are detected when an identifier is immediately followed by a colon.
  RhapsodyExpressionAnalyserResult analyse(List<RhapsodyToken> tokens) {
    final List<String> requiredRules = [];
    for (int i = 0; i < tokens.length; i++) {
      final RhapsodyToken token = tokens[i];
      if (token.type == TokenTypes.identifier) {
        // Do not treat function calls as rule dependencies.
        if (i + 1 < tokens.length &&
            (tokens[i + 1].type == TokenTypes.lparen ||
                tokens[i + 1].type == TokenTypes.colon)) {
          continue;
        }
        // Exclude logical operators.
        if (token.text == "and" || token.text == "or" || token.text == "not") {
          continue;
        }
        // Avoid misidentifying functions or valid variables.
        if (options.isFunction(token.text) || options.isVariable(token.text)) {
          continue;
        }
        if (!requiredRules.contains(token.text)) {
          requiredRules.add(token.text);
        }
      }
    }
    final String exprText = tokens.map((t) => t.text).join(' ');
    final RhapsodyBooleanExpression expression =
        RhapsodyBooleanExpression(exprText);
    return RhapsodyExpressionAnalyserResult(
        expression: expression, requiredRules: requiredRules);
  }

  RhapsodyExpressionAnalyserResult _parseOrExpression(RhapsodyTokenStream tokens) {
    final result = _parseAndTerm(tokens);
    if (tokens.matchType(TokenTypes.operatorType) && tokens.matchText('or')) {
      tokens.consume();
      final nextOrExpression=  _parseOrExpression(tokens);
      final orExpression = RhapsodyOrOperator(result.expression, nextOrExpression.expression);
      return RhapsodyExpressionAnalyserResult(expression: orExpression, requiredRules: nextOrExpression.requiredRules);
    }
    return result;
  }

  RhapsodyExpressionAnalyserResult _parseAndTerm(RhapsodyTokenStream tokens) {
    final result = _parseFactor(tokens);
    if (tokens.matchType(TokenTypes.operatorType) && tokens.matchText('and')) {
      tokens.consume();
     final nextAndExpression = _parseAndTerm(tokens);
      final andExpression = RhapsodyAndOperator(result.expression, nextAndExpression.expression);
      return RhapsodyExpressionAnalyserResult(expression: andExpression, requiredRules: nextAndExpression.requiredRules);
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
      return RhapsodyExpressionAnalyserResult(expression: notExpression, requiredRules: next.requiredRules);

    } else if (tokens.matchType(TokenTypes.lparen)) {
      final expr = _parseOrExpression(tokens);
      if (!tokens.matchType(TokenTypes.rparen)) {
        throw Exception("Missing closing parenthesis.");
      }
      tokens.consume();
      return expr;
    } else if (token.text.startsWith('r:')) {
      final ruleRef = RhapsodyRuleReference(token.text.substring(2), ruleDefinitions);
      return RhapsodyExpressionAnalyserResult(expression: ruleRef, requiredRules: []);
    } else if (token.text.contains('(')) {
      final funcCall = _parseFunctionCall(token.text, tokens);
      return RhapsodyExpressionAnalyserResult(expression: funcCall.expression, requiredRules: funcCall.requiredRules);
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
    return RhapsodyExpressionAnalyserResult(expression: fnExpression, requiredRules: []);
  }
}

/// Helper class to encapsulate the result of parsing a boolean expression.
class RhapsodyExpressionAnalyserResult {
  final RhapsodyBooleanExpression expression;
  final List<String> requiredRules;
  RhapsodyExpressionAnalyserResult({
    required this.expression,
    required this.requiredRules,
  });
}
