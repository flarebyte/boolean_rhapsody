import '../boolean_rhapsody.dart';

/// A stream-based iterator for traversing a list of [RhapsodyToken]s
/// without modifying the original list.
///
/// Maintains immutability by using an internal index for traversal
/// instead of removing or altering tokens. Supports lookahead, token
/// validation, and consumption operations.
class RhapsodyTokenStream {
  final List<RhapsodyToken> _tokens;
  int _index = 0;

  /// Creates a token stream from the provided list of [RhapsodyToken]s.
  ///
  /// The list is not modified during traversal.
  RhapsodyTokenStream(this._tokens);

  /// Indicates whether all tokens have been consumed.
  ///
  /// Returns `true` if the stream is positioned at or beyond the last token.
  bool get isAtEnd => _index >= _tokens.length;

  /// Checks if the stream would reach the end after skipping [lookahead] tokens.
  ///
  /// [lookahead]: The number of tokens to skip when checking for the end.
  /// Must be a non-negative integer.
  ///
  /// Returns `true` if skipping [lookahead] tokens would exceed the list bounds.
  bool isNextAtEnd({int lookahead = 1}) =>
      (_index + lookahead) >= _tokens.length;

  /// Retrieves the current token without advancing the stream.
  ///
  /// Throws a [SemanticException] if the stream is at the end.
  RhapsodyToken get current {
    if (isAtEnd) {
      throw SemanticException("Unexpected end of tokens.", _tokens.last);
    }
    return _tokens[_index];
  }

  /// Returns a list of all remaining tokens from the current position.
  ///
  /// The returned list is a view of the original token list and
  /// remains unchanged by further stream operations.
  List<RhapsodyToken> get remainingTokens => _tokens.sublist(_index);

  /// Checks if the current token’s [type] matches the specified [value].
  ///
  /// [value]: The type to compare with the current token's type.
  ///
  /// Returns `true` if the stream is not at the end and the token matches.
  bool matchType(String value) => !isAtEnd && _tokens[_index].type == value;

  /// Peeks ahead by [lookahead] tokens to check if the token's [type] matches [value].
  ///
  /// [lookahead]: Number of tokens to look ahead without consuming them.
  /// Defaults to 1. Must not exceed the bounds of the token list.
  ///
  /// Returns `true` if the lookahead token exists and matches the specified [type].
  bool peekMatchesType(String value, {int lookahead = 1}) =>
      !isNextAtEnd(lookahead: lookahead) &&
      _tokens[_index + lookahead].type == value;

  /// Checks if the current token’s [text] matches the specified [value].
  ///
  /// [value]: The text to compare with the current token's text.
  ///
  /// Returns `true` if the stream is not at the end and the token matches.
  bool matchText(String value) => !isAtEnd && _tokens[_index].text == value;

  /// Peeks ahead by [lookahead] tokens to check if the token's [text] matches [value].
  ///
  /// [lookahead]: Number of tokens to look ahead without consuming them.
  /// Defaults to 1. Must not exceed the bounds of the token list.
  ///
  /// Returns `true` if the lookahead token exists and matches the specified [text].
  bool peekMatchesText(String value, {int lookahead = 1}) =>
      !isNextAtEnd(lookahead: lookahead) &&
      _tokens[_index + lookahead].text == value;

  /// Consumes and returns the current token, advancing the stream position by one.
  ///
  /// Throws a [SemanticException] if no tokens remain to be consumed.
  ///
  /// Returns the consumed [RhapsodyToken].
  RhapsodyToken consume() {
    if (isAtEnd) {
      throw SemanticException("Unexpected end of tokens.", _tokens.last);
    }
    return _tokens[_index++];
  }

  String friendlyToken(String token) {
    switch (token) {
      case TokenTypes.lparen:
        return 'left parenthesis "("';
      case TokenTypes.rparen:
        return 'right parenthesis ")"';
      case TokenTypes.operatorType:
        return 'operator (or, and, not)';
      case TokenTypes.identifier:
        return 'identifier';
      case TokenTypes.number:
        return 'number';
      case TokenTypes.equal:
        return 'equal "="';
      case TokenTypes.comma:
        return 'comma ","';
      case TokenTypes.semicolon:
        return 'semicolon ";"';
      case TokenTypes.colon:
        return 'colon ":"';
      case TokenTypes.comment:
        return 'comment "# ..."';
      case TokenTypes.unknown:
        return 'unknown';
      default:
        return token;
    }
  }

  /// Consumes the current token and validates its [type] and optionally its [text]
  /// and [contextual] information.
  ///
  /// [type]: The expected type of the token. Throws [SemanticException] if it does not match.
  /// [text]: The expected text of the token. If provided, must match exactly,
  ///         or a [SemanticException] is thrown.
  ///
  /// Returns the consumed [RhapsodyToken] if all validations pass.
  ///
  /// Throws:
  /// - [SemanticException] if either the type or text does not match the expected values.
  RhapsodyToken consumeAndValidate(String type,
      {String? text, String? contextual}) {
    final token = consume();
    if (token.type != type) {
      final String message = [
        'Expected',
        friendlyToken(type),
        'but got',
        friendlyToken(token.type)
      ].join(' ');
      throw SemanticException(message, token);
    }
    if (text != null && token.text != text) {
      final String message =
          ['Expected', text, 'but got', token.text].join(' ');
      throw SemanticException(message, token);
    }
    return token;
  }
}
