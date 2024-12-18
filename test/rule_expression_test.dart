import 'package:boolean_rhapsody/boolean_rhapsody.dart';
import 'package:boolean_rhapsody/src/rule_function.dart';
import 'package:test/test.dart';

class MockBooleanFunction implements BooleanRhapsodyFunction {
  final bool result;

  MockBooleanFunction(this.result);

  @override
  bool isTrue(RhapsodyEvaluationContext context) => result;

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
      context = RhapsodyEvaluationContext(
        variables: {'v:testVar': 'true'},
        constants: {'c:testConst': 'false'},
        parameters: {'p:testParam': 'true'},
        deviceVars: {'d:testDeviceVar': 'false'},
      );
    });

    test('RhapsodyAndOperator evaluates correctly', () {
      final expr = RhapsodyAndOperator(
        RhapsodyFunctionExpression(MockBooleanFunction(true)),
        RhapsodyFunctionExpression(MockBooleanFunction(false)),
      );

      expect(expr.evaluate(context), isFalse);

      final exprTrue = RhapsodyAndOperator(
        RhapsodyFunctionExpression(MockBooleanFunction(true)),
        RhapsodyFunctionExpression(MockBooleanFunction(true)),
      );

      expect(exprTrue.evaluate(context), isTrue);
    });

    test('RhapsodyOrOperator evaluates correctly', () {
      final expr = RhapsodyOrOperator(
        RhapsodyFunctionExpression(MockBooleanFunction(false)),
        RhapsodyFunctionExpression(MockBooleanFunction(false)),
      );

      expect(expr.evaluate(context), isFalse);

      final exprTrue = RhapsodyOrOperator(
        RhapsodyFunctionExpression(MockBooleanFunction(true)),
        RhapsodyFunctionExpression(MockBooleanFunction(false)),
      );

      expect(exprTrue.evaluate(context), isTrue);
    });

    test('RhapsodyNotOperator evaluates correctly', () {
      final expr = RhapsodyNotOperator(
        RhapsodyFunctionExpression(MockBooleanFunction(false)),
      );

      expect(expr.evaluate(context), isTrue);

      final exprFalse = RhapsodyNotOperator(
        RhapsodyFunctionExpression(MockBooleanFunction(true)),
      );

      expect(exprFalse.evaluate(context), isFalse);
    });

    test('RhapsodyFunctionExpression evaluates correctly', () {
      final exprTrue = RhapsodyFunctionExpression(MockBooleanFunction(true));
      expect(exprTrue.evaluate(context), isTrue);

      final exprFalse = RhapsodyFunctionExpression(MockBooleanFunction(false));
      expect(exprFalse.evaluate(context), isFalse);
    });

    test('RhapsodyRuleReference evaluates defined rules correctly', () {
      final ruleDefinitions = {
        'rule1': RhapsodyFunctionExpression(MockBooleanFunction(true)),
        'rule2': RhapsodyFunctionExpression(MockBooleanFunction(false)),
      };

      final ruleReferenceTrue = RhapsodyRuleReference('rule1', ruleDefinitions);
      expect(ruleReferenceTrue.evaluate(context), isTrue);

      final ruleReferenceFalse =
          RhapsodyRuleReference('rule2', ruleDefinitions);
      expect(ruleReferenceFalse.evaluate(context), isFalse);
    });

    test('RhapsodyRuleReference throws exception for undefined rules', () {
      final ruleDefinitions = {
        'rule1': RhapsodyFunctionExpression(MockBooleanFunction(true)),
      };

      final ruleReference =
          RhapsodyRuleReference('undefinedRule', ruleDefinitions);

      expect(() => ruleReference.evaluate(context), throwsA(isA<Exception>()));
    });

    test('Complex expressions evaluate correctly', () {
      final complexExpression = RhapsodyAndOperator(
        RhapsodyOrOperator(
          RhapsodyFunctionExpression(MockBooleanFunction(false)),
          RhapsodyFunctionExpression(MockBooleanFunction(true)),
        ),
        RhapsodyNotOperator(
          RhapsodyFunctionExpression(MockBooleanFunction(false)),
        ),
      );

      expect(complexExpression.evaluate(context), isTrue);
    });

    test('Empty evaluation context works with default functions', () {
      final emptyContext = RhapsodyEvaluationContext(
        variables: {},
        constants: {},
        parameters: {},
        deviceVars: {},
      );

      final expr = RhapsodyFunctionExpression(MockBooleanFunction(true));
      expect(expr.evaluate(emptyContext), isTrue);

      final exprFalse = RhapsodyFunctionExpression(MockBooleanFunction(false));
      expect(exprFalse.evaluate(emptyContext), isFalse);
    });

    test('Edge case: deeply nested expressions evaluate correctly', () {
      final deeplyNested = RhapsodyAndOperator(
        RhapsodyOrOperator(
          RhapsodyAndOperator(
            RhapsodyFunctionExpression(MockBooleanFunction(true)),
            RhapsodyFunctionExpression(MockBooleanFunction(true)),
          ),
          RhapsodyNotOperator(
            RhapsodyFunctionExpression(MockBooleanFunction(false)),
          ),
        ),
        RhapsodyFunctionExpression(MockBooleanFunction(true)),
      );

      expect(deeplyNested.evaluate(context), isTrue);
    });
  });
}
