import 'package:boolean_rhapsody/boolean_rhapsody.dart';

void main() {
  // TODO ...wip..make sure it is configure and work
  final functionRegistry = BooleanRhapsodyFunctionRegistry();
  final RhapsodyAnalyserOptions analyserOptions = RhapsodyAnalyserOptions(
      prefixes: ['env', 'config'],
      functions: ['func1', 'func2', 'log', 'calc'],
      variableValidator: (String variableName) {
        // A valid variable name must start with a letter and may contain letters and digits.
        return RegExp(r'^[a-zA-Z][a-zA-Z0-9]*$').hasMatch(variableName);
      },
      functionRegistry: functionRegistry);

  final tokeniser = RhapsodyTokeniser();
  final RhapsodySemanticAnalyser analyser =
      RhapsodySemanticAnalyser(analyserOptions);
  final tokens = tokeniser.parse('func1(prefix:a)');
  final analysis = analyser.analyse(tokens);
  final interpreter = RhapsodyInterpreter(analysis);
  RhapsodyEvaluationContext context = RhapsodyEvaluationContext(
      prefixes: ['env', 'config'],
      variables: {'env:variable1': 'func1', 'env:variable4': 'func2'});
  interpreter.interpret(context);
}
