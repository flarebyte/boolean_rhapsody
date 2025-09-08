import 'model/data_store.dart';
import 'model/rule_state.dart';
import 'model/supported_prefixes.dart';

/// Evaluation context used by the boolean rhapsody engine.
///
/// This is the runtime key/value lookup backing expression evaluation. Keys
/// must use a supported prefix scheme (e.g. `user:age`, `rule:foo`). The
/// context enforces prefixes and offers helpers to access values as common
/// types.
///
/// Practical guidance:
/// - Keep prefixes consistent across producers/consumers; treat them as part
///   of your public contract.
/// - Store booleans as the lowercase string `"true"`; anything else resolves
///   to `false` via `getRefValueAsBool`.
/// - For delimited lists, prefer comma separation and avoid empty segments;
///   values are trimmed on read.
/// - Consider providing a custom `RhapsodyBaseDataStore` when integrating with
///   existing caches or when you need observability.
/// - Call `clearRuleState()` between independent evaluations if you persist the
///   builder/context across runs.
class RhapsodyEvaluationContext {
  /// Key/value store for references and their associated string values.
  final RhapsodyBaseDataStore variables;

  late RhapsodyRuleState ruleState;

  /// Supported prefixes used to validate reference keys.
  late final RhapsodySupportedPrefixes supportedPrefixes;

  /// Create a new evaluation context.
  ///
  /// - `variables`: backing store implementation (in‑memory by default in the
  ///   builder; inject your own for integration/testing).
  /// - `prefixes`: allowed key prefixes (without the trailing colon).
  RhapsodyEvaluationContext({
    required this.variables,
    required List<String> prefixes,
  }) {
    supportedPrefixes = RhapsodySupportedPrefixes(prefixes);
    ruleState = RhapsodyRuleState(states: variables);
  }

  /// Get the raw string value for `ref` after prefix validation.
  ///
  /// Returns `null` if unset. Throws if `ref` does not start with any supported
  /// prefix (e.g. `user:`).
  String? getRefValue(String ref) {
    supportedPrefixes.assertPrefix(ref);
    return variables.get(ref);
  }

  /// Read `ref` as a boolean.
  ///
  /// Only the lowercase string `"true"` maps to `true`; any other value or a
  /// missing ref yields `defaultValue`.
  bool getRefValueAsBool(String? ref, bool defaultValue) {
    if (ref == null) {
      return defaultValue;
    }
    final value = getRefValue(ref);
    return value == 'true' ? true : defaultValue;
  }

  /// Read `ref` as a string, falling back to `defaultValue` when unset.
  String getRefValueAsString(String? ref, String defaultValue) {
    if (ref == null) {
      return defaultValue;
    }
    final value = getRefValue(ref);
    return value ?? defaultValue;
  }

  /// Read `ref` as a list of strings using `separator` (default `,`).
  ///
  /// Empty segments are trimmed; missing refs return `defaultValue` unchanged.
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

/// Builder for `RhapsodyEvaluationContext`.
///
/// Use when constructing contexts from multiple sources or when you want to
/// inject a custom `RhapsodyBaseDataStore`.
class RhapsodyEvaluationContextBuilder {
  /// Supported prefixes for validating reference keys.
  late final RhapsodySupportedPrefixes supportedPrefixes;

  /// Accumulator for reference values prior to build.
  final Map<String, String> variables = {};

  /// Backing key/value store used by the built context.
  late final RhapsodyBaseDataStore keyValueStore;

  /// Create a new builder with allowed `prefixes` and an optional store.
  RhapsodyEvaluationContextBuilder({
    required List<String> prefixes,
    RhapsodyBaseDataStore? store,
  }) {
    supportedPrefixes = RhapsodySupportedPrefixes(prefixes);
    keyValueStore = store ?? RhapsodyDataStore();
  }

  /// Set a reference value after validating its prefix.
  ///
  /// Returns this builder for chaining. Throws if `ref` prefix is unsupported.
  RhapsodyEvaluationContextBuilder setRefValue(String ref, String value) {
    supportedPrefixes.assertPrefix(ref);
    variables[ref] = value;
    return this;
  }

  /// Update a reference value by transformation or initialize it.
  ///
  /// If `ref` exists, applies `transform(previous)`; otherwise sets
  /// `defaultValue`. Throws if `ref` prefix is unsupported.
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

  /// Build the final `RhapsodyEvaluationContext`.
  RhapsodyEvaluationContext build() {
    keyValueStore.addAll(variables);
    return RhapsodyEvaluationContext(
      variables: keyValueStore,
      prefixes: supportedPrefixes.prefixes,
    );
  }
}
