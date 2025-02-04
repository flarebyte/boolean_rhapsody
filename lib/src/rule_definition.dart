import 'rule_expession.dart';
import 'token.dart';

/// Models the semantic structure of a grammar rule for the analysis phase.
///
/// This class encapsulates not only the rule’s identifier and its dependency
/// relationships, but also the expression that defines when the rule applies.
/// It includes precise source locations (both as offsets and as positions)
/// to support accurate error reporting and debugging.
class RhapsodyRuleDefintition {
  /// The unique identifier used to reference the rule within the grammar.
  final String ruleName;

  /// Identifiers for other rules that must be processed before this one.
  ///
  /// These dependencies are key during semantic analysis to verify that
  /// prerequisites are met.
  final List<String> requiredRules;

  /// A logical condition that encapsulates the rule’s semantic constraints.
  ///
  /// This expression determines if the rule should trigger based on the
  /// current context during analysis.
  final RhapsodyBooleanExpression expression;

  /// The starting offset (in the raw source) where this rule is defined.
  ///
  /// Useful for correlating errors or warnings back to the source text.
  final int startIndex;

  /// The ending offset (in the raw source) for this rule definition.
  ///
  /// This, together with [startIndex], helps isolate the exact snippet
  /// responsible for a potential semantic issue.
  final int endIndex;

  /// The precise source position (line and column) where the definition starts.
  ///
  /// Enhances the granularity of diagnostics in tools that process the grammar.
  final RhapsodyPosition startPosition;

  /// The precise source position (line and column) where the definition ends.
  ///
  /// This positional information supports pinpointing issues in multi-line rules.
  final RhapsodyPosition endPosition;

  /// The verbatim text corresponding to the rule’s definition.
  ///
  /// Retaining the original text facilitates debugging and can be used for
  /// producing detailed error messages.
  final String text;

  /// Creates an instance by providing all semantic details for the rule.
  ///
  /// Every field is required to ensure that the analysis phase has access to
  /// complete information for dependency tracking and precise diagnostics.
  RhapsodyRuleDefintition({
    required this.ruleName,
    required this.requiredRules,
    required this.expression,
    required this.startIndex,
    required this.endIndex,
    required this.startPosition,
    required this.endPosition,
    required this.text,
  });
}
