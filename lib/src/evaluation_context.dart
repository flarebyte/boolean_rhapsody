/// **Class: RhapsodyEvaluationContext**
///
/// A class for managing evaluation contexts in a DSL for boolean logic.
/// Provides mechanisms to retrieve values for references categorized
/// as variables, constants, parameters, and device variables.
class RhapsodyEvaluationContext {
  /// A map containing variable references (keys prefixed with `v:`)
  /// and their associated values.
  Map<String, String> variables;

  /// A map containing constant references (keys prefixed with `c:`)
  /// and their associated values.
  Map<String, String> constants;

  /// A map containing parameter references (keys prefixed with `p:`)
  /// and their associated values.
  Map<String, String> parameters;

  /// A map containing device variable references (keys prefixed with `d:`)
  /// and their associated values.
  Map<String, String> deviceVars;

  /// **Constructor:**
  ///
  /// Creates an instance of `RhapsodyEvaluationContext` with the specified maps.
  ///
  /// **Parameters:**
  /// - `variables` : A map of variable references and their values.
  /// - `constants` : A map of constant references and their values.
  /// - `parameters`: A map of parameter references and their values.
  /// - `deviceVars`: A map of device variable references and their values.
  RhapsodyEvaluationContext(
      {required this.variables,
      required this.constants,
      required this.parameters,
      required this.deviceVars});

  /// **Method: getRefValue**
  ///
  /// Retrieves the value corresponding to a given reference string (`ref`).
  ///
  /// **Parameters:**
  /// - `ref` : A reference string that must begin with one of the following prefixes:
  ///   - `v:` for variables
  ///   - `c:` for constants
  ///   - `p:` for parameters
  ///   - `d:` for device variables
  ///
  /// **Returns:**
  /// - The value associated with the given reference string, or `null`
  ///   if the reference does not exist in the corresponding map.
  ///
  /// **Throws:**
  /// - `Exception` : If the `ref` does not start with a valid prefix (`v:`, `c:`, `p:`, `d:`).
  String? getRefValue(String ref) {
    if (ref.startsWith('v:')) {
      return variables[ref];
    }
    if (ref.startsWith('c:')) {
      return constants[ref];
    }
    if (ref.startsWith('p:')) {
      return parameters[ref];
    }
    if (ref.startsWith('d:')) {
      return deviceVars[ref];
    }
    throw Exception("The ref $ref should start with v:, c:, p:, or d:");
  }
}
