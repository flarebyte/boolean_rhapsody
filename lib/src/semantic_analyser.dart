import 'analysis_failure.dart';
import 'rule_definition.dart';
import 'token.dart';

/// Consolidates the result of the semantic analysis phase for a grammar.
///
/// This result distinguishes between a successful analysis—where a full set of rule
/// definitions is available—and a failure state that provides detailed diagnostic
/// information for error recovery or reporting.
class RhapsodySemanticAnalysisResult {
  /// When present, details the error that prevented successful analysis.
  ///
  /// A non-null value indicates that an error was encountered during the semantic
  /// analysis phase, signaling that the rule definitions may be incomplete or invalid.
  final RhapsodyAnalysisFailure? failure;

  /// A mapping of grammar rule names to their respective semantic definitions.
  ///
  /// This collection serves as the primary reference for downstream processes, such as
  /// code generation or further validation, once the analysis phase completes successfully.
  final Map<String, RhapsodyRuleDefintition> ruleDefinitions;

  /// Creates a result object that encapsulates either an analysis error or a valid set of rule definitions.
  ///
  /// The [ruleDefinitions] map must be provided to ensure that all semantic constructs are accessible,
  /// regardless of whether an error was detected.
  RhapsodySemanticAnalysisResult({
    this.failure,
    required this.ruleDefinitions,
  });
}


class RhapsodySemanticAnalyser {
  RhapsodySemanticAnalysisResult analyse(List<RhapsodyToken> tokens);
}







