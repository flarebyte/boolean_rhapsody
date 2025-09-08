import '../function/function_factory.dart';
import 'supported_prefixes.dart';

/// Options controlling parsing and validation of expressions.
///
/// Use to define which key prefixes are allowed, which function names are
/// recognized, and how variable names are validated. Variables must follow the
/// `<prefix>:<name>` convention where `prefix` is whitelisted and `name`
/// passes `variableValidator`.
///
/// Guidance:
/// - Keep `functions` consistent with the active function factory. Consider
///   sourcing them from `rhapsodyFunctionNames` plus your custom additions.
/// - `variableValidator` should be strict and cheap (regex or lookup); avoid
///   I/O here as it is used frequently during analysis.
/// - Prefix matching is case‑sensitive; settle on lowercase prefixes to avoid
///   surprises.
class RhapsodyAnalyserOptions {
  final List<String> prefixes;
  final List<String> functions;
  final BooleanRhapsodyFunctionRegistry functionRegistry;
  final bool Function(String) variableValidator;
  final RhapsodySupportedPrefixes _supportedPrefixes;
  final Set<String> _functionsSet;

  /// Create analyser options with allowed [prefixes], [functions], a
  /// [variableValidator], and a [functionRegistry].
  ///
  /// The [functions] list is converted to a set for fast lookups.
  RhapsodyAnalyserOptions({
    required this.prefixes,
    required this.functions,
    required this.variableValidator,
    required this.functionRegistry,
  })  : _supportedPrefixes = RhapsodySupportedPrefixes(prefixes),
        _functionsSet = functions.toSet();

  /// Check whether [text] is a valid variable reference.
  ///
  /// Requires a supported prefix and a non‑empty name that passes
  /// [variableValidator].
  bool isVariable(String text) {
    if (!_supportedPrefixes.isPrefixSupported(text)) return false;
    final int colonIndex = text.indexOf(':');
    final String variablePart = text.substring(colonIndex + 1);
    if (variablePart.isEmpty) return false;
    return variableValidator(variablePart);
  }

  /// Check whether [text] is a recognized function name (case‑sensitive).
  bool isFunction(String text) => _functionsSet.contains(text);
}
