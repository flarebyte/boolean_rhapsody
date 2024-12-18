import 'package:boolean_rhapsody/src/evaluation_context.dart';

import 'rule_function.dart';

/// **Abstract Class: RhapsodyBooleanExpression**
///
/// Represents the base class for boolean expressions in a DSL.
/// This is an abstract class and must be extended to define specific boolean logic operations.
abstract class RhapsodyBooleanExpression {
  /// Evaluates the boolean expression in the context of a given `RhapsodyEvaluationContext`.
  ///
  /// **Parameters:**
  /// - `context`: An instance of `RhapsodyEvaluationContext` used to resolve variables,
  ///   constants, and other contextual data.
  ///
  /// **Returns:** A `bool` representing the result of the evaluation.
  bool evaluate(RhapsodyEvaluationContext context);
}

/// **Class: RhapsodyAndOperator**
///
/// Represents a logical AND operator for combining two boolean expressions.
class RhapsodyAndOperator extends RhapsodyBooleanExpression {
  /// The left-hand side expression.
  final RhapsodyBooleanExpression left;

  /// The right-hand side expression.
  final RhapsodyBooleanExpression right;

  /// Creates an instance of `RhapsodyAndOperator`.
  ///
  /// **Parameters:**
  /// - `left`: The left-hand side boolean expression.
  /// - `right`: The right-hand side boolean expression.
  RhapsodyAndOperator(this.left, this.right);

  /// Evaluates the logical AND of the left and right expressions.
  ///
  /// **Overrides:** `evaluate` in `RhapsodyBooleanExpression`.
  ///
  /// **Parameters:**
  /// - `context`: The evaluation context.
  ///
  /// **Returns:** `true` if both expressions evaluate to `true`, otherwise `false`.
  @override
  bool evaluate(RhapsodyEvaluationContext context) {
    return left.evaluate(context) && right.evaluate(context);
  }
}

/// **Class: RhapsodyOrOperator**
///
/// Represents a logical OR operator for combining two boolean expressions.
class RhapsodyOrOperator extends RhapsodyBooleanExpression {
  /// The left-hand side expression.
  final RhapsodyBooleanExpression left;

  /// The right-hand side expression.
  final RhapsodyBooleanExpression right;

  /// Creates an instance of `RhapsodyOrOperator`.
  ///
  /// **Parameters:**
  /// - `left`: The left-hand side boolean expression.
  /// - `right`: The right-hand side boolean expression.
  RhapsodyOrOperator(this.left, this.right);

  /// Evaluates the logical OR of the left and right expressions.
  ///
  /// **Overrides:** `evaluate` in `RhapsodyBooleanExpression`.
  ///
  /// **Parameters:**
  /// - `context`: The evaluation context.
  ///
  /// **Returns:** `true` if at least one expression evaluates to `true`, otherwise `false`.
  @override
  bool evaluate(RhapsodyEvaluationContext context) {
    return left.evaluate(context) || right.evaluate(context);
  }
}

/// **Class: RhapsodyNotOperator**
///
/// Represents a logical NOT operator for inverting a boolean expression.
class RhapsodyNotOperator extends RhapsodyBooleanExpression {
  /// The expression to be inverted.
  final RhapsodyBooleanExpression operand;

  /// Creates an instance of `RhapsodyNotOperator`.
  ///
  /// **Parameters:**
  /// - `operand`: The boolean expression to invert.
  RhapsodyNotOperator(this.operand);

  /// Evaluates the logical NOT of the operand expression.
  ///
  /// **Overrides:** `evaluate` in `RhapsodyBooleanExpression`.
  ///
  /// **Parameters:**
  /// - `context`: The evaluation context.
  ///
  /// **Returns:** `true` if the operand evaluates to `false`, otherwise `false`.
  @override
  bool evaluate(RhapsodyEvaluationContext context) {
    return !operand.evaluate(context);
  }
}

/// **Class: RhapsodyFunctionExpression**
///
/// Represents a boolean function expression to be evaluated in the context.
class RhapsodyFunctionExpression extends RhapsodyBooleanExpression {
  /// The function to be evaluated.
  final BooleanRhapsodyFunction function;

  /// Creates an instance of `RhapsodyFunctionExpression`.
  ///
  /// **Parameters:**
  /// - `function`: A function implementing boolean logic evaluation.
  RhapsodyFunctionExpression(this.function);

  /// Evaluates the function within the given context.
  ///
  /// **Overrides:** `evaluate` in `RhapsodyBooleanExpression`.
  ///
  /// **Parameters:**
  /// - `context`: The evaluation context.
  ///
  /// **Returns:** The result of the function evaluation as a `bool`.
  @override
  bool evaluate(RhapsodyEvaluationContext context) {
    return function.isTrue(context);
  }
}

/// **Class: RhapsodyRuleReference**
///
/// Represents a reference to a named rule within a collection of rule definitions.
class RhapsodyRuleReference extends RhapsodyBooleanExpression {
  /// The name of the rule being referenced.
  final String ruleName;

  /// A map containing all available rule definitions.
  final Map<String, RhapsodyBooleanExpression> ruleDefinitions;

  /// Creates an instance of `RhapsodyRuleReference`.
  ///
  /// **Parameters:**
  /// - `ruleName`: The name of the rule to reference.
  /// - `ruleDefinitions`: A map of rule definitions to resolve the rule.
  RhapsodyRuleReference(this.ruleName, this.ruleDefinitions);

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
  @override
  bool evaluate(RhapsodyEvaluationContext context) {
    final rule = ruleDefinitions[ruleName];
    if (rule == null) {
      throw Exception("Rule $ruleName is not defined");
    }
    return rule.evaluate(context);
  }
}
