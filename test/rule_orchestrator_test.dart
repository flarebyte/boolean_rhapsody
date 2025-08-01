import 'package:boolean_rhapsody/src/rule_orchestrator.dart';
import 'package:test/test.dart';

void main() {
  group('BooleanRhapsodyRuleEvaluator', () {
    test('Evaluates simple linear dependencies correctly', () {
      final Map<String, List<String>> rules = {
        'A': ['B'],
        'B': ['C'],
        'C': [],
      };
      final evaluator = BooleanRhapsodyRuleOrchestrator(rules);

      expect(evaluator.hasCycle, isFalse);
      expect(evaluator.orderOfEval, equals(['C', 'B', 'A']));
      expect(evaluator.parallelEval, equals(['C']));
      expect(evaluator.sequentialEval, equals(['B', 'A']));
    });

    test('Handles complex dependencies with Greek gods with no cycle', () {
      final Map<String, List<String>> rules = {
        'Zeus': ['Hera', 'Poseidon'],
        'Hera': ['Apollo'],
        'Poseidon': ['Aphrodite'],
        'Apollo': ['Hermes'],
        'Aphrodite': [],
        'Hermes': [],
      };
      final evaluator = BooleanRhapsodyRuleOrchestrator(rules);

      expect(evaluator.hasCycle, isFalse);
      expect(
          evaluator.orderOfEval,
          equals(
              ['Hermes', 'Apollo', 'Hera', 'Aphrodite', 'Poseidon', 'Zeus']));
      expect(evaluator.parallelEval, containsAll(['Aphrodite', 'Hermes']));
    });

    test('Handles independent rules correctly', () {
      final Map<String, List<String>> rules = {
        'A': [],
        'B': [],
        'C': [],
      };
      final evaluator = BooleanRhapsodyRuleOrchestrator(rules);

      expect(evaluator.hasCycle, isFalse);
      expect(evaluator.orderOfEval, containsAllInOrder(['A', 'B', 'C']));
      expect(evaluator.parallelEval, containsAll(['A', 'B', 'C']));
      expect(evaluator.sequentialEval.isEmpty, true);
    });

    test('Detects a simple cycle', () {
      final Map<String, List<String>> rules = {
        'A': ['B'],
        'B': ['A'],
      };
      final evaluator = BooleanRhapsodyRuleOrchestrator(rules);

      expect(evaluator.hasCycle, isTrue);
      expect(evaluator.cycles, isNotEmpty);
      expect(evaluator.cycles.first, containsAllInOrder(['A', 'B', 'A']));
      expect(evaluator.parallelEval.isEmpty, true);
      expect(evaluator.sequentialEval.isEmpty, true);
    });

    test('Detects multiple independent cycles', () {
      final rules = {
        'A': ['B'],
        'B': ['A'],
        'C': ['D'],
        'D': ['C'],
      };
      final evaluator = BooleanRhapsodyRuleOrchestrator(rules);

      expect(evaluator.hasCycle, isTrue);
      expect(evaluator.cycles.length, equals(2));
      expect(evaluator.cycles[0], containsAllInOrder(['A', 'B', 'A']));
      expect(evaluator.cycles[1], containsAllInOrder(['C', 'D', 'C']));
      expect(evaluator.parallelEval.isEmpty, true);
      expect(evaluator.sequentialEval.isEmpty, true);
    });

    test('Handles a complex graph with cycles and independent nodes', () {
      final Map<String, List<String>> rules = {
        'A': ['B', 'C'],
        'B': ['D'],
        'C': ['D'],
        'D': [],
        'E': ['F'],
        'F': ['E'], // Cycle
        'G': ['H'],
        'H': [],
      };
      final evaluator = BooleanRhapsodyRuleOrchestrator(rules);

      expect(evaluator.hasCycle, isTrue);
      expect(evaluator.cycles.length, equals(1));
      expect(evaluator.cycles.first, containsAllInOrder(['E', 'F', 'E']));
      expect(evaluator.orderOfEval, []);
      expect(evaluator.parallelEval, containsAll(['D', 'H']));
      expect(evaluator.sequentialEval.isEmpty, true);
    });

    test('Handles an empty set of rules', () {
      final rules = <String, List<String>>{};
      final evaluator = BooleanRhapsodyRuleOrchestrator(rules);

      expect(evaluator.hasCycle, isFalse);
      expect(evaluator.orderOfEval, isEmpty);
      expect(evaluator.parallelEval.isEmpty, true);
    });

    test('Handles self-loop (single node cycle)', () {
      final Map<String, List<String>> rules = {
        'A': ['A'],
      };
      final evaluator = BooleanRhapsodyRuleOrchestrator(rules);

      expect(evaluator.hasCycle, isTrue);
      expect(evaluator.cycles, isNotEmpty);
      expect(evaluator.cycles.first, containsAllInOrder(['A', 'A']));
      expect(evaluator.parallelEval.isEmpty, true);
      expect(evaluator.sequentialEval.isEmpty, true);
    });
  });
}
