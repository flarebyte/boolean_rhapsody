/// Boolean with certainty used by the engine.
///
/// Encodes both the truth value and whether it is certain. This enables
/// propagation of uncertainty across logical operators:
/// - AND: a definite false dominates; any uncertainty yields an uncertain result
///   unless both sides are definitively true.
/// - OR: a definite true dominates; uncertainty remains unless both sides are
///   definitively false.
/// - NOT: flips truth while preserving certainty.
///
/// Storage/interchange:
/// - Use `toChar()`/`fromChar()` for compact persistence (see `rule_state`).
/// - Prefer `fromBool` when certainty is known at the source boundary.
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

  ///Return a RhapsodicBool from a char: T,F,t,t
  static RhapsodicBool fromChar(String value) {
    switch (value) {
      case "T":
        return RhapsodicBool.truth();
      case "F":
        return RhapsodicBool.untruth();
      case "t":
        return RhapsodicBool.truthy();
      case "f":
        return RhapsodicBool.untruthy();
      default:
        throw Exception("Invalid RhapsodicBool: [$value]");
    }
  }
}
