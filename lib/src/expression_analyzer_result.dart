import 'rule_expession.dart';

/// Helper class to encapsulate the result of parsing a boolean expression.
class RhapsodyExpressionAnalyserResult {
  final RhapsodyBooleanExpression expression;
  final List<String> requiredRules;

  @override
  String toString() {
    return 'RhapsodyExpressionAnalyserResult{expression: $expression, requiredRules: $requiredRules}';
  }

  RhapsodyExpressionAnalyserResult({
    required this.expression,
    required this.requiredRules,
  });
}
