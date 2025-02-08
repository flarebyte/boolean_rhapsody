import 'parser_options.dart';
import 'rule_expession.dart';
import 'token.dart';
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
