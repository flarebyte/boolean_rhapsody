import 'package:boolean_rhapsody/boolean_rhapsody.dart';
import 'package:boolean_rhapsody/src/model/data_store.dart';
import 'package:test/test.dart';

void main() {
  group('RhapsodyEvaluationContextBuilder', () {
    late RhapsodyEvaluationContextBuilder builder;

    setUp(() {
      builder = RhapsodyEvaluationContextBuilder(prefixes: ['valid']);
    });

    test('should set default value when ref does not exist', () {
      builder.transformRefValue(
        'valid:example',
        (value) => value.toUpperCase(),
        'defaultValue',
      );

      expect(builder.variables['valid:example'], equals('defaultValue'));
    });

    test('should transform existing value when ref exists', () {
      builder.variables['valid:example'] = 'existingValue';

      builder.transformRefValue(
        'valid:example',
        (value) => value.toUpperCase(),
        'defaultValue',
      );

      expect(builder.variables['valid:example'], equals('EXISTINGVALUE'));
    });

    test('should throw an exception for unsupported prefixes', () {
      expect(
        () => builder.transformRefValue(
          'invalid:example',
          (value) => value.toUpperCase(),
          'defaultValue',
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('should not overwrite existing value if no transformation occurs', () {
      builder.variables['valid:example'] = 'unchanged';

      builder.transformRefValue(
        'valid:example',
        (value) => value, // Identity transformation
        'defaultValue',
      );

      expect(builder.variables['valid:example'], equals('unchanged'));
    });

    test('should handle empty defaultValue', () {
      builder.transformRefValue(
        'valid:example',
        (value) => value.toUpperCase(),
        '',
      );

      expect(builder.variables['valid:example'], equals(''));
    });
  });
  group('RhapsodyEvaluationContext Tests', () {
    late RhapsodyEvaluationContext context;

    setUp(() {
      context = RhapsodyEvaluationContextBuilder(prefixes: ["c", "v", "p", "d"])
          .setRefValue("v:var1", "value1")
          .setRefValue("v:var2", "value2")
          .setRefValue("c:const1", "constant1")
          .setRefValue("c:const2", "constant2")
          .setRefValue("p:param1", "paramValue1")
          .setRefValue("p:param2", "paramValue2")
          .build();
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
          variables: RhapsodyDataStore(), prefixes: ["v"]);

      expect(emptyContext.getRefValue('v:var1'), isNull);
      expect(() => emptyContext.getRefValue('x:invalid'),
          throwsA(isA<Exception>()));
    });
  });
  group('RhapsodySupportedPrefixes', () {
    late RhapsodySupportedPrefixes supportedPrefixes;

    setUp(() {
      supportedPrefixes = RhapsodySupportedPrefixes(['http', 'https', 'ftp']);
    });

    test('isPrefixSupported returns true for supported prefix', () {
      final result = supportedPrefixes.isPrefixSupported('http:example.com');
      expect(result, isTrue);
    });

    test('isPrefixSupported returns false for unsupported prefix', () {
      final result = supportedPrefixes.isPrefixSupported('mailto:example.com');
      expect(result, isFalse);
    });

    test('isPrefixSupported returns false for empty ref', () {
      final result = supportedPrefixes.isPrefixSupported('');
      expect(result, isFalse);
    });

    test('assertPrefix does not throw for supported prefix', () {
      expect(
        () => supportedPrefixes.assertPrefix('https:secure.com'),
        returnsNormally,
      );
    });

    test('assertPrefix throws exception for unsupported prefix', () {
      expect(
        () => supportedPrefixes.assertPrefix('mailto:example.com'),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('should start with any of'),
        )),
      );
    });

    test('assertPrefix throws exception for empty ref', () {
      expect(
        () => supportedPrefixes.assertPrefix(''),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('should start with any of'),
        )),
      );
    });

    test(
        'assertPrefix includes all supported prefixes in the exception message',
        () {
      expect(
        () => supportedPrefixes.assertPrefix('mailto:example.com'),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('http:, https:, ftp:'),
        )),
      );
    });

    test('isPrefixSupported is case-sensitive', () {
      final result = supportedPrefixes.isPrefixSupported('HTTP:example.com');
      expect(result, isFalse); // Prefixes are case-sensitive.
    });

    test('supports empty prefix list', () {
      final emptyPrefixes = RhapsodySupportedPrefixes([]);
      final result = emptyPrefixes.isPrefixSupported('http:example.com');
      expect(result, isFalse);
    });

    test('assertPrefix throws exception when no prefixes are supported', () {
      final emptyPrefixes = RhapsodySupportedPrefixes([]);
      expect(
        () => emptyPrefixes.assertPrefix('http:example.com'),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('should start with any of'),
        )),
      );
    });
  });
}
