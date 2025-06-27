/// Represents a boolean value with an additional certainty flag.
/// This allows distinguishing between definite (`certain: true`)
/// and uncertain (`certain: false`) truth values.
class RhapsodicBool {
  /// The boolean value (true or false).
  final bool value;

  /// Indicates whether the boolean value is certain (true) or uncertain (false).
  final bool certain;

  /// Creates a [RhapsodicBool] with the given [value] and [certain] flag.
  RhapsodicBool({required this.value, required this.certain});

  /// Returns `true` if both `value` and `certain` are equal to another [RhapsodicBool].
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RhapsodicBool &&
          runtimeType == other.runtimeType &&
          value == other.value &&
          certain == other.certain;

  /// Computes a hash code based on `value` and `certain`.
  @override
  int get hashCode => value.hashCode ^ certain.hashCode;

  /// Returns a string representation in the format:
  /// `RhapsodicBool{value: true, certain: false}`
  @override
  String toString() {
    return 'RhapsodicBool{value: $value, certain: $certain}';
  }

  /// Returns a `RhapsodicBool` representing definite truth (`true, certain`).
  factory RhapsodicBool.truth() {
    return RhapsodicBool(value: true, certain: true);
  }

  /// Returns a `RhapsodicBool` representing uncertain truth (`true, uncertain`).
  factory RhapsodicBool.truthy() {
    return RhapsodicBool(value: true, certain: false);
  }

  /// Returns a `RhapsodicBool` representing definite falsehood (`false, certain`).
  factory RhapsodicBool.untruth() {
    return RhapsodicBool(value: false, certain: true);
  }

  /// Returns a `RhapsodicBool` representing uncertain falsehood (`false, uncertain`).
  factory RhapsodicBool.untruthy() {
    return RhapsodicBool(value: false, certain: false);
  }

  /// Converts a standard [bool] into a `RhapsodicBool` with certainty (`certain: true`).
  factory RhapsodicBool.fromBool(bool value) {
    return RhapsodicBool(value: value, certain: true);
  }

  /// Returns `true` if the value is definitively `true` (`true, certain`).
  bool isTrue() {
    return value && certain;
  }

  /// Returns `true` if the value is definitively `false` (`false, certain`).
  bool isFalse() {
    return !value && certain;
  }

  /// Returns `true` if the value is uncertainly `true` (`true, uncertain`).
  bool isTruthy() {
    return value && !certain;
  }

  /// Returns `true` if the value is uncertainly `false` (`false, uncertain`).
  bool isUntruthy() {
    return !value && !certain;
  }

  /// Returns a single-character representation:
  /// - `'T'` for definite truth (`true, certain`)
  /// - `'F'` for definite falsehood (`false, certain`)
  /// - `'t'` for uncertain truth (`true, uncertain`)
  /// - `'f'` for uncertain falsehood (`false, uncertain`)
  String toChar() {
    return certain ? (value ? 'T' : 'F') : (value ? 't' : 'f');
  }

  /// Returns a two-character string representation of two `RhapsodicBool` values.
  /// Example:
  /// ```dart
  /// RhapsodicBool.asPairOfChars(RhapsodicBool.truth(), RhapsodicBool.untruthy()); // "Tf"
  /// ```
  static String asPairOfChars(RhapsodicBool a, RhapsodicBool b) {
    return "${a.toChar()}${b.toChar()}";
  }
}
