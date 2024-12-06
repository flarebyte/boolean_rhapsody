class RuleEvaluator {
  final Map<String, List<String>> _rules;
  late final List<String> orderOfEval;
  late final bool hasCycle;
  late final List<List<String>> cycles;

  RuleEvaluator(this._rules) {
    _initialize();
  }

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
    orderOfEval = hasCycle ? [] : resultStack.reversed.toList();
  }

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