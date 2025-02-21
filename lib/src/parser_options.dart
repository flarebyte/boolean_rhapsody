import 'function_factory.dart';
import 'supported_prefixes.dart';

/// Provides parsing options for Rhapsodic expressions, including variable and function validation.
///
/// Variables are expected in the format `<prefix>:<variableName>`. The prefix must be one of the
/// supported prefixes, and the variable name is validated using the provided function.
class RhapsodyAnalyserOptions {
  final List<String> prefixes;
  final List<String> functions;
  final BooleanRhapsodyFunctionRegistry functionRegistry;
  final bool Function(String) variableValidator;
  final RhapsodySupportedPrefixes _supportedPrefixes;
  final Set<String> _functionsSet;

  /// Creates an instance of [RhapsodyAnalyserOptions] with the specified [prefixes],
  /// [functions], and a [variableValidator] function.
  ///
  /// The [prefixes] are used to determine valid variable identifiers. Each variable
  /// must be prefixed with one of these values followed by a colon (e.g. `myprefix:variable`).
  /// The [functions] list is converted into a set for efficient lookup.
  /// The [variableValidator] should validate the variable name (the part after `:`).
  RhapsodyAnalyserOptions({
    required this.prefixes,
    required this.functions,
    required this.variableValidator,
    required this.functionRegistry,
  })  : _supportedPrefixes = RhapsodySupportedPrefixes(prefixes),
        _functionsSet = functions.toSet();

  /// Determines whether the given [text] represents a valid variable.
  ///
  /// The [text] must be in the format `<prefix>:<variableName>`, where the prefix is validated
  /// using [RhapsodySupportedPrefixes]. If the prefix is valid, the variable name (after the colon)
  /// is validated using [variableValidator].
  bool isVariable(String text) {
    if (!_supportedPrefixes.isPrefixSupported(text)) return false;
    final int colonIndex = text.indexOf(':');
    final String variablePart = text.substring(colonIndex + 1);
    if (variablePart.isEmpty) return false;
    return variableValidator(variablePart);
  }

  /// Determines whether the given [text] is a recognized function.
  ///
  /// Function recognition is case-sensitive and relies on the predefined set of functions.
  bool isFunction(String text) => _functionsSet.contains(text);
}
