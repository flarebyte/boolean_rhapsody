import 'expression_analyzer_result.dart';
import 'parser_options.dart';
import 'rule_expession.dart';
import 'semantic_exception.dart';
import 'token_stream.dart';
import 'tokeniser.dart';

class RhapsodyAnalyserFunctionHelper {
  final RhapsodyAnalyserOptions options;

  RhapsodyAnalyserFunctionHelper({required this.options});

  /// Parses a function call expression from the provided [tokens] stream.
  ///
  /// The expected token format is:
  /// ```
  /// funcName(scope1:variable1, scope2:variable2, ...)
  /// ```
  ///
  /// **Example:**
  /// ```
  /// func1(env:variable1, config:variable2)
  /// ```
  ///
  /// **Parsing Details:**
  /// - `funcName`: Must be a known function as registered in [RhapsodyAnalyserOptions].
  /// - Each parameter follows the `scope:variable` format, where:
  ///   - `scope` and `variable` are valid identifiers.
  ///   - A colon (`:`) separates the scope and variable.
  /// - Parameters are comma-separated (`','`) and enclosed in parentheses (`()`).
  ///
  /// **Throws:**
  /// - [SemanticException] if:
  ///   - The function name is missing or unknown.
  ///   - Parentheses or commas are misplaced or missing.
  ///   - Scope or variable identifiers are invalid or unregistered.
  ///
  /// **Returns:**
  /// A [RhapsodyExpressionAnalyserResult] containing the parsed [RhapsodyFunctionExpression]
  /// and the gathered variables used within the function call.
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
      throw SemanticException("Call to unknown function", functionToken);
    }

    final parenthesisStart = tokens.consume();
    if (parenthesisStart.type != TokenTypes.lparen) {
      throw SemanticException(
          "Expecting left parenthesis but got ${parenthesisStart.type}",
          parenthesisStart);
    }
    final params = <String>[];
    RhapsodyExpressionResultGatherer gatherer =
        RhapsodyExpressionResultGatherer();
    for (var safetyCounter = 1; safetyCounter < 100; safetyCounter++) {
      final scopeVar = _parseScopeVariable(tokens);
      params.add(scopeVar);
      gatherer.addVariable(scopeVar);
      final nextToken = tokens.consume();
      if (nextToken.type == TokenTypes.rparen) {
        break;
      }
      if (nextToken.type != TokenTypes.comma) {
        final paramPosition =
            safetyCounter <= 1 ? "${safetyCounter}st" : "${safetyCounter}nd";
        throw SemanticException(
            "Expecting comma but got ${nextToken.type} after $paramPosition parameter",
            nextToken);
      }
    }

    final fn = options.functionRegistry.create(functionToken.text, params);
    final fnExpression = RhapsodyFunctionExpression(fn);
    return RhapsodyExpressionAnalyserResult(
        expression: fnExpression, gathering: gatherer);
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
          "Expecting a valid variable format with a scope but got $varName",
          prefixToken);
    }

    return varName;
  }
}
