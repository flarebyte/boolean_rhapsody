import 'package:boolean_rhapsody/boolean_rhapsody.dart';
import 'package:boolean_rhapsody/src/tokeniser_helper.dart';
import 'package:test/test.dart';

void main() {
  group('isWhitespace', () {
    test('returns true for space, tab, newline, and carriage return', () {
      expect(isWhitespace(' '), isTrue);
      expect(isWhitespace('\t'), isTrue);
      expect(isWhitespace('\n'), isTrue);
      expect(isWhitespace('\r'), isTrue);
    });

    test('returns false for non-whitespace characters', () {
      expect(isWhitespace('a'), isFalse);
      expect(isWhitespace('1'), isFalse);
      expect(isWhitespace(','), isFalse);
    });
  });

  group('isLetter', () {
    test('returns true for letters', () {
      expect(isLetter('a'), isTrue);
      expect(isLetter('Z'), isTrue);
    });

    test('returns false for non-letter characters', () {
      expect(isLetter('1'), isFalse);
      expect(isLetter(' '), isFalse);
      expect(isLetter('?'), isFalse);
    });
  });

  group('isDigit', () {
    test('returns true for digit characters', () {
      expect(isDigit('0'), isTrue);
      expect(isDigit('9'), isTrue);
    });

    test('returns false for non-digit characters', () {
      expect(isDigit('a'), isFalse);
      expect(isDigit(' '), isFalse);
      expect(isDigit('!'), isFalse);
    });
  });

  group('isLetterOrDigitOr_', () {
    test('returns true for letters and digits', () {
      expect(isLetterOrDigitOr_('a'), isTrue);
      expect(isLetterOrDigitOr_('Z'), isTrue);
      expect(isLetterOrDigitOr_('0'), isTrue);
      expect(isLetterOrDigitOr_('9'), isTrue);
      expect(isLetterOrDigitOr_('_'), isTrue);
    });

    test('returns false for non-alphanumeric characters', () {
      expect(isLetterOrDigitOr_(' '), isFalse);
      expect(isLetterOrDigitOr_('@'), isFalse);
      expect(isLetterOrDigitOr_(','), isFalse);
    });
  });

  group('needsSpace', () {
    // Create some dummy tokens with minimal positional info.
    final tokenHello = RhapsodyToken(
      type: TokenTypes.identifier,
      text: 'hello',
      startIndex: 0,
      endIndex: 5,
      startPosition: RhapsodyPosition(row: 0, column: 0),
      endPosition: RhapsodyPosition(row: 0, column: 5),
    );

    final tokenWorld = RhapsodyToken(
      type: TokenTypes.identifier,
      text: 'world',
      startIndex: 6,
      endIndex: 11,
      startPosition: RhapsodyPosition(row: 0, column: 6),
      endPosition: RhapsodyPosition(row: 0, column: 11),
    );

    final tokenComma = RhapsodyToken(
      type: TokenTypes.comma,
      text: ',',
      startIndex: 5,
      endIndex: 6,
      startPosition: RhapsodyPosition(row: 0, column: 5),
      endPosition: RhapsodyPosition(row: 0, column: 6),
    );

    final tokenUnderscore = RhapsodyToken(
      type: TokenTypes.identifier,
      text: 'foo_bar',
      startIndex: 12,
      endIndex: 19,
      startPosition: RhapsodyPosition(row: 0, column: 12),
      endPosition: RhapsodyPosition(row: 0, column: 19),
    );

    test('returns true when both tokens are alphanumeric', () {
      expect(needsSpace(tokenHello, tokenWorld), isTrue);
      expect(needsSpace(tokenHello, tokenUnderscore), isTrue);
    });

    test('returns false when one token is not alphanumeric', () {
      expect(needsSpace(tokenHello, tokenComma), isFalse);
      expect(needsSpace(tokenComma, tokenWorld), isFalse);
    });
  });
}
