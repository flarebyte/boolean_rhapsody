import 'package:boolean_rhapsody/src/token_stream_flyweight.dart';

import 'model/expression_analyzer_result.dart';
import 'model/parser_options.dart';
import 'rule_expression.dart';
import 'semantic_exception.dart';
import 'token_stream.dart';

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
      RhapsodyTokenStream tokens, RhapsodyExpressionResultGatherer gatherer) {
    final functionToken = RhapsodyTokenStreamFlyweight.consumeIdentifier(tokens,
        contextual: "function call");

    final isKnownFunction = options.isFunction(functionToken.text);
    if (!isKnownFunction) {
      throw SemanticException("Call to unknown function", functionToken);
    }

    RhapsodyTokenStreamFlyweight.consumeLeftParenthesis(tokens);
    final params = <String>[];
    for (var safetyCounter = 1; safetyCounter < 100; safetyCounter++) {
      final scopeVar = _parseScopeVariable(tokens, gatherer);
      params.add(scopeVar);
      gatherer.addVariable(scopeVar);
      if (RhapsodyTokenStreamFlyweight.isRightParenthesis(tokens)) {
        RhapsodyTokenStreamFlyweight.consumeRightParenthesis(tokens,
            contextual: "function call");
        break;
      } else {
        RhapsodyTokenStreamFlyweight.consumeComma(tokens,
            contextual: "function call");
      }
    }

    final fn = options.functionRegistry.create(functionToken.text, params);
    final fnExpression = RhapsodyFunctionExpression(fn);
    return RhapsodyExpressionAnalyserResult(
        expression: fnExpression, gathering: gatherer);
  }

  String _parseScopeVariable(
      RhapsodyTokenStream tokens, RhapsodyExpressionResultGatherer gatherer) {
    final prefixToken = RhapsodyTokenStreamFlyweight.consumeIdentifier(tokens,
        contextual: "scope of variable");
    RhapsodyTokenStreamFlyweight.consumeColon(tokens, contextual: "variable");
    final varToken = RhapsodyTokenStreamFlyweight.consumeIdentifier(tokens,
        contextual: "variable name");

    var maxSegments = 12;
    var compositeName = "";
    while (maxSegments > 0 && RhapsodyTokenStreamFlyweight.isColon(tokens)) {
      maxSegments = maxSegments - 1;
      RhapsodyTokenStreamFlyweight.consumeColon(tokens,
          contextual: "composite variable");
      final partOfName = RhapsodyTokenStreamFlyweight.consumeIdentifier(tokens,
              contextual: "composite variable name")
          .text;
      compositeName = "$compositeName:$partOfName";
    }
    final varName = "${prefixToken.text}:${varToken.text}$compositeName";

    if (maxSegments <= 0) {
      throw SemanticException(
          "Expecting a valid composite variable format with just a few colons but got $varName",
          prefixToken);
    }

    final isSupportedVar = options.isVariable(varName);
    if (!isSupportedVar) {
      throw SemanticException(
          "Expecting a valid variable format with a scope but got $varName",
          prefixToken);
    }

    return varName;
  }
}
