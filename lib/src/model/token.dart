/// Zero‑based line/column position within the source.
class RhapsodyPosition {
  /// The row index (0-based) where the element is located.
  final int row;

  /// The column index (0-based) indicating the horizontal position.
  final int column;

  /// Create a position at [row]/[column] (both 0‑based).
  const RhapsodyPosition({
    required this.row,
    required this.column,
  });

  @override
  String toString() {
    return 'Position{row: $row, column: $column}';
  }
}

/// Lexical token produced by the Rhapsody tokeniser.
///
/// Types are defined in `TokenTypes` (identifier, number, operator, lparen,
/// rparen, comma, semicolon, colon, comment, unknown).
///
/// Invariants:
/// - `endIndex > startIndex`
/// - `text.length == endIndex - startIndex`
/// - positions are 0‑based and refer to the original code snapshot
class RhapsodyToken {
  /// Token category (see `TokenTypes`).
  final String type;

  /// Exact source slice for this token (no normalization).
  final String text;

  /// Start index in the source string.
  final int startIndex;

  /// Exclusive end index in the source string.
  final int endIndex;

  /// Starting position (line/column) of this token.
  final RhapsodyPosition startPosition;

  @override
  String toString() {
    return 'RhapsodyToken{type: $type, text: $text, startIndex: $startIndex, endIndex: $endIndex, startPosition: $startPosition, endPosition: $endPosition, hasError: $hasError}';
  }

  /// Ending position (line/column) of this token.
  final RhapsodyPosition endPosition;

  /// Whether tokenisation flagged this token as erroneous (e.g. `unknown`).
  final bool hasError;

  /// Construct a token. Leave [hasError] at default unless you explicitly
  /// want downstream stages to treat this token as suspicious.
  const RhapsodyToken({
    required this.type,
    required this.text,
    required this.startIndex,
    required this.endIndex,
    required this.startPosition,
    required this.endPosition,
    this.hasError = false,
  });
}
