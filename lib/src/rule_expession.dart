import 'package:boolean_rhapsody/src/evaluation_context.dart';

import 'rule_model.dart';

abstract class BooleanExpression {
  bool evaluate(RhapsodyEvaluationContext context);
}

class AndOperator extends BooleanExpression {
  final BooleanExpression left;
  final BooleanExpression right;

  AndOperator(this.left, this.right);

  @override
  bool evaluate(RhapsodyEvaluationContext context) {
    return left.evaluate(context) && right.evaluate(context);
  }
}

class OrOperator extends BooleanExpression {
  final BooleanExpression left;
  final BooleanExpression right;

  OrOperator(this.left, this.right);

  @override
  bool evaluate(RhapsodyEvaluationContext context) {
    return left.evaluate(context) || right.evaluate(context);
  }
}

class NotOperator extends BooleanExpression {
  final BooleanExpression operand;

  NotOperator(this.operand);

  @override
  bool evaluate(RhapsodyEvaluationContext context) {
    return !operand.evaluate(context);
  }
}

class FunctionExpression extends BooleanExpression {
  final BooleanRhapsodyFunction function;

  FunctionExpression(this.function);

  @override
  bool evaluate(RhapsodyEvaluationContext context) {
    return function.isTrue(context);
  }
}

class RuleReference extends BooleanExpression {
  final String ruleName;
  final Map<String, BooleanExpression> ruleDefinitions;

  RuleReference(this.ruleName, this.ruleDefinitions);

  @override
  bool evaluate(RhapsodyEvaluationContext context) {
    final rule = ruleDefinitions[ruleName];
    if (rule == null) {
      throw Exception("Rule $ruleName is not defined");
    }
    return rule.evaluate(context);
  }
}
