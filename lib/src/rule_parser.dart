import 'function_factory.dart';
import 'rule_expession.dart';

class BooleanExpressionParser {
  final Map<String, RhapsodyBooleanExpression> ruleDefinitions;

  BooleanExpressionParser(this.ruleDefinitions);

  RhapsodyBooleanExpression parse(String expression) {
    final tokens = _tokenize(expression);
    final tokenStream = _TokenStream(tokens);
    final ast = _parseOrExpression(tokenStream);
    if (!tokenStream.isAtEnd) {
      throw Exception(
          "Unexpected tokens after parsing: ${tokenStream.remainingTokens}");
    }
    return ast;
  }

  List<String> _tokenize(String expression) {
    final regex = RegExp(r'[\w:]+|\(|\)|and|or|not|,');
    return regex.allMatches(expression).map((e) => e.group(0)!).toList();
  }

  RhapsodyBooleanExpression _parseOrExpression(_TokenStream tokens) {
    final expr = _parseAndTerm(tokens);
    if (tokens.match('or')) {
      tokens.consume();
      return RhapsodyOrOperator(expr, _parseOrExpression(tokens));
    }
    return expr;
  }

  RhapsodyBooleanExpression _parseAndTerm(_TokenStream tokens) {
    final factor = _parseFactor(tokens);
    if (tokens.match('and')) {
      tokens.consume();
      return RhapsodyAndOperator(factor, _parseAndTerm(tokens));
    }
    return factor;
  }

  RhapsodyBooleanExpression _parseFactor(_TokenStream tokens) {
    if (tokens.isAtEnd) {
      throw Exception("Unexpected end of expression.");
    }

    final token = tokens.consume();

    if (token == 'not') {
      return RhapsodyNotOperator(_parseFactor(tokens));
    } else if (token == '(') {
      final expr = _parseOrExpression(tokens);
      if (!tokens.match(')')) {
        throw Exception("Missing closing parenthesis.");
      }
      tokens.consume();
      return expr;
    } else if (token.startsWith('r:')) {
      return RhapsodyRuleReference(token.substring(2), ruleDefinitions);
    } else if (token.contains('(')) {
      return _parseFunctionCall(token, tokens);
    }

    throw Exception("Unexpected token: $token");
  }

  RhapsodyBooleanExpression _parseFunctionCall(
      String functionToken, _TokenStream tokens) {
    final nameEnd = functionToken.indexOf('(');
    final functionName = functionToken.substring(0, nameEnd);
    final params = <String>[];

    var token = functionToken.substring(nameEnd + 1);
    while (!token.endsWith(')')) {
      params.add(token);
      token = tokens.consume();
    }
    params.add(token.substring(0, token.length - 1));

    final fn = BooleanRhapsodyFunctionFactory.create(functionName, params);
    return RhapsodyFunctionExpression(fn);
  }
}

class _TokenStream {
  final List<String> _tokens;
  int _index = 0;

  _TokenStream(this._tokens);

  bool get isAtEnd => _index >= _tokens.length;
  String get current => isAtEnd ? '' : _tokens[_index];
  List<String> get remainingTokens => _tokens.sublist(_index);

  bool match(String value) => !isAtEnd && _tokens[_index] == value;

  String consume() {
    if (isAtEnd) throw Exception("Unexpected end of tokens.");
    return _tokens[_index++];
  }
}
