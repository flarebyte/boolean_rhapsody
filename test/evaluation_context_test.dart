import 'package:boolean_rhapsody/boolean_rhapsody.dart';
import 'package:test/test.dart';

void main() {
  group('RhapsodyEvaluationContext Tests', () {
    late RhapsodyEvaluationContext context;

    setUp(() {
      context = RhapsodyEvaluationContext(
        variables: {'v:var1': 'value1', 'v:var2': 'value2'},
        constants: {'c:const1': 'constant1', 'c:const2': 'constant2'},
        parameters: {'p:param1': 'paramValue1', 'p:param2': 'paramValue2'},
        deviceVars: {'d:device1': 'deviceValue1', 'd:device2': 'deviceValue2'},
      );
    });

    test('Should return correct value for variable references', () {
      expect(context.getRefValue('v:var1'), equals('value1'));
      expect(context.getRefValue('v:var2'), equals('value2'));
    });

    test('Should return correct value for constant references', () {
      expect(context.getRefValue('c:const1'), equals('constant1'));
      expect(context.getRefValue('c:const2'), equals('constant2'));
    });

    test('Should return correct value for parameter references', () {
      expect(context.getRefValue('p:param1'), equals('paramValue1'));
      expect(context.getRefValue('p:param2'), equals('paramValue2'));
    });

    test('Should return correct value for device variable references', () {
      expect(context.getRefValue('d:device1'), equals('deviceValue1'));
      expect(context.getRefValue('d:device2'), equals('deviceValue2'));
    });

    test('Should return null for nonexistent references', () {
      expect(context.getRefValue('v:nonexistent'), isNull);
      expect(context.getRefValue('c:nonexistent'), isNull);
      expect(context.getRefValue('p:nonexistent'), isNull);
      expect(context.getRefValue('d:nonexistent'), isNull);
    });

    test('Should throw an exception for invalid prefixes', () {
      expect(() => context.getRefValue('x:invalid'), throwsA(isA<Exception>()));
      expect(() => context.getRefValue('invalid'), throwsA(isA<Exception>()));
    });

    test('Should handle an empty context without errors', () {
      final emptyContext = RhapsodyEvaluationContext(
        variables: {},
        constants: {},
        parameters: {},
        deviceVars: {},
      );

      expect(emptyContext.getRefValue('v:var1'), isNull);
      expect(() => emptyContext.getRefValue('x:invalid'),
          throwsA(isA<Exception>()));
    });
  });
}