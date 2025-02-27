import '../boolean_rhapsody.dart';

/// Provides flyweight static methods for common token consumption and peeking
/// operations on [RhapsodyTokenStream].
///
/// This class centralizes logic for parsing token types and operator keywords
/// to ensure consistency and reduce duplication across the codebase.
///
/// All methods are static and stateless, making them suitable for reuse.
class RhapsodyTokenStreamFlyweight {
  /// Consumes and returns the current token if it is an `identifier`.
  ///
  /// Throws a [SemanticException] if the current token is not an identifier.
  static RhapsodyToken consumeIdentifier(RhapsodyTokenStream tokens,
      {String? contextual}) {
    return tokens.consumeAndValidate(TokenTypes.identifier,
        contextual: contextual);
  }

  /// Checks if the next token is a right parenthesis (`rparen`) without consuming it.
  ///
  /// Returns `true` if the next token is a right parenthesis; otherwise, `false`.
  static bool peekIsRightParenthesis(RhapsodyTokenStream tokens) {
    return tokens.peekMatchesType(TokenTypes.rparen);
  }

  static bool isRightParenthesis(RhapsodyTokenStream tokens) {
    return tokens.matchType(TokenTypes.rparen);
  }

  /// Consumes the next token if it is a right parenthesis (`rparen`).
  ///
  /// Throws a [SemanticException] if the next token is not a right parenthesis.
  static void consumeRightParenthesis(RhapsodyTokenStream tokens,
      {String? contextual}) {
    tokens.consumeAndValidate(TokenTypes.rparen, contextual: contextual);
  }

  /// Consumes the next token if it is a left parenthesis (`lparen`).
  ///
  /// Throws a [SemanticException] if the next token is not a left parenthesis.
  static void consumeLeftParenthesis(RhapsodyTokenStream tokens,
      {String? contextual}) {
    tokens.consumeAndValidate(TokenTypes.lparen, contextual: contextual);
  }

  /// Checks if the next token is a left parenthesis (`rparen`) without consuming it.
  ///
  /// Returns `true` if the next token is a left parenthesis; otherwise, `false`.
  static bool peekIsLeftParenthesis(RhapsodyTokenStream tokens) {
    return tokens.peekMatchesType(TokenTypes.lparen);
  }

  /// Checks if the next token is an `or` operator without consuming it.
  ///
  /// Returns `true` if the next token is the `or` operator; otherwise, `false`.
  static bool peekIsOrOperator(RhapsodyTokenStream tokens) {
    return tokens.peekMatchesType(TokenTypes.operatorType) &&
        tokens.peekMatchesText('or');
  }

  /// Consumes the next token if it is the `or` operator.
  ///
  /// Throws a [SemanticException] if the next token is not the `or` operator.
  static void consumeOrOperator(RhapsodyTokenStream tokens,
      {String? contextual}) {
    tokens.consumeAndValidate(TokenTypes.operatorType,
        text: 'or', contextual: contextual);
  }

  /// Checks if the next token is an `and` operator without consuming it.
  ///
  /// Returns `true` if the next token is the `and` operator; otherwise, `false`.
  static bool peekIsAndOperator(RhapsodyTokenStream tokens) {
    return tokens.peekMatchesType(TokenTypes.operatorType) &&
        tokens.peekMatchesText('and');
  }

  /// Consumes the next token if it is the `and` operator.
  ///
  /// Throws a [SemanticException] if the next token is not the `and` operator.
  static void consumeAndOperator(RhapsodyTokenStream tokens,
      {String? contextual}) {
    tokens.consumeAndValidate(TokenTypes.operatorType,
        text: 'and', contextual: contextual);
  }

  /// Checks if the next token is a `not` operator without consuming it.
  ///
  /// Returns `true` if the next token is the `not` operator; otherwise, `false`.
  static bool peekIsNotOperator(RhapsodyTokenStream tokens) {
    return tokens.peekMatchesType(TokenTypes.operatorType) &&
        tokens.peekMatchesText('not');
  }

  /// Consumes the next token if it is the `not` operator.
  ///
  /// Throws a [SemanticException] if the next token is not the `not` operator.
  static void consumeNotOperator(RhapsodyTokenStream tokens,
      {String? contextual}) {
    tokens.consumeAndValidate(TokenTypes.operatorType,
        text: 'not', contextual: contextual);
  }

  /// Checks if the next token is an equal sign (`equal`) without consuming it.
  ///
  /// Returns `true` if the next token is `equal`; otherwise, `false`.
  static bool peekIsEqual(RhapsodyTokenStream tokens) {
    return tokens.peekMatchesType(TokenTypes.equal);
  }

  /// Consumes the next token if it is an equal sign (`equal`).
  ///
  /// Throws a [SemanticException] if the next token is not `equal`.
  static void consumeEqual(RhapsodyTokenStream tokens, {String? contextual}) {
    tokens.consumeAndValidate(TokenTypes.equal, contextual: contextual);
  }

  /// Checks if the next token is a comma (`comma`) without consuming it.
  ///
  /// Returns `true` if the next token is a comma; otherwise, `false`.
  static bool peekIsComma(RhapsodyTokenStream tokens) {
    return tokens.peekMatchesType(TokenTypes.comma);
  }

  /// Consumes the next token if it is a comma (`comma`).
  ///
  /// Throws a [SemanticException] if the next token is not a comma.
  static void consumeComma(RhapsodyTokenStream tokens, {String? contextual}) {
    tokens.consumeAndValidate(TokenTypes.comma, contextual: contextual);
  }

  /// Checks if the next token is a semicolon (`semicolon`) without consuming it.
  ///
  /// Returns `true` if the next token is a semicolon; otherwise, `false`.
  static bool peekIsSemicolon(RhapsodyTokenStream tokens) {
    return tokens.peekMatchesType(TokenTypes.semicolon);
  }

  /// Consumes the next token if it is a semicolon (`semicolon`).
  ///
  /// Throws a [SemanticException] if the next token is not a semicolon.
  static void consumeSemicolon(RhapsodyTokenStream tokens,
      {String? contextual}) {
    tokens.consumeAndValidate(TokenTypes.semicolon, contextual: contextual);
  }

  /// Checks if the next token is a colon (`colon`) without consuming it.
  ///
  /// Returns `true` if the next token is a colon; otherwise, `false`.
  static bool peekIsColon(RhapsodyTokenStream tokens) {
    return tokens.peekMatchesType(TokenTypes.colon);
  }

  /// Consumes the next token if it is a colon (`colon`).
  ///
  /// Throws a [SemanticException] if the next token is not a colon.
  static void consumeColon(RhapsodyTokenStream tokens, {String? contextual}) {
    tokens.consumeAndValidate(TokenTypes.colon, contextual: contextual);
  }
}
