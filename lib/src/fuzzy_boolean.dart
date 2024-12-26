class RhapsodicBool {
  final bool value;
  final bool certain;
  RhapsodicBool({required this.value, required this.certain});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RhapsodicBool &&
          runtimeType == other.runtimeType &&
          value == other.value &&
          certain == other.certain;

  @override
  int get hashCode => value.hashCode ^ certain.hashCode;

  @override
  String toString() {
    return 'RhapsodicBool{value: $value, certain: $certain}';
  }

  factory RhapsodicBool.truth() {
    return RhapsodicBool(value: true, certain: true);
  }
  factory RhapsodicBool.truthy() {
    return RhapsodicBool(value: true, certain: false);
  }
  factory RhapsodicBool.untruth() {
    return RhapsodicBool(value: false, certain: true);
  }
  factory RhapsodicBool.untruthy() {
    return RhapsodicBool(value: false, certain: false);
  }
  factory RhapsodicBool.fromBool(bool value) {
    return RhapsodicBool(value: value, certain: true);
  }

  bool isTrue() {
    return value && certain;
  }

  bool isFalse() {
    return !value && certain;
  }

  bool isTruthy() {
    return value && !certain;
  }

  bool isUntruthy() {
    return !value && !certain;
  }

  String toChar() {
    return certain ? (value ? 'T' : 'F') : (value ? 't' : 'f');
  }

  static asPairOfChars(RhapsodicBool a, RhapsodicBool b) {
    return "$a$b";
  }
}
