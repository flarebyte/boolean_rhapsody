import 'token.dart';

/// Returns `true` if [char] is a whitespace character.
bool isWhitespace(String char) =>
    char == ' ' || char == '\t' || char == '\n' || char == '\r';

/// Returns `true` if [char] is the underscore character.
bool isUnderscore(String char) => char == '_';

/// Returns `true` if [char] is an alphabetic letter.
bool isLetter(String char) => RegExp(r'[a-zA-Z]').hasMatch(char);

/// Returns `true` if [char] is a digit.
bool isDigit(String char) => RegExp(r'[0-9]').hasMatch(char);

/// Returns `true` if [char] is a letter or a digit.
bool isLetterOrDigitOr_(String char) =>
    isLetter(char) || isDigit(char) || isUnderscore(char);

/// Determines whether a space should be inserted between two tokens.
///
/// Inserts a space if both tokens consist solely of alphanumeric characters.
bool needsSpace(RhapsodyToken previous, RhapsodyToken current) {
  return RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(previous.text) &&
      RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(current.text);
}
