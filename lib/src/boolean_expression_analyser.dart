import 'analyser_function_helper.dart';
import 'expression_analyzer_result.dart';
import 'parser_options.dart';
import 'rule_expession.dart';
import 'semantic_exception.dart';
import 'token.dart';
import 'token_stream.dart';
import 'token_stream_flyweight.dart';

class RhapsodyBooleanExpressionAnalyser {
  final RhapsodyAnalyserOptions options;
  final Map<String, RhapsodyBooleanExpression> ruleDefinitions;
  late RhapsodyAnalyserFunctionHelper functionHelper;

  /// Instantiates the analyser with custom options.
  RhapsodyBooleanExpressionAnalyser({
    required this.options,
    required this.ruleDefinitions,
  }) {
    functionHelper = RhapsodyAnalyserFunctionHelper(options: options);
  }

  /// Parses a list of tokens into a boolean expression while collecting referenced rules.
  RhapsodyExpressionAnalyserResult analyse(List<RhapsodyToken> tokens) {
    final tokenStream = RhapsodyTokenStream(tokens);
    final gatherer = RhapsodyExpressionResultGatherer();

    final expression = _parseExpression(tokenStream, gatherer);

    if (!tokenStream.isAtEnd) {
      throw SemanticException(
        'Unexpected token after end of expression',
        tokenStream.current,
      );
    }

    return RhapsodyExpressionAnalyserResult(
        expression: expression, gathering: gatherer);
  }

  /// Parses `<expr> ::= <term> <expr_tail>`
  RhapsodyBooleanExpression _parseExpression(
    RhapsodyTokenStream tokens,
    RhapsodyExpressionResultGatherer gatherer,
  ) {
    final left = _parseTerm(tokens, gatherer);
    return _parseExpressionTail(tokens, left, gatherer);
  }

  /// Parses `<expr_tail> ::= and <term> <expr_tail> | or <term> <expr_tail> | ε`
  RhapsodyBooleanExpression _parseExpressionTail(
    RhapsodyTokenStream tokens,
    RhapsodyBooleanExpression left,
    RhapsodyExpressionResultGatherer gatherer,
  ) {
    while (!tokens.isAtEnd) {
      if (RhapsodyTokenStreamFlyweight.peekIsAndOperator(tokens)) {
        RhapsodyTokenStreamFlyweight.consumeAndOperator(tokens);
        final right = _parseTerm(tokens, gatherer);
        left = RhapsodyBooleanExpressionFactory.and(left, right);
      } else if (RhapsodyTokenStreamFlyweight.peekIsOrOperator(tokens)) {
        RhapsodyTokenStreamFlyweight.consumeOrOperator(tokens);
        final right = _parseTerm(tokens, gatherer);
        left = RhapsodyBooleanExpressionFactory.or(left, right);
      } else {
        break;
      }
    }
    return left;
  }

  /// Parses `<term> ::= not <term> | ( <expr> ) | <functionCall> | <ruleRef>`
  RhapsodyBooleanExpression _parseTerm(
    RhapsodyTokenStream tokens,
    RhapsodyExpressionResultGatherer gatherer,
  ) {
    if (RhapsodyTokenStreamFlyweight.peekIsNotOperator(tokens)) {
      RhapsodyTokenStreamFlyweight.consumeNotOperator(tokens);
      final operand = _parseTerm(tokens, gatherer);
      return RhapsodyBooleanExpressionFactory.not(operand);
    }

    if (RhapsodyTokenStreamFlyweight.peekIsLeftParenthesis(tokens)) {
      RhapsodyTokenStreamFlyweight.consumeLeftParenthesis(tokens,
          contextual: 'group');
      final expr = _parseExpression(tokens, gatherer);
      RhapsodyTokenStreamFlyweight.consumeRightParenthesis(tokens,
          contextual: 'group');
      return expr;
    }

    if (RhapsodyTokenStreamFlyweight.isFunctionCall(tokens)) {
      /// Parses `<functionCall> ::= (Predefined function call token)`
      final reaResult = functionHelper.parseFunctionCall(tokens);
      return reaResult.expression;
    }

    return _parseRuleReference(tokens, gatherer);
  }

  /// Parses `<ruleRef> ::= <ruleName>`
  RhapsodyBooleanExpression _parseRuleReference(
    RhapsodyTokenStream tokens,
    RhapsodyExpressionResultGatherer gatherer,
  ) {
    final token = RhapsodyTokenStreamFlyweight.consumeIdentifier(tokens,
        contextual: 'rule reference');
    gatherer.addRule(token.text);

    if (!ruleDefinitions.containsKey(token.text)) {
      throw SemanticException('Undefined rule reference: ${token.text}', token);
    }

    return RhapsodyBooleanExpressionFactory.ruleReference(
        token.text, ruleDefinitions);
  }
}
