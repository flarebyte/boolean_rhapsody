import 'package:boolean_rhapsody/boolean_rhapsody.dart';

void main() {
  // Instantiate function registry containing boolean functions like string_equals
  final functionRegistry = BooleanRhapsodyFunctionRegistry();

// Configure semantic analyser options
  final RhapsodyAnalyserOptions analyserOptions = RhapsodyAnalyserOptions(
    prefixes: ['env', 'config'], // Allowed variable prefixes
    functions: rhapsodyFunctionNames, // List of allowed function names
    variableValidator: (String variableName) {
      // Validate variable naming: must start with letter, then alphanumerics
      return RegExp(r'^[a-zA-Z][a-zA-Z0-9_:]*$').hasMatch(variableName);
    },
    functionRegistry: functionRegistry, // Attach function registry
  );

// Create tokeniser and parse input rule strings into tokens
  final tokeniser = RhapsodyTokeniser();
  final tokens = tokeniser.parse([
    'rule stop = string_equals(env:state, config:color:red) or is_present(env:alert);',
    'rule orange = string_equals(env:state, config:color:orange);'
  ].join(''));

// Create analyser and perform semantic analysis on tokens
  final RhapsodySemanticAnalyser analyser =
      RhapsodySemanticAnalyser(analyserOptions);
  final analysis = analyser.analyse(tokens);

// Interpret analysed rules
  final interpreter = RhapsodyInterpreter(analysis);

// Define context with variable values at runtime
  RhapsodyEvaluationContextBuilder builder =
      RhapsodyEvaluationContextBuilder(prefixes: ['env', 'config']);
  builder.setRefValue('config:color:red', 'red');
  builder.setRefValue('config:color:orange', 'orange');
  builder.setRefValue('env:state', 'green');
  builder.setRefValue('env:alert', 'panic');

  RhapsodyEvaluationContext context = builder.build();

// Evaluate rules using the interpreter
  interpreter.interpret(context);

// Print final rule evaluation results
  print(context.ruleState.states);
// Output:
// {stop: RhapsodicBool{value: true, certain: true},
//  orange: RhapsodicBool{value: false, certain: false}}
}
