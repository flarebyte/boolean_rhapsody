import 'analysis_failure.dart';
import 'boolean_expression_analyser.dart';
import 'expression_analyzer_result.dart';
import 'parser_options.dart';
import 'rule_definition.dart';
import 'rule_expession.dart';
import 'semantic_exception.dart';
import 'token.dart';
import 'tokeniser.dart';

/// Consolidates the result of the semantic analysis phase for a grammar.
///
/// This result distinguishes between a successful analysis—where a full set of rule
/// definitions is available—and a failure state that provides detailed diagnostic
/// information for error recovery or reporting.
class RhapsodySemanticAnalysisResult {
  /// When present, details the error that prevented successful analysis.
  ///
  /// A non-null value indicates that an error was encountered during the semantic
  /// analysis phase, signaling that the rule definitions may be incomplete or invalid.
  final RhapsodyAnalysisFailure? failure;

  /// A mapping of grammar rule names to their respective semantic definitions.
  ///
  /// This collection serves as the primary reference for downstream processes, such as
  /// code generation or further validation, once the analysis phase completes successfully.
  final Map<String, RhapsodyRuleDefintition> ruleDefinitions;

  /// Creates a result object that encapsulates either an analysis error or a valid set of rule definitions.
  ///
  /// The [ruleDefinitions] map must be provided to ensure that all semantic constructs are accessible,
  /// regardless of whether an error was detected.
  RhapsodySemanticAnalysisResult({
    this.failure,
    required this.ruleDefinitions,
  });
}

/// Analyser for a boolean query language that produces semantic rule definitions.
///
/// The analyser expects input tokens for one or more rule definitions that follow
/// the syntax:
///
///     rule <ruleName> = <boolean expression> ;
///
/// For example:
///
///     rule rule23 = (func1(env:variable1) or func2(config:variable2)) and not rule42;
///
/// In the above, the analyzer will record that `rule23` depends on `rule42`.
class RhapsodySemanticAnalyser {
  /// Provides domain‐specific details (such as valid prefixes and functions)
  /// used during the analysis phase.
  final RhapsodyAnalyserOptions options;
  late RhapsodyBooleanExpressionAnalyser expressionAnalyser;

  /// Instantiates the analyser with custom options.
  RhapsodySemanticAnalyser(this.options) {
    expressionAnalyser = RhapsodyBooleanExpressionAnalyser(
        options: options, ruleDefinitions: {});
  }

  /// Analyzes a stream of tokens, returning either a set of valid rule definitions
  /// or an analysis failure with detailed diagnostics.
  ///
  /// The analysis is done by “parsing” rule definitions from the token list.
  /// Each definition is expected to begin with the keyword `rule` (an identifier token),
  /// followed by a rule name, an equal sign, a boolean expression, and a terminating semicolon.
  ///
  /// The boolean expression is scanned for identifiers that (by the current semantic rules)
  /// represent dependencies on other rules.
  RhapsodySemanticAnalysisResult analyse(List<RhapsodyToken> tokens) {
    final Map<String, RhapsodyRuleDefintition> ruleDefinitions = {};
    int index = 0;

    try {
      while (index < tokens.length) {
        // Expect the 'rule' keyword.
        final RhapsodyToken ruleKeyword = tokens[index];
        if (ruleKeyword.type != TokenTypes.identifier ||
            ruleKeyword.text != 'rule') {
          throw SemanticException("Expected 'rule' keyword", ruleKeyword);
        }
        final int ruleStartIndex = ruleKeyword.startIndex;
        final RhapsodyPosition ruleStartPosition = ruleKeyword.startPosition;
        index++;

        // The next token should be the rule name.
        if (index >= tokens.length) {
          throw SemanticException(
              "Expected rule name after 'rule'", ruleKeyword);
        }
        final RhapsodyToken ruleNameToken = tokens[index];
        if (ruleNameToken.type != TokenTypes.identifier) {
          throw SemanticException(
              "Expected an identifier for the rule name", ruleNameToken);
        }
        final String ruleName = ruleNameToken.text;
        index++;

        // Expect an equal sign.
        if (index >= tokens.length) {
          throw SemanticException(
              "Expected '=' after the rule name", ruleNameToken);
        }
        final RhapsodyToken equalToken = tokens[index];
        if (equalToken.type != TokenTypes.equal) {
          throw SemanticException(
              "Expected '=' after the rule name", equalToken);
        }
        index++;

        // Collect tokens that form the boolean expression.
        final List<RhapsodyToken> exprTokens = [];
        while (index < tokens.length &&
            tokens[index].type != TokenTypes.semicolon) {
          exprTokens.add(tokens[index]);
          index++;
        }
        if (index >= tokens.length) {
          throw SemanticException(
              "Expected ';' at the end of the rule definition", tokens.last);
        }
        final RhapsodyToken semicolonToken = tokens[index];
        final int ruleEndIndex = semicolonToken.endIndex;
        final RhapsodyPosition ruleEndPosition = semicolonToken.endPosition;
        index++; // Skip the semicolon.

        // Process the expression tokens.
        final RhapsodyExpressionAnalyserResult parseResult =
            expressionAnalyser.analyse(exprTokens);
        final RhapsodyBooleanExpression expression = parseResult.expression;
        final RhapsodyExpressionResultGatherer gatherer =
            RhapsodyExpressionResultGatherer();

        // Reconstruct the rule’s source text by joining the tokens.
        // (A real analyser might use the original input text instead.)
        final int start =
            index - (exprTokens.length + 3); // rule keyword, name, '=' tokens
        final String ruleText =
            tokens.sublist(start, index).map((t) => t.text).join(' ');

        final ruleDefinition = RhapsodyRuleDefintition(
          ruleName: ruleName,
          requiredRules: gatherer.requiredRules.toList(),
          expression: expression,
          startIndex: ruleStartIndex,
          endIndex: ruleEndIndex,
          startPosition: ruleStartPosition,
          endPosition: ruleEndPosition,
          text: ruleText,
        );
        ruleDefinitions[ruleName] = ruleDefinition;
      }
      return RhapsodySemanticAnalysisResult(ruleDefinitions: ruleDefinitions);
    } on SemanticException catch (e) {
      // Package the diagnostic details into a failure object.
      final RhapsodyToken errorToken = e.token;
      final failure = RhapsodyAnalysisFailure(
        position: errorToken.startPosition,
        index: errorToken.startIndex,
        errorType: "Semantic Analysis Error",
        message: e.message,
        contextCode: errorToken.text,
        expected: "",
        suggestion: "Check rule definition syntax near '${errorToken.text}'.",
      );
      return RhapsodySemanticAnalysisResult(
        failure: failure,
        ruleDefinitions: ruleDefinitions,
      );
    } catch (e) {
      // Catch-all for any unexpected issues.
      final failure = RhapsodyAnalysisFailure(
        position: tokens.isNotEmpty
            ? tokens.first.startPosition
            : RhapsodyPosition(row: 0, column: 0),
        index: tokens.isNotEmpty ? tokens.first.startIndex : 0,
        errorType: "Unknown Error",
        message: e.toString(),
        contextCode: "",
        expected: "",
        suggestion: "Review the input.",
      );
      return RhapsodySemanticAnalysisResult(
        failure: failure,
        ruleDefinitions: ruleDefinitions,
      );
    }
  }
}
