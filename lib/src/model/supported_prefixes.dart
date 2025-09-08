/// Whitelist of allowed reference prefixes.
///
/// Prefixes should not include the trailing colon when passed in (e.g. `user`,
/// not `user:`). Validation checks for `"<prefix>:"` at the start of a ref.
///
/// Tips:
/// - Avoid overlapping prefixes (`u` and `user`) to reduce ambiguity.
/// - Keep the list small and stable; it is consulted frequently during parse
///   and evaluation.
class RhapsodySupportedPrefixes {
  /// List of supported prefixes.
  final List<String> prefixes;

  /// Constructs an instance of `RhapsodySupportedPrefixes` with the provided prefixes.
  RhapsodySupportedPrefixes(this.prefixes);

  /// Return whether [ref] starts with any supported prefix.
  ///
  /// **Parameters:**
  /// - `ref`: The reference to validate.
  ///
  /// **Returns:**
  /// - `true` if the reference starts with any supported prefix; otherwise, `false`.
  bool isPrefixSupported(String ref) {
    return prefixes.any((prefix) => ref.startsWith("$prefix:"));
  }

  /// Assert that [ref] starts with a supported prefix; throws otherwise.
  ///
  /// **Parameters:**
  /// - `ref`: The reference to validate.
  ///
  /// **Throws:**
  /// - `Exception` if the reference does not start with a supported prefix.
  void assertPrefix(String ref) {
    if (!isPrefixSupported(ref)) {
      final prefixesDisplay = prefixes.map((prefix) => "$prefix:").join(", ");
      throw Exception("The ref $ref should start with any of $prefixesDisplay");
    }
  }
}
