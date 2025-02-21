import 'rule_expession.dart';

/// Helper class to encapsulate the result of parsing a boolean expression.
class RhapsodyExpressionAnalyserResult {
  final RhapsodyBooleanExpression expression;
  final RhapsodyExpressionResultGatherer gathering;

  @override
  String toString() {
    return 'R.E.A.Result{expression: $expression, gathering: $gathering}';
  }

  RhapsodyExpressionAnalyserResult({
    required this.expression,
    required this.gathering,
  });
}

/// Gathers required rules and variables extracted from Rhapsody expressions.
///
/// This class provides functionality to collect unique rules and variables
/// from expressions and merge multiple gatherings into a single instance.
class RhapsodyExpressionResultGatherer {
  /// The set of unique required rules.
  final Set<String> requiredRules;

  /// The set of unique required variables.
  final Set<String> requiredVariables;

  /// Creates an empty [RhapsodyExpressionResultGatherer] instance.
  RhapsodyExpressionResultGatherer()
      : requiredRules = <String>{},
        requiredVariables = <String>{};

  /// Adds a [rule] to the set of required rules.
  ///
  /// If the [rule] already exists, it will not be added again.
  void addRule(String rule) {
    requiredRules.add(rule);
  }

  /// Adds a [variable] to the set of required variables.
  ///
  /// If the [variable] already exists, it will not be added again.
  void addVariable(String variable) {
    requiredVariables.add(variable);
  }

  /// Merges multiple [RhapsodyExpressionResultGatherer] instances into a single one.
  ///
  /// All unique rules and variables from the provided [gatherings] list are combined.
  ///
  /// Throws an [ArgumentError] if [gatherings] is empty.
  static RhapsodyExpressionResultGatherer merge(
      List<RhapsodyExpressionResultGatherer> gatherings) {
    if (gatherings.isEmpty) {
      throw ArgumentError('The gatherings list cannot be empty.');
    }

    final merged = RhapsodyExpressionResultGatherer();
    for (final gatherer in gatherings) {
      merged.requiredRules.addAll(gatherer.requiredRules);
      merged.requiredVariables.addAll(gatherer.requiredVariables);
    }
    return merged;
  }

  @override
  String toString() {
    final List<String> rules = requiredRules.toList(growable: false);
    final List<String> vars = requiredVariables.toList(growable: false);
    rules.sort();
    vars.sort();
    return 'R.E.R.Gatherer{rules: $rules, vars: $vars}';
  }
}
