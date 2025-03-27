import 'evaluation_context.dart';
import 'semantic_analyser.dart';

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

    // Could be done in parallel but will probably add overhead.
    for (var ruleName in parallelEval) {
      final expression = analysis.ruleDefinitions[ruleName]!.expression;
      final evaluated = expression.evaluate(context);
      context.ruleState.set(ruleName, evaluated);
    }
    // This have to done sequentially
    for (var ruleName in sequentialEval) {
      final expression = analysis.ruleDefinitions[ruleName]!.expression;
      final evaluated = expression.evaluate(context);
      context.ruleState.set(ruleName, evaluated);
    }
  }
}
