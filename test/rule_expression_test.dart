import 'package:boolean_rhapsody/boolean_rhapsody.dart';
import 'package:boolean_rhapsody/src/rule_function.dart';
import 'package:test/test.dart';

class MockBooleanFunction implements BooleanRhapsodyFunction {
  final RhapsodicBool result;

  MockBooleanFunction(this.result);

  @override
  RhapsodicBool isTrue(RhapsodyEvaluationContext context) => result;

  @override
  basicValidateParams(
      {required List<String> refs,
      required int minSize,
      required int maxSize,
      required String name}) {}
}

void main() {
  group('RhapsodyBooleanExpression Tests', () {
    late RhapsodyEvaluationContext context;

    setUp(() {
      context = RhapsodyEvaluationContext(variables: {
        'v:testVar': 'RhapsodicBool.truth()',
        'c:testConst': 'RhapsodicBool.untruth()',
        'p:testParam': 'RhapsodicBool.truth()',
        'd:testDeviceVar': 'RhapsodicBool.untruth()'
      }, prefixes: [
        "c",
        "v",
        "p",
        "d"
      ]);
    });

    test('And Operator evaluates correctly', () {
      for (var secondValue in [
        RhapsodicBool.untruth(),
        RhapsodicBool.truthy(),
        RhapsodicBool.untruthy()
      ]) {
        final expr = RhapsodyAndOperator(
          RhapsodyFunctionExpression(
              MockBooleanFunction(RhapsodicBool.truth())),
          RhapsodyFunctionExpression(MockBooleanFunction(secondValue)),
        );
        final swapExpr = RhapsodyAndOperator(
          RhapsodyFunctionExpression(MockBooleanFunction(secondValue)),
          RhapsodyFunctionExpression(
              MockBooleanFunction(RhapsodicBool.truth())),
        );

        expect(expr.evaluate(context), RhapsodicBool.untruth());
        expect(expr.evaluate(context), swapExpr.evaluate(context));
      }

      final exprTrue = RhapsodyAndOperator(
        RhapsodyFunctionExpression(MockBooleanFunction(RhapsodicBool.truth())),
        RhapsodyFunctionExpression(MockBooleanFunction(RhapsodicBool.truth())),
      );

      expect(exprTrue.evaluate(context), RhapsodicBool.truth());
      for (var firstValue in [
        RhapsodicBool.truthy(),
        RhapsodicBool.untruthy()
      ]) {
        for (var secondValue in [
          RhapsodicBool.truthy(),
          RhapsodicBool.untruthy()
        ]) {
          expect(
              RhapsodyAndOperator(
                RhapsodyFunctionExpression(MockBooleanFunction(firstValue)),
                RhapsodyFunctionExpression(MockBooleanFunction(secondValue)),
              ).evaluate(context).certain,
              isFalse);
        }
      }
    });

    test('Or Operator evaluates correctly', () {
      final expr = RhapsodyOrOperator(
        RhapsodyFunctionExpression(
            MockBooleanFunction(RhapsodicBool.untruth())),
        RhapsodyFunctionExpression(
            MockBooleanFunction(RhapsodicBool.untruth())),
      );

      expect(expr.evaluate(context), RhapsodicBool.untruth());

      for (var secondValue in [
        RhapsodicBool.truth(),
        RhapsodicBool.untruth(),
        RhapsodicBool.truthy(),
        RhapsodicBool.untruthy()
      ]) {
        final exprTrue = RhapsodyOrOperator(
          RhapsodyFunctionExpression(
              MockBooleanFunction(RhapsodicBool.truth())),
          RhapsodyFunctionExpression(MockBooleanFunction(secondValue)),
        );
        final swapExprTrue = RhapsodyOrOperator(
          RhapsodyFunctionExpression(MockBooleanFunction(secondValue)),
          RhapsodyFunctionExpression(
              MockBooleanFunction(RhapsodicBool.truth())),
        );

        expect(exprTrue.evaluate(context), RhapsodicBool.truth());
        expect(exprTrue.evaluate(context), swapExprTrue.evaluate(context));
        for (var firstValue in [
          RhapsodicBool.truthy(),
          RhapsodicBool.untruthy()
        ]) {
          for (var secondValue in [
            RhapsodicBool.truthy(),
            RhapsodicBool.untruthy()
          ]) {
            expect(
                RhapsodyOrOperator(
                  RhapsodyFunctionExpression(MockBooleanFunction(firstValue)),
                  RhapsodyFunctionExpression(MockBooleanFunction(secondValue)),
                ).evaluate(context).certain,
                isFalse);
          }
        }
      }
    });

    test('Not Operator evaluates correctly', () {
      expect(
          RhapsodyNotOperator(
            RhapsodyFunctionExpression(
                MockBooleanFunction(RhapsodicBool.untruth())),
          ).evaluate(context),
          RhapsodicBool.truth());

      expect(
          RhapsodyNotOperator(
            RhapsodyFunctionExpression(
                MockBooleanFunction(RhapsodicBool.untruthy())),
          ).evaluate(context),
          RhapsodicBool.truthy());

      expect(
          RhapsodyNotOperator(
            RhapsodyFunctionExpression(
                MockBooleanFunction(RhapsodicBool.truth())),
          ).evaluate(context),
          RhapsodicBool.untruth());
      expect(
          RhapsodyNotOperator(
            RhapsodyFunctionExpression(
                MockBooleanFunction(RhapsodicBool.truthy())),
          ).evaluate(context),
          RhapsodicBool.untruthy());
    });

    test('RhapsodyFunctionExpression evaluates correctly', () {
      final exprTrue = RhapsodyFunctionExpression(
          MockBooleanFunction(RhapsodicBool.truth()));
      expect(exprTrue.evaluate(context), RhapsodicBool.truth());

      final exprFalse = RhapsodyFunctionExpression(
          MockBooleanFunction(RhapsodicBool.untruth()));
      expect(exprFalse.evaluate(context), RhapsodicBool.untruth());
    });

    test('RhapsodyRuleReference evaluates defined rules correctly', () {
      final ruleDefinitions = {
        'rule1': RhapsodyFunctionExpression(
            MockBooleanFunction(RhapsodicBool.truth())),
        'rule2': RhapsodyFunctionExpression(
            MockBooleanFunction(RhapsodicBool.untruth())),
      };

      final ruleReferenceTrue = RhapsodyRuleReference('rule1', ruleDefinitions);
      expect(ruleReferenceTrue.evaluate(context), RhapsodicBool.truth());

      final ruleReferenceFalse =
          RhapsodyRuleReference('rule2', ruleDefinitions);
      expect(ruleReferenceFalse.evaluate(context), RhapsodicBool.untruth());
    });

    test('RhapsodyRuleReference throws exception for undefined rules', () {
      final ruleDefinitions = {
        'rule1': RhapsodyFunctionExpression(
            MockBooleanFunction(RhapsodicBool.truth())),
      };

      final ruleReference =
          RhapsodyRuleReference('undefinedRule', ruleDefinitions);

      expect(() => ruleReference.evaluate(context), throwsA(isA<Exception>()));
    });

    test('Complex expressions evaluate correctly', () {
      final complexExpression = RhapsodyAndOperator(
        RhapsodyOrOperator(
          RhapsodyFunctionExpression(
              MockBooleanFunction(RhapsodicBool.untruth())),
          RhapsodyFunctionExpression(
              MockBooleanFunction(RhapsodicBool.truth())),
        ),
        RhapsodyNotOperator(
          RhapsodyFunctionExpression(
              MockBooleanFunction(RhapsodicBool.untruth())),
        ),
      );

      expect(complexExpression.evaluate(context), RhapsodicBool.truth());
    });

    test('Empty evaluation context works with default functions', () {
      final emptyContext =
          RhapsodyEvaluationContext(variables: {}, prefixes: ["c"]);

      final expr = RhapsodyFunctionExpression(
          MockBooleanFunction(RhapsodicBool.truth()));
      expect(expr.evaluate(emptyContext), RhapsodicBool.truth());

      final exprFalse = RhapsodyFunctionExpression(
          MockBooleanFunction(RhapsodicBool.untruth()));
      expect(exprFalse.evaluate(emptyContext), RhapsodicBool.untruth());
    });

    test('Edge case: deeply nested expressions evaluate correctly', () {
      final deeplyNested = RhapsodyAndOperator(
        RhapsodyOrOperator(
          RhapsodyAndOperator(
            RhapsodyFunctionExpression(
                MockBooleanFunction(RhapsodicBool.truth())),
            RhapsodyFunctionExpression(
                MockBooleanFunction(RhapsodicBool.truth())),
          ),
          RhapsodyNotOperator(
            RhapsodyFunctionExpression(
                MockBooleanFunction(RhapsodicBool.untruth())),
          ),
        ),
        RhapsodyFunctionExpression(MockBooleanFunction(RhapsodicBool.truth())),
      );

      expect(deeplyNested.evaluate(context), RhapsodicBool.truth());
    });
  });
}
