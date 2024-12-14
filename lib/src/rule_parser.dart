import 'rule_expession.dart';
import 'rule_model.dart';

class BooleanExpressionParser {
  final Map<String, BooleanExpression> ruleDefinitions;

  BooleanExpressionParser(this.ruleDefinitions);

  BooleanExpression parse(String expression) {
    final tokens = _tokenize(expression);
    final ast = _parseExpression(tokens);
    if (tokens.isNotEmpty) {
      throw Exception("Unexpected tokens after parsing: $tokens");
    }
    return ast;
  }

  List<String> _tokenize(String expression) {
    final regex = RegExp(r'[\w:]+|\(|\)|and|or|not|,');
    return regex.allMatches(expression).map((e) => e.group(0)!).toList();
  }

  BooleanExpression _parseExpression(List<String> tokens) {
    final expr = _parseTerm(tokens);
    if (tokens.isNotEmpty && tokens.first == 'or') {
      tokens.removeAt(0);
      return OrOperator(expr, _parseExpression(tokens));
    }
    return expr;
  }

  BooleanExpression _parseTerm(List<String> tokens) {
    final factor = _parseFactor(tokens);
    if (tokens.isNotEmpty && tokens.first == 'and') {
      tokens.removeAt(0);
      return AndOperator(factor, _parseTerm(tokens));
    }
    return factor;
  }

  BooleanExpression _parseFactor(List<String> tokens) {
    if (tokens.isEmpty) {
      throw Exception("Unexpected end of expression.");
    }
    final token = tokens.removeAt(0);

    if (token == 'not') {
      return NotOperator(_parseFactor(tokens));
    } else if (token == '(') {
      final expr = _parseExpression(tokens);
      if (tokens.isEmpty || tokens.removeAt(0) != ')') {
        throw Exception("Missing closing parenthesis.");
      }
      return expr;
    } else if (token.startsWith('r:')) {
      return RuleReference(token.substring(2), ruleDefinitions);
    } else if (token.contains('(')) {
      return _parseFunctionCall(token, tokens);
    }
    throw Exception("Unexpected token: $token");
  }

  BooleanExpression _parseFunctionCall(
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
    return FunctionExpression(fn);
  }
}
