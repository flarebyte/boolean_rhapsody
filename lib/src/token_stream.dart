import 'semantic_exception.dart';
import 'token.dart';

/// A stream-based iterator for traversing a list of [RhapsodyToken]s
/// without modifying the original list.
///
/// This class helps maintain immutability by using an internal index
/// instead of removing tokens from the list.
class RhapsodyTokenStream {
  final List<RhapsodyToken> _tokens;
  int _index = 0;

  /// Creates a token stream from a list of tokens.
  RhapsodyTokenStream(this._tokens);

  /// Returns `true` if all tokens have been consumed.
  bool get isAtEnd => _index >= _tokens.length;

  /// Returns the current token without consuming it.
  ///
  /// Throws an exception if the stream is at the end.
  RhapsodyToken get current {
    if (isAtEnd) {
      throw SemanticException("Unexpected end of tokens.", _tokens.last);
    }
    return _tokens[_index];
  }

  /// Returns the remaining tokens from the current position.
  List<RhapsodyToken> get remainingTokens => _tokens.sublist(_index);

  /// Checks if the current token matches the given [value] by type.
  ///
  /// Returns `true` if the current token's type matches the given [value].
  bool matchType(String value) => !isAtEnd && _tokens[_index].type == value;

  /// Checks if the current token matches the given [value] by text.
  ///
  /// Returns `true` if the current token's text matches the given [value].
  bool matchText(String value) => !isAtEnd && _tokens[_index].text == value;

  /// Consumes and returns the current token, advancing the stream.
  ///
  /// Throws a [SemanticException] if there are no more tokens.
  RhapsodyToken consume() {
    if (isAtEnd) {
      throw SemanticException("Unexpected end of tokens.", _tokens.last);
    }
    return _tokens[_index++];
  }
}
