// Example: mock options for RhapsodyParserOptions.
import 'package:boolean_rhapsody/boolean_rhapsody.dart';

final RhapsodyParserOptions mockOptions = RhapsodyParserOptions(
  prefixes: ['env', 'config'],
  functions: ['func1', 'func2', 'log', 'calc'],
  variableValidator: (String variableName) {
    // A valid variable name must start with a letter and may contain letters and digits.
    return RegExp(r'^[a-zA-Z][a-zA-Z0-9]*$').hasMatch(variableName);
  },
);

// An array of code samples representing a diverse set of valid and invalid code,
// including some examples that span multiple lines.
final List<String> codeSamples = [
  // Valid: A well-formed rule expression in a single line.
  "rule 23 = (func1(env:variable1) or func2(config:variable2)) and not rule42;",

  // Valid: A rule expression with extra grouping spanning multiple lines.
  """
rule 1 = func1(env:var) and 
       (func2(config:var2) or not func1(env:otherVar));
""",

  // Valid: A simple variable reference.
  "env:validVar",

  // Invalid: Variable part starts with digits, which fails the variable validator.
  "config:123invalid",

  // Valid: A line that is just a comment.
  "# This is a standalone comment",

  // Invalid: A function call with a missing closing parenthesis.
  "func1(env:var",

  // Invalid: A rule expression missing the 'rule' keyword.
  "23 = func1(env:var) and func2(config:var2);",

  // Valid: A function call with multiple parameters spanning multiple lines.
  """
func2(env:var1, config:var2, env:var3)
""",

  // Invalid: Uses an unknown operator 'xor' which is not supported.
  "rule 10 = func1(env:var) xor func2(config:var);",

  // Valid: A rule expression that includes an inline comment.
  "rule 42 = (log(env:var)) # inline comment",

  // Valid: A multi-line code sample with a leading comment and multiple rule statements.
  """
   # Leading whitespace before a comment
   rule 5 = calc(config:calcVar) and not func1(env:var);
   rule 6 = func2(env:anotherVar) or func1(env:yetAnotherVar);
  """
];
