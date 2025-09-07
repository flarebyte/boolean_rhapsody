import 'package:boolean_rhapsody/boolean_rhapsody.dart';
import 'package:boolean_rhapsody/src/function/rule_function.dart';
import 'package:test/test.dart';

class _TruthFn extends BooleanRhapsodyFunction {
  @override
  RhapsodicBool isTrue(RhapsodyEvaluationContext context) =>
      RhapsodicBool.truth();
}

class _CustomFactory extends BooleanRhapsodyFunctionBaseFactory {
  @override
  BooleanRhapsodyFunction create(String name, List<String> params) {
    if (name == 'always_true') return _TruthFn();
    throw Exception('Unsupported');
  }
}

void main() {
  group('Function factory registry', () {
    test('Registerable factory delegates to default implementation', () {
      final factory = BooleanRhapsodyFunctionRegisterableFactory();
      final fn = factory.create('is_present', ['v:x']);
      expect(fn, isNotNull);
    });

    test('Registry can swap factory at runtime', () {
      final registry = BooleanRhapsodyFunctionRegistry();

      // Default factory does not know custom name
      expect(() => registry.create('always_true', []), throwsA(isA<Exception>()));

      // After registering a custom factory the name is supported
      registry.registerFactory(_CustomFactory());
      final fn = registry.create('always_true', []);
      final ctx = RhapsodyEvaluationContextBuilder(prefixes: ['v', 'c']).build();
      expect(fn.isTrue(ctx), equals(RhapsodicBool.truth()));
    });
  });
}

