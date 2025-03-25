import 'evaluation_context.dart';
import 'fuzzy_boolean.dart';
import 'rule_expession.dart';

/// **Class: RhapsodyRuleReference**
///
/// Represents a reference to a named rule within a collection of rule definitions.
class RhapsodySingleRuleEvaluator {
  /// The name of the rule being referenced.

  /// A map containing all available rule definitions.
  final Map<String, RhapsodyBooleanExpression> ruleDefinitions = {};

  /// Creates an instance of `RhapsodyRuleReference`.
  ///
  /// **Parameters:**
  RhapsodySingleRuleEvaluator();

  addRuleDefinition(String name, RhapsodyBooleanExpression expression) {
    ruleDefinitions.putIfAbsent(name, () => expression);
  }

  @override
  String toString() {
    return 'Evaluator {ruleDefinitions: ${ruleDefinitions.keys}}';
  }

  /// Evaluates the referenced rule within the given context.
  ///
  /// **Overrides:** `evaluate` in `RhapsodyBooleanExpression`.
  ///
  /// **Parameters:**
  /// - `context`: The evaluation context.
  ///
  /// **Returns:** The result of evaluating the referenced rule.
  ///
  /// **Throws:** `Exception` if the rule is not found in `ruleDefinitions`.
  RhapsodicBool evaluate(RhapsodyEvaluationContext context, String ruleName) {
    final rule = ruleDefinitions[ruleName];
    if (rule == null) {
      throw Exception("Rule $ruleName is not defined");
    }
    return rule.evaluate(context);
  }
}
