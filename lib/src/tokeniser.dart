import 'token.dart';
import 'tokeniser_helper.dart';

/// Defines all supported token types for the Rhapsody language.
class TokenTypes {
  static const String identifier = 'identifier';
  static const String number = 'number';
  static const String operatorType = 'operator';
  static const String equal = 'equal';
  static const String lparen = 'lparen';
  static const String rparen = 'rparen';
  static const String comma = 'comma';
  static const String semicolon = 'semicolon';
  static const String colon = 'colon';
  static const String comment = 'comment';
  static const String unknown = 'unknown';
}

/// A lightweight tokeniser for Rhapsody rule expressions.
///
/// This class converts a source [code] string into a sequence of [RhapsodyToken]s,
/// preserving positional information for accurate error reporting and debugging.
/// It now captures line comments as tokens and uses constants for token types.
class RhapsodyTokeniser {
  /// This tokeniser processes a textual representation of the Rhapsody rule language,
  /// splitting the source code into a sequence of lexical tokens. It recognizes:
  ///   - Identifiers (including prefixed variables like "prefix:a")
  ///   - Numeric literals
  ///   - Logical operators ("and", "or", "not")
  ///   - Punctuation (parentheses, commas, colons, semicolons, etc.)
  ///   - Comments (lines starting with "#")
  ///
  /// For each token, the tokeniser records precise positional information (start/end indices,
  /// as well as line and column positions) to facilitate detailed error reporting and later analysis.
  ///
  /// The grammar supported includes function calls with arguments, grouped expressions using
  /// parentheses, and complete rule declarations (e.g., "rule 23 = (func1(prefix:a) or func2(b))
  /// and not rule42;"). This design focuses solely on lexical analysis, deferring semantic
  /// validation to subsequent stages.
  RhapsodyTokeniser();

  /// Parses the provided [code] into a list of [RhapsodyToken]s.
  List<RhapsodyToken> parse(String code) {
    final List<RhapsodyToken> tokens = [];
    int index = 0;
    int line = 0;
    int column = 0;

    while (index < code.length) {
      final String currentChar = code[index];

      // Skip whitespace while updating position.
      if (isWhitespace(currentChar)) {
        if (currentChar == '\n') {
          line++;
          column = 0;
        } else {
          column++;
        }
        index++;
        continue;
      }

      final int tokenStartIndex = index;
      final RhapsodyPosition startPosition =
          RhapsodyPosition(row: line, column: column);

      // Capture comments starting with '#'.
      if (currentChar == '#') {
        while (index < code.length && code[index] != '\n') {
          index++;
          column++;
        }
        final String tokenText = code.substring(tokenStartIndex, index);
        final RhapsodyPosition endPosition =
            RhapsodyPosition(row: line, column: column);
        tokens.add(RhapsodyToken(
          type: TokenTypes.comment,
          text: tokenText,
          startIndex: tokenStartIndex,
          endIndex: index,
          startPosition: startPosition,
          endPosition: endPosition,
        ));
        continue;
      }

      // Identify identifiers and keywords.
      if (isLetter(currentChar)) {
        while (index < code.length && isLetterOrDigitOr_(code[index])) {
          index++;
          column++;
        }
        final String tokenText = code.substring(tokenStartIndex, index);
        String tokenType = TokenTypes.identifier;
        if (tokenText == 'and' || tokenText == 'or' || tokenText == 'not') {
          tokenType = TokenTypes.operatorType;
        }
        final RhapsodyPosition endPosition =
            RhapsodyPosition(row: line, column: column);
        tokens.add(RhapsodyToken(
          type: tokenType,
          text: tokenText,
          startIndex: tokenStartIndex,
          endIndex: index,
          startPosition: startPosition,
          endPosition: endPosition,
        ));
        continue;
      }

      // Identify numeric literals.
      if (isDigit(currentChar)) {
        while (index < code.length && isDigit(code[index])) {
          index++;
          column++;
        }
        final String tokenText = code.substring(tokenStartIndex, index);
        final RhapsodyPosition endPosition =
            RhapsodyPosition(row: line, column: column);
        tokens.add(RhapsodyToken(
          type: TokenTypes.number,
          text: tokenText,
          startIndex: tokenStartIndex,
          endIndex: index,
          startPosition: startPosition,
          endPosition: endPosition,
        ));
        continue;
      }

      // Process single-character tokens.
      String tokenType;
      switch (currentChar) {
        case '=':
          tokenType = TokenTypes.equal;
          break;
        case '(':
          tokenType = TokenTypes.lparen;
          break;
        case ')':
          tokenType = TokenTypes.rparen;
          break;
        case ',':
          tokenType = TokenTypes.comma;
          break;
        case ';':
          tokenType = TokenTypes.semicolon;
          break;
        case ':':
          tokenType = TokenTypes.colon;
          break;
        default:
          tokenType = TokenTypes.unknown;
      }
      index++;
      column++;
      final String tokenText = code.substring(tokenStartIndex, index);
      final RhapsodyPosition endPosition =
          RhapsodyPosition(row: line, column: column);
      tokens.add(RhapsodyToken(
        type: tokenType,
        text: tokenText,
        startIndex: tokenStartIndex,
        endIndex: index,
        startPosition: startPosition,
        endPosition: endPosition,
        hasError: tokenType == TokenTypes.unknown,
      ));
    }

    return tokens;
  }

  /// Reconstructs the source code from a list of [tokens].
  String unparse(List<RhapsodyToken> tokens) {
    if (tokens.isEmpty) return '';
    final StringBuffer buffer = StringBuffer();
    for (int i = 0; i < tokens.length; i++) {
      if (i > 0 && needsSpace(tokens[i - 1], tokens[i])) {
        buffer.write(' ');
      }
      buffer.write(tokens[i].text);
    }
    return buffer.toString();
  }
}
