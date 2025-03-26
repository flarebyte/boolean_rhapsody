/// A class to evaluate the order of rule evaluation using Depth-First Search (DFS)
/// with post-order traversal. This helps resolve the ordering of rules based on
/// their dependencies and detect if there are any cycles among the rules.
///
/// The algorithm works by performing a DFS on the dependency graph of the rules.
/// It tracks visited nodes, maintains an "on stack" state for cycle detection, and
/// uses post-order traversal to produce the order of evaluation.
class BooleanRhapsodyRuleOrchestrator {
  /// A map representing the rules and their dependencies.
  /// Each key represents a rule, and its associated value is a list of rules that it depends on.
  final Map<String, List<String>> _rules;

  /// The post-order traversal result representing the order of rule evaluation.
  /// This is the order in which rules should be evaluated, respecting their dependencies.
  late final List<String> orderOfEval;

  /// The post-order traversal result representing the rules that have to be evaluated first
  /// in parallel
  late final List<String> parallelEval;

  /// The post-order traversal result representing the rules that have to be evaluated second
  /// in sequential order
  late final List<String> sequentialEval;

  /// Indicates whether the dependency graph contains cycles.
  /// If `true`, it means there are cyclic dependencies among the rules.
  late final bool hasCycle;

  /// A list of detected cycles in the dependency graph.
  /// Each element is a list of rules that form a cycle.
  late final List<List<String>> cycles;

  /// Constructs a RuleEvaluator with the given rules and initializes the evaluation.
  ///
  /// The [rules] parameter is a map where each key represents a rule, and the value
  /// is a list of rules that the key rule depends on.
  BooleanRhapsodyRuleOrchestrator(this._rules) {
    _initialize();
  }

  /// Initializes the evaluator by performing a DFS on each rule to determine
  /// the order of evaluation and detect cycles.
  void _initialize() {
    final visited = <String, bool>{};
    final onStack = <String, bool>{};
    final resultStack = <String>[];
    final detectedCycles = <List<String>>[];

    for (var rule in _rules.keys) {
      if (!visited.containsKey(rule)) {
        _dfs(rule, visited, onStack, resultStack, detectedCycles);
      }
    }

    hasCycle = detectedCycles.isNotEmpty;
    cycles = detectedCycles;
    orderOfEval = hasCycle ? [] : resultStack.toList();
    parallelEval = _rules.entries
        .toList()
        .where((rule) => rule.value.isEmpty)
        .map((rule) => rule.key)
        .toList();
    final parallelEvalSet = parallelEval.toSet();
    sequentialEval = orderOfEval
        .where((ruleName) => !parallelEvalSet.contains(ruleName))
        .toList();
  }

  /// Performs Depth-First Search (DFS) on the given [rule].
  ///
  /// During traversal, it marks nodes as visited and tracks those currently
  /// on the stack to detect cycles. When a node is fully processed, it is added
  /// to the [resultStack] to determine the post-order evaluation order.
  void _dfs(
    String rule,
    Map<String, bool> visited,
    Map<String, bool> onStack,
    List<String> resultStack,
    List<List<String>> detectedCycles,
  ) {
    visited[rule] = true;
    onStack[rule] = true;

    for (var dependency in _rules[rule] ?? []) {
      if (!visited.containsKey(dependency)) {
        _dfs(dependency, visited, onStack, resultStack, detectedCycles);
      } else if (onStack[dependency] == true) {
        _recordCycle(dependency, rule, onStack, detectedCycles);
      }
    }

    onStack[rule] = false;
    resultStack.add(rule);
  }

  /// Records a detected cycle starting from the [start] node.
  ///
  /// This method constructs the cycle by iterating through the [onStack] nodes
  /// and adds it to the [detectedCycles] list.
  void _recordCycle(
    String start,
    String current,
    Map<String, bool> onStack,
    List<List<String>> detectedCycles,
  ) {
    final cycle = <String>[];
    var found = false;

    for (var key in onStack.keys) {
      if (onStack[key]!) {
        if (key == start) found = true;
        if (found) cycle.add(key);
      }
    }

    cycle.add(start); // Close the cycle
    detectedCycles.add(cycle);
  }
}
