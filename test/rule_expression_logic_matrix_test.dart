import 'package:boolean_rhapsody/boolean_rhapsody.dart';
import 'package:boolean_rhapsody/src/function/rule_function.dart';
import 'package:boolean_rhapsody/src/rule_expression.dart';
import 'package:test/test.dart';

class _ConstFn extends BooleanRhapsodyFunction {
  final RhapsodicBool result;
  _ConstFn(this.result);
  @override
  RhapsodicBool isTrue(RhapsodyEvaluationContext context) => result;
}

void main() {
  late RhapsodyEvaluationContext ctx;
  setUp(() {
    ctx = RhapsodyEvaluationContextBuilder(prefixes: ['v']).build();
  });

  group('AND operator selected truth table points', () {
    test('T with t -> F (uncertain right collapses to untruth)', () {
      final expr = RhapsodyAndOperator(
        RhapsodyFunctionExpression(_ConstFn(RhapsodicBool.truth())),
        RhapsodyFunctionExpression(_ConstFn(RhapsodicBool.truthy())),
      );
      expect(expr.evaluate(ctx).toChar(), equals('F'));
    });

    test('t with t -> t', () {
      final expr = RhapsodyAndOperator(
        RhapsodyFunctionExpression(_ConstFn(RhapsodicBool.truthy())),
        RhapsodyFunctionExpression(_ConstFn(RhapsodicBool.truthy())),
      );
      expect(expr.evaluate(ctx).toChar(), equals('t'));
    });

    test('t with F -> f', () {
      final expr = RhapsodyAndOperator(
        RhapsodyFunctionExpression(_ConstFn(RhapsodicBool.truthy())),
        RhapsodyFunctionExpression(_ConstFn(RhapsodicBool.untruth())),
      );
      expect(expr.evaluate(ctx).toChar(), equals('f'));
    });

    test('F with t -> f', () {
      final expr = RhapsodyAndOperator(
        RhapsodyFunctionExpression(_ConstFn(RhapsodicBool.untruth())),
        RhapsodyFunctionExpression(_ConstFn(RhapsodicBool.truthy())),
      );
      expect(expr.evaluate(ctx).toChar(), equals('f'));
    });
  });

  group('OR operator selected truth table points', () {
    test('F with t -> t', () {
      final expr = RhapsodyOrOperator(
        RhapsodyFunctionExpression(_ConstFn(RhapsodicBool.untruth())),
        RhapsodyFunctionExpression(_ConstFn(RhapsodicBool.truthy())),
      );
      expect(expr.evaluate(ctx).toChar(), equals('t'));
    });

    test('t with F -> t', () {
      final expr = RhapsodyOrOperator(
        RhapsodyFunctionExpression(_ConstFn(RhapsodicBool.truthy())),
        RhapsodyFunctionExpression(_ConstFn(RhapsodicBool.untruth())),
      );
      expect(expr.evaluate(ctx).toChar(), equals('t'));
    });

    test('f with f -> f', () {
      final expr = RhapsodyOrOperator(
        RhapsodyFunctionExpression(_ConstFn(RhapsodicBool.untruthy())),
        RhapsodyFunctionExpression(_ConstFn(RhapsodicBool.untruthy())),
      );
      expect(expr.evaluate(ctx).toChar(), equals('f'));
    });
  });
}
