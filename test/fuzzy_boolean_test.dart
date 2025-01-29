import 'package:boolean_rhapsody/boolean_rhapsody.dart';
import 'package:test/test.dart';

void main() {
  group('RhapsodicBool', () {
    test('Constructor initializes value and certainty correctly', () {
      final rb = RhapsodicBool(value: true, certain: false);
      expect(rb.value, isTrue);
      expect(rb.certain, isFalse);
    });

    test('Factory constructors create correct instances', () {
      expect(RhapsodicBool.truth(),
          equals(RhapsodicBool(value: true, certain: true)));
      expect(RhapsodicBool.truthy(),
          equals(RhapsodicBool(value: true, certain: false)));
      expect(RhapsodicBool.untruth(),
          equals(RhapsodicBool(value: false, certain: true)));
      expect(RhapsodicBool.untruthy(),
          equals(RhapsodicBool(value: false, certain: false)));
      expect(RhapsodicBool.fromBool(true),
          equals(RhapsodicBool(value: true, certain: true)));
      expect(RhapsodicBool.fromBool(false),
          equals(RhapsodicBool(value: false, certain: true)));
    });

    test('isTrue() returns correct values', () {
      expect(RhapsodicBool.truth().isTrue(), isTrue);
      expect(RhapsodicBool.truthy().isTrue(), isFalse);
      expect(RhapsodicBool.untruth().isTrue(), isFalse);
      expect(RhapsodicBool.untruthy().isTrue(), isFalse);
    });

    test('isFalse() returns correct values', () {
      expect(RhapsodicBool.untruth().isFalse(), isTrue);
      expect(RhapsodicBool.untruthy().isFalse(), isFalse);
      expect(RhapsodicBool.truth().isFalse(), isFalse);
      expect(RhapsodicBool.truthy().isFalse(), isFalse);
    });

    test('isTruthy() returns correct values', () {
      expect(RhapsodicBool.truthy().isTruthy(), isTrue);
      expect(RhapsodicBool.truth().isTruthy(), isFalse);
      expect(RhapsodicBool.untruth().isTruthy(), isFalse);
      expect(RhapsodicBool.untruthy().isTruthy(), isFalse);
    });

    test('isUntruthy() returns correct values', () {
      expect(RhapsodicBool.untruthy().isUntruthy(), isTrue);
      expect(RhapsodicBool.truth().isUntruthy(), isFalse);
      expect(RhapsodicBool.untruth().isUntruthy(), isFalse);
      expect(RhapsodicBool.truthy().isUntruthy(), isFalse);
    });

    test('toChar() returns correct representation', () {
      expect(RhapsodicBool.truth().toChar(), equals('T'));
      expect(RhapsodicBool.truthy().toChar(), equals('t'));
      expect(RhapsodicBool.untruth().toChar(), equals('F'));
      expect(RhapsodicBool.untruthy().toChar(), equals('f'));
    });

    test('asPairOfChars() returns correct string representation', () {
      expect(
        RhapsodicBool.asPairOfChars(
            RhapsodicBool.truth(), RhapsodicBool.untruthy()),
        equals('Tf'),
      );
      expect(
        RhapsodicBool.asPairOfChars(
            RhapsodicBool.truthy(), RhapsodicBool.untruth()),
        equals('tF'),
      );
      expect(
        RhapsodicBool.asPairOfChars(
            RhapsodicBool.untruth(), RhapsodicBool.untruthy()),
        equals('Ff'),
      );
    });

    test('Equality and hashCode work correctly', () {
      final rb1 = RhapsodicBool(value: true, certain: false);
      final rb2 = RhapsodicBool(value: true, certain: false);
      final rb3 = RhapsodicBool(value: false, certain: false);

      expect(rb1, equals(rb2)); // Same value and certainty
      expect(rb1.hashCode, equals(rb2.hashCode));
      expect(rb1, isNot(equals(rb3))); // Different value
    });

    test('toString() returns correct format', () {
      expect(
        RhapsodicBool.truth().toString(),
        equals('RhapsodicBool{value: true, certain: true}'),
      );
      expect(
        RhapsodicBool.untruthy().toString(),
        equals('RhapsodicBool{value: false, certain: false}'),
      );
    });
  });
}
