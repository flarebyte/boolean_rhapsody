import 'model/token.dart';

/// Error raised during semantic analysis with token context.
///
/// Include a concise, actionable [message] and the offending [token]. Downstream
/// tooling can surface the token’s `startIndex`/positions for user‑friendly
/// diagnostics. Keep messages deterministic to simplify testing.
class SemanticException implements Exception {
  final String message;
  final RhapsodyToken token;
  SemanticException(this.message, this.token);

  @override
  String toString() =>
      "SemanticException: $message at token '${token.text}' and index ${token.startIndex}";
}
