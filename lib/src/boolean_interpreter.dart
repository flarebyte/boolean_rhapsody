import 'evaluation_context.dart';
import 'semantic_analyser.dart';

/// Executes analysed rules against an evaluation context.
///
/// Uses the orchestrator from [RhapsodySemanticAnalysis] to determine a safe
/// evaluation order. `parallelEval` rules are independent and could be run in
/// parallel (currently evaluated sequentially to avoid overhead), while
/// `sequentialEval` respects dependencies.
///
/// Results are written to `context.ruleState` as `RhapsodicBool` values.
/// Ensure `analysis.isValid()` before constructing the interpreter.
class RhapsodyInterpreter {
  RhapsodySemanticAnalysis analysis;
  RhapsodyInterpreter(this.analysis) {
    if (!analysis.isValid()) {
      throw Exception('The boolean rhapsody script is not valid');
    }
  }

  interpret(RhapsodyEvaluationContext context) {
    final parallelEval = analysis.orchestrator?.parallelEval ?? [];
    final sequentialEval = analysis.orchestrator?.sequentialEval ?? [];

    // Independent rules; safe to parallelize if execution cost warrants it.
    for (var ruleName in parallelEval) {
      final expression = analysis.ruleDefinitions[ruleName]!.expression;
      final evaluated = expression.evaluate(context);
      context.ruleState.set(ruleName, evaluated);
    }
    // Dependent rules must be evaluated in order.
    for (var ruleName in sequentialEval) {
      final expression = analysis.ruleDefinitions[ruleName]!.expression;
      final evaluated = expression.evaluate(context);
      context.ruleState.set(ruleName, evaluated);
    }
  }
}
