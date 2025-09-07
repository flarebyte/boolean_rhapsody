import 'package:boolean_rhapsody/boolean_rhapsody.dart';
import 'package:boolean_rhapsody/src/function/rule_function.dart';
import 'package:boolean_rhapsody/src/rule_expression.dart';
import 'package:test/test.dart';

class _NamedFn extends BooleanRhapsodyFunction {
  final String name;
  _NamedFn(this.name);
  @override
  RhapsodicBool isTrue(RhapsodyEvaluationContext context) =>
      RhapsodicBool.truth();
  @override
  String toString() => name;
}

void main() {
  group('Rule expression toString', () {
    late RhapsodyEvaluationContext ctx;
    setUp(() {
      ctx = RhapsodyEvaluationContextBuilder(prefixes: ['v', 'c']).build();
    });

    test('FunctionExpression toString contains function name', () {
      final expr = RhapsodyFunctionExpression(_NamedFn('MyFn'));
      expect(expr.evaluate(ctx), equals(RhapsodicBool.truth()));
      expect(expr.toString(), contains('FUNC'));
      expect(expr.toString(), contains('MyFn'));
    });

    test('And/Or/Not and RuleReference toString contain tags', () {
      final a = RhapsodyFunctionExpression(_NamedFn('A'));
      final b = RhapsodyFunctionExpression(_NamedFn('B'));
      final andExpr = RhapsodyAndOperator(a, b);
      final orExpr = RhapsodyOrOperator(a, b);
      final notExpr = RhapsodyNotOperator(a);
      final refExpr = RhapsodyRuleReference('ruleX');

      expect(andExpr.toString(), contains('AND'));
      expect(orExpr.toString(), contains('OR'));
      expect(notExpr.toString(), contains('NOT'));
      expect(refExpr.toString(), contains('RULE_REF'));
    });
  });

  group('RhapsodyBooleanExpressionFactory', () {
    test('creates expected expression types', () {
      final a = RhapsodyFunctionExpression(_NamedFn('A'));
      final b = RhapsodyFunctionExpression(_NamedFn('B'));
      expect(RhapsodyBooleanExpressionFactory.and(a, b),
          isA<RhapsodyAndOperator>());
      expect(
          RhapsodyBooleanExpressionFactory.or(a, b), isA<RhapsodyOrOperator>());
      expect(
          RhapsodyBooleanExpressionFactory.not(a), isA<RhapsodyNotOperator>());
      expect(RhapsodyBooleanExpressionFactory.function(_NamedFn('F')),
          isA<RhapsodyFunctionExpression>());
      expect(RhapsodyBooleanExpressionFactory.ruleReference('r'),
          isA<RhapsodyRuleReference>());
    });
  });
}
