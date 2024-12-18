import 'package:boolean_rhapsody/src/evaluation_context.dart';

import 'rule_function.dart';

abstract class RhapsodyBooleanExpression {
  bool evaluate(RhapsodyEvaluationContext context);
}

class RhapsodyAndOperator extends RhapsodyBooleanExpression {
  final RhapsodyBooleanExpression left;
  final RhapsodyBooleanExpression right;

  RhapsodyAndOperator(this.left, this.right);

  @override
  bool evaluate(RhapsodyEvaluationContext context) {
    return left.evaluate(context) && right.evaluate(context);
  }
}

class RhapsodyOrOperator extends RhapsodyBooleanExpression {
  final RhapsodyBooleanExpression left;
  final RhapsodyBooleanExpression right;

  RhapsodyOrOperator(this.left, this.right);

  @override
  bool evaluate(RhapsodyEvaluationContext context) {
    return left.evaluate(context) || right.evaluate(context);
  }
}

class RhapsodyNotOperator extends RhapsodyBooleanExpression {
  final RhapsodyBooleanExpression operand;

  RhapsodyNotOperator(this.operand);

  @override
  bool evaluate(RhapsodyEvaluationContext context) {
    return !operand.evaluate(context);
  }
}

class RhapsodyFunctionExpression extends RhapsodyBooleanExpression {
  final BooleanRhapsodyFunction function;

  RhapsodyFunctionExpression(this.function);

  @override
  bool evaluate(RhapsodyEvaluationContext context) {
    return function.isTrue(context);
  }
}

class RhapsodyRuleReference extends RhapsodyBooleanExpression {
  final String ruleName;
  final Map<String, RhapsodyBooleanExpression> ruleDefinitions;

  RhapsodyRuleReference(this.ruleName, this.ruleDefinitions);

  @override
  bool evaluate(RhapsodyEvaluationContext context) {
    final rule = ruleDefinitions[ruleName];
    if (rule == null) {
      throw Exception("Rule $ruleName is not defined");
    }
    return rule.evaluate(context);
  }
}
