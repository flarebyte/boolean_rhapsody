import 'package:boolean_rhapsody/boolean_rhapsody.dart';
import 'package:boolean_rhapsody/src/function/rule_function.dart';
import 'package:test/test.dart';

class _DummyFunction extends BooleanRhapsodyFunction {
  @override
  RhapsodicBool isTrue(RhapsodyEvaluationContext context) =>
      RhapsodicBool.truth();
}

void main() {
  group('BooleanRhapsodyFunction.basicValidateParams', () {
    late _DummyFunction dummy;

    setUp(() {
      dummy = _DummyFunction();
    });

    test('throws when fewer than minSize', () {
      expect(
          () => dummy.basicValidateParams(
              refs: ['v:a'], minSize: 2, maxSize: 3, name: 'fn'),
          throwsA(isA<Exception>()));
    });

    test('throws when greater than maxSize', () {
      expect(
          () => dummy.basicValidateParams(
              refs: ['v:a', 'c:b', 'v:c', 'c:d'],
              minSize: 1,
              maxSize: 3,
              name: 'fn'),
          throwsA(isA<Exception>()));
    });

    test('throws when a ref is missing prefix separator', () {
      expect(
          () => dummy.basicValidateParams(
              refs: ['va', 'c:b'], minSize: 1, maxSize: 2, name: 'fn'),
          throwsA(isA<Exception>()));
    });

    test('does not throw when within bounds and refs have prefixes', () {
      expect(
          () => dummy.basicValidateParams(
              refs: ['v:a', 'c:b'], minSize: 1, maxSize: 2, name: 'fn'),
          returnsNormally);
    });

    test('boundary: exactly min and exactly max pass', () {
      expect(
          () => dummy.basicValidateParams(
              refs: ['v:a'], minSize: 1, maxSize: 3, name: 'fn'),
          returnsNormally);

      expect(
          () => dummy.basicValidateParams(
              refs: ['v:a', 'c:b', 'v:c'], minSize: 1, maxSize: 3, name: 'fn'),
          returnsNormally);
    });
  });
}
