import 'model/token.dart';
import 'token_stream.dart';
import 'tokeniser.dart';

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

  /// Checks if the current token is a right parenthesis (`rparen`).
  ///
  /// Returns `true` if the current token is a right parenthesis; otherwise, `false`.
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

// Checks if the current token is a left parenthesis (`lparen`).
  ///
  /// Returns `true` if the current token is a left parenthesis; otherwise, `false`.
  static bool isLeftParenthesis(RhapsodyTokenStream tokens) {
    return tokens.matchType(TokenTypes.lparen);
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

  /// Checks if the current token is the `or` operator.
  ///
  /// Returns `true` if the current token is the `or` operator; otherwise, `false`.
  static bool isOrOperator(RhapsodyTokenStream tokens) {
    return tokens.matchType(TokenTypes.operatorType) && tokens.matchText('or');
  }

  /// Checks if the current token is the `and` operator.
  ///
  /// Returns `true` if the current token is the `and` operator; otherwise, `false`.
  static bool isAndOperator(RhapsodyTokenStream tokens) {
    return tokens.matchType(TokenTypes.operatorType) && tokens.matchText('and');
  }

  /// Checks if the current token is the `not` operator.
  ///
  /// Returns `true` if the current token is the `not` operator; otherwise, `false`.
  static bool isNotOperator(RhapsodyTokenStream tokens) {
    return tokens.matchType(TokenTypes.operatorType) && tokens.matchText('not');
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

  /// Checks if the current token is an equal sign (`equal`).
  ///
  /// Returns `true` if the current token is `equal`; otherwise, `false`.
  static bool isEqual(RhapsodyTokenStream tokens) {
    return tokens.matchType(TokenTypes.equal);
  }

  /// Checks if the current token is a comma (`comma`).
  ///
  /// Returns `true` if the current token is a comma; otherwise, `false`.
  static bool isComma(RhapsodyTokenStream tokens) {
    return tokens.matchType(TokenTypes.comma);
  }

  /// Checks if the current token is a semicolon (`semicolon`).
  ///
  /// Returns `true` if the current token is a semicolon; otherwise, `false`.
  static bool isSemicolon(RhapsodyTokenStream tokens) {
    return tokens.matchType(TokenTypes.semicolon);
  }

  /// Checks if the current token is a colon (`colon`).
  ///
  /// Returns `true` if the current token is a colon; otherwise, `false`.
  static bool isColon(RhapsodyTokenStream tokens) {
    return tokens.matchType(TokenTypes.colon);
  }

  /// Checks if the current token is a function call.
  /// We are looking for an identifier followed by left parenthesis
  /// This break the LL(1) concept but we may get away with it
  /// Returns `true` if the current token a function call; otherwise, `false`.
  static bool isFunctionCall(RhapsodyTokenStream tokens) {
    return tokens.matchType(TokenTypes.identifier) &&
        tokens.peekMatchesType(TokenTypes.lparen);
  }
}
