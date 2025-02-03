import 'parser_options.dart';
import 'token.dart';

/// A lightweight tokeniser for Rhapsody rule expressions.
///
/// This class converts a source [code] string into a sequence of [RhapsodyToken]s,
/// preserving positional information for accurate error reporting and debugging.
///
/// The tokeniser supports:
/// - Line comments initiated by `#`.
/// - Logical operators: `or`, `and`, and `not`.
/// - Function calls with arguments, e.g. `func(a, b)`.
/// - Grouping via parentheses.
/// - Rule expressions like `rule 23 = (func1(a) or func2(b)) and not rule42;`.
class RhapsodyTokeniser {
  final RhapsodyParserOptions options;

  /// Creates an instance of [RhapsodyTokeniser] with the provided [options].
  ///
  /// **Insight:** The [options] control variable validation and function lookup;
  /// ensure they are correctly configured to match your language's rules.
  RhapsodyTokeniser(this.options);

  /// Parses the provided [code] into a list of [RhapsodyToken]s.
  ///
  /// The [code] is processed character-by-character. It skips over whitespace and
  /// comments, and creates tokens for identifiers, numbers, operators, and punctuation.
  /// Each token records its position, which is useful for later stages of parsing.
  List<RhapsodyToken> parse(String code) {
    final List<RhapsodyToken> tokens = [];
    int index = 0;
    int line = 0;
    int column = 0;

    while (index < code.length) {
      final String currentChar = code[index];

      // Skip whitespace.
      if (_isWhitespace(currentChar)) {
        if (currentChar == '\n') {
          line++;
          column = 0;
        } else {
          column++;
        }
        index++;
        continue;
      }

      // Skip line comments starting with '#'.
      if (currentChar == '#') {
        while (index < code.length && code[index] != '\n') {
          index++;
          column++;
        }
        continue;
      }

      final int tokenStartIndex = index;
      final RhapsodyPosition startPosition = RhapsodyPosition(row: line, column: column);

      // Identify identifiers and keywords.
      if (_isLetter(currentChar)) {
        while (index < code.length && _isLetterOrDigit(code[index])) {
          index++;
          column++;
        }
        final String tokenText = code.substring(tokenStartIndex, index);
        // Operators like 'and', 'or', and 'not' are treated specially.
        String tokenType = 'Identifier';
        if (tokenText == 'and' || tokenText == 'or' || tokenText == 'not') {
          tokenType = 'Operator';
        }
        final RhapsodyPosition endPosition = RhapsodyPosition(row: line, column: column);
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
      if (_isDigit(currentChar)) {
        while (index < code.length && _isDigit(code[index])) {
          index++;
          column++;
        }
        final String tokenText = code.substring(tokenStartIndex, index);
        final RhapsodyPosition endPosition = RhapsodyPosition(row: line, column: column);
        tokens.add(RhapsodyToken(
          type: 'Number',
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
          tokenType = 'Equal';
          break;
        case '(':
          tokenType = 'ParenOpen';
          break;
        case ')':
          tokenType = 'ParenClose';
          break;
        case ',':
          tokenType = 'Comma';
          break;
        case ';':
          tokenType = 'Semicolon';
          break;
        case ':':
          tokenType = 'Colon';
          break;
        default:
          tokenType = 'Unknown';
      }
      index++;
      column++;
      final String tokenText = code.substring(tokenStartIndex, index);
      final RhapsodyPosition endPosition = RhapsodyPosition(row: line, column: column);
      tokens.add(RhapsodyToken(
        type: tokenType,
        text: tokenText,
        startIndex: tokenStartIndex,
        endIndex: index,
        startPosition: startPosition,
        endPosition: endPosition,
        hasError: tokenType == 'Unknown',
      ));
    }

    return tokens;
  }

  /// Reconstructs the source code from a list of [tokens].
  ///
  /// **Tip:** This method heuristically reinserts spaces between tokens when needed,
  /// which may not perfectly match the original formatting.
  String unparse(List<RhapsodyToken> tokens) {
    if (tokens.isEmpty) return '';
    final StringBuffer buffer = StringBuffer();
    for (int i = 0; i < tokens.length; i++) {
      if (i > 0 && _needsSpace(tokens[i - 1], tokens[i])) {
        buffer.write(' ');
      }
      buffer.write(tokens[i].text);
    }
    return buffer.toString();
  }

  // --- Private helper methods ---

  bool _isWhitespace(String char) =>
      char == ' ' || char == '\t' || char == '\n' || char == '\r';

  bool _isLetter(String char) => RegExp(r'[a-zA-Z]').hasMatch(char);

  bool _isDigit(String char) => RegExp(r'[0-9]').hasMatch(char);

  bool _isLetterOrDigit(String char) => _isLetter(char) || _isDigit(char);

  bool _needsSpace(RhapsodyToken previous, RhapsodyToken current) {
    // Insert a space if both tokens are alphanumeric.
    return RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(previous.text) &&
        RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(current.text);
  }
}
