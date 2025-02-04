import 'token.dart';

/// Thrown when the semantic analyser encounters an unexpected token.
class SemanticException implements Exception {
  final String message;
  final RhapsodyToken token;
  SemanticException(this.message, this.token);

  @override
  String toString() => "SemanticException: $message at token '${token.text}'";
}
