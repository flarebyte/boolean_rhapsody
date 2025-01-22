class RhapsodySupportedPrefixes {
  List<String> prefixes;
  RhapsodySupportedPrefixes(this.prefixes);

  bool isPrefixSupported(String ref) {
    return prefixes.any((prefix) => ref.startsWith("$prefix:"));
  }

  assertPrefix(String ref) {
    if (!isPrefixSupported(ref)) {
      final prefixesDisplay = prefixes.map((prefix) => "$prefix:").join(", ");
      throw Exception("The ref $ref should start with any of $prefixesDisplay");
    }
  }
}

/// **Class: RhapsodyEvaluationContext**
///
/// A class for managing evaluation contexts in a DSL for boolean logic.
/// Provides mechanisms to retrieve values for references categorized
/// as variables, constants, parameters, and device variables.
class RhapsodyEvaluationContext {
  /// A map containing variable references
  /// and their associated values.
  Map<String, String> variables;
  late RhapsodySupportedPrefixes supportedPrefixes;

  /// **Constructor:**
  ///
  /// Creates an instance of `RhapsodyEvaluationContext` with the specified maps.
  ///
  /// **Parameters:**
  /// - `variables` : A map of variable references and their values.
  /// - `prefixes` : todo
  RhapsodyEvaluationContext({
    required this.variables,
    required List<String> prefixes,
  }) {
    supportedPrefixes = RhapsodySupportedPrefixes(prefixes);
  }

  String? getRefValue(String ref) {
    supportedPrefixes.assertPrefix(ref);

    return variables[ref];
  }

  bool getRefValueAsBool(String? ref, bool defaultValue) {
    if (ref == null) {
      return defaultValue;
    }
    final value = getRefValue(ref);
    if (value == null) {
      return defaultValue;
    } else {
      return value == 'true';
    }
  }

  String getRefValueAsString(String? ref, String defaultValue) {
    if (ref == null) {
      return defaultValue;
    }
    final value = getRefValue(ref);
    if (value == null) {
      return defaultValue;
    } else {
      return value;
    }
  }

  List<String> getRefValueAsStringList(String? ref, List<String> defaultValue,
      [String separator = ',']) {
    if (ref == null) {
      return defaultValue;
    }
    final value = getRefValue(ref);
    if (value == null) {
      return defaultValue;
    } else {
      return value.split(separator).map((field) => field.trim()).toList();
    }
  }
}

class RhapsodyEvaluationContextBuilder {
  late RhapsodySupportedPrefixes supportedPrefixes;
  Map<String, String> variables = {};

  RhapsodyEvaluationContextBuilder({
    required List<String> prefixes,
  }) {
    supportedPrefixes = RhapsodySupportedPrefixes(prefixes);
  }

  RhapsodyEvaluationContextBuilder setRefValue(String ref, String value) {
    supportedPrefixes.assertPrefix(ref);

    variables[ref] = value;
    return this;
  }

  RhapsodyEvaluationContext build() {
    return RhapsodyEvaluationContext(
        variables: variables, prefixes: supportedPrefixes.prefixes);
  }
}
