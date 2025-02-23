import 'analyser_function_helper.dart';
import 'expression_analyzer_result.dart';
import 'parser_options.dart';
import 'rule_expession.dart';
import 'semantic_exception.dart';
import 'token.dart';
import 'token_stream.dart';
import 'tokeniser.dart';

class RhapsodyBooleanExpressionAnalyser {
  final RhapsodyAnalyserOptions options;
  final Map<String, RhapsodyBooleanExpression> ruleDefinitions;
  late RhapsodyAnalyserFunctionHelper functionHelper;

  /// Instantiates the analyser with custom options.
  RhapsodyBooleanExpressionAnalyser(
      {required this.options, required this.ruleDefinitions}) {
    functionHelper = RhapsodyAnalyserFunctionHelper(options: options);
  }

  /// Parses the tokens forming a boolean expression and extracts external rule references.
  RhapsodyExpressionAnalyserResult analyse(List<RhapsodyToken> tokens) {
    final tokenStream = RhapsodyTokenStream(tokens);
    final ast = _parseOrExpression(tokenStream);
    if (!tokenStream.isAtEnd) {
      throw SemanticException(
          "Unexpected ${tokenStream.remainingTokens.length} tokens after parsing: ",
          tokenStream.current);
    }
    return ast;
  }

  /// An Or Expression can be one or more And terms joined by or.
  /// OrExpression ::= AndTerm ( "or" OrExpression )*
  RhapsodyExpressionAnalyserResult _parseOrExpression(
      RhapsodyTokenStream tokens) {
    final result = _parseAndTerm(tokens);
    final isFollowedByOr = tokens.peekMatchesType(TokenTypes.operatorType) &&
        tokens.peekMatchesText('or');
    if (isFollowedByOr) {
      tokens.consume(); //consume or
      final nextOrExpression = _parseOrExpression(tokens);
      final orExpression =
          RhapsodyOrOperator(result.expression, nextOrExpression.expression);
      return RhapsodyExpressionAnalyserResult(
          expression: orExpression,
          gathering: RhapsodyExpressionResultGatherer.merge(
              [result.gathering, nextOrExpression.gathering]));
    }
    return result;
  }

  /// And And term can be one or more Factors joined by and.
  /// AndTerm ::= Factor ( "and" AndTerm )*
  RhapsodyExpressionAnalyserResult _parseAndTerm(RhapsodyTokenStream tokens) {
    final result = _parseFactor(tokens);
    final isFollowedByAnd = tokens.peekMatchesType(TokenTypes.operatorType) &&
        tokens.peekMatchesText('and');
    if (isFollowedByAnd) {
      tokens.consume(); //consume and
      final nextAndExpression = _parseAndTerm(tokens);
      final andExpression =
          RhapsodyAndOperator(result.expression, nextAndExpression.expression);
      return RhapsodyExpressionAnalyserResult(
          expression: andExpression,
          gathering: RhapsodyExpressionResultGatherer.merge(
              [result.gathering, nextAndExpression.gathering]));
    }
    return result;
  }

  RhapsodyExpressionAnalyserResult _parseFactor(RhapsodyTokenStream tokens) {
    if (tokens.isAtEnd) {
      throw Exception("Unexpected end of expression.");
    }

    final isFollowedByNot = tokens.peekMatchesType(TokenTypes.operatorType) &&
        tokens.peekMatchesText('not');
    final isFollowedByLeftParenthesis =
        tokens.peekMatchesType(TokenTypes.lparen);
    final isFollowedByFunction =
        tokens.peekMatchesType(TokenTypes.identifier) &&
            tokens.peekMatchesType(TokenTypes.lparen, lookahead: 2);
    final isFollowedByRule = tokens.peekMatchesType(TokenTypes.identifier);

    if (isFollowedByNot) {
      tokens.consume(); //consume not
      final next = _parseFactor(tokens);
      final notExpression = RhapsodyNotOperator(next.expression);
      return RhapsodyExpressionAnalyserResult(
          expression: notExpression, gathering: next.gathering);
    } else if (isFollowedByLeftParenthesis) {
      tokens.consume(); // consumme (
      final expr = _parseOrExpression(tokens);
      tokens.consume(); // consumme )
      if (!tokens.matchType(TokenTypes.rparen)) {
        throw SemanticException("Missing closing parenthesis.", tokens.current);
      }
      return expr;
    } else if (isFollowedByFunction) {
      final funcCall = functionHelper.parseFunctionCall(tokens);
      return RhapsodyExpressionAnalyserResult(
          expression: funcCall.expression, gathering: funcCall.gathering);
    } else if (isFollowedByRule) {
      final ruleIdToken = tokens.consume();
      final ruleRef = RhapsodyRuleReference(ruleIdToken.text, ruleDefinitions);
      final gatherer = RhapsodyExpressionResultGatherer();
      gatherer.addRule(ruleIdToken.text);
      return RhapsodyExpressionAnalyserResult(
          expression: ruleRef, gathering: gatherer);
    }

    throw SemanticException("Unexpected token", tokens.consume());
  }
}
