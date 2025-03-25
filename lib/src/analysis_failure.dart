import 'package:boolean_rhapsody/boolean_rhapsody.dart';

/// Represents a detailed report of a semantic analysis error detected in the grammar.
///
/// This class aggregates all pertinent information about an analysis failure,
/// facilitating precise error reporting, and offering guidance to the user for correction.
class RhapsodyAnalysisFailure {
  /// The exact source location (row, column) where the error was identified.
  ///
  /// This aids in mapping the error back to the corresponding location in the source code.
  final RhapsodyPosition position;

  /// The offset in the source text at which the error occurs.
  ///
  /// This index can be used to highlight the erroneous segment within the raw input.
  final int index;

  /// A categorization of the error.
  ///
  /// This value helps in identifying the nature of the problem and can be useful
  /// for filtering or grouping related issues.
  final String errorType;

  /// A human-readable explanation of the error.
  ///
  /// This message is intended to clarify the issue and assist users in understanding
  /// what went wrong during the analysis.
  final String message;

  /// A fragment of the source code that provides context for the error.
  ///
  /// Including the surrounding code helps in visualizing the problematic area,
  /// which can be crucial for debugging.
  final String contextCode;

  /// Describes the expected input or state that was not met.
  ///
  /// This information can help users quickly recognize the missing or incorrect component.
  final String expected;

  /// Offers advice on how to resolve or work around the error.
  ///
  /// Suggestions are geared towards providing practical next steps to correct the issue.
  final String suggestion;

  /// Creates an instance with all necessary diagnostic details.
  ///
  /// All fields are required to ensure that errors are reported with sufficient context,
  /// enabling effective troubleshooting.
  RhapsodyAnalysisFailure({
    required this.position,
    required this.index,
    required this.errorType,
    required this.message,
    required this.contextCode,
    required this.expected,
    required this.suggestion,
  });

  @override
  String toString() {
    return 'AnalysisFailure{position: $position, message: $message}';
  }
}
