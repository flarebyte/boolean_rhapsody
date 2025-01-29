import 'package:boolean_rhapsody/boolean_rhapsody.dart';
import 'package:test/test.dart';

void main() {
  group('RhapsodyStringComparators', () {
    const String text = 'Hello, World!';
    const String termContained = 'World';
    const String termNotContained = 'Flutter';
    const String termStart = 'Hello';
    const String termEnd = 'World!';
    const String termExact = 'Hello, World!';
    const String differentCase = 'hello, world!';
    const String empty = '';

    test('contains should return true when text contains term', () {
      expect(RhapsodyStringComparators.contains.compare(text, termContained),
          isTrue);
    });

    test('contains should return false when text does not contain term', () {
      expect(RhapsodyStringComparators.contains.compare(text, termNotContained),
          isFalse);
    });

    test('contains should respect case sensitivity by default', () {
      expect(RhapsodyStringComparators.contains.compare(text, differentCase),
          isFalse);
    });

    test('contains should ignore case when ignoreCase is true', () {
      expect(
          RhapsodyStringComparators.contains.compare(text, differentCase, true),
          isTrue);
    });

    test('startsWith should return true when text starts with term', () {
      expect(RhapsodyStringComparators.startsWith.compare(text, termStart),
          isTrue);
    });

    test('startsWith should return false when text does not start with term',
        () {
      expect(RhapsodyStringComparators.startsWith.compare(text, termContained),
          isFalse);
    });

    test('startsWith should respect case sensitivity by default', () {
      expect(
          RhapsodyStringComparators.startsWith
              .compare(text, differentCase.split(',')[0]),
          isFalse);
    });

    test('startsWith should ignore case when ignoreCase is true', () {
      expect(
          RhapsodyStringComparators.startsWith
              .compare(text, differentCase.split(',')[0], true),
          isTrue);
    });

    test('endsWith should return true when text ends with term', () {
      expect(RhapsodyStringComparators.endsWith.compare(text, termEnd), isTrue);
    });

    test('endsWith should return false when text does not end with term', () {
      expect(RhapsodyStringComparators.endsWith.compare(text, termContained),
          isFalse);
    });

    test('endsWith should respect case sensitivity by default', () {
      expect(
          RhapsodyStringComparators.endsWith
              .compare(text, differentCase.split(' ')[1]),
          isFalse);
    });

    test('endsWith should ignore case when ignoreCase is true', () {
      expect(
          RhapsodyStringComparators.endsWith
              .compare(text, differentCase.split(' ')[1], true),
          isTrue);
    });

    test('equals should return true when text matches term exactly', () {
      expect(RhapsodyStringComparators.equals.compare(text, termExact), isTrue);
    });

    test('equals should return false when text does not match term exactly',
        () {
      expect(RhapsodyStringComparators.equals.compare(text, termContained),
          isFalse);
    });

    test('equals should respect case sensitivity by default', () {
      expect(RhapsodyStringComparators.equals.compare(text, differentCase),
          isFalse);
    });

    test('equals should ignore case when ignoreCase is true', () {
      expect(
          RhapsodyStringComparators.equals.compare(text, differentCase, true),
          isTrue);
    });

    test('comparators should handle empty strings correctly', () {
      expect(RhapsodyStringComparators.contains.compare(empty, termContained),
          isFalse);
      expect(RhapsodyStringComparators.startsWith.compare(empty, termStart),
          isFalse);
      expect(
          RhapsodyStringComparators.endsWith.compare(empty, termEnd), isFalse);
      expect(RhapsodyStringComparators.equals.compare(empty, ''), isTrue);
    });
  });
}
