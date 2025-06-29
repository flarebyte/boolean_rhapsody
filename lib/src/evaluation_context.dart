import 'model/data_store.dart';
import 'model/rule_state.dart';
import 'model/supported_prefixes.dart';

/// **Class: RhapsodyEvaluationContext**
///
/// Manages a collection of reference-value pairs within a DSL for boolean logic.
/// Provides support for retrieving values and enforcing prefix constraints.
class RhapsodyEvaluationContext {
  /// Map containing references and their associated string values.
  final KiwiWatermelonDataStore variables;

  late RhapsodyRuleState ruleState;

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
    ruleState = RhapsodyRuleState(states: variables);
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
    return variables.get(ref);
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

  void clearRuleState() {
    ruleState.clear();
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

  /// Updates the value of a reference in the evaluation context, applying a
  /// transformation if the reference already exists or setting a default value otherwise.
  ///
  /// The method ensures the `ref` value begins with a supported prefix before
  /// proceeding. If the reference (`ref`) is not present in the `variables` map,
  /// the `defaultValue` is assigned. Otherwise, the provided `transform` function
  /// is applied to the existing value.
  ///
  /// - Parameters:
  ///   - `ref`: The reference key to be updated. It must begin with a supported prefix.
  ///   - `transform`: A function that transforms the current value of the reference,
  ///      if it exists.
  ///   - `defaultValue`: The value to be assigned if the reference does not
  ///      currently exist in the `variables` map.
  ///
  /// - Returns:
  ///   This builder instance (`RhapsodyEvaluationContextBuilder`) to allow
  ///   method chaining.
  ///
  /// - Throws:
  ///   An exception if the `ref` does not start with a supported prefix.
  RhapsodyEvaluationContextBuilder transformRefValue(
      String ref, RhapsodyStringTransformer transform, String defaultValue) {
    supportedPrefixes
        .assertPrefix(ref); // Validates that the prefix is supported.
    final previous = variables[ref]; // Gets the current value of the reference.

    if (previous == null) {
      // If the reference does not exist, set the default value.
      variables[ref] = defaultValue;
    } else {
      // If the reference exists, apply the transform function.
      variables[ref] = transform(previous);
    }

    // Returns the current builder instance for method chaining.
    return this;
  }

  /// Builds and returns a `RhapsodyEvaluationContext` with the accumulated variables.
  ///
  /// **Returns:**
  /// - A new `RhapsodyEvaluationContext` instance.
  RhapsodyEvaluationContext build() {
    final store = RhapsodyDataStore();
    store.addAll(variables);
    return RhapsodyEvaluationContext(
      variables: store,
      prefixes: supportedPrefixes.prefixes,
    );
  }
}
