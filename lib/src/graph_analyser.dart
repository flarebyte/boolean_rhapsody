import 'analysis_failure.dart';
import 'rule_orchestrator.dart';
import 'semantic_analyser.dart';
import 'token.dart';

class RhapsodyGraphAnalysisResult {
  RhapsodyAnalysisFailure? failure;
  List<String> parallelEval;
  List<String> sequentialEval;
  RhapsodyGraphAnalysisResult(
      {required this.parallelEval,
      required this.sequentialEval,
      required this.failure});
}

class RhapsodyGraphAnalyser {
  RhapsodyGraphAnalysisResult analyse(RhapsodySemanticAnalysisResult result) {
    if (result.failure != null) {
      return RhapsodyGraphAnalysisResult(
          failure: result.failure, parallelEval: [], sequentialEval: []);
    }
    Map<String, List<String>> rules = {};
    result.ruleDefinitions.forEach((ruleName, ruleDef) {
      final requiredRules = ruleDef.requiredRules.toList();
      requiredRules.sort();
      rules[ruleName] = requiredRules;
    });

    BooleanRhapsodyRuleOrchestrator orchestrator =
        BooleanRhapsodyRuleOrchestrator(rules);
    if (orchestrator.hasCycle) {
      final cycles = orchestrator.cycles.join(' ');
      final message = "There are cycles with rules in $cycles";
      final failure = RhapsodyAnalysisFailure(
          contextCode: "",
          position: RhapsodyPosition(row: 0, column: 0),
          index: 1,
          errorType: 'Rule Cycle Error',
          message: message,
          expected: '',
          suggestion: 'Check for cycles');
      return RhapsodyGraphAnalysisResult(
          failure: failure, parallelEval: [], sequentialEval: []);
    } else {
      return RhapsodyGraphAnalysisResult(
          failure: null,
          parallelEval: orchestrator.parallelEval,
          sequentialEval: orchestrator.sequentialEval);
    }
  }
}
