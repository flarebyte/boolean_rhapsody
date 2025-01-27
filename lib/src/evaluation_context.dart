/// Represents a collection of supported prefixes for references.
/// Provides utilities to validate and assert the use of these prefixes.
class RhapsodySupportedPrefixes {
  /// List of supported prefixes.
  final List<String> prefixes;

  /// Constructs an instance of `RhapsodySupportedPrefixes` with the provided prefixes.
  RhapsodySupportedPrefixes(this.prefixes);

  /// Checks if the given reference starts with any of the supported prefixes.
  ///
  /// **Parameters:**
  /// - `ref`: The reference to validate.
  ///
  /// **Returns:**
  /// - `true` if the reference starts with any supported prefix; otherwise, `false`.
  bool isPrefixSupported(String ref) {
    return prefixes.any((prefix) => ref.startsWith("$prefix:"));
  }

  /// Ensures the given reference starts with a supported prefix.
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

/// **Class: RhapsodyEvaluationContext**
///
/// Manages a collection of reference-value pairs within a DSL for boolean logic.
/// Provides support for retrieving values and enforcing prefix constraints.
class RhapsodyEvaluationContext {
  /// Map containing references and their associated string values.
  final Map<String, String> variables;

  /// Validates and manages supported prefixes for references.
  late final RhapsodySupportedPrefixes supportedPrefixes;

  /// **Constructor:**
  ///
  /// Creates a new `RhapsodyEvaluationContext` instance.
  ///
  /// **Parameters:**
  /// - `variables`: A map of references and their associated values.
  /// - `prefixes`: A list of allowed prefixes for the references.
  RhapsodyEvaluationContext({
    required this.variables,
    required List<String> prefixes,
  }) {
    supportedPrefixes = RhapsodySupportedPrefixes(prefixes);
  }

  /// Retrieves the value associated with a reference if it has a supported prefix.
  ///
  /// **Parameters:**
  /// - `ref`: The reference to retrieve the value for.
  ///
  /// **Returns:**
  /// - The value corresponding to the reference, or `null` if not found.
  ///
  /// **Throws:**
  /// - `Exception` if the reference does not have a supported prefix.
  String? getRefValue(String ref) {
    supportedPrefixes.assertPrefix(ref);
    return variables[ref];
  }

  /// Retrieves the value of a reference as a boolean.
  ///
  /// **Parameters:**
  /// - `ref`: The reference to retrieve the value for.
  /// - `defaultValue`: The value to return if the reference is not found or invalid.
  ///
  /// **Returns:**
  /// - The boolean value of the reference, or `defaultValue` if not found.
  bool getRefValueAsBool(String? ref, bool defaultValue) {
    if (ref == null) {
      return defaultValue;
    }
    final value = getRefValue(ref);
    return value == 'true' ? true : defaultValue;
  }

  /// Retrieves the value of a reference as a string.
  ///
  /// **Parameters:**
  /// - `ref`: The reference to retrieve the value for.
  /// - `defaultValue`: The value to return if the reference is not found or invalid.
  ///
  /// **Returns:**
  /// - The string value of the reference, or `defaultValue` if not found.
  String getRefValueAsString(String? ref, String defaultValue) {
    if (ref == null) {
      return defaultValue;
    }
    final value = getRefValue(ref);
    return value ?? defaultValue;
  }

  /// Retrieves the value of a reference as a list of strings, split by a separator.
  ///
  /// **Parameters:**
  /// - `ref`: The reference to retrieve the value for.
  /// - `defaultValue`: The list to return if the reference is not found or invalid.
  /// - `separator`: The character used to split the reference value (default: `,`).
  ///
  /// **Returns:**
  /// - A list of strings derived from the reference value, or `defaultValue` if not found.
  List<String> getRefValueAsStringList(String? ref, List<String> defaultValue,
      [String separator = ',']) {
    if (ref == null) {
      return defaultValue;
    }
    final value = getRefValue(ref);
    return value?.split(separator).map((field) => field.trim()).toList() ??
        defaultValue;
  }
}

typedef RhapsodyStringTransformer = String Function(String);

/// **Class: RhapsodyEvaluationContextBuilder**
///
/// A builder class for creating `RhapsodyEvaluationContext` instances.
/// Enables incremental construction of the context's variables and enforces prefix constraints.
class RhapsodyEvaluationContextBuilder {
  /// Validates and manages supported prefixes for references.
  late final RhapsodySupportedPrefixes supportedPrefixes;

  /// Map for accumulating references and their associated string values.
  final Map<String, String> variables = {};

  /// **Constructor:**
  ///
  /// Creates a new `RhapsodyEvaluationContextBuilder` instance.
  ///
  /// **Parameters:**
  /// - `prefixes`: A list of allowed prefixes for the references.
  RhapsodyEvaluationContextBuilder({
    required List<String> prefixes,
  }) {
    supportedPrefixes = RhapsodySupportedPrefixes(prefixes);
  }

  /// Adds or updates a reference and its value in the builder.
  ///
  /// **Parameters:**
  /// - `ref`: The reference to add or update.
  /// - `value`: The value to associate with the reference.
  ///
  /// **Returns:**
  /// - The current builder instance, allowing for method chaining.
  ///
  /// **Throws:**
  /// - `Exception` if the reference does not have a supported prefix.
  RhapsodyEvaluationContextBuilder setRefValue(String ref, String value) {
    supportedPrefixes.assertPrefix(ref);
    variables[ref] = value;
    return this;
  }

  RhapsodyEvaluationContextBuilder transformRefValue(
      String ref, RhapsodyStringTransformer transform, String defaultValue) {
    supportedPrefixes.assertPrefix(ref);
    final previous = variables[ref];
    if (previous == null) {
      variables[ref] = defaultValue;
    } else {
      variables[ref] = transform(previous);
    }
    return this;
  }

  /// Builds and returns a `RhapsodyEvaluationContext` with the accumulated variables.
  ///
  /// **Returns:**
  /// - A new `RhapsodyEvaluationContext` instance.
  RhapsodyEvaluationContext build() {
    return RhapsodyEvaluationContext(
      variables: variables,
      prefixes: supportedPrefixes.prefixes,
    );
  }
}
