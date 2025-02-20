import 'expression_analyzer_result.dart';
import 'function_factory.dart';
import 'parser_options.dart';
import 'rule_expession.dart';
import 'semantic_exception.dart';
import 'token.dart';
import 'token_stream.dart';
import 'tokeniser.dart';

class RhapsodyAnalyserFunctionHelper {
  final RhapsodyAnalyserOptions options;

  RhapsodyAnalyserFunctionHelper({required this.options});

  RhapsodyExpressionAnalyserResult parseFunctionCall(
      RhapsodyTokenStream tokens) {
    final functionToken = tokens.consume();
    if (functionToken.type != TokenTypes.identifier) {
      throw SemanticException(
          "Expecting call to function but got ${functionToken.type}",
          functionToken);
    }

    final isKnownFunction = options.isFunction(functionToken.text);
    if (!isKnownFunction) {
      throw SemanticException(
          "Call to unknown function ${functionToken.text}", functionToken);
    }

    final parenthesisStart = tokens.consume();
    if (parenthesisStart.type != TokenTypes.lparen) {
      throw SemanticException(
          "Expecting left parenthesis but got ${parenthesisStart.type}",
          parenthesisStart);
    }
    final params = <String>[];

    for (var safetyCounter = 0; safetyCounter < 100; safetyCounter++) {}
    // while (safetyCounter> 0) {
    //   // && token.type!=TokenTypes.rparen
    //   safetyCounter--;
    //   params.add(token);
    //   token = tokens.consume().text;
    // }
    params.add(token.substring(0, token.length - 1));

    final fn = BooleanRhapsodyFunctionFactory.create(functionName, params);
    final fnExpression = RhapsodyFunctionExpression(fn);
    return RhapsodyExpressionAnalyserResult(
        expression: fnExpression, requiredRules: []);
  }

  String _parseScopeVariable(RhapsodyTokenStream tokens) {
    final prefixToken = tokens.consume();
    if (prefixToken.type != TokenTypes.identifier) {
      throw SemanticException(
          "Expecting a scope identifier but got ${prefixToken.type}",
          prefixToken);
    }
    final columnToken = tokens.consume();
    if (columnToken.type != TokenTypes.colon) {
      throw SemanticException(
          "Expecting a colon but got ${columnToken.type}", columnToken);
    }

    final varToken = tokens.consume();
    if (varToken.type != TokenTypes.identifier) {
      throw SemanticException(
          "Expecting a variable identifier but got ${varToken.type}", varToken);
    }

    final varName = "${prefixToken.text}:${varToken.text}";

    final isSupportedVar = options.isVariable(varName);
    if (!isSupportedVar) {
      throw SemanticException(
          "Expecting a valid variable format with a scope but got ${varName}",
          prefixToken);
    }

    return varName;
  }
}
