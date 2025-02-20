/// Represents a specific location in a two-dimensional coordinate system.
///
/// Use this class when you need to track positions in a multi-line source,
/// keeping in mind that both [row] and [column] are zero-based.
class RhapsodyPosition {
  /// The row index (0-based) where the element is located.
  final int row;

  /// The column index (0-based) indicating the horizontal position.
  final int column;

  /// Creates a [RhapsodyPosition] with a given [row] and [column].
  ///
  /// **Hint:** Ensure that your row and column values follow 0-based indexing
  /// to maintain consistency with common programming practices.
  const RhapsodyPosition({
    required this.row,
    required this.column,
  });
}

/// Encapsulates the details of a token extracted from source code.
///
/// This class is designed to support precise source mapping and error handling.
/// When constructing a [RhapsodyToken], ensure that the start/end indices
/// and positions accurately reflect the token's boundaries in the source.
class RhapsodyToken {
  /// The semantic category of this token.
  ///
  /// **Guidance:** This value should align with the token types defined in
  /// your language's specification. Use consistent naming to aid in parsing.
  final String type;

  /// The exact text as it appears in the source code.
  ///
  /// **Note:** This field preserves all characters, including whitespace,
  /// to ensure an accurate representation of the original input.
  final String text;

  /// The starting index in the source string where this token begins.
  ///
  /// **Tip:** Use this index for generating precise error messages or for
  /// mapping tokens back to the source text.
  final int startIndex;

  /// The index immediately after the token in the source string.
  ///
  /// **Usage:** Subtract [startIndex] from [endIndex] to obtain the token's length.
  final int endIndex;

  /// The starting position (line and column) of this token.
  ///
  /// **Insight:** This helps in scenarios where the source spans multiple lines,
  /// enabling detailed position tracking.
  final RhapsodyPosition startPosition;

  @override
  String toString() {
    return 'RhapsodyToken{type: $type, text: $text, startIndex: $startIndex, endIndex: $endIndex, startPosition: $startPosition, endPosition: $endPosition, hasError: $hasError}';
  }

  /// The ending position (line and column) of this token.
  ///
  /// **Advice:** Ensure that [endPosition] correctly represents the token's
  /// final character to facilitate accurate highlighting in editors.
  final RhapsodyPosition endPosition;

  /// Indicates if an error was encountered during tokenization.
  ///
  /// **Recommendation:** Utilize this flag for error recovery and debugging;
  /// a value of `true` signals that the token may not conform to expected standards.
  final bool hasError;

  /// Constructs a [RhapsodyToken] with all necessary properties.
  ///
  /// All fields are required except [hasError], which defaults to `false`.
  /// Ensure that the positional information ([startIndex], [endIndex],
  /// [startPosition], and [endPosition]) are in sync for reliable source mapping.
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
