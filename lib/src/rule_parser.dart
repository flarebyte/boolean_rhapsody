import 'rule_expession.dart';
import 'rule_function.dart';

class BooleanExpressionParser {
  final Map<String, RhapsodyBooleanExpression> ruleDefinitions;

  BooleanExpressionParser(this.ruleDefinitions);

  RhapsodyBooleanExpression parse(String expression) {
    final tokens = _tokenize(expression);
    final ast = _parseOrExpression(tokens);
    if (tokens.isNotEmpty) {
      throw Exception("Unexpected tokens after parsing: $tokens");
    }
    return ast;
  }

  List<String> _tokenize(String expression) {
    final regex = RegExp(r'[\w:]+|\(|\)|and|or|not|,');
    return regex.allMatches(expression).map((e) => e.group(0)!).toList();
  }

  RhapsodyBooleanExpression _parseOrExpression(List<String> tokens) {
    final expr = _parseAndTerm(tokens);
    if (tokens.isNotEmpty && tokens.first == 'or') {
      tokens.removeAt(0);
      return RhapsodyOrOperator(expr, _parseOrExpression(tokens));
    }
    return expr;
  }

  RhapsodyBooleanExpression _parseAndTerm(List<String> tokens) {
    final factor = _parseFactor(tokens);
    if (tokens.isNotEmpty && tokens.first == 'and') {
      tokens.removeAt(0);
      return RhapsodyAndOperator(factor, _parseAndTerm(tokens));
    }
    return factor;
  }

  RhapsodyBooleanExpression _parseFactor(List<String> tokens) {
    if (tokens.isEmpty) {
      throw Exception("Unexpected end of expression.");
    }
    final token = tokens.removeAt(0);

    if (token == 'not') {
      return RhapsodyNotOperator(_parseFactor(tokens));
    } else if (token == '(') {
      final expr = _parseOrExpression(tokens);
      if (tokens.isEmpty || tokens.removeAt(0) != ')') {
        throw Exception("Missing closing parenthesis.");
      }
      return expr;
    } else if (token.startsWith('r:')) {
      return RhapsodyRuleReference(token.substring(2), ruleDefinitions);
    } else if (token.contains('(')) {
      return _parseFunctionCall(token, tokens);
    }
    throw Exception("Unexpected token: $token");
  }

  RhapsodyBooleanExpression _parseFunctionCall(
      String functionToken, List<String> tokens) {
    final nameEnd = functionToken.indexOf('(');
    final functionName = functionToken.substring(0, nameEnd);
    final params = <String>[];

    var token = functionToken.substring(nameEnd + 1);
    while (!token.endsWith(')')) {
      params.add(token);
      token = tokens.removeAt(0);
    }
    params.add(token.substring(0, token.length - 1));
    final fn = BooleanRhapsodyFunctionFactory.create(functionName, params);
    return RhapsodyFunctionExpression(fn);
  }
}
