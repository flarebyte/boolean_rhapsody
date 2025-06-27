import 'package:boolean_rhapsody/boolean_rhapsody.dart';

void main() {
  final functionRegistry = BooleanRhapsodyFunctionRegistry();
  final RhapsodyAnalyserOptions analyserOptions = RhapsodyAnalyserOptions(
      prefixes: ['env', 'config'],
      functions: rhapsodyFunctionNames,
      variableValidator: (String variableName) {
        return RegExp(r'^[a-zA-Z][a-zA-Z0-9]*$').hasMatch(variableName);
      },
      functionRegistry: functionRegistry);

  final tokeniser = RhapsodyTokeniser();
  final RhapsodySemanticAnalyser analyser =
      RhapsodySemanticAnalyser(analyserOptions);
  final tokens = tokeniser.parse([
    'rule stop = string_equals(env:state, config:red) or is_present(env:alert);',
    'rule orange = string_equals(env:state, config:orange);'
  ].join(''));
  final analysis = analyser.analyse(tokens);
  final interpreter = RhapsodyInterpreter(analysis);

  RhapsodyEvaluationContext context = RhapsodyEvaluationContext(
      prefixes: ['env', 'config'],
      variables: {'env:state': 'green', 'env:alert': 'panic'});
  interpreter.interpret(context);
  print(context.ruleState.states);
  // {stop: RhapsodicBool{value: true, certain: true}, orange: RhapsodicBool{value: false, certain: false}}
}
